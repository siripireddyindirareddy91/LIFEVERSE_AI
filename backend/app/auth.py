from dataclasses import dataclass
from functools import lru_cache
from uuid import UUID

import jwt
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.config import get_settings

bearer = HTTPBearer(auto_error=False)


@dataclass(frozen=True)
class Identity:
    id: UUID


@lru_cache
def jwks_client(url: str) -> jwt.PyJWKClient:
    return jwt.PyJWKClient(f"{url}/auth/v1/.well-known/jwks.json", timeout=5)


def current_identity(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer),
) -> Identity:
    if credentials is None:
        raise HTTPException(401, "Authentication required", headers={"WWW-Authenticate": "Bearer"})
    settings = get_settings()
    if not settings.supabase_url:
        raise HTTPException(503, "Supabase authentication requires configuration")
    try:
        if len(credentials.credentials) > 16384:
            raise ValueError("Token limit")
        header = jwt.get_unverified_header(credentials.credentials)
        if header.get("alg") not in {"ES256", "RS256"}:
            raise ValueError("Unsupported signing algorithm")
        kid = header.get("kid")
        if not isinstance(kid, str) or not 1 <= len(kid) <= 200:
            raise ValueError("Missing or invalid signing key identifier")
        key = jwks_client(settings.supabase_url).get_signing_key_from_jwt(credentials.credentials)
        claims = jwt.decode(
            credentials.credentials,
            key.key,
            algorithms=["ES256", "RS256"],
            audience="authenticated",
            issuer=f"{settings.supabase_url}/auth/v1",
            options={"require": ["exp", "iat", "sub", "aud", "iss"]},
        )
        if claims.get("role") != "authenticated":
            raise ValueError("User access token required")
        return Identity(UUID(claims["sub"]))
    except jwt.PyJWKClientConnectionError as exc:
        raise HTTPException(503, "Authentication provider temporarily unavailable") from exc
    except (jwt.PyJWTError, ValueError, TypeError) as exc:
        raise HTTPException(
            401, "Invalid or expired access token", headers={"WWW-Authenticate": "Bearer"}
        ) from exc
