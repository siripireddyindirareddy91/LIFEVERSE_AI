from datetime import datetime, time, timedelta, timezone
from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, Response
from sqlalchemy import delete, func, select, update
from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from app.auth import Identity, current_identity
from app.database import user_session
from app.models import Profile
from app.agentic.models import RetrievalChunk
from app.agentic.rag import invalidate_source
from app.life.models import CalendarEvent, ConsentEvent, Goal, Habit, HabitCheckIn, Memory, Task
from app.life.schemas import (
    CheckInWrite,
    DashboardRead,
    EraseMemories,
    EventRead,
    EventWrite,
    GoalRead,
    GoalWrite,
    HabitRead,
    HabitWrite,
    MemoryRead,
    MemoryWrite,
    Page,
    ProfileRead,
    ProfileWrite,
    TaskRead,
    TaskStatus,
    TaskWrite,
)
from app.life.service import (
    active_memory_filters,
    get_owned,
    habit_read,
    list_owned,
    now,
    purge_expired,
    update_record,
    user_timezone,
    user_today,
)

router = APIRouter(prefix="/api/v1", tags=["life"])
User = Annotated[Identity, Depends(current_identity)]
DB = Annotated[Session, Depends(user_session)]
Limit = Annotated[int, Query(ge=1, le=100)]
Offset = Annotated[int, Query(ge=0, le=100000)]
Search = Annotated[str, Query(max_length=120)]


@router.get("/profile", response_model=ProfileRead)
def profile(user: User, db: DB):
    row = db.get(Profile, user.id)
    if row is None:
        raise HTTPException(404, "Create your profile to get started")
    return row


@router.put("/profile", response_model=ProfileRead)
def save_profile(payload: ProfileWrite, user: User, db: DB):
    row = db.scalar(select(Profile).where(Profile.user_id == user.id).with_for_update())
    if row is None:
        row = Profile(user_id=user.id, ai_consent=False, memory_consent=False)
        db.add(row)
    for field, kind in (
        ("ai_consent", "ai"),
        ("memory_consent", "memory"),
        ("knowledge_consent", "knowledge"),
    ):
        if bool(getattr(row, field)) != getattr(payload, field):
            db.add(ConsentEvent(user_id=user.id, kind=kind, allowed=getattr(payload, field)))
    if row.memory_consent and not payload.memory_consent:
        db.execute(
            delete(RetrievalChunk).where(
                RetrievalChunk.user_id == user.id, RetrievalChunk.memory_id.is_not(None)
            )
        )
    if row.knowledge_consent and not payload.knowledge_consent:
        db.execute(
            delete(RetrievalChunk).where(
                RetrievalChunk.user_id == user.id, RetrievalChunk.source_id.is_not(None)
            )
        )
    update_record(row, payload)
    db.flush()
    return row


@router.get("/goals", response_model=Page[GoalRead])
def goals(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, q: Search = ""):
    return list_owned(db, Goal, user, limit, offset, q)


@router.post("/goals", response_model=GoalRead, status_code=201)
def create_goal(payload: GoalWrite, user: User, db: DB):
    row = Goal(user_id=user.id, **payload.model_dump())
    db.add(row)
    db.flush()
    return row


@router.get("/goals/{record_id}", response_model=GoalRead)
def goal_detail(record_id: UUID, user: User, db: DB):
    return get_owned(db, Goal, record_id, user)


@router.put("/goals/{record_id}", response_model=GoalRead)
def edit_goal(record_id: UUID, payload: GoalWrite, user: User, db: DB):
    row = get_owned(db, Goal, record_id, user)
    update_record(row, payload)
    db.flush()
    return row


@router.delete("/goals/{record_id}", status_code=204)
def delete_goal(record_id: UUID, user: User, db: DB):
    row = get_owned(db, Goal, record_id, user)
    db.execute(
        update(Task).where(Task.user_id == user.id, Task.goal_id == record_id).values(goal_id=None)
    )
    db.delete(row)
    db.flush()
    return Response(status_code=204)


@router.get("/tasks", response_model=Page[TaskRead])
def tasks(
    user: User,
    db: DB,
    limit: Limit = 30,
    offset: Offset = 0,
    q: Search = "",
    status: Literal["todo", "done"] | None = None,
    goal_id: UUID | None = None,
):
    filters = []
    if status:
        filters.append(Task.status == status)
    if goal_id:
        filters.append(Task.goal_id == goal_id)
    return list_owned(db, Task, user, limit, offset, q, filters)


def set_task(row: Task, payload: TaskWrite, user: Identity, db: Session):
    if payload.goal_id:
        get_owned(db, Goal, payload.goal_id, user)
    was_done = row.status == "done"
    update_record(row, payload)
    row.completed_at = (
        (row.completed_at if was_done else now()) if payload.status == "done" else None
    )


@router.post("/tasks", response_model=TaskRead, status_code=201)
def create_task(payload: TaskWrite, user: User, db: DB):
    row = Task(user_id=user.id)
    set_task(row, payload, user, db)
    db.add(row)
    db.flush()
    return row


@router.put("/tasks/{record_id}", response_model=TaskRead)
def edit_task(record_id: UUID, payload: TaskWrite, user: User, db: DB):
    row = get_owned(db, Task, record_id, user)
    set_task(row, payload, user, db)
    db.flush()
    return row


@router.patch("/tasks/{record_id}/status", response_model=TaskRead)
def task_status(record_id: UUID, payload: TaskStatus, user: User, db: DB):
    row = get_owned(db, Task, record_id, user)
    if row.status != payload.status:
        row.completed_at = now() if payload.status == "done" else None
    row.status = payload.status
    db.flush()
    return row


@router.delete("/tasks/{record_id}", status_code=204)
def delete_task(record_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, Task, record_id, user))
    db.flush()
    return Response(status_code=204)


@router.get("/events", response_model=Page[EventRead])
def events(
    user: User,
    db: DB,
    limit: Limit = 30,
    offset: Offset = 0,
    q: Search = "",
    starts_after: datetime | None = None,
    ends_before: datetime | None = None,
):
    if starts_after and ends_before:
        if starts_after.tzinfo is None or ends_before.tzinfo is None or ends_before <= starts_after:
            raise HTTPException(
                422, "Date filters require an end after the start, with UTC offsets"
            )
    filters = []
    if starts_after:
        if starts_after.tzinfo is None:
            raise HTTPException(422, "Date filters require a UTC offset")
        filters.append(CalendarEvent.ends_at > starts_after)
    if ends_before:
        if ends_before.tzinfo is None:
            raise HTTPException(422, "Date filters require a UTC offset")
        filters.append(CalendarEvent.starts_at < ends_before)
    return list_owned(db, CalendarEvent, user, limit, offset, q, filters)


def validate_event(payload: EventWrite, user: Identity, db: Session, record_id=None):
    # Serialize event changes per user so simultaneous overlapping creates cannot both pass.
    lock_id = int.from_bytes(user.id.bytes[:8], "big", signed=True)
    if not db.scalar(select(func.pg_try_advisory_xact_lock(lock_id))):
        raise HTTPException(409, "Another calendar change is in progress. Retry shortly.")
    conflict = select(CalendarEvent.id).where(
        CalendarEvent.user_id == user.id,
        CalendarEvent.starts_at < payload.ends_at,
        CalendarEvent.ends_at > payload.starts_at,
    )
    if record_id:
        conflict = conflict.where(CalendarEvent.id != record_id)
    if not payload.allow_overlap and db.scalar(conflict.limit(1)):
        raise HTTPException(409, "This overlaps an existing event. Confirm overlap to save anyway.")


@router.post("/events", response_model=EventRead, status_code=201)
def create_event(payload: EventWrite, user: User, db: DB):
    validate_event(payload, user, db)
    row = CalendarEvent(user_id=user.id, **payload.model_dump(exclude={"allow_overlap"}))
    db.add(row)
    db.flush()
    return row


@router.put("/events/{record_id}", response_model=EventRead)
def edit_event(record_id: UUID, payload: EventWrite, user: User, db: DB):
    row = get_owned(db, CalendarEvent, record_id, user)
    validate_event(payload, user, db, record_id)
    update_record(row, payload, ("allow_overlap",))
    db.flush()
    return row


@router.delete("/events/{record_id}", status_code=204)
def delete_event(record_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, CalendarEvent, record_id, user))
    db.flush()
    return Response(status_code=204)


@router.get("/habits", response_model=Page[HabitRead])
def habits(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, q: Search = ""):
    page = list_owned(db, Habit, user, limit, offset, q)
    page["items"] = [habit_read(db, row, user) for row in page["items"]]
    return page


@router.post("/habits", response_model=HabitRead, status_code=201)
def create_habit(payload: HabitWrite, user: User, db: DB):
    row = Habit(user_id=user.id, **payload.model_dump())
    db.add(row)
    db.flush()
    return habit_read(db, row, user)


@router.put("/habits/{record_id}", response_model=HabitRead)
def edit_habit(record_id: UUID, payload: HabitWrite, user: User, db: DB):
    row = get_owned(db, Habit, record_id, user)
    update_record(row, payload)
    db.flush()
    return habit_read(db, row, user)


@router.post("/habits/{record_id}/checkins", response_model=HabitRead)
def check_in(record_id: UUID, payload: CheckInWrite, user: User, db: DB):
    row = get_owned(db, Habit, record_id, user)
    if not row.active:
        raise HTTPException(409, "Activate this habit before checking in")
    day = payload.day or user_today(db, user)
    if day > user_today(db, user):
        raise HTTPException(422, "Future check-ins are not allowed")
    from uuid import uuid4

    db.execute(
        insert(HabitCheckIn)
        .values(id=uuid4(), user_id=user.id, habit_id=record_id, day=day)
        .on_conflict_do_nothing(index_elements=["user_id", "habit_id", "day"])
    )
    db.flush()
    return habit_read(db, row, user)


@router.delete("/habits/{record_id}/checkins", response_model=HabitRead)
def undo_check_in(record_id: UUID, user: User, db: DB):
    row = get_owned(db, Habit, record_id, user)
    db.execute(
        delete(HabitCheckIn).where(
            HabitCheckIn.user_id == user.id,
            HabitCheckIn.habit_id == record_id,
            HabitCheckIn.day == user_today(db, user),
        )
    )
    return habit_read(db, row, user)


@router.delete("/habits/{record_id}", status_code=204)
def delete_habit(record_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, Habit, record_id, user))
    db.flush()
    return Response(status_code=204)


@router.get("/memories/export", response_model=list[MemoryRead])
def export_memories(user: User, db: DB):
    purge_expired(db, user)
    return list(
        db.scalars(
            select(Memory).where(Memory.user_id == user.id).order_by(Memory.created_at, Memory.id)
        )
    )


@router.get("/memories", response_model=Page[MemoryRead])
def memories(user: User, db: DB, limit: Limit = 30, offset: Offset = 0, q: Search = ""):
    purge_expired(db, user)
    return list_owned(db, Memory, user, limit, offset, q, active_memory_filters())


@router.post("/memories", response_model=MemoryRead, status_code=201)
def create_memory(payload: MemoryWrite, user: User, db: DB):
    row = Memory(user_id=user.id, **payload.model_dump())
    db.add(row)
    db.flush()
    return row


@router.put("/memories/{record_id}", response_model=MemoryRead)
def edit_memory(record_id: UUID, payload: MemoryWrite, user: User, db: DB):
    purge_expired(db, user)
    row = get_owned(db, Memory, record_id, user)
    update_record(row, payload)
    invalidate_source(db, user.id, "memory", row)
    db.flush()
    return row


@router.delete("/memories/{record_id}", status_code=204)
def delete_memory(record_id: UUID, user: User, db: DB):
    db.delete(get_owned(db, Memory, record_id, user))
    db.flush()
    return Response(status_code=204)


@router.delete("/memories", status_code=204)
def erase_memories(payload: EraseMemories, user: User, db: DB):
    db.execute(delete(Memory).where(Memory.user_id == user.id))
    return Response(status_code=204)


@router.get("/dashboard", response_model=DashboardRead)
def dashboard(user: User, db: DB):
    zone = user_timezone(db, user)
    today = user_today(db, user)
    start = datetime.combine(today, time.min, tzinfo=zone).astimezone(timezone.utc)
    end = datetime.combine(today + timedelta(days=1), time.min, tzinfo=zone).astimezone(
        timezone.utc
    )

    def count(model, *filters):
        return db.scalar(
            select(func.count()).select_from(model).where(model.user_id == user.id, *filters)
        )

    def completed_for(day):
        begin = datetime.combine(day, time.min, tzinfo=zone).astimezone(timezone.utc)
        finish = datetime.combine(day + timedelta(days=1), time.min, tzinfo=zone).astimezone(
            timezone.utc
        )
        return count(Task, Task.completed_at >= begin, Task.completed_at < finish)

    checked = db.scalar(
        select(func.count())
        .select_from(HabitCheckIn)
        .join(Habit, HabitCheckIn.habit_id == Habit.id)
        .where(
            HabitCheckIn.user_id == user.id,
            Habit.user_id == user.id,
            Habit.active.is_(True),
            HabitCheckIn.day == today,
        )
    )
    return {
        "timezone": str(zone),
        "today": today,
        "tasks_open": count(Task, Task.status == "todo"),
        "tasks_completed": count(Task, Task.status == "done"),
        "tasks_due_today": count(
            Task, Task.status == "todo", Task.due_at >= start, Task.due_at < end
        ),
        "tasks_overdue": count(Task, Task.status == "todo", Task.due_at < now()),
        "goals_active": count(Goal, Goal.progress < 100),
        "goals_completed": count(Goal, Goal.progress == 100),
        "habit_count": count(Habit, Habit.active.is_(True)),
        "habits_completed_today": checked,
        "memories_active": count(Memory, *active_memory_filters()),
        "weekly_activity": [
            {
                "day": day,
                "tasks_completed": completed_for(day),
                "habit_checkins": count(HabitCheckIn, HabitCheckIn.day == day),
            }
            for day in [today - timedelta(days=i) for i in range(6, -1, -1)]
        ],
    }
