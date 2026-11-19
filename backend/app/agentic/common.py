import hashlib
import json
from contextlib import contextmanager
from uuid import UUID

from sqlalchemy import select, text
from sqlalchemy.orm import Session

from app.auth import Identity
from app import database
from app.life.service import now
from app.models import Profile
from app.agentic.models import AgentRun, AgentStep

TERMINAL = {"completed", "failed", "rejected", "cancelled", "expired", "stale"}


class AgentError(Exception):
    def __init__(self, code, message):
        self.code, self.message = code, message
        super().__init__(message)


def digest(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":"), default=str).encode()
    ).hexdigest()


@contextmanager
def owned_session(user_id: UUID):
    # Worker ownership comes only from immutable queue metadata created by authenticated APIs.
    with Session(database.engine()) as db, db.begin():
        db.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(user_id)})
        yield db


def owned_run(db, user_id, run_id, lock=False):
    query = select(AgentRun).where(AgentRun.user_id == user_id, AgentRun.id == run_id)
    if lock:
        query = query.with_for_update()
    row = db.scalar(query)
    if row is None:
        raise AgentError("not_found", "Agent run not found")
    return row


def check_consent(db, user_id, scopes, lock=False):
    query = (
        select(Profile).where(Profile.user_id == user_id).execution_options(populate_existing=True)
    )
    if lock:
        query = query.with_for_update()
    profile = db.scalar(query)
    if not profile or not profile.ai_consent:
        raise AgentError(
            "consent_required", "AI processing permission is required in your profile."
        )
    if "memory" in scopes and not profile.memory_consent:
        raise AgentError("consent_required", "Memory context permission has not been granted.")
    if "knowledge" in scopes and not profile.knowledge_consent:
        raise AgentError(
            "consent_required", "Knowledge processing permission has not been granted."
        )
    return profile


def event(db, run, kind, summary, *, status="succeeded", agent="system", tool=None, details=None):
    run.event_seq += 1
    step = AgentStep(
        user_id=run.user_id,
        run_id=run.id,
        sequence=run.event_seq,
        kind=kind,
        agent=agent,
        tool=tool,
        status=status,
        summary=summary,
        details=details or {},
        created_at=now(),
    )
    db.add(step)
    db.flush()
    return step


def identity(user_id):
    return Identity(user_id)
