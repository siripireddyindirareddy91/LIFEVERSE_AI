from datetime import timedelta
from uuid import UUID, uuid4
from fastapi import APIRouter, HTTPException, Request as HttpRequest, Response, Query
from fastapi.responses import HTMLResponse
from sqlalchemy import delete, func, select, update
from app.agentic.common import digest, check_consent
from app.automation.models import (
    Workflow,
    WorkflowRun,
    AutomationWorker,
    InboxNotification,
    CalendarConnection,
    CalendarMirror,
    CalendarOperation,
)
from app.automation import calendar
from app.automation.external import fetch
from app.automation.queue import enqueue
from app.automation.schemas import (
    Activate,
    Definition,
    ExportDecision,
    ExportWrite,
    External,
    OAuthStart,
    Reminder,
    Request,
    WorkflowWrite,
)
from app.automation.service import (
    TERMINAL,
    enqueue_run,
    flow_read,
    next_due,
    notify,
    pause,
    run_read,
    stop_run,
)
from app.config import get_settings
from app.life.router import User, DB, Limit, Offset, Search
from app.life.service import get_owned, list_owned, now
from app.modules.service import lock_owner

router = APIRouter(prefix="/api/v1", tags=["automation and integrations"])


@router.get("/automation/status")
def status(user: User, db: DB):
    online = db.scalar(
        select(func.count())
        .select_from(AutomationWorker)
        .where(AutomationWorker.last_seen > now() - timedelta(seconds=60))
    )
    return {
        "worker_online": bool(online),
        "daily_limit": get_settings().workflow_runs_per_day,
        "history_days": 30,
        "max_nodes": 12,
        "external_apis_enabled": get_settings().external_apis_enabled,
        "definition_schema": Definition.model_json_schema(),
    }


@router.get("/automation/templates")
def templates(user: User):
    return {
        "items": [
            {
                "title": "Daily life report",
                "definition": {
                    "nodes": [
                        {
                            "type": "trigger",
                            "mode": "schedule",
                            "timezone": "UTC",
                            "at": "07:00",
                            "weekdays": list(range(7)),
                        },
                        {"type": "report", "module": "life"},
                        {
                            "type": "notify",
                            "title": "Your daily life report",
                            "body": "Your report is ready.",
                            "include_output": True,
                        },
                        {"type": "output"},
                    ]
                },
            },
            {
                "title": "A gentle deadline check",
                "definition": {
                    "nodes": [
                        {
                            "type": "trigger",
                            "mode": "schedule",
                            "timezone": "UTC",
                            "at": "09:00",
                            "weekdays": list(range(7)),
                        },
                        {"type": "condition", "test": "overdue_tasks", "minimum": 1},
                        {
                            "type": "notify",
                            "title": "A little room for your tasks",
                            "body": "You have overdue tasks. Open Planner to decide what comes next.",
                        },
                        {"type": "output"},
                    ]
                },
            },
            {
                "title": "Review a new goal",
                "definition": {
                    "nodes": [
                        {"type": "trigger", "mode": "event", "topic": "goal.created"},
                        {
                            "type": "action",
                            "tool": "create_task",
                            "arguments": {"title": "Review my new goal"},
                        },
                        {"type": "approval"},
                        {
                            "type": "notify",
                            "title": "Goal review workflow finished",
                            "body": "Your approval decision has been recorded.",
                        },
                        {"type": "output"},
                    ]
                },
            },
        ]
    }


@router.get("/automation/workflows")
def flows(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, q: Search = ""):
    page = list_owned(db, Workflow, user, limit, offset, q)
    page["items"] = [flow_read(r) for r in page["items"]]
    return page


@router.post("/automation/workflows", status_code=201)
def create(payload: WorkflowWrite, user: User, db: DB, response: Response):
    lock_owner(db, user)
    fingerprint = digest(
        {"title": payload.title, "definition": payload.definition.model_dump(mode="json")}
    )
    old = db.scalar(
        select(Workflow).where(
            Workflow.user_id == user.id, Workflow.request_id == payload.request_id
        )
    )
    if old:
        if old.input_hash != fingerprint:
            raise HTTPException(409, "Request identifier used for different workflow content")
        response.status_code = 200
        return flow_read(old)
    if (
        db.scalar(select(func.count()).select_from(Workflow).where(Workflow.user_id == user.id))
        >= 30
    ):
        raise HTTPException(409, "Maximum thirty workflows per account")
    row = Workflow(
        user_id=user.id,
        title=payload.title,
        definition=payload.definition.model_dump(mode="json"),
        request_id=payload.request_id,
        input_hash=fingerprint,
    )
    db.add(row)
    db.flush()
    return flow_read(row)


@router.get("/automation/workflows/{workflow_id}")
def flow(workflow_id: UUID, user: User, db: DB):
    return flow_read(get_owned(db, Workflow, workflow_id, user))


@router.put("/automation/workflows/{workflow_id}")
def edit(workflow_id: UUID, payload: WorkflowWrite, user: User, db: DB):
    lock_owner(db, user)
    row = db.scalar(
        select(Workflow)
        .where(Workflow.user_id == user.id, Workflow.id == workflow_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Workflow not found")
    if row.revision != payload.revision:
        raise HTTPException(409, "Workflow changed. Refresh before editing again.")
    pause(db, user, row)
    row.title = payload.title
    row.definition = payload.definition.model_dump(mode="json")
    row.revision = uuid4()
    db.flush()
    return flow_read(row)


@router.post("/automation/workflows/{workflow_id}/activate")
def activate(workflow_id: UUID, payload: Activate, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, Workflow, workflow_id, user)
    if payload.revision != row.revision or payload.digest != digest(row.definition):
        raise HTTPException(409, "The workflow preview changed. Review it again.")
    if row.enabled:
        return flow_read(row)
    definition = Definition.model_validate(row.definition)
    for node in definition.nodes:
        if node.type == "ai":
            check_consent(db, user.id, node.scopes)
        if node.type == "external" and not get_settings().external_apis_enabled:
            raise HTTPException(503, "External API reads are disabled on the server")
    row.enabled = True
    row.activated_at = now()
    trigger = definition.nodes[0]
    if trigger.mode == "schedule":
        enqueue(db, user.id, "trigger", row.id, next_due(trigger, now()))
    return flow_read(row)


@router.post("/automation/workflows/{workflow_id}/pause")
def suspend(workflow_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, Workflow, workflow_id, user)
    pause(db, user, row)
    return flow_read(row)


@router.delete("/automation/workflows/{workflow_id}", status_code=204)
def remove(workflow_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, Workflow, workflow_id, user)
    pause(db, user, row)
    db.delete(row)
    db.flush()
    return Response(status_code=204)


@router.post("/automation/workflows/{workflow_id}/run", status_code=201)
def run(workflow_id: UUID, payload: Request, user: User, db: DB):
    return run_read(
        enqueue_run(db, user, get_owned(db, Workflow, workflow_id, user), payload.request_id)
    )


@router.get("/automation/runs")
def history(
    user: User, db: DB, workflow_id: UUID | None = None, limit: Limit = 30, offset: Offset = 0
):
    conditions = [WorkflowRun.user_id == user.id]
    if workflow_id:
        conditions.append(WorkflowRun.workflow_id == workflow_id)
    total = db.scalar(select(func.count()).select_from(WorkflowRun).where(*conditions))
    rows = db.scalars(
        select(WorkflowRun)
        .where(*conditions)
        .order_by(WorkflowRun.created_at.desc())
        .offset(offset)
        .limit(limit)
    )
    return {"items": [run_read(r) for r in rows], "total": total, "offset": offset, "limit": limit}


@router.get("/automation/runs/{run_id}")
def detail(run_id: UUID, user: User, db: DB):
    return run_read(get_owned(db, WorkflowRun, run_id, user))


@router.post("/automation/runs/{run_id}/cancel")
def cancel(run_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, WorkflowRun, run_id, user)
    stop_run(db, user, row)
    return run_read(row)


@router.post("/automation/runs/{run_id}/retry")
def retry(run_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, WorkflowRun, run_id, user)
    flow = get_owned(db, Workflow, row.workflow_id, user)
    if (
        row.status != "failed"
        or row.attempts >= 3
        or not flow.enabled
        or flow.revision != row.revision
    ):
        raise HTTPException(
            409,
            "Retry requires an active unchanged workflow, a failed run and fewer than three attempts",
        )
    row.status = "queued"
    row.error = ""
    enqueue(db, user.id, "run", row.id)
    return run_read(row)


@router.delete("/automation/runs/{run_id}", status_code=204)
def delete_run(run_id: UUID, user: User, db: DB):
    row = get_owned(db, WorkflowRun, run_id, user)
    if row.status not in TERMINAL:
        raise HTTPException(409, "Cancel the run before deleting history")
    db.delete(row)
    db.flush()
    return Response(status_code=204)


def notification_read(row):
    return {
        k: getattr(row, k)
        for k in (
            "id",
            "title",
            "body",
            "route",
            "due_at",
            "read_at",
            "cancelled",
            "created_at",
            "expires_at",
        )
    }


@router.get("/notifications")
def inbox(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, pending: bool = False):
    conditions = [
        InboxNotification.user_id == user.id,
        InboxNotification.expires_at > now(),
        InboxNotification.cancelled.is_(False),
    ]
    if pending:
        conditions.extend(
            [
                InboxNotification.read_at.is_(None),
                InboxNotification.due_at > now() - timedelta(hours=24),
            ]
        )
    total = db.scalar(select(func.count()).select_from(InboxNotification).where(*conditions))
    rows = db.scalars(
        select(InboxNotification)
        .where(*conditions)
        .order_by(
            InboxNotification.due_at if pending else InboxNotification.due_at.desc(),
            InboxNotification.id,
        )
        .limit(limit)
        .offset(offset)
    )
    unread = db.scalar(
        select(func.count())
        .select_from(InboxNotification)
        .where(
            InboxNotification.user_id == user.id,
            InboxNotification.read_at.is_(None),
            InboxNotification.cancelled.is_(False),
            InboxNotification.due_at <= now(),
            InboxNotification.expires_at > now(),
        )
    )
    return {
        "items": [notification_read(r) for r in rows],
        "total": total,
        "unread": unread,
        "offset": offset,
        "limit": limit,
    }


@router.post("/notifications", status_code=201)
def reminder(payload: Reminder, user: User, db: DB):
    lock_owner(db, user)
    if payload.due_at < now() - timedelta(seconds=5) or payload.due_at > now() + timedelta(days=30):
        raise HTTPException(422, "Choose a reminder in the next thirty days")
    key = "reminder:" + str(payload.request_id)
    old = db.scalar(
        select(InboxNotification).where(
            InboxNotification.user_id == user.id, InboxNotification.source_key == key
        )
    )
    if old and (
        old.title != payload.title or old.body != payload.body or old.due_at != payload.due_at
    ):
        raise HTTPException(409, "Reminder request ID used for different content")
    if (
        old is None
        and db.scalar(
            select(func.count())
            .select_from(InboxNotification)
            .where(InboxNotification.user_id == user.id, InboxNotification.expires_at > now())
        )
        >= 1000
    ):
        raise HTTPException(429, "Notification storage limit reached; wait for retention cleanup.")
    return notification_read(
        notify(db, user.id, payload.title, payload.body, key, due_at=payload.due_at)
    )


@router.post("/notifications/{notification_id}/read")
def read(notification_id: UUID, user: User, db: DB):
    row = get_owned(db, InboxNotification, notification_id, user)
    row.read_at = now()
    return notification_read(row)


@router.delete("/notifications/{notification_id}", status_code=204)
def dismiss(notification_id: UUID, user: User, db: DB):
    row = get_owned(db, InboxNotification, notification_id, user)
    row.cancelled = True
    row.title = "Dismissed update"
    row.body = ""
    row.route = "/notifications"
    row.read_at = now()
    return Response(status_code=204)


@router.post("/integrations/external/read")
def public_api(payload: External, user: User):
    return fetch(payload)


@router.get("/integrations/status")
def integrations_status(user: User):
    providers = []
    for provider in ["google", "microsoft"]:
        try:
            calendar.provider_config(provider)
            configured = True
        except HTTPException:
            configured = False
        providers.append({"provider": provider, "configured": configured})
    return {"providers": providers, "external_apis_enabled": get_settings().external_apis_enabled}


@router.post("/integrations/oauth/{provider}/start")
def oauth_start(provider: str, payload: OAuthStart, user: User, db: DB):
    return calendar.start(db, user, provider, payload.writable)


@router.get("/integrations/oauth/{provider}/callback", response_class=HTMLResponse)
def oauth_callback(
    provider: str,
    request: HttpRequest,
    state: str = Query(max_length=200),
    code: str = Query(default="", max_length=4096),
    error: str = Query(default="", max_length=200),
):
    request.scope["query_string"] = b""
    ok = calendar.callback(provider, state, code) if not error else False
    return HTMLResponse(
        '<!doctype html><html><head><meta name="referrer" content="no-referrer"><title>LIFEVERSE calendar</title></head><body><h1>'
        + ("Calendar connected" if ok else "Calendar connection did not complete")
        + "</h1><p>Return to LIFEVERSE and refresh Integrations. You can safely close this tab.</p></body></html>",
        headers={"Cache-Control": "no-store", "Referrer-Policy": "no-referrer"},
    )


@router.get("/integrations/calendars")
def connections(user: User, db: DB):
    return {
        "items": [
            calendar.connection_read(c)
            for c in db.scalars(
                select(CalendarConnection)
                .where(CalendarConnection.user_id == user.id)
                .order_by(CalendarConnection.created_at.desc())
            )
        ]
    }


@router.delete("/integrations/calendars/{connection_id}", status_code=204)
def disconnect(connection_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    row = db.scalar(
        select(CalendarConnection)
        .where(CalendarConnection.user_id == user.id, CalendarConnection.id == connection_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Connection not found")
    row.active = False
    row.revision = uuid4()
    row.token_cipher = b""
    db.execute(
        delete(CalendarMirror).where(
            CalendarMirror.user_id == user.id, CalendarMirror.connection_id == row.id
        )
    )
    for op in db.scalars(
        select(CalendarOperation).where(
            CalendarOperation.user_id == user.id,
            CalendarOperation.connection_id == row.id,
            CalendarOperation.status.in_(["awaiting_approval", "approved", "uncertain"]),
        )
    ):
        op.status = "cancelled"
    return Response(status_code=204)


@router.post("/integrations/calendars/{connection_id}/sync")
def sync(connection_id: UUID, user: User, db: DB):
    return calendar.sync(db, user, connection_id)


@router.get("/integrations/calendars/{connection_id}/events")
def events(connection_id: UUID, user: User, db: DB, limit: Limit = 30, offset: Offset = 0):
    get_owned(db, CalendarConnection, connection_id, user)
    page = list_owned(
        db, CalendarMirror, user, limit, offset, "", [CalendarMirror.connection_id == connection_id]
    )
    page["items"] = [
        {
            k: getattr(r, k)
            for k in ("id", "title", "starts_at", "ends_at", "all_day", "local_event_id")
        }
        for r in page["items"]
    ]
    return page


@router.post("/integrations/events/{mirror_id}/import")
def import_event(mirror_id: UUID, user: User, db: DB, allow_overlap: bool = False):
    return calendar.import_event(db, user, mirror_id, allow_overlap)


@router.post("/integrations/calendars/{connection_id}/exports", status_code=201)
def export(connection_id: UUID, payload: ExportWrite, user: User, db: DB):
    lock_owner(db, user)
    return calendar.operation_read(calendar.prepare_export(db, user, connection_id, payload))


@router.get("/integrations/exports")
def exports(user: User, db: DB, limit: Limit = 30, offset: Offset = 0):
    db.execute(
        update(CalendarOperation)
        .where(
            CalendarOperation.user_id == user.id,
            CalendarOperation.status == "awaiting_approval",
            CalendarOperation.expires_at <= now(),
        )
        .values(status="expired")
    )
    rows = list(
        db.scalars(
            select(CalendarOperation)
            .where(CalendarOperation.user_id == user.id)
            .order_by(CalendarOperation.created_at.desc())
            .limit(limit)
            .offset(offset)
        )
    )
    return {
        "items": [calendar.operation_read(r) for r in rows],
        "total": db.scalar(
            select(func.count())
            .select_from(CalendarOperation)
            .where(CalendarOperation.user_id == user.id)
        ),
        "limit": limit,
        "offset": offset,
    }


@router.post("/integrations/exports/{operation_id}/decision")
def export_decision(operation_id: UUID, payload: ExportDecision, user: User, db: DB):
    lock_owner(db, user)
    row = db.scalar(
        select(CalendarOperation)
        .where(CalendarOperation.user_id == user.id, CalendarOperation.id == operation_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Export not found")
    if payload.digest != row.digest or payload.nonce != row.nonce:
        raise HTTPException(409, "Export preview changed; review again")
    if row.status in {"approved", "publishing", "published"} and not payload.approve:
        raise HTTPException(409, "This export was already approved; check its actual outcome.")
    if row.status == "rejected" and payload.approve:
        raise HTTPException(409, "This preview was rejected. Prepare a new export.")
    if not payload.approve and row.status in {"awaiting_approval", "uncertain", "expired"}:
        row.status = "rejected"
        return calendar.operation_read(row)
    if row.status in {"published", "approved", "publishing", "rejected"}:
        return calendar.operation_read(row)
    if row.status not in {"awaiting_approval", "uncertain"} or row.expires_at <= now():
        raise HTTPException(409, "Export approval expired or stopped")
    row.status = "approved" if payload.approve else "rejected"
    if payload.approve:
        enqueue(db, user.id, "export", row.id)
    return calendar.operation_read(row)
