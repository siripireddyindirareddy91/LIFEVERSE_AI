import base64
import hashlib
import json
import os
import secrets
from datetime import datetime, timedelta, timezone
from uuid import uuid4
from urllib.parse import urlencode, urlsplit
from zoneinfo import ZoneInfo
from fastapi import HTTPException
from sqlalchemy import select, func
from sqlalchemy.orm import Session
from cryptography.exceptions import InvalidTag
from app.agentic.common import digest, owned_session
from app.agentic.queue import dispatcher_engine
from app.automation.external import request_json
from app.automation.models import (
    CalendarConnection,
    CalendarMirror,
    CalendarOperation,
    OAuthState,
    OAuthLookup,
)
from app.config import get_settings
from app.life.models import CalendarEvent
from app.life.schemas import EventWrite
from app.life.router import validate_event
from app.life.service import now, get_owned, user_timezone
from app.modules.vault import cipher


def seal(value, key_id, aad):
    nonce = os.urandom(12)
    return nonce + cipher(key_id).encrypt(nonce, json.dumps(value).encode(), aad.encode())


def unseal(value, key_id, aad):
    try:
        return json.loads(cipher(key_id).decrypt(value[:12], value[12:], aad.encode()))
    except (InvalidTag, ValueError, TypeError) as e:
        raise HTTPException(503, "Encrypted integration credentials could not be read.") from e


def provider_config(provider):
    settings = get_settings()
    if provider not in {"google", "microsoft"}:
        raise HTTPException(404, "Calendar provider not found")
    client = getattr(settings, provider + "_client_id")
    secret = getattr(settings, provider + "_client_secret").get_secret_value()
    base = settings.oauth_public_base_url.rstrip("/")
    parsed = urlsplit(base)
    if (
        not client
        or not secret
        or not base
        or not parsed.hostname
        or parsed.path not in {"", "/"}
        or parsed.scheme != "https"
        or parsed.username
        or parsed.query
        or parsed.fragment
    ):
        raise HTTPException(
            503,
            "Calendar OAuth requires a registered client, secret and HTTPS public callback origin.",
        )
    cipher(settings.vault_active_key_id)
    return client, secret, base + "/api/v1/integrations/oauth/" + provider + "/callback"


def scopes(provider, writable):
    if provider == "google":
        return [
            "https://www.googleapis.com/auth/calendar.events"
            if writable
            else "https://www.googleapis.com/auth/calendar.events.readonly"
        ]
    return ["offline_access", "Calendars.ReadWrite" if writable else "Calendars.Read"]


def start(db, user, provider, writable):
    from app.modules.service import lock_owner

    lock_owner(db, user)
    if (
        db.scalar(
            select(func.count())
            .select_from(OAuthState)
            .where(
                OAuthState.user_id == user.id, OAuthState.created_at > now() - timedelta(hours=1)
            )
        )
        >= 10
    ):
        raise HTTPException(429, "Too many OAuth starts. Retry later.")
    if (
        db.scalar(
            select(func.count())
            .select_from(CalendarConnection)
            .where(CalendarConnection.user_id == user.id, CalendarConnection.active.is_(True))
        )
        >= 10
    ):
        raise HTTPException(409, "Disconnect an existing calendar before adding another.")
    client, _, redirect = provider_config(provider)
    state = secrets.token_urlsafe(32)
    verifier = secrets.token_urlsafe(48)
    state_id = uuid4()
    key = get_settings().vault_active_key_id
    db.add(
        OAuthState(
            id=state_id,
            user_id=user.id,
            provider=provider,
            writable=writable,
            key_id=key,
            verifier_cipher=seal({"verifier": verifier}, key, "oauth:" + str(state_id)),
            expires_at=now() + timedelta(minutes=10),
        )
    )
    db.add(
        OAuthLookup(
            id=state_id,
            user_id=user.id,
            state_hash=hashlib.sha256(state.encode()).hexdigest(),
            expires_at=now() + timedelta(minutes=10),
        )
    )
    params = {
        "client_id": client,
        "redirect_uri": redirect,
        "response_type": "code",
        "scope": " ".join(scopes(provider, writable)),
        "state": state,
        "code_challenge": base64.urlsafe_b64encode(hashlib.sha256(verifier.encode()).digest())
        .decode()
        .rstrip("="),
        "code_challenge_method": "S256",
    }
    if provider == "google":
        params.update(access_type="offline", prompt="consent")
    endpoint = (
        "https://accounts.google.com/o/oauth2/v2/auth"
        if provider == "google"
        else "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
    )
    return {"authorization_url": endpoint + "?" + urlencode(params), "expires_in": 600}


def callback(provider, state, code, *, dispatch=None, transport=None):
    if not state or len(state) > 200 or not code or len(code) > 4096:
        raise HTTPException(400, "Invalid OAuth callback")
    hashed = hashlib.sha256(state.encode()).hexdigest()
    with Session(dispatch or dispatcher_engine()) as lookup_db:
        found = lookup_db.scalar(
            select(OAuthLookup).where(
                OAuthLookup.state_hash == hashed, OAuthLookup.expires_at > now()
            )
        )
        if found is None:
            raise HTTPException(400, "OAuth request expired or is unknown")
        owner, state_id = found.user_id, found.id
    # Only immutable server-generated lookup metadata resolves ownership, never callback user input.
    with owned_session(owner) as db:
        pending = db.scalar(
            select(OAuthState)
            .where(OAuthState.user_id == owner, OAuthState.id == state_id)
            .with_for_update()
        )
        if (
            pending is None
            or pending.consumed
            or pending.provider != provider
            or pending.expires_at <= now()
        ):
            raise HTTPException(400, "OAuth request expired or was already used")
        pending.consumed = True
        try:
            client, secret, redirect = provider_config(provider)
            verifier = unseal(pending.verifier_cipher, pending.key_id, "oauth:" + str(pending.id))[
                "verifier"
            ]
            endpoint = (
                "https://oauth2.googleapis.com/token"
                if provider == "google"
                else "https://login.microsoftonline.com/common/oauth2/v2.0/token"
            )
            token = request_json(
                "POST",
                endpoint,
                data={
                    "grant_type": "authorization_code",
                    "code": code,
                    "client_id": client,
                    "client_secret": secret,
                    "redirect_uri": redirect,
                    "code_verifier": verifier,
                },
                transport=transport,
            )
            needed = set(scopes(provider, pending.writable)) - {"offline_access"}
            if (
                not needed.issubset(set(token.get("scope", "").split()))
                or not token.get("access_token")
                or not token.get("refresh_token")
            ):
                raise HTTPException(
                    503,
                    "Calendar permissions or offline access were not granted. Reconnect and review consent.",
                )
            if (
                db.scalar(
                    select(func.count())
                    .select_from(CalendarConnection)
                    .where(CalendarConnection.user_id == owner, CalendarConnection.active.is_(True))
                )
                >= 10
            ):
                raise HTTPException(
                    409, "Connection limit reached; disconnect an existing calendar first."
                )
            connection_id = uuid4()
            key = get_settings().vault_active_key_id
            token["expires_at"] = (
                now() + timedelta(seconds=min(int(token.get("expires_in", 3600)), 86400))
            ).isoformat()
            db.add(
                CalendarConnection(
                    id=connection_id,
                    user_id=owner,
                    title=("Google" if provider == "google" else "Microsoft") + " default calendar",
                    provider=provider,
                    writable=pending.writable,
                    active=True,
                    key_id=key,
                    token_cipher=seal(token, key, f"calendar:{owner}:{connection_id}"),
                )
            )
            db.flush()
            return True
        except Exception:
            return False  # Commit single-use state even on an exchange failure; reconnect starts a new request.
        finally:
            pending.verifier_cipher = b""


def connection_read(row):
    return {
        k: getattr(row, k)
        for k in (
            "id",
            "title",
            "provider",
            "writable",
            "active",
            "revision",
            "last_sync_at",
            "error",
            "created_at",
        )
    }


def token_for(db, user, connection, transport=None):
    if not connection.active:
        raise HTTPException(409, "Calendar connection was disconnected")
    token = unseal(
        connection.token_cipher, connection.key_id, f"calendar:{user.id}:{connection.id}"
    )
    if datetime.fromisoformat(token["expires_at"]) > now() + timedelta(seconds=60):
        return token["access_token"]
    client, secret, _ = provider_config(connection.provider)
    endpoint = (
        "https://oauth2.googleapis.com/token"
        if connection.provider == "google"
        else "https://login.microsoftonline.com/common/oauth2/v2.0/token"
    )
    updated = request_json(
        "POST",
        endpoint,
        data={
            "grant_type": "refresh_token",
            "refresh_token": token["refresh_token"],
            "client_id": client,
            "client_secret": secret,
        },
        transport=transport,
    )
    if not updated.get("access_token"):
        raise HTTPException(503, "Calendar access expired; reconnect the provider")
    token.update(updated)
    token["expires_at"] = (
        now() + timedelta(seconds=min(int(updated.get("expires_in", 3600)), 86400))
    ).isoformat()
    connection.token_cipher = seal(token, connection.key_id, f"calendar:{user.id}:{connection.id}")
    return token["access_token"]


def parse_time(value, zone="UTC"):
    parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    if parsed.tzinfo is None:
        parsed = parsed.replace(tzinfo=ZoneInfo(zone))
    return parsed.astimezone(timezone.utc)


def sync(db, user, connection_id, transport=None):
    row = db.scalar(
        select(CalendarConnection)
        .where(CalendarConnection.user_id == user.id, CalendarConnection.id == connection_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Connection not found")
    access = token_for(db, user, row, transport)
    headers = {"Authorization": "Bearer " + access, "Prefer": 'outlook.timezone="UTC"'}
    start_at, end_at = now() - timedelta(days=30), now() + timedelta(days=90)
    url = (
        "https://www.googleapis.com/calendar/v3/calendars/primary/events"
        if row.provider == "google"
        else "https://graph.microsoft.com/v1.0/me/calendarView"
    )
    params = (
        {
            "singleEvents": "true",
            "timeMin": start_at.isoformat(),
            "timeMax": end_at.isoformat(),
            "maxResults": 100,
            "fields": "items(id,status,summary,start,end),nextPageToken",
        }
        if row.provider == "google"
        else {
            "startDateTime": start_at.isoformat(),
            "endDateTime": end_at.isoformat(),
            "$top": 100,
            "$select": "id,subject,start,end,isAllDay,isCancelled",
        }
    )
    events = []
    truncated = False
    for page in range(5):
        data = request_json("GET", url, headers=headers, params=params, transport=transport)
        for item in data.get("items" if row.provider == "google" else "value", []):
            if item.get("status") == "cancelled" or item.get("isCancelled"):
                continue
            try:
                if row.provider == "google":
                    starts, ends = item["start"], item["end"]
                    all_day = "date" in starts
                    zone = starts.get("timeZone") or str(user_timezone(db, user))
                    begin = parse_time(starts.get("dateTime") or starts["date"], zone)
                    finish = parse_time(ends.get("dateTime") or ends["date"], zone)
                    title = item.get("summary") or "Untitled event"
                else:
                    all_day = bool(item.get("isAllDay"))
                    begin = parse_time(item["start"]["dateTime"])
                    finish = parse_time(item["end"]["dateTime"])
                    title = item.get("subject") or "Untitled event"
                if finish <= begin:
                    continue
                events.append(
                    {
                        "remote_id": str(item["id"])[:512],
                        "title": title[:120],
                        "starts_at": begin,
                        "ends_at": finish,
                        "all_day": all_day,
                    }
                )
            except (KeyError, ValueError, TypeError):
                continue
        if row.provider == "google":
            next_token = data.get("nextPageToken")
            if not next_token:
                break
            if len(next_token) > 4096:
                raise HTTPException(503, "Invalid calendar pagination")
            params = {**params, "pageToken": next_token}
        else:
            next_link = data.get("@odata.nextLink")
            if not next_link:
                break
            parsed = urlsplit(next_link)
            if (
                parsed.scheme != "https"
                or parsed.hostname != "graph.microsoft.com"
                or not parsed.path.startswith("/v1.0/me/calendarView")
                or parsed.username
            ):
                raise HTTPException(
                    503, "Calendar pagination outside the approved provider was denied"
                )
            url = next_link
            params = None
        if page == 4:
            truncated = True
    existing = list(
        db.scalars(
            select(CalendarMirror).where(
                CalendarMirror.user_id == user.id, CalendarMirror.connection_id == row.id
            )
        )
    )
    by_id = {m.remote_id: m for m in existing}
    seen = set()
    for item in events[:500]:
        if item["remote_id"] in seen:
            continue
        seen.add(item["remote_id"])
        mirror = by_id.get(item["remote_id"])
        if mirror is None:
            mirror = CalendarMirror(user_id=user.id, connection_id=row.id, **item)
            db.add(mirror)
        else:
            for key, value in item.items():
                setattr(mirror, key, value)
    if not truncated:
        for mirror in existing:
            if mirror.remote_id not in seen:
                db.delete(mirror)
    row.last_sync_at = now()
    row.error = ""
    db.flush()
    return {
        "events": len(seen),
        "truncated": truncated,
        "window_start": start_at,
        "window_end": end_at,
        "notice": "Read-only mirror. Import explicitly; later provider edits do not silently change Planner.",
    }


def import_event(db, user, mirror_id, allow_overlap=False):
    row = db.scalar(
        select(CalendarMirror)
        .where(CalendarMirror.user_id == user.id, CalendarMirror.id == mirror_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Calendar event not found")
    connection = get_owned(db, CalendarConnection, row.connection_id, user)
    if not connection.active:
        raise HTTPException(409, "Connection was disconnected")
    if row.local_event_id:
        local = get_owned(db, CalendarEvent, row.local_event_id, user)
        return {"event_id": local.id, "cached": True}
    payload = EventWrite(
        title=row.title,
        starts_at=row.starts_at,
        ends_at=row.ends_at,
        notes="Imported "
        + ("all-day " if row.all_day else "")
        + "calendar event. Provider changes require a new review.",
        allow_overlap=allow_overlap,
    )
    validate_event(payload, user, db)
    local = CalendarEvent(user_id=user.id, **payload.model_dump(exclude={"allow_overlap"}))
    db.add(local)
    db.flush()
    row.local_event_id = local.id
    return {"event_id": local.id, "cached": False}


def event_payload(event):
    return {
        "title": event.title,
        "notes": event.notes,
        "starts_at": event.starts_at.isoformat(),
        "ends_at": event.ends_at.isoformat(),
    }


def prepare_export(db, user, connection_id, payload):
    connection = get_owned(db, CalendarConnection, connection_id, user)
    if not connection.active or not connection.writable:
        raise HTTPException(409, "Reconnect with calendar write permission first")
    event = get_owned(db, CalendarEvent, payload.local_event_id, user)
    data = event_payload(event)
    fingerprint = digest(
        {"event": data, "connection": str(connection.id), "revision": str(connection.revision)}
    )
    old = db.scalar(
        select(CalendarOperation).where(
            CalendarOperation.user_id == user.id, CalendarOperation.request_id == payload.request_id
        )
    )
    if old:
        if old.digest != fingerprint:
            raise HTTPException(409, "Export request ID used for different content")
        return old
    if (
        db.scalar(
            select(func.count())
            .select_from(CalendarOperation)
            .where(
                CalendarOperation.user_id == user.id,
                CalendarOperation.created_at > now() - timedelta(days=1),
            )
        )
        >= 20
    ):
        raise HTTPException(429, "Twenty calendar export previews per rolling day are allowed.")
    op = CalendarOperation(
        id=uuid4(),
        user_id=user.id,
        request_id=payload.request_id,
        connection_id=connection.id,
        connection_revision=connection.revision,
        local_event_id=event.id,
        payload=data,
        digest=fingerprint,
        status="awaiting_approval",
        expires_at=now() + timedelta(hours=1),
    )
    db.add(op)
    db.flush()
    return op


def operation_read(row):
    return {
        k: getattr(row, k)
        for k in (
            "id",
            "connection_id",
            "local_event_id",
            "payload",
            "digest",
            "nonce",
            "status",
            "remote_id",
            "error",
            "expires_at",
            "created_at",
        )
    }


def publish(db, user, operation_id, transport=None):
    op = db.scalar(
        select(CalendarOperation)
        .where(CalendarOperation.user_id == user.id, CalendarOperation.id == operation_id)
        .with_for_update()
    )
    if op is None or op.status in {"published", "rejected", "cancelled"}:
        return
    if op.expires_at <= now():
        raise HTTPException(
            409,
            "Export authorization expired. Reconcile provider history before preparing a new export.",
        )
    if op.status not in {"approved", "publishing"}:
        raise HTTPException(409, "Export was not approved")
    connection = db.scalar(
        select(CalendarConnection)
        .where(CalendarConnection.user_id == user.id, CalendarConnection.id == op.connection_id)
        .with_for_update()
    )
    if (
        connection is None
        or not connection.active
        or not connection.writable
        or connection.revision != op.connection_revision
    ):
        raise HTTPException(409, "The calendar connection changed; prepare a new export")
    local = db.scalar(
        select(CalendarEvent)
        .where(CalendarEvent.user_id == user.id, CalendarEvent.id == op.local_event_id)
        .with_for_update()
    )
    if local is None:
        raise HTTPException(409, "The local event was deleted; no export was sent.")
    if event_payload(local) != op.payload:
        raise HTTPException(409, "The local event changed after approval; prepare a new export")
    access = token_for(db, user, connection, transport)
    headers = {"Authorization": "Bearer " + access}
    op.status = "publishing"
    if connection.provider == "google":
        url = "https://www.googleapis.com/calendar/v3/calendars/primary/events"
        remote_id = op.id.hex
        # A deterministic provider event ID makes uncertain retries reconcilable.
        try:
            prior = request_json("GET", url + "/" + remote_id, headers=headers, transport=transport)
        except HTTPException:
            prior = None
        if prior and prior.get("extendedProperties", {}).get("private", {}).get(
            "lifeverse_operation"
        ) == str(op.id):
            result = prior
        else:
            result = request_json(
                "POST",
                url,
                headers=headers,
                params={"sendUpdates": "none"},
                payload={
                    "id": remote_id,
                    "summary": op.payload["title"],
                    "description": op.payload["notes"],
                    "start": {"dateTime": op.payload["starts_at"]},
                    "end": {"dateTime": op.payload["ends_at"]},
                    "extendedProperties": {"private": {"lifeverse_operation": str(op.id)}},
                },
                transport=transport,
            )
    else:
        result = request_json(
            "POST",
            "https://graph.microsoft.com/v1.0/me/events",
            headers=headers,
            payload={
                "transactionId": str(op.id),
                "subject": op.payload["title"],
                "body": {"contentType": "text", "content": op.payload["notes"]},
                "start": {
                    "dateTime": parse_time(op.payload["starts_at"])
                    .replace(tzinfo=None)
                    .isoformat(),
                    "timeZone": "UTC",
                },
                "end": {
                    "dateTime": parse_time(op.payload["ends_at"]).replace(tzinfo=None).isoformat(),
                    "timeZone": "UTC",
                },
            },
            transport=transport,
        )
    if not isinstance(result.get("id"), str):
        raise HTTPException(503, "Provider did not confirm an event ID")
    op.remote_id = result["id"][:512]
    op.status = "published"
    op.error = ""
