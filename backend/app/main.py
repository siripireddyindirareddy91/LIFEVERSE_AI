from app.automation.router import router as automation_router
from app.automation import signals  # noqa: F401 - transactional app-event outbox
from app.modules.router import router as modules_router
from app.modules.vault import router as vault_router, BodyLimit
from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from app.security import PrivateResponsePolicy

from app.auth import Identity, current_identity
from app.config import get_settings
from app.database import engine
from app.life.router import router as life_router
from app.life.assistant import router as assistant_router
from app.agentic.router import router as agentic_router
from app.agentic.common import AgentError


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
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
)
app.include_router(life_router)
app.include_router(assistant_router)
app.include_router(agentic_router)
app.include_router(modules_router)
app.include_router(vault_router)
app.include_router(automation_router)
app.add_middleware(BodyLimit)
app.add_middleware(PrivateResponsePolicy)


@app.exception_handler(RequestValidationError)
async def invalid_request(request, error):
    # Pydantic errors can contain submitted notes, credentials and entire payloads.
    return JSONResponse(
        status_code=422,
        content={"detail": "Invalid request. Check your form values and try again."},
    )


@app.exception_handler(AgentError)
async def agent_error(request, error):
    status = (
        403
        if error.code == "consent_required"
        else 404
        if error.code == "not_found"
        else 422
        if error.code == "invalid_source"
        else 409
        if error.code.startswith("stale")
        else 503
    )
    return JSONResponse(status_code=status, content={"detail": error.message, "code": error.code})


@app.exception_handler(SQLAlchemyError)
async def database_unavailable(request, error):
    return JSONResponse(
        status_code=503,
        content={"detail": "The database could not complete this request. Please retry."},
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
