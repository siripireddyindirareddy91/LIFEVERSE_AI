from datetime import datetime, timedelta, time, timezone
from uuid import uuid4, uuid5
from zoneinfo import ZoneInfo
from fastapi import HTTPException, Response
from sqlalchemy import func, select
from app.agentic.common import digest, check_consent, event
from app.agentic.models import AgentRun, AgentAction
from app.agentic.router import create_run as create_agent, cancel as cancel_agent
from app.agentic.schemas import RunWrite
from app.agentic.tools import TOOLS, prepare, actions_digest
from app.automation.models import (
    WorkflowRun,
    WorkflowUsage,
    AutomationJob,
    InboxNotification,
)
from app.automation.queue import enqueue
from app.automation.schemas import Definition, Trigger
from app.config import get_settings
from app.life.models import Task, CalendarEvent
from app.life.router import dashboard
from app.life.service import now, get_owned
from app.modules.service import overview, lock_owner

TERMINAL = {"completed", "failed", "cancelled", "skipped"}


def next_due(trigger: Trigger, after: datetime):
    zone = ZoneInfo(trigger.timezone)
    local = after.astimezone(zone)
    hour, minute = map(int, trigger.at.split(":"))
    for offset in range(9):
        day = local.date() + timedelta(days=offset)
        if day.weekday() not in trigger.weekdays:
            continue
        candidate = datetime.combine(day, time(hour, minute), tzinfo=zone).replace(fold=0)
        utc = candidate.astimezone(timezone.utc)
        if utc.astimezone(zone).replace(tzinfo=None) != candidate.replace(tzinfo=None):
            continue
        if utc > after:
            return utc
    raise HTTPException(422, "No valid scheduled occurrence in the next nine days")


def flow_read(row):
    definition = Definition.model_validate(row.definition)
    permissions = []
    for node in definition.nodes:
        if node.type == "action":
            permissions.append("Approval required: " + node.tool.replace("_", " "))
        elif node.type == "ai":
            permissions.append("AI provider: selected scopes " + ", ".join(node.scopes))
        elif node.type == "external":
            permissions.append("External read: " + node.api)
        elif node.type == "notify":
            permissions.append("Automatic in-app notification")
        elif node.type in {"report", "condition"}:
            permissions.append("Read your own saved records")
    return {
        "id": row.id,
        "title": row.title,
        "definition": row.definition,
        "revision": row.revision,
        "enabled": row.enabled,
        "digest": digest(row.definition),
        "permissions": list(dict.fromkeys(permissions)),
        "created_at": row.created_at,
    }


def run_read(row):
    return {
        k: getattr(row, k)
        for k in (
            "id",
            "workflow_id",
            "revision",
            "status",
            "cursor",
            "steps",
            "summary",
            "error",
            "attempts",
            "agent_run_id",
            "proposal_run_id",
            "created_at",
            "started_at",
            "finished_at",
            "expires_at",
        )
    }


def notify(db, user_id, title, body, key, route="/notifications", due_at=None):
    old = db.scalar(
        select(InboxNotification).where(
            InboxNotification.user_id == user_id, InboxNotification.source_key == key
        )
    )
    if old:
        return old
    row = InboxNotification(
        user_id=user_id,
        title=title[:120],
        body=body[:4000],
        route=route,
        source_key=key,
        due_at=due_at or now(),
        expires_at=(due_at or now()) + timedelta(days=30),
    )
    db.add(row)
    db.flush()
    return row


def enqueue_run(db, user, flow, request_id, trigger_context=None):
    lock_owner(db, user)
    previous = db.scalar(
        select(WorkflowRun).where(
            WorkflowRun.user_id == user.id, WorkflowRun.request_id == request_id
        )
    )
    if previous:
        if previous.workflow_id != flow.id:
            raise HTTPException(409, "Request ID belongs to another workflow")
        return previous
    if not flow.enabled:
        raise HTTPException(409, "Activate the reviewed workflow first")
    if db.scalar(
        select(WorkflowUsage.id).where(
            WorkflowUsage.user_id == user.id, WorkflowUsage.request_id == request_id
        )
    ):
        raise HTTPException(409, "A deleted run used this request ID. Start a new request.")
    count = db.scalar(
        select(func.count())
        .select_from(WorkflowUsage)
        .where(
            WorkflowUsage.user_id == user.id, WorkflowUsage.created_at > now() - timedelta(days=1)
        )
    )
    if count >= get_settings().workflow_runs_per_day:
        raise HTTPException(429, "Daily workflow run limit reached")
    run = WorkflowRun(
        id=uuid4(),
        user_id=user.id,
        workflow_id=flow.id,
        request_id=request_id,
        revision=flow.revision,
        definition=flow.definition,
        status="queued",
        context=trigger_context or {},
        expires_at=now() + timedelta(days=30),
    )
    db.add(run)
    db.add(WorkflowUsage(user_id=user.id, request_id=request_id))
    db.flush()
    enqueue(db, user.id, "run", run.id)
    return run


def stop_run(db, user, run):
    if run.status in TERMINAL:
        return
    for linked in [run.agent_run_id, run.proposal_run_id]:
        if linked:
            existing = db.scalar(
                select(AgentRun).where(AgentRun.user_id == user.id, AgentRun.id == linked)
            )
            if existing:
                cancel_agent(linked, user, db)
    run.status = "cancelled"
    run.finished_at = now()
    run.summary = "Cancelled. Earlier completed effects remain in history."
    job = db.scalar(
        select(AutomationJob).where(
            AutomationJob.user_id == user.id,
            AutomationJob.kind == "run",
            AutomationJob.subject_id == run.id,
        )
    )
    if job:
        job.status = "done"
        job.lease_until = None


def pause(db, user, flow):
    flow.enabled = False
    clock = db.scalar(
        select(AutomationJob).where(
            AutomationJob.user_id == user.id,
            AutomationJob.kind == "trigger",
            AutomationJob.subject_id == flow.id,
        )
    )
    if clock:
        clock.status = "done"
        clock.lease_until = None
    for run in db.scalars(
        select(WorkflowRun)
        .where(WorkflowRun.user_id == user.id, WorkflowRun.workflow_id == flow.id)
        .order_by(WorkflowRun.id)
        .with_for_update()
    ):
        stop_run(db, user, run)


def condition(db, user, node, context):
    if node.test == "trigger_kind":
        return context.get("record_kind") == node.record_kind
    if node.test in {"open_tasks", "overdue_tasks"}:
        filters = [Task.user_id == user.id, Task.status == "todo"]
        if node.test == "overdue_tasks":
            filters.append(Task.due_at < now())
        count = db.scalar(select(func.count()).select_from(Task).where(*filters))
    else:
        count = db.scalar(
            select(func.count())
            .select_from(CalendarEvent)
            .where(
                CalendarEvent.user_id == user.id,
                CalendarEvent.starts_at >= now(),
                CalendarEvent.starts_at < now() + timedelta(days=1),
            )
        )
    return count >= node.minimum


def step(run, node, status, summary, result=None):
    import json

    result = json.loads(json.dumps(result, default=str))
    rows = list(run.steps)
    rows.append(
        {
            "index": run.cursor,
            "type": node.type,
            "status": status,
            "summary": summary,
            "at": now().isoformat(),
            "result": result,
        }
    )
    run.steps = rows


def proposal_run(db, user, run):
    if run.proposal_run_id:
        return get_owned(db, AgentRun, run.proposal_run_id, user)
    # Deterministic workflow writes still pass through the same exact-preview executor.
    agent = AgentRun(
        id=uuid4(),
        user_id=user.id,
        request_id=uuid5(run.id, "proposals"),
        input_hash=digest(run.definition),
        prompt="Workflow record proposals",
        scopes=["planner"],
        allow_proposals=True,
        status="running",
        origin="workflow",
        queue_expires_at=now() + timedelta(hours=1),
        expires_at=now() + timedelta(days=30),
    )
    db.add(agent)
    db.flush()
    run.proposal_run_id = agent.id
    event(
        db, agent, "system", "Deterministic workflow proposals; no AI call and no records changed."
    )
    return agent


def readable_result(value):
    lines = []
    for metric in [*value.get("metrics", []), *value.get("lines", [])][:30]:
        lines.append(str(metric["label"]) + ": " + str(metric["value"]))
    for key, item in value.items():
        if isinstance(item, (str, int, float, bool)):
            lines.append(key.replace("_", " ").capitalize() + ": " + str(item))
    return "\n".join(lines)[:5000]


def advance(db, user, flow, run, external_fetch=None):
    if run.status in TERMINAL:
        return True
    if not flow.enabled or flow.revision != run.revision:
        stop_run(db, user, run)
        return True
    if run.created_at < now() - timedelta(days=1):
        raise HTTPException(409, "This workflow run expired after 24 hours")
    definition = Definition.model_validate(run.definition)
    if run.started_at is None:
        run.started_at = now()
    run.status = "running"
    while run.cursor < len(definition.nodes):
        node = definition.nodes[run.cursor]
        if node.type == "trigger":
            step(run, node, "completed", "Trigger received")
        elif node.type == "condition":
            passed = condition(db, user, node, run.context)
            step(
                run,
                node,
                "completed" if passed else "skipped",
                "Condition passed" if passed else "Condition not met; remaining steps skipped",
            )
            if not passed:
                run.status = "skipped"
                run.summary = "Condition not met. Remaining steps were skipped."
                run.finished_at = now()
                return True
        elif node.type == "report":
            result = (
                dashboard(user, db) if node.module == "life" else overview(db, user, node.module)
            )
            if node.module != "life":
                result = {
                    **result,
                    "metrics": result["metrics"][:12],
                    "lines": result["lines"][:30],
                    "bounded": True,
                }
            run.context = {**run.context, "output": readable_result(result)}
            step(
                run,
                node,
                "completed",
                "Calculated a report from your current records",
                {"module": node.module, "report": result},
            )
        elif node.type == "external":
            from app.automation.external import fetch

            result = (external_fetch or fetch)(node)
            run.context = {**run.context, "output": readable_result(result)}
            step(run, node, "completed", "External read completed", result)
        elif node.type == "ai":
            check_consent(db, user.id, node.scopes)
            if run.agent_run_id is None:
                result = create_agent(
                    RunWrite(
                        request_id=uuid5(run.id, "ai"),
                        prompt=node.prompt,
                        scopes=node.scopes,
                        allow_proposals=False,
                    ),
                    user,
                    db,
                    Response(),
                )
                run.agent_run_id = result["id"]
                run.status = "waiting_agent"
                return False
            agent = get_owned(db, AgentRun, run.agent_run_id, user)
            if agent.status in {"queued", "running"}:
                run.status = "waiting_agent"
                return False
            if agent.status != "completed":
                raise HTTPException(409, "The linked AI run did not complete; review its history")
            run.context = {**run.context, "output": agent.summary[:5000]}
            step(
                run,
                node,
                "completed",
                "Read-only AI run completed",
                {"agent_run_id": str(agent.id)},
            )
        elif node.type == "action":
            agent = proposal_run(db, user, run)
            spec = TOOLS[node.tool]
            result = prepare(db, agent, spec, spec.args.model_validate(node.arguments))
            step(
                run, node, "prepared", "Prepared for your approval; no life records changed", result
            )
        elif node.type == "approval":
            from app.agentic.approval import expire_run

            agent = db.scalar(
                select(AgentRun)
                .where(AgentRun.user_id == user.id, AgentRun.id == run.proposal_run_id)
                .with_for_update()
            )
            if agent is None:
                raise HTTPException(409, "Approval history was removed")
            expire_run(db, agent)
            if agent.status == "running":
                actions = list(
                    db.scalars(
                        select(AgentAction)
                        .where(AgentAction.user_id == user.id, AgentAction.run_id == agent.id)
                        .order_by(AgentAction.position)
                    )
                )
                agent.status = "awaiting_approval"
                agent.summary = "Workflow changes are ready for your review."
                agent.approval_digest = actions_digest(actions)
                agent.review_nonce = uuid4()
                agent.review_expires_at = now() + timedelta(hours=1)
                event(db, agent, "approval", "Waiting for exact-preview approval")
                notify(
                    db,
                    user.id,
                    "Workflow approval needed",
                    "Review the proposed changes before this workflow continues.",
                    f"approval:{run.id}",
                    f"/agents/{agent.id}",
                )
            if agent.status == "awaiting_approval":
                run.status = "waiting_approval"
                return False
            if agent.status != "completed":
                raise HTTPException(
                    409,
                    "Approval was rejected, cancelled, stale or expired; no remaining steps ran",
                )
            step(
                run,
                node,
                "completed",
                "Approval decision completed",
                {"agent_run_id": str(agent.id), "summary": agent.summary},
            )
        elif node.type == "notify":
            body = node.body + (
                "\n\n" + run.context.get("output", "")[:2000] if node.include_output else ""
            )
            row = notify(
                db,
                user.id,
                node.title,
                body,
                f"workflow:{run.id}:{run.cursor}",
                f"/automation/runs/{run.id}",
            )
            step(
                run,
                node,
                "completed",
                "Saved an in-app notification",
                {"notification_id": str(row.id)},
            )
        else:
            step(run, node, "completed", "Workflow output saved")
            run.summary = run.context.get(
                "output", "Workflow completed. See each step for verified outcomes."
            )[:5000]
        run.cursor += 1
        db.flush()
    run.status = "completed"
    run.finished_at = now()
    return True
