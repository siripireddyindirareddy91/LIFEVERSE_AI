from datetime import date, datetime
from uuid import UUID, uuid4

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Date,
    DateTime,
    ForeignKeyConstraint,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.models import Base


class Owned:
    id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), primary_key=True, default=uuid4)
    user_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), nullable=False, index=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class Goal(Owned, Base):
    __tablename__ = "goals"
    __table_args__ = (
        UniqueConstraint("user_id", "id"),
        CheckConstraint("progress BETWEEN 0 AND 100"),
    )
    title: Mapped[str] = mapped_column(String(120))
    notes: Mapped[str] = mapped_column(Text, default="")
    target_date: Mapped[date | None] = mapped_column(Date)
    progress: Mapped[int] = mapped_column(Integer, default=0)


class Task(Owned, Base):
    __tablename__ = "tasks"
    __table_args__ = (
        ForeignKeyConstraint(["user_id", "goal_id"], ["goals.user_id", "goals.id"]),
        CheckConstraint("status IN ('todo', 'done')"),
        CheckConstraint("priority IN ('low', 'normal', 'high')"),
    )
    title: Mapped[str] = mapped_column(String(120))
    notes: Mapped[str] = mapped_column(Text, default="")
    status: Mapped[str] = mapped_column(String(8), default="todo")
    priority: Mapped[str] = mapped_column(String(8), default="normal")
    due_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), index=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), index=True)
    goal_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True), index=True)


class CalendarEvent(Owned, Base):
    __tablename__ = "calendar_events"
    __table_args__ = (CheckConstraint("ends_at > starts_at"),)
    title: Mapped[str] = mapped_column(String(120))
    notes: Mapped[str] = mapped_column(Text, default="")
    starts_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    ends_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))


class Habit(Owned, Base):
    __tablename__ = "habits"
    __table_args__ = (UniqueConstraint("user_id", "id"),)
    title: Mapped[str] = mapped_column(String(120))
    notes: Mapped[str] = mapped_column(Text, default="")
    active: Mapped[bool] = mapped_column(Boolean, default=True)


class HabitCheckIn(Owned, Base):
    __tablename__ = "habit_checkins"
    __table_args__ = (
        ForeignKeyConstraint(
            ["user_id", "habit_id"], ["habits.user_id", "habits.id"], ondelete="CASCADE"
        ),
        UniqueConstraint("user_id", "habit_id", "day"),
    )
    habit_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    day: Mapped[date] = mapped_column(Date, index=True)


class Memory(Owned, Base):
    __tablename__ = "memories"
    title: Mapped[str] = mapped_column(String(120))
    content: Mapped[str] = mapped_column(Text)
    allow_ai: Mapped[bool] = mapped_column(Boolean, default=False)
    expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), index=True)


class Conversation(Owned, Base):
    __tablename__ = "conversations"
    __table_args__ = (UniqueConstraint("user_id", "id"),)
    title: Mapped[str] = mapped_column(String(120))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class Message(Owned, Base):
    __tablename__ = "messages"
    __table_args__ = (
        ForeignKeyConstraint(
            ["user_id", "conversation_id"],
            ["conversations.user_id", "conversations.id"],
            ondelete="CASCADE",
        ),
        UniqueConstraint("user_id", "request_id", "role"),
        CheckConstraint("role IN ('user', 'assistant')"),
    )
    conversation_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    role: Mapped[str] = mapped_column(String(12))
    content: Mapped[str] = mapped_column(Text)
    memory_count: Mapped[int] = mapped_column(Integer, default=0)
    plan_count: Mapped[int] = mapped_column(Integer, default=0)
    model: Mapped[str] = mapped_column(String(120), default="")


class ConsentEvent(Owned, Base):
    __tablename__ = "consent_events"
    __table_args__ = (CheckConstraint("kind IN ('ai', 'memory')"),)
    kind: Mapped[str] = mapped_column(String(12))
    allowed: Mapped[bool] = mapped_column(Boolean)


class AIUsage(Owned, Base):
    __tablename__ = "ai_usage"
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
