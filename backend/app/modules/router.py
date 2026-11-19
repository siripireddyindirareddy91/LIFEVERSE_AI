from datetime import date
from uuid import UUID
from fastapi import APIRouter, HTTPException, Response
from sqlalchemy import select
from app.agentic.common import digest
from app.agentic.models import KnowledgeSource
from app.agentic.provider import get_embedder
from app.agentic.rag import search, invalidate_source
from app.life.models import Task
from app.life.router import User, DB, Limit, Offset, Search, set_task
from app.life.schemas import TaskWrite
from app.life.service import get_owned, list_owned, now
from app.modules.models import KnowledgeLink, ModuleOperation, ModuleRecord
from app.modules.schemas import (
    MODULE_KINDS,
    SCHEMAS,
    Conversion,
    LinkWrite,
    PlannerLink,
    QuizAnswer,
    RecordWrite,
    RetrievalQuery,
)
from app.modules.service import (
    lock_owner,
    money,
    module_kinds,
    overview,
    projection,
    record_read,
    resume_export,
    save_record,
)

router = APIRouter(prefix="/api/v1", tags=["advanced modules"])


@router.get("/modules/catalog")
def catalog(user: User):
    return {
        "modules": MODULE_KINDS,
        "schemas": {kind: schema.model_json_schema() for kind, schema in SCHEMAS.items()},
    }


@router.get("/modules/{module}/overview")
def summary(module: str, user: User, db: DB, month: date | None = None):
    return overview(db, user, module, month)


@router.get("/modules/{module}/records")
def records(
    module: str,
    user: User,
    db: DB,
    kind: str | None = None,
    parent_id: UUID | None = None,
    q: Search = "",
    limit: Limit = 30,
    offset: Offset = 0,
):
    kinds = module_kinds(module)
    if kind is not None and kind not in kinds:
        raise HTTPException(422, "Record type is not part of this module")
    filters = [ModuleRecord.kind.in_([kind] if kind else kinds)]
    if parent_id:
        filters.append(ModuleRecord.parent_id == parent_id)
    page = list_owned(db, ModuleRecord, user, limit, offset, q, filters)
    page["items"] = [record_read(row) for row in page["items"]]
    return page


@router.post("/modules/records/{kind}", status_code=201)
def create(kind: str, payload: RecordWrite, user: User, db: DB, response: Response):
    row, cached = save_record(db, user, kind, payload)
    if cached:
        response.status_code = 200
    return record_read(row)


@router.get("/modules/record/{record_id}")
def record(record_id: UUID, user: User, db: DB):
    return record_read(get_owned(db, ModuleRecord, record_id, user))


@router.put("/modules/record/{record_id}")
def update(record_id: UUID, payload: RecordWrite, user: User, db: DB):
    lock_owner(db, user)
    row = db.scalar(
        select(ModuleRecord)
        .where(ModuleRecord.user_id == user.id, ModuleRecord.id == record_id)
        .with_for_update()
    )
    if row is None:
        raise HTTPException(404, "Record not found")
    return record_read(save_record(db, user, row.kind, payload, row)[0])


@router.delete("/modules/record/{record_id}", status_code=204)
def remove(record_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    db.delete(get_owned(db, ModuleRecord, record_id, user))
    db.flush()
    return Response(status_code=204)


@router.post("/modules/record/{record_id}/planner")
def plan(record_id: UUID, payload: PlannerLink, user: User, db: DB):
    lock_owner(db, user)
    row = get_owned(db, ModuleRecord, record_id, user)
    fingerprint = digest({"record_id": record_id, "due_at": payload.due_at})
    previous = db.scalar(
        select(ModuleOperation).where(
            ModuleOperation.user_id == user.id, ModuleOperation.request_id == payload.request_id
        )
    )
    if previous:
        if previous.input_hash != fingerprint:
            raise HTTPException(409, "Request identifier used for a different task")
        task = get_owned(db, Task, previous.task_id, user)
        return {"task_id": task.id, "cached": True}
    task = Task(user_id=user.id)
    set_task(
        task,
        TaskWrite(
            title=row.title,
            notes=("From " + row.kind + "\n" + row.data.get("notes", ""))[:4000],
            due_at=payload.due_at,
        ),
        user,
        db,
    )
    db.add(task)
    db.flush()
    db.add(
        ModuleOperation(
            user_id=user.id, request_id=payload.request_id, input_hash=fingerprint, task_id=task.id
        )
    )
    return {"task_id": task.id, "cached": False}


@router.post("/finance/convert")
def convert(payload: Conversion, user: User):
    return {
        "amount": money(payload.amount * payload.rate),
        "currency": payload.to_currency,
        "rate": str(payload.rate),
        "rate_date": payload.rate_date,
        "method": "Your manually entered rate; no live exchange feed.",
    }


@router.get("/learning/practice/{record_id}")
def practice(record_id: UUID, user: User, db: DB):
    row = get_owned(db, ModuleRecord, record_id, user)
    if row.kind not in {"quiz", "flashcard"}:
        raise HTTPException(422, "Choose a quiz question or flashcard")
    return {
        "id": row.id,
        "kind": row.kind,
        "title": row.title,
        "question": row.data["question"],
        "options": {key.upper(): row.data["option_" + key] for key in "abcd"}
        if row.kind == "quiz"
        else {},
    }


@router.post("/learning/practice/{record_id}")
def answer(record_id: UUID, payload: QuizAnswer, user: User, db: DB):
    row = get_owned(db, ModuleRecord, record_id, user)
    if row.kind != "quiz":
        raise HTTPException(422, "Choose a quiz question")
    return {
        "correct": payload.answer == row.data["correct"],
        "answer": row.data["correct"],
        "explanation": row.data["explanation"],
        "score": 1 if payload.answer == row.data["correct"] else 0,
        "total": 1,
    }


@router.get("/career/resume/{record_id}")
def resume(record_id: UUID, user: User, db: DB):
    row = get_owned(db, ModuleRecord, record_id, user)
    if row.kind != "resume":
        raise HTTPException(422, "Choose a resume")
    return resume_export(row.data)


@router.get("/future/scenarios/{record_id}")
def simulate(record_id: UUID, user: User, db: DB):
    row = get_owned(db, ModuleRecord, record_id, user)
    if row.kind != "scenario":
        raise HTTPException(422, "Choose a scenario")
    return projection(row.data)


@router.get("/knowledge-universe/graph")
def graph(user: User, db: DB, q: Search = ""):
    page = list_owned(
        db,
        KnowledgeSource,
        user,
        100,
        0,
        q,
        [(KnowledgeSource.expires_at.is_(None)) | (KnowledgeSource.expires_at > now())],
    )
    ids = [source.id for source in page["items"]]
    links = db.scalars(
        select(KnowledgeLink)
        .where(
            KnowledgeLink.user_id == user.id,
            KnowledgeLink.source_id.in_(ids),
            KnowledgeLink.target_id.in_(ids),
        )
        .order_by(KnowledgeLink.created_at)
        .limit(300)
    )
    return {
        "nodes": [{"id": s.id, "title": s.title, "allow_ai": s.allow_ai} for s in page["items"]],
        "edges": [
            {
                "id": link.id,
                "source_id": link.source_id,
                "target_id": link.target_id,
                "label": link.label,
            }
            for link in links
        ],
        "total": page["total"],
        "limit": 100,
    }


@router.post("/knowledge-universe/links", status_code=201)
def connect(payload: LinkWrite, user: User, db: DB):
    lock_owner(db, user)
    if payload.source_id == payload.target_id:
        raise HTTPException(422, "Choose two different sources")
    for source_id in [payload.source_id, payload.target_id]:
        source = get_owned(db, KnowledgeSource, source_id, user)
        if source.expires_at and source.expires_at <= now():
            raise HTTPException(422, "Source expired")
    for source in db.scalars(
        select(KnowledgeSource)
        .where(
            KnowledgeSource.user_id == user.id,
            KnowledgeSource.id.in_([payload.source_id, payload.target_id]),
        )
        .order_by(KnowledgeSource.id)
        .with_for_update()
    ):
        invalidate_source(db, user.id, "knowledge", source)
    old = db.scalar(
        select(KnowledgeLink).where(
            KnowledgeLink.user_id == user.id,
            KnowledgeLink.source_id == payload.source_id,
            KnowledgeLink.target_id == payload.target_id,
        )
    )
    if old:
        old.label = payload.label
        return {"id": old.id}
    link = KnowledgeLink(user_id=user.id, **payload.model_dump())
    db.add(link)
    db.flush()
    return {"id": link.id}


@router.delete("/knowledge-universe/links/{link_id}", status_code=204)
def disconnect(link_id: UUID, user: User, db: DB):
    lock_owner(db, user)
    link = get_owned(db, KnowledgeLink, link_id, user)
    for source in db.scalars(
        select(KnowledgeSource)
        .where(
            KnowledgeSource.user_id == user.id,
            KnowledgeSource.id.in_([link.source_id, link.target_id]),
        )
        .order_by(KnowledgeSource.id)
        .with_for_update()
    ):
        invalidate_source(db, user.id, "knowledge", source)
    db.delete(link)
    db.flush()
    return Response(status_code=204)


@router.post("/knowledge-universe/search")
def retrieve(payload: RetrievalQuery, user: User, db: DB):
    return search(
        db, user.id, "knowledge", payload.query, 5, get_embedder() if payload.semantic else None
    )
