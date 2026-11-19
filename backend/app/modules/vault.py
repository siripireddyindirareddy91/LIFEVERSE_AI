import base64
import binascii
import hashlib
import os
from uuid import UUID, uuid4
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.exceptions import InvalidTag
from fastapi import APIRouter, HTTPException, Response
from pydantic import AwareDatetime, Field, field_validator
from sqlalchemy import delete, func, or_, select
from app.config import get_settings
from app.life.router import DB, User, Limit, Offset, Search
from app.life.schemas import Input
from app.life.service import get_owned, list_owned, now
from app.modules.models import VaultFile
from app.modules.service import lock_owner

router = APIRouter(prefix="/api/v1/vault", tags=["vault"])
MAX_FILE = 5 * 1024 * 1024


class VaultMetadata(Input):
    title: str = Field(min_length=1, max_length=120)
    category: str = Field(default="Document", min_length=1, max_length=40)
    allow_ai: bool = False
    expires_at: AwareDatetime | None = None

    @field_validator("expires_at")
    @classmethod
    def future(cls, value):
        if value is not None and value <= now():
            raise ValueError("Choose a future expiry")
        return value


class VaultUpload(VaultMetadata):
    request_id: UUID
    filename: str = Field(min_length=1, max_length=180)
    content_base64: str = Field(min_length=1, max_length=7 * 1024 * 1024)

    @field_validator("filename")
    @classmethod
    def safe_name(cls, value):
        if any(ord(c) < 32 or c in "/\\:" for c in value) or value in {".", ".."}:
            raise ValueError("Choose a plain file name without paths")
        return value


def cipher(key_id):
    secret = get_settings().vault_encryption_keys.get(key_id)
    try:
        if secret is None:
            raise ValueError()
        key = base64.b64decode(secret.get_secret_value(), validate=True)
        if len(key) != 32:
            raise ValueError()
        return AESGCM(key)
    except (ValueError, binascii.Error) as error:
        raise HTTPException(
            503, "Vault encryption requires a valid server key. Contact your server administrator."
        ) from error


def metadata(row):
    return {
        key: getattr(row, key)
        for key in (
            "id",
            "title",
            "category",
            "filename",
            "mime",
            "size",
            "sha256",
            "allow_ai",
            "expires_at",
            "created_at",
        )
    }


def active():
    return or_(VaultFile.expires_at.is_(None), VaultFile.expires_at > now())


def purge(db, user):
    db.execute(delete(VaultFile).where(VaultFile.user_id == user.id, VaultFile.expires_at <= now()))


@router.get("/status")
def status(user: User, db: DB):
    configured = True
    try:
        cipher(get_settings().vault_active_key_id)
    except HTTPException:
        configured = False
    used = db.scalar(
        select(func.coalesce(func.sum(VaultFile.size), 0)).where(
            VaultFile.user_id == user.id, active()
        )
    )
    return {
        "configured": configured,
        "max_file_bytes": MAX_FILE,
        "quota_bytes": 100 * 1024 * 1024,
        "used_bytes": used,
        "encryption": "Server-side AES-256-GCM; private owner-authorized storage. Not end-to-end encryption.",
    }


@router.get("/files")
def files(user: User, db: DB, q: Search = "", limit: Limit = 30, offset: Offset = 0):
    purge(db, user)
    page = list_owned(db, VaultFile, user, limit, offset, q, [active()])
    page["items"] = [metadata(row) for row in page["items"]]
    return page


@router.post("/files", status_code=201)
def upload(payload: VaultUpload, user: User, db: DB, response: Response):
    lock_owner(db, user)
    purge(db, user)
    key_id = get_settings().vault_active_key_id
    encryptor = cipher(key_id)
    try:
        content = base64.b64decode(payload.content_base64, validate=True)
    except (ValueError, binascii.Error) as error:
        raise HTTPException(422, "Invalid file encoding") from error
    if not content or len(content) > MAX_FILE:
        raise HTTPException(413, "Choose a nonempty file up to 5 MiB")
    extension = payload.filename.rsplit(".", 1)[-1].lower()
    signatures = {
        "pdf": ("application/pdf", b"%PDF-"),
        "png": ("image/png", b"\x89PNG\r\n\x1a\n"),
        "jpg": ("image/jpeg", b"\xff\xd8\xff"),
        "jpeg": ("image/jpeg", b"\xff\xd8\xff"),
    }
    if extension == "txt":
        try:
            content.decode("utf-8")
            if b"\0" in content:
                raise ValueError()
        except (UnicodeDecodeError, ValueError) as error:
            raise HTTPException(422, "Text documents must be UTF-8 text") from error
        mime = "text/plain"
    elif extension in signatures and content.startswith(signatures[extension][1]):
        mime = signatures[extension][0]
    else:
        raise HTTPException(
            422, "Supported files: PDF, PNG, JPEG and UTF-8 TXT with matching content"
        )
    checksum = hashlib.sha256(content).hexdigest()
    previous = db.scalar(
        select(VaultFile).where(
            VaultFile.user_id == user.id, VaultFile.request_id == payload.request_id
        )
    )
    if previous:
        if previous.sha256 != checksum or any(
            getattr(previous, key) != getattr(payload, key)
            for key in ("filename", "title", "category", "allow_ai", "expires_at")
        ):
            raise HTTPException(409, "Request identifier used for different file content")
        response.status_code = 200
        return metadata(previous)
    used = db.scalar(
        select(func.coalesce(func.sum(VaultFile.size), 0)).where(VaultFile.user_id == user.id)
    )
    if used + len(content) > 100 * 1024 * 1024:
        raise HTTPException(409, "Your 100 MiB vault quota would be exceeded")
    file_id = uuid4()
    nonce = os.urandom(12)
    aad = f"{user.id}:{file_id}".encode()
    encrypted = nonce + encryptor.encrypt(nonce, content, aad)
    row = VaultFile(
        id=file_id,
        user_id=user.id,
        request_id=payload.request_id,
        filename=payload.filename,
        mime=mime,
        size=len(content),
        sha256=checksum,
        key_id=key_id,
        ciphertext=encrypted,
        **payload.model_dump(exclude={"request_id", "filename", "content_base64"}),
    )
    db.add(row)
    db.flush()
    response.headers["Cache-Control"] = "no-store"
    return metadata(row)


@router.get("/files/{file_id}/download")
def download(file_id: UUID, user: User, db: DB, response: Response):
    row = get_owned(db, VaultFile, file_id, user)
    if row.expires_at and row.expires_at <= now():
        raise HTTPException(404, "File expired")
    try:
        content = cipher(row.key_id).decrypt(
            row.ciphertext[:12], row.ciphertext[12:], f"{user.id}:{row.id}".encode()
        )
    except (InvalidTag, ValueError) as error:
        raise HTTPException(503, "File integrity verification failed") from error
    if len(content) != row.size or hashlib.sha256(content).hexdigest() != row.sha256:
        raise HTTPException(503, "File integrity verification failed")
    response.headers["Cache-Control"] = "no-store"
    return {
        "filename": row.filename,
        "mime": row.mime,
        "content_base64": base64.b64encode(content).decode(),
    }


@router.get("/files/{file_id}")
def file_detail(file_id: UUID, user: User, db: DB):
    row = get_owned(db, VaultFile, file_id, user)
    if row.expires_at and row.expires_at <= now():
        raise HTTPException(404, "File expired")
    return metadata(row)


@router.put("/files/{file_id}")
def edit(file_id: UUID, payload: VaultMetadata, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, VaultFile, file_id, user)
    if row.expires_at and row.expires_at <= now():
        raise HTTPException(404, "File expired")
    for key, value in payload.model_dump().items():
        setattr(row, key, value)
    db.flush()
    return metadata(row)


@router.delete("/files/{file_id}", status_code=204)
def remove(file_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, VaultFile, file_id, user))
    db.flush()
    return Response(status_code=204)


class BodyLimit:
    """Bound JSON upload buffers before FastAPI parses them, including chunked requests."""

    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope["type"] != "http":
            return await self.app(scope, receive, send)
        limit = 8 * 1024 * 1024 if scope["path"] == "/api/v1/vault/files" else 1024 * 1024
        body = bytearray()
        while True:
            message = await receive()
            if message["type"] == "http.disconnect":
                return
            body.extend(message.get("body", b""))
            if len(body) > limit:
                await send(
                    {
                        "type": "http.response.start",
                        "status": 413,
                        "headers": [(b"content-type", b"application/json")],
                    }
                )
                return await send(
                    {
                        "type": "http.response.body",
                        "body": b'{"detail":"Request body exceeds the upload limit"}',
                    }
                )
            if not message.get("more_body", False):
                break
        sent = False

        async def replay():
            nonlocal sent
            if not sent:
                sent = True
                return {"type": "http.request", "body": bytes(body), "more_body": False}
            return await receive()

        async def safe_send(message):
            if message["type"] == "http.response.start" and scope["path"].startswith(
                "/api/v1/integrations/oauth/"
            ):
                scope["query_string"] = b""
            await send(message)

        await self.app(scope, replay, safe_send)
