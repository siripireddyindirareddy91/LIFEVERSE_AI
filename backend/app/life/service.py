from datetime import date, datetime, timedelta, timezone
from uuid import UUID
from zoneinfo import ZoneInfo

from fastapi import HTTPException
from sqlalchemy import delete, func, or_, select
from sqlalchemy.orm import Session

from app.auth import Identity
from app.life.models import Conversation, HabitCheckIn, Memory
from app.models import Profile


def now():
    return datetime.now(timezone.utc)


def user_timezone(session: Session, identity: Identity):
    profile = session.get(Profile, identity.id)
    return ZoneInfo(profile.timezone if profile else "UTC")


def user_today(session: Session, identity: Identity) -> date:
    return now().astimezone(user_timezone(session, identity)).date()


def get_owned(session: Session, model, record_id: UUID, identity: Identity):
    row = session.scalar(select(model).where(model.id == record_id, model.user_id == identity.id))
    if row is None:
        raise HTTPException(404, "Record not found")
    return row


def list_owned(
    session: Session, model, identity: Identity, limit: int, offset: int, q: str = "", filters=()
):
    conditions = [model.user_id == identity.id, *filters]
    if q:
        # Literal substring search: user wildcards must not expand query scope.
        escaped = q.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")
        conditions.append(model.title.ilike(f"%{escaped}%", escape="\\"))
    total = session.scalar(select(func.count()).select_from(model).where(*conditions))
    items = session.scalars(
        select(model)
        .where(*conditions)
        .order_by(model.created_at.desc(), model.id)
        .offset(offset)
        .limit(limit)
    ).all()
    return {"items": list(items), "total": total, "limit": limit, "offset": offset}


def update_record(record, payload, exclude=()):
    for key, value in payload.model_dump(exclude=set(exclude)).items():
        setattr(record, key, value)


def purge_expired(session: Session, identity: Identity):
    session.execute(delete(Memory).where(Memory.user_id == identity.id, Memory.expires_at <= now()))
    session.execute(
        delete(Conversation).where(
            Conversation.user_id == identity.id, Conversation.expires_at <= now()
        )
    )


def habit_read(session: Session, habit, identity: Identity):
    today = user_today(session, identity)
    days = session.scalars(
        select(HabitCheckIn.day)
        .where(HabitCheckIn.user_id == identity.id, HabitCheckIn.habit_id == habit.id)
        .order_by(HabitCheckIn.day.desc())
    ).all()
    checked = bool(days and days[0] == today)
    expected = today if checked else today - timedelta(days=1)
    streak = 0
    for day in days:
        if day != expected:
            break
        streak += 1
        expected -= timedelta(days=1)
    return {
        "id": habit.id,
        "title": habit.title,
        "notes": habit.notes,
        "active": habit.active,
        "created_at": habit.created_at,
        "checked_today": checked,
        "current_streak": streak,
        "today": today,
    }


def active_memory_filters():
    return (or_(Memory.expires_at.is_(None), Memory.expires_at > now()),)
