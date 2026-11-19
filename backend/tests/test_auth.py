import time
from types import SimpleNamespace
from unittest.mock import patch
from uuid import uuid4

import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import ec
from fastapi.testclient import TestClient

from app.config import Settings
from app.main import app

private_key = ec.generate_private_key(ec.SECP256R1())
subject = str(uuid4())
issuer = "https://test.supabase.co/auth/v1"


def token(**changes):
    claims = {
        "sub": subject,
        "aud": "authenticated",
        "iss": issuer,
        "iat": int(time.time()),
        "exp": int(time.time()) + 60,
        "role": "authenticated",
    }
    claims.update(changes)
    return jwt.encode(claims, private_key, algorithm="ES256", headers={"kid": "test"})


@pytest.fixture
def client():
    key_client = SimpleNamespace(
        get_signing_key_from_jwt=lambda _: SimpleNamespace(key=private_key.public_key())
    )
    with (
        patch(
            "app.auth.get_settings", return_value=Settings(supabase_url="https://test.supabase.co")
        ),
        patch("app.auth.jwks_client", return_value=key_client),
        TestClient(app) as client,
    ):
        yield client


def test_verified_identity(client):
    assert client.get("/api/v1/me", headers={"Authorization": f"Bearer {token()}"}).json() == {
        "id": subject
    }


@pytest.mark.parametrize(
    "changes",
    [
        {"exp": 1},
        {"aud": "other"},
        {"iss": "https://attacker.example"},
        {"sub": "invalid"},
        {"role": "service_role"},
    ],
)
def test_reject_invalid_claims(client, changes):
    assert (
        client.get(
            "/api/v1/me", headers={"Authorization": f"Bearer {token(**changes)}"}
        ).status_code
        == 401
    )


def test_reject_forged_signature(client):
    forged = jwt.encode(
        {"sub": subject}, ec.generate_private_key(ec.SECP256R1()), algorithm="ES256"
    )
    assert (
        client.get("/api/v1/me", headers={"Authorization": f"Bearer {forged}"}).status_code == 401
    )


def test_provider_outage_fails_closed(client):
    with patch("app.auth.jwks_client", side_effect=jwt.PyJWKClientConnectionError("offline")):
        assert (
            client.get("/api/v1/me", headers={"Authorization": f"Bearer {token()}"}).status_code
            == 503
        )
