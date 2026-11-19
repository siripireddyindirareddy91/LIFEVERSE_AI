from contextlib import asynccontextmanager
from uuid import UUID

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict
from sqlalchemy import select, text
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from app.auth import Identity, current_identity
from app.config import get_settings
from app.database import engine, user_session
from app.models import Profile


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield
    if engine.cache_info().currsize:
        engine().dispose()


app = FastAPI(title="LIFEVERSE AI", version="0.1.0", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=get_settings().cors_origins,
    allow_credentials=True,
    allow_methods=["GET"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health/live", tags=["health"])
def liveness():
    return {"status": "ok"}


@app.get("/health/ready", tags=["health"])
def readiness():
    if not get_settings().supabase_url:
        raise HTTPException(503, "Supabase authentication requires configuration")
    try:
        with engine().connect() as connection:
            connection.execute(text("SELECT user_id FROM profiles LIMIT 0"))
    except SQLAlchemyError as exc:
        raise HTTPException(503, "Database unavailable or migrations pending") from exc
    return {"status": "ready"}


@app.get("/api/v1/me", tags=["identity"])
def me(identity: Identity = Depends(current_identity)):
    return {"id": str(identity.id)}


class ProfileResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    user_id: UUID
    display_name: str
    locale: str
    timezone: str


@app.get("/api/v1/profile", response_model=ProfileResponse, tags=["identity"])
def profile(
    identity: Identity = Depends(current_identity),
    session: Session = Depends(user_session),
):
    row = session.scalar(select(Profile).where(Profile.user_id == identity.id))
    if row is None:
        raise HTTPException(404, "Profile not created; onboarding is a later phase")
    return row
