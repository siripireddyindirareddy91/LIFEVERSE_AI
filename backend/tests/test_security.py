"""Adversarial API contracts; no live identity/provider credentials are used."""

import asyncio
import json
import re
import time
from unittest.mock import patch
from uuid import uuid4

import httpx
import jwt
import pytest
from cryptography.hazmat.primitives.asymmetric import rsa
from fastapi import FastAPI, Depends
from fastapi.testclient import TestClient

from app.auth import Identity, current_identity
from app.automation.external import fetch
from app.automation.schemas import External
from app.config import Settings
from app.main import app
from app.modules.vault import BodyLimit
from app.security import PrivateResponsePolicy
from test_auth import client, token, private_key, issuer, subject  # noqa: F401


PROTECTED = [
    (method, path)
    for path, operations in app.openapi()["paths"].items()
    if path.startswith("/api/") and path != "/api/v1/integrations/oauth/{provider}/callback"
    for method in sorted(operations)
    if method in {"get", "put", "post", "patch", "delete"}
]


@pytest.mark.parametrize("method,path", PROTECTED)
def test_every_private_api_method_requires_authentication(method, path):
    assert not app.dependency_overrides
    path = re.sub(r"\{[^}]+\}", str(uuid4()), path)
    with TestClient(app) as api:
        response = api.request(method, path)
    assert response.status_code == 401, (method, path, response.text)
    assert response.headers["www-authenticate"] == "Bearer"
    assert response.headers["cache-control"] == "no-store"


@pytest.mark.parametrize("claim", ["exp", "iat", "sub", "aud", "iss", "role"])
def test_missing_required_claim_is_rejected(client, claim):  # noqa: F811
    claims = jwt.decode(token(), options={"verify_signature": False})
    claims.pop(claim)
    encoded = jwt.encode(claims, private_key, algorithm="ES256", headers={"kid": "test"})
    assert (
        client.get("/api/v1/me", headers={"Authorization": f"Bearer {encoded}"}).status_code == 401
    )


@pytest.mark.parametrize(
    "changes",
    [
        {"iat": int(time.time()) + 3600},
        {"nbf": int(time.time()) + 3600},
        {"sub": None},
        {"aud": None},
    ],
)
def test_future_or_invalid_claims_fail_closed(client, changes):  # noqa: F811
    assert (
        client.get(
            "/api/v1/me", headers={"Authorization": f"Bearer {token(**changes)}"}
        ).status_code
        == 401
    )


@pytest.mark.parametrize(
    "value",
    [
        "not-a-jwt",
        "a" * 16385,
        jwt.encode({"sub": subject}, key="", algorithm="none"),
        jwt.encode({"sub": subject}, key="x" * 64, algorithm="HS256"),
    ],
)
def test_bad_tokens_do_not_trigger_jwks_network(client, value):  # noqa: F811
    with patch("app.auth.jwks_client") as network:
        response = client.get("/api/v1/me", headers={"Authorization": f"Bearer {value}"})
        assert response.status_code == 401
        network.assert_not_called()


def test_rsa_rotation_and_stale_signatures(client):  # noqa: F811
    from types import SimpleNamespace

    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    claims = jwt.decode(token(), options={"verify_signature": False})
    encoded = jwt.encode(claims, key, algorithm="RS256", headers={"kid": "rotated"})
    keys = SimpleNamespace(get_signing_key_from_jwt=lambda _: SimpleNamespace(key=key.public_key()))
    with patch("app.auth.jwks_client", return_value=keys):
        assert client.get("/api/v1/me", headers={"Authorization": f"Bearer {encoded}"}).json() == {
            "id": subject
        }
        assert (
            client.get("/api/v1/me", headers={"Authorization": f"Bearer {token()}"}).status_code
            == 401
        )


def test_validation_does_not_echo_private_input_or_nested_payload():
    app.dependency_overrides[current_identity] = lambda: Identity(uuid4())
    try:
        with TestClient(app) as api:
            secret = "PRIVATE-NOTE-DO-NOT-ECHO"
            response = api.post(
                "/api/v1/integrations/external/read", json={"api": secret, "credential": secret}
            )
            assert response.status_code == 422
            assert secret not in response.text
            assert "input" not in response.text
            assert response.headers["cache-control"] == "no-store"
    finally:
        app.dependency_overrides.clear()


def test_error_headers_and_untrusted_cors():
    with TestClient(app) as api:
        response = api.get("/api/v1/me", headers={"Origin": "https://attacker.example"})
        assert response.status_code == 401
        assert "access-control-allow-origin" not in response.headers
        assert response.headers["x-content-type-options"] == "nosniff"
        assert response.headers["referrer-policy"] == "no-referrer"
        assert "frame-ancestors 'none'" in response.headers["content-security-policy"]


def test_chunked_body_limit_without_content_length_and_disconnect():
    async def exercise(disconnect=False):
        called, sent = [], []

        async def inner(scope, receive, send):
            called.append(True)

        chunks = iter(
            [
                {"type": "http.request", "body": b"x" * 600000, "more_body": True},
                {"type": "http.disconnect"}
                if disconnect
                else {"type": "http.request", "body": b"x" * 600000, "more_body": False},
            ]
        )

        async def receive():
            return next(chunks)

        async def send(message):
            sent.append(message)

        await PrivateResponsePolicy(BodyLimit(inner))(
            {"type": "http", "path": "/api/v1/tasks"}, receive, send
        )
        assert not called
        if disconnect:
            assert not sent
        else:
            assert sent[0]["status"] == 413
            assert dict(sent[0]["headers"])[b"cache-control"] == b"no-store"

    asyncio.run(exercise())
    asyncio.run(exercise(True))


@pytest.mark.parametrize(
    "body",
    [
        [],
        {"current": []},
        {"current": {"temperature_2m": "NaN"}},
        {"current": {"temperature_2m": True}},
    ],
)
def test_malformed_public_provider_data_is_sanitized(body):
    from fastapi import HTTPException

    with patch(
        "app.automation.external.get_settings", return_value=Settings(external_apis_enabled=True)
    ):
        with pytest.raises(HTTPException) as error:
            fetch(
                External(type="external", api="weather", latitude=0, longitude=0),
                transport=httpx.MockTransport(lambda _: httpx.Response(200, json=body)),
            )
        assert error.value.status_code == 503
        assert json.dumps(body) not in str(error.value.detail)


def test_unknown_provider_redirect_timeout_and_size_are_rejected():
    from app.automation.external import request_json
    from fastapi import HTTPException

    for response in [
        httpx.Response(302, headers={"location": "https://attacker.example"}),
        httpx.Response(200, content=b"x" * 512001),
        httpx.Response(500, text="PRIVATE-UPSTREAM-ERROR"),
    ]:
        with pytest.raises(HTTPException) as error:
            request_json(
                "GET",
                "https://provider.example",
                transport=httpx.MockTransport(lambda _, r=response: r),
            )
        assert error.value.status_code == 503
        assert "PRIVATE-UPSTREAM" not in error.value.detail

    def timeout(request):
        raise httpx.ReadTimeout("PRIVATE-UPSTREAM-ERROR")

    with pytest.raises(HTTPException) as error:
        request_json("GET", "https://provider.example", transport=httpx.MockTransport(timeout))
    assert error.value.status_code == 503


def test_database_errors_do_not_expose_sql_or_credentials():
    from sqlalchemy.exc import SQLAlchemyError

    async def fail():
        raise SQLAlchemyError("PRIVATE-SQL-DATABASE-PASSWORD")

    test_app = FastAPI()
    from app.main import database_unavailable

    test_app.add_exception_handler(SQLAlchemyError, database_unavailable)
    test_app.add_api_route("/api/v1/private", fail, dependencies=[Depends(lambda: None)])
    test_app.add_middleware(PrivateResponsePolicy)
    with TestClient(test_app) as api:
        response = api.get("/api/v1/private")
        assert response.status_code == 503
        assert "PRIVATE-SQL" not in response.text
        assert response.headers["cache-control"] == "no-store"


def test_response_policy_preserves_repeated_headers():
    async def exercise():
        sent = []

        async def inner(scope, receive, send):
            await send(
                {
                    "type": "http.response.start",
                    "status": 200,
                    "headers": [
                        (b"set-cookie", b"first=test; Secure"),
                        (b"set-cookie", b"second=test; Secure"),
                        (b"cache-control", b"public"),
                    ],
                }
            )

        async def receive():
            return {"type": "http.request", "body": b""}

        async def send(message):
            sent.append(message)

        await PrivateResponsePolicy(inner)({"type": "http", "path": "/api/v1/test"}, receive, send)
        assert [value for key, value in sent[0]["headers"] if key == b"set-cookie"] == [
            b"first=test; Secure",
            b"second=test; Secure",
        ]
        assert dict(sent[0]["headers"])[b"cache-control"] == b"no-store"

    asyncio.run(exercise())
