from datetime import timedelta
from functools import lru_cache
from uuid import UUID

from sqlalchemy import create_engine, or_, select, text
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.agentic.common import AgentError
from app.agentic.models import AgentJob, AgentWorker
from app.config import get_settings
from app.life.service import now


@lru_cache
def dispatcher_engine():
    return create_engine(
        get_settings().dispatch_database_url,
        pool_pre_ping=True,
        connect_args={"connect_timeout": 5},
    )


def verify_dispatcher(engine):
    with engine.connect() as connection:
        superuser, bypass = connection.execute(
            text("SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user")
        ).one()
        private_access = connection.scalar(
            text("SELECT has_table_privilege(current_user, 'profiles', 'SELECT')")
        )
        if superuser or bypass or private_access:
            raise AgentError(
                "unsafe_dispatch_role", "Dispatch credentials must be a non-bypass queue-only role."
            )


def heartbeat(worker_id: UUID, engine=None):
    with Session(engine or dispatcher_engine()) as db, db.begin():
        db.execute(
            insert(AgentWorker)
            .values(id=worker_id, last_seen=now())
            .on_conflict_do_update(index_elements=["id"], set_={"last_seen": now()})
        )


def claim(worker_id: UUID, engine=None):
    engine = engine or dispatcher_engine()
    heartbeat(worker_id, engine)
    with Session(engine) as db, db.begin():
        row = db.scalar(
            select(AgentJob)
            .where(
                or_(
                    AgentJob.status == "pending",
                    (AgentJob.status == "leased") & (AgentJob.lease_until < now()),
                )
            )
            .order_by(AgentJob.created_at, AgentJob.id)
            .with_for_update(skip_locked=True)
            .limit(1)
        )
        if row is None:
            return None
        row.status = "leased"
        row.lease_until = now() + timedelta(seconds=60)
        row.attempts += 1
        row.updated_at = now()
        db.flush()
        return {
            "id": row.id,
            "user_id": row.user_id,
            "run_id": row.run_id,
            "attempts": row.attempts,
        }
