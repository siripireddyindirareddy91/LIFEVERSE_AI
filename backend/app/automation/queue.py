from datetime import timedelta
from uuid import uuid4
from sqlalchemy import or_, select
from sqlalchemy.orm import Session
from sqlalchemy.dialects.postgresql import insert
from app.agentic.queue import dispatcher_engine
from app.automation.models import AutomationJob, AutomationWorker
from app.life.service import now


def enqueue(db, user_id, kind, subject_id, due_at=None):
    old = db.scalar(
        select(AutomationJob)
        .where(
            AutomationJob.user_id == user_id,
            AutomationJob.kind == kind,
            AutomationJob.subject_id == subject_id,
        )
        .with_for_update()
    )
    if old:
        old.status = "pending"
        old.due_at = due_at or now()
        old.lease_until = None
        return old
    row = AutomationJob(
        id=uuid4(),
        user_id=user_id,
        kind=kind,
        subject_id=subject_id,
        status="pending",
        due_at=due_at or now(),
        attempts=0,
    )
    db.add(row)
    db.flush()
    return row


def heartbeat(worker_id, engine=None):
    with Session(engine or dispatcher_engine()) as db, db.begin():
        db.execute(
            insert(AutomationWorker)
            .values(id=worker_id, last_seen=now())
            .on_conflict_do_update(index_elements=["id"], set_={"last_seen": now()})
        )


def claim(worker_id, engine=None):
    engine = engine or dispatcher_engine()
    heartbeat(worker_id, engine)
    with Session(engine) as db, db.begin():
        row = db.scalar(
            select(AutomationJob)
            .where(
                AutomationJob.due_at <= now(),
                or_(
                    AutomationJob.status == "pending",
                    (AutomationJob.status == "leased") & (AutomationJob.lease_until < now()),
                ),
            )
            .order_by(AutomationJob.due_at, AutomationJob.id)
            .with_for_update(skip_locked=True)
            .limit(1)
        )
        if row is None:
            return None
        row.status = "leased"
        row.lease_until = now() + timedelta(seconds=120)
        row.attempts += 1
        return {
            "id": row.id,
            "user_id": row.user_id,
            "subject_id": row.subject_id,
            "kind": row.kind,
            "attempt": row.attempts,
            "due_at": row.due_at,
        }


def owned_job(db, job):
    row = db.scalar(
        select(AutomationJob)
        .where(AutomationJob.user_id == job["user_id"], AutomationJob.id == job["id"])
        .with_for_update()
    )
    if row is None or row.status != "leased" or row.attempts != job["attempt"]:
        return None
    return row
