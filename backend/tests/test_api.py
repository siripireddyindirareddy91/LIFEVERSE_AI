from fastapi.testclient import TestClient

from app.config import Settings
from app.main import app


def test_liveness_and_missing_token():
    with TestClient(app) as client:
        assert client.get("/health/live").json() == {"status": "ok"}
        assert client.get("/api/v1/me").status_code == 401
        assert client.get("/api/v1/profile").status_code == 401


def test_unconfigured_auth_is_not_ready():
    app.dependency_overrides.clear()
    from unittest.mock import patch

    with patch("app.main.get_settings", return_value=Settings(supabase_url="")):
        with TestClient(app) as client:
            assert client.get("/health/ready").status_code == 503


def test_settings_reject_insecure_auth_url():
    import pytest

    with pytest.raises(ValueError):
        Settings(supabase_url="http://example.com")
