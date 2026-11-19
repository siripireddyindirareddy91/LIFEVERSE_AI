from functools import lru_cache
from pathlib import Path
from typing import Literal
from urllib.parse import urlsplit

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=Path(__file__).resolve().parents[2] / ".env", extra="ignore"
    )

    app_env: Literal["development", "test", "production"] = "development"
    database_url: str = "postgresql+psycopg://lifeverse:lifeverse_local@localhost:5432/lifeverse"
    runtime_database_url: str = (
        "postgresql+psycopg://lifeverse_app:lifeverse_app_local@localhost:5432/lifeverse"
    )
    supabase_url: str = ""
    cors_origins: list[str] = []

    @field_validator("supabase_url")
    @classmethod
    def valid_supabase_url(cls, value: str) -> str:
        parsed = urlsplit(value)
        if value and (
            parsed.scheme != "https"
            or not parsed.hostname
            or parsed.username
            or parsed.password
            or parsed.query
            or parsed.fragment
            or parsed.path not in ("", "/")
        ):
            raise ValueError("SUPABASE_URL must be an HTTPS project origin")
        return value.rstrip("/")


@lru_cache
def get_settings() -> Settings:
    return Settings()
