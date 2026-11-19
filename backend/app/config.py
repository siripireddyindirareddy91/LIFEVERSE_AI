from functools import lru_cache
from pathlib import Path
from typing import Literal
from urllib.parse import urlsplit

from pydantic import Field, SecretStr, field_validator
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
    ai_api_key: SecretStr = SecretStr("")
    ai_model: str = ""
    ai_requests_per_day: int = Field(default=50, ge=1, le=1000)
    ai_requests_per_minute: int = Field(default=5, ge=1, le=30)
    conversation_retention_days: int = Field(default=7, ge=1, le=30)
    dispatch_database_url: str = (
        "postgresql+psycopg://lifeverse_dispatcher:dispatcher_local@localhost:5432/lifeverse"
    )
    agent_max_model_calls: int = Field(default=10, ge=2, le=12)
    agent_max_tool_calls: int = Field(default=12, ge=1, le=20)
    agent_max_proposals: int = Field(default=8, ge=1, le=12)
    agent_runs_per_day: int = Field(default=10, ge=1, le=100)
    agent_run_timeout_seconds: int = Field(default=240, ge=60, le=360)
    agent_approval_minutes: int = Field(default=60, ge=5, le=1440)
    agent_history_days: int = Field(default=30, ge=1, le=30)
    ai_embedding_model: str = Field(default="", max_length=120)
    ai_embedding_dimensions: int = Field(default=1536, ge=64, le=3072)
    retrieval_candidate_limit: int = Field(default=1000, ge=50, le=2000)

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
