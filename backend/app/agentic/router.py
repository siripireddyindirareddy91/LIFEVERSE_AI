from datetime import timedelta
from uuid import UUID, uuid4

from fastapi import APIRouter, Depends, HTTPException, Response
from sqlalchemy import delete, func, select

from app.agentic.approval import decide, expire_run
from app.agentic.common import TERMINAL, check_consent, digest, event
from app.agentic.models import (
    AgentAction,
    AgentJob,
    AgentRun,
    AgentStep,
    AgentUsage,
    AgentWorker,
    KnowledgeSource,
)
from app.agentic.provider import get_embedder
from app.agentic.rag import index_source, invalidate_source, knowledge_read
from app.agentic.schemas import (
    DecisionWrite,
    KnowledgeRead,
    KnowledgeWrite,
    RunDetail,
    RunRead,
    RunWrite,
)
from app.agentic.tools import AGENTS, TOOLS
from app.config import get_settings
from app.life.models import Memory
from app.life.router import DB, Limit, Offset, Search, User
from app.life.schemas import MemoryRead, Page
from app.life.service import get_owned, list_owned, now, update_record
from app.models import Profile

router = APIRouter(prefix="/api/v1", tags=["agents"])


def action_read(db, user, action):
    before = action.before or {}
    preview = []
    if before.get("title"):
        preview.append({"name": "Target", "before": None, "after": before["title"]})

    def display(value):
        if value is None:
            return "Not set"
        if isinstance(value, bool):
            return "Yes" if value else "No"
        return str(value)

    for key, value in action.arguments.items():
        if key == "record_id" or key == "clear_due_date" or (value is None and before):
            continue
        if key == "goal_id" and value is not None:
            from app.life.models import Goal

            goal = db.scalar(select(Goal).where(Goal.user_id == user.id, Goal.id == UUID(value)))
            parent = db.scalar(
                select(AgentAction).where(
                    AgentAction.user_id == user.id,
                    AgentAction.run_id == action.run_id,
                    AgentAction.record_id == UUID(value),
                    AgentAction.tool == "create_goal",
                )
            )
            value = (
                goal.title
                if goal
                else parent.arguments["title"]
                if parent
                else "Goal no longer available"
            )
        preview.append(
            {
                "name": key.replace("_", " ").capitalize(),
                "before": display(before[key]) if key in before else None,
                "after": display(value),
            }
        )
    if action.arguments.get("clear_due_date"):
        preview.append(
            {"name": "Due at", "before": display(before.get("due_at")), "after": "Not set"}
        )
    if action.tool == "save_memory":
        preview.append({"name": "AI sharing", "before": None, "after": "Off — saved privately"})
    return {
        "id": action.id,
        "position": action.position,
        "agent": action.agent,
        "tool": action.tool,
        "label": action.label,
        "status": action.status,
        "record_id": action.record_id,
        "dependencies": action.dependencies,
        "preview": preview,
        "permission_level": 2,
        "result": action.result,
    }


def detail(db, user, run):
    result = RunRead.model_validate(run).model_dump()
    result["actions"] = [
        action_read(db, user, action)
        for action in db.scalars(
            select(AgentAction)
            .where(AgentAction.user_id == user.id, AgentAction.run_id == run.id)
            .order_by(AgentAction.position)
        )
    ]
    result["steps"] = list(
        db.scalars(
            select(AgentStep)
            .where(AgentStep.user_id == user.id, AgentStep.run_id == run.id)
            .order_by(AgentStep.sequence)
        )
    )
    return result


def purge(db, user):
    db.execute(
        delete(AgentRun).where(
            AgentRun.user_id == user.id, AgentRun.expires_at <= now(), AgentRun.status.in_(TERMINAL)
        )
    )
    db.execute(
        delete(AgentUsage).where(
            AgentUsage.user_id == user.id, AgentUsage.created_at < now() - timedelta(days=2)
        )
    )
    for row in db.scalars(
        select(AgentRun)
        .where(AgentRun.user_id == user.id, AgentRun.status.in_(["queued", "awaiting_approval"]))
        .with_for_update(skip_locked=True)
    ):
        expire_run(db, row)


@router.get("/agents/status")
def agent_status(user: User, db: DB):
    settings = get_settings()
    profile = db.get(Profile, user.id)
    online = db.scalar(
        select(func.count())
        .select_from(AgentWorker)
        .where(AgentWorker.last_seen > now() - timedelta(seconds=60))
    )
    return {
        "configured": bool(settings.ai_model and settings.ai_api_key.get_secret_value()),
        "consent_required": not bool(profile and profile.ai_consent),
        "worker_online": bool(online),
        "embeddings_configured": bool(
            settings.ai_embedding_model and settings.ai_api_key.get_secret_value()
        ),
        "max_model_calls": settings.agent_max_model_calls,
        "max_tool_calls": settings.agent_max_tool_calls,
        "daily_limit": settings.agent_runs_per_day,
        "history_days": settings.agent_history_days,
    }


@router.get("/agents/catalog")
def catalog(user: User):
    return {
        "permission_levels": [
            {"level": 1, "label": "Read selected internal data", "available": True},
            {
                "level": 2,
                "label": "Change internal records after exact-preview approval",
                "available": True,
            },
            {
                "level": 3,
                "label": "External actions require stronger confirmation",
                "available": False,
            },
            {
                "level": 4,
                "label": "Restricted or unsupported actions are denied",
                "available": False,
            },
        ],
        "agents": [
            {"name": name, "label": label, "scope": None if name == "assistant" else name}
            for name, label in AGENTS.items()
        ],
        "tools": [
            {
                "name": spec.name,
                "label": spec.label,
                "agent": spec.agent,
                "scope": spec.scope,
                "permission_level": 2 if spec.write else 1,
                "prepares_changes": spec.write,
            }
            for spec in TOOLS.values()
        ],
    }


@router.get("/agents/runs", response_model=Page[RunRead])
def runs(user: User, db: DB, limit: Limit = 30, offset: Offset = 0):
    purge(db, user)
    conditions = (AgentRun.user_id == user.id,)
    total = db.scalar(select(func.count()).select_from(AgentRun).where(*conditions))
    rows = db.scalars(
        select(AgentRun)
        .where(*conditions)
        .order_by(AgentRun.created_at.desc(), AgentRun.id)
        .limit(limit)
        .offset(offset)
    ).all()
    return {"items": rows, "total": total, "limit": limit, "offset": offset}


@router.post("/agents/runs", response_model=RunDetail, status_code=201)
def create_run(payload: RunWrite, user: User, db: DB, response: Response):
    check_consent(db, user.id, payload.scopes)
    fingerprint = digest(payload.model_dump(mode="json"))
    previous = db.scalar(
        select(AgentRun).where(
            AgentRun.user_id == user.id, AgentRun.request_id == payload.request_id
        )
    )
    if previous:
        if previous.input_hash != fingerprint:
            raise HTTPException(409, "That request identifier was used for a different plan.")
        response.status_code = 200
        return detail(db, user, previous)
    settings = get_settings()
    if not settings.ai_model or not settings.ai_api_key.get_secret_value():
        raise HTTPException(503, "The agent AI provider has not been configured.")
    # Serialize enqueue/rate decisions for this owner without holding a lock during AI calls.
    lock_id = int.from_bytes(user.id.bytes[:8], "big", signed=True)
    if not db.scalar(select(func.pg_try_advisory_xact_lock(lock_id))):
        raise HTTPException(409, "Another change is in progress. Retry shortly.")
    previous = db.scalar(
        select(AgentRun).where(
            AgentRun.user_id == user.id, AgentRun.request_id == payload.request_id
        )
    )
    if previous:
        if previous.input_hash != fingerprint:
            raise HTTPException(409, "That request identifier was used for a different plan.")
        response.status_code = 200
        return detail(db, user, previous)
    if db.scalar(
        select(AgentUsage.id).where(
            AgentUsage.user_id == user.id, AgentUsage.request_id == payload.request_id
        )
    ):
        raise HTTPException(409, "A deleted run used this request identifier. Start a new request.")
    used = db.scalar(
        select(func.count())
        .select_from(AgentUsage)
        .where(AgentUsage.user_id == user.id, AgentUsage.created_at > now() - timedelta(days=1))
    )
    if used >= settings.agent_runs_per_day:
        raise HTTPException(429, "The rolling-day agent request limit has been reached.")
    purge(db, user)
    active = db.scalar(
        select(AgentRun.id)
        .where(AgentRun.user_id == user.id, AgentRun.status.in_(["queued", "running"]))
        .limit(1)
    )
    if active:
        raise HTTPException(409, "A plan is already queued or running. Finish or cancel it first.")
    run = AgentRun(
        id=uuid4(),
        user_id=user.id,
        request_id=payload.request_id,
        input_hash=fingerprint,
        prompt=payload.prompt,
        scopes=payload.scopes,
        allow_proposals=payload.allow_proposals,
        status="queued",
        queue_expires_at=now() + timedelta(hours=1),
        expires_at=now() + timedelta(days=settings.agent_history_days),
    )
    db.add(run)
    db.flush()
    db.add(AgentJob(user_id=user.id, run_id=run.id, status="pending", attempts=0))
    db.add(AgentUsage(user_id=user.id, request_id=payload.request_id))
    event(db, run, "system", "Queued for an agent worker.")
    return detail(db, user, run)


@router.get("/agents/runs/{run_id}", response_model=RunDetail)
def get_run(run_id: UUID, user: User, db: DB):
    run = db.scalar(
        select(AgentRun).where(AgentRun.user_id == user.id, AgentRun.id == run_id).with_for_update()
    )
    if run is None:
        raise HTTPException(404, "Run not found")
    expire_run(db, run)
    return detail(db, user, run)


@router.post("/agents/runs/{run_id}/decision", response_model=RunDetail)
def decision(run_id: UUID, payload: DecisionWrite, user: User, db: DB):
    run = db.scalar(
        select(AgentRun).where(AgentRun.user_id == user.id, AgentRun.id == run_id).with_for_update()
    )
    if run is None:
        raise HTTPException(404, "Run not found")
    decide(db, run, payload)
    return detail(db, user, run)


@router.post("/agents/runs/{run_id}/cancel", response_model=RunDetail)
def cancel(run_id: UUID, user: User, db: DB):
    run = db.scalar(
        select(AgentRun).where(AgentRun.user_id == user.id, AgentRun.id == run_id).with_for_update()
    )
    if run is None:
        raise HTTPException(404, "Run not found")
    if run.status not in TERMINAL:
        run.status = "cancelled"
        run.finished_at = now()
        run.summary = "Cancelled. No proposals were applied."
        for action in db.scalars(
            select(AgentAction).where(AgentAction.user_id == user.id, AgentAction.run_id == run_id)
        ):
            action.status = "blocked"
        job = db.scalar(
            select(AgentJob).where(AgentJob.user_id == user.id, AgentJob.run_id == run_id)
        )
        if job:
            job.status = "done"
            job.lease_until = None
        event(db, run, "system", "User cancelled remaining work.")
    return detail(db, user, run)


@router.delete("/agents/runs/{run_id}", status_code=204)
def delete_run(run_id: UUID, user: User, db: DB):
    run = get_owned(db, AgentRun, run_id, user)
    if run.status not in TERMINAL:
        raise HTTPException(409, "Stop or reject the plan before deleting its history.")
    db.delete(run)
    db.flush()
    return Response(status_code=204)


@router.get("/knowledge", response_model=Page[KnowledgeRead])
def sources(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, q: Search = ""):
    db.execute(
        delete(KnowledgeSource).where(
            KnowledgeSource.user_id == user.id, KnowledgeSource.expires_at <= now()
        )
    )
    page = list_owned(db, KnowledgeSource, user, limit, offset, q)
    page["items"] = [knowledge_read(db, user.id, source) for source in page["items"]]
    return page


@router.post("/knowledge", response_model=KnowledgeRead, status_code=201)
def create_source(payload: KnowledgeWrite, user: User, db: DB):
    source = KnowledgeSource(user_id=user.id, **payload.model_dump())
    db.add(source)
    db.flush()
    return knowledge_read(db, user.id, source)


@router.put("/knowledge/{source_id}", response_model=KnowledgeRead)
def edit_source(source_id: UUID, payload: KnowledgeWrite, user: User, db: DB):
    source = get_owned(db, KnowledgeSource, source_id, user)
    update_record(source, payload)
    invalidate_source(db, user.id, "knowledge", source)
    db.flush()
    return knowledge_read(db, user.id, source)


@router.get("/knowledge/{source_id}", response_model=KnowledgeRead)
def source_detail(source_id: UUID, user: User, db: DB):
    source = get_owned(db, KnowledgeSource, source_id, user)
    if source.expires_at is not None and source.expires_at <= now():
        raise HTTPException(404, "Source expired")
    return knowledge_read(db, user.id, source)


@router.get("/memories/{source_id}", response_model=MemoryRead)
def memory_detail(source_id: UUID, user: User, db: DB):
    source = get_owned(db, Memory, source_id, user)
    if source.expires_at is not None and source.expires_at <= now():
        raise HTTPException(404, "Source expired")
    return source


@router.delete("/knowledge/{source_id}", status_code=204)
def delete_source(source_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, KnowledgeSource, source_id, user))
    db.flush()
    return Response(status_code=204)


@router.post("/retrieval/{kind}/{source_id}/index")
def index(kind: str, source_id: UUID, user: User, db: DB, embedder=Depends(get_embedder)):
    return index_source(db, user.id, kind, source_id, embedder)
