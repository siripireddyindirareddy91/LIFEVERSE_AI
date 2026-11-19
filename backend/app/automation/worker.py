import time
import threading
from datetime import timedelta
from uuid import uuid4, uuid5
from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError
from app.agentic.common import owned_session, identity
from app.agentic.queue import dispatcher_engine, verify_dispatcher
from app.automation.models import AutomationSignal, CalendarOperation, Workflow, WorkflowRun
from app.automation.queue import claim, heartbeat, owned_job
from app.automation.schemas import Definition
from app.automation.service import advance, enqueue_run, next_due, notify, TERMINAL
from app.automation.calendar import publish
from app.life.service import now
from app.modules.service import lock_owner


def process(job, external_fetch=None, transport=None):
    user = identity(job["user_id"])
    try:
        with owned_session(user.id) as db:
            lock_owner(db, user)
            queue = owned_job(db, job)
            if queue is None:
                return
            if job["kind"] == "trigger":
                flow = db.scalar(
                    select(Workflow)
                    .where(Workflow.user_id == user.id, Workflow.id == job["subject_id"])
                    .with_for_update()
                )
                if flow is None or not flow.enabled:
                    queue.status = "done"
                    return
                trigger = Definition.model_validate(flow.definition).nodes[0]
                if trigger.mode != "schedule":
                    queue.status = "done"
                    return
                enqueue_run(db, user, flow, uuid5(flow.id, job["due_at"].isoformat()))
                queue.due_at = next_due(trigger, now())
                queue.status = "pending"
            elif job["kind"] == "signal":
                signal = db.scalar(
                    select(AutomationSignal).where(
                        AutomationSignal.user_id == user.id,
                        AutomationSignal.id == job["subject_id"],
                    )
                )
                if signal:
                    for flow in db.scalars(
                        select(Workflow)
                        .where(Workflow.user_id == user.id, Workflow.enabled.is_(True))
                        .order_by(Workflow.id)
                        .with_for_update()
                    ):
                        trigger = Definition.model_validate(flow.definition).nodes[0]
                        # Never backfill events that occurred before this workflow was activated/created.
                        if (
                            trigger.mode == "event"
                            and trigger.topic == signal.topic
                            and flow.activated_at is not None
                            and flow.activated_at <= signal.created_at
                        ):
                            enqueue_run(
                                db,
                                user,
                                flow,
                                uuid5(flow.id, str(signal.id)),
                                {
                                    "record_kind": signal.record_kind,
                                    "record_id": str(signal.record_id),
                                },
                            )
                queue.status = "done"
            elif job["kind"] == "run":
                run = db.scalar(
                    select(WorkflowRun).where(
                        WorkflowRun.user_id == user.id, WorkflowRun.id == job["subject_id"]
                    )
                )
                if run is None:
                    queue.status = "done"
                    return
                flow = db.scalar(
                    select(Workflow)
                    .where(Workflow.user_id == user.id, Workflow.id == run.workflow_id)
                    .with_for_update()
                )
                run = db.scalar(
                    select(WorkflowRun)
                    .where(WorkflowRun.user_id == user.id, WorkflowRun.id == run.id)
                    .with_for_update()
                )
                if flow is None:
                    queue.status = "done"
                    return
                if run.started_at is None:
                    run.attempts += 1
                done = advance(db, user, flow, run, external_fetch)
                queue.status = "done" if done else "pending"
                queue.due_at = now() + timedelta(seconds=15)
            elif job["kind"] == "export":
                publish(db, user, job["subject_id"], transport)
                queue.status = "done"
            else:
                queue.status = "done"
            queue.lease_until = None
    except Exception as error:
        with owned_session(user.id) as db:
            queue = owned_job(db, job)
            if queue is None:
                return
            queue.status = "done"
            queue.lease_until = None
            if (
                isinstance(error, HTTPException)
                and error.status_code == 409
                and str(error.detail).startswith("Another change")
            ):
                queue.status = "pending"
                queue.due_at = now() + timedelta(seconds=5)
                return
            message = (
                error.detail
                if isinstance(error, HTTPException) and isinstance(error.detail, str)
                else "The worker could not finish this step. Review history before retrying."
            )
            if job["kind"] == "run":
                run = db.scalar(
                    select(WorkflowRun)
                    .where(WorkflowRun.user_id == user.id, WorkflowRun.id == job["subject_id"])
                    .with_for_update()
                )
                if run and run.status not in TERMINAL:
                    run.status = "failed"
                    run.error = message[:500]
                    run.finished_at = now()
                    run.attempts += 1
                    notify(
                        db,
                        user.id,
                        "Workflow needs your attention",
                        message,
                        f"failure:{run.id}:{run.attempts}",
                        f"/automation/runs/{run.id}",
                    )
            elif job["kind"] == "export":
                op = db.scalar(
                    select(CalendarOperation)
                    .where(
                        CalendarOperation.user_id == user.id,
                        CalendarOperation.id == job["subject_id"],
                    )
                    .with_for_update()
                )
                if op and op.status not in {"published", "cancelled", "rejected"}:
                    op.status = (
                        "uncertain"
                        if not isinstance(error, HTTPException) or error.status_code == 503
                        else "failed"
                    )
                    op.error = (
                        message
                        + " Provider writes may need reconciliation; retries use the same provider identifier."
                    )[:500]
                    notify(
                        db,
                        user.id,
                        "Calendar export needs review",
                        op.error,
                        f"calendar:{op.id}",
                        "/integrations",
                    )
            else:
                if job["kind"] == "trigger":
                    flow = db.scalar(
                        select(Workflow).where(
                            Workflow.user_id == user.id, Workflow.id == job["subject_id"]
                        )
                    )
                    if flow and flow.enabled:
                        trigger = Definition.model_validate(flow.definition).nodes[0]
                        if trigger.mode == "schedule":
                            queue.status = "pending"
                            queue.due_at = next_due(trigger, now())
                notify(
                    db,
                    user.id,
                    "Automation trigger needs review",
                    message,
                    f"job:{queue.id}:{job['attempt']}",
                    "/automation",
                )


def main():
    engine = dispatcher_engine()
    verify_dispatcher(engine)
    worker_id = uuid4()
    stop = threading.Event()

    def pulse():
        while not stop.wait(15):
            try:
                heartbeat(worker_id, engine)
            except SQLAlchemyError:
                pass

    thread = threading.Thread(target=pulse, daemon=True)
    thread.start()
    try:
        while True:
            try:
                job = claim(worker_id, engine)
                if job:
                    process(job)
                else:
                    time.sleep(2)
            except SQLAlchemyError:
                print("Automation database temporarily unavailable.", flush=True)
                time.sleep(5)
    except KeyboardInterrupt:
        pass
    finally:
        stop.set()
        thread.join(timeout=2)
        engine.dispose()


if __name__ == "__main__":
    main()
