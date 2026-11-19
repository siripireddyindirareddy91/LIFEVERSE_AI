from uuid import uuid4
from sqlalchemy import event
from sqlalchemy.orm import Session
from app.life.models import Task, Goal
from app.modules.models import ModuleRecord
from app.automation.models import AutomationSignal, AutomationJob
from app.life.service import now


@event.listens_for(Session, "before_flush")
def collect(session, flush_context, instances):
    seen = session.info.setdefault("automation_signals", set())
    for row in list(session.new):
        if not isinstance(row, (Task, Goal, ModuleRecord)):
            continue
        if row.id is None:
            row.id = uuid4()
        key = (row.user_id, row.id)
        if key in seen:
            continue
        seen.add(key)
        signal_id = uuid4()
        topic = (
            "task.created"
            if isinstance(row, Task)
            else "goal.created"
            if isinstance(row, Goal)
            else "module.created"
        )
        session.add(
            AutomationSignal(
                id=signal_id,
                user_id=row.user_id,
                topic=topic,
                record_id=row.id,
                record_kind=row.kind
                if isinstance(row, ModuleRecord)
                else "task"
                if isinstance(row, Task)
                else "goal",
            )
        )
        session.add(
            AutomationJob(
                id=uuid4(),
                user_id=row.user_id,
                kind="signal",
                subject_id=signal_id,
                status="pending",
                due_at=now(),
                attempts=0,
            )
        )
