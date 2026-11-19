from datetime import date, datetime, timedelta, timezone
from typing import Generic, Literal, TypeVar
from uuid import UUID
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError

from pydantic import AwareDatetime, BaseModel, ConfigDict, Field, field_validator, model_validator

T = TypeVar("T")


class Input(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)


class Output(BaseModel):
    model_config = ConfigDict(from_attributes=True)


class Page(BaseModel, Generic[T]):
    items: list[T]
    total: int
    limit: int
    offset: int


class ProfileWrite(Input):
    display_name: str = Field(min_length=1, max_length=80)
    locale: Literal["en"] = "en"
    timezone: str = Field(default="UTC", max_length=64)
    ai_consent: bool = False
    memory_consent: bool = False
    knowledge_consent: bool = False

    @field_validator("timezone")
    @classmethod
    def valid_timezone(cls, value: str):
        try:
            ZoneInfo(value)
        except (ZoneInfoNotFoundError, ValueError) as exc:
            raise ValueError("Use a valid IANA timezone, such as Asia/Kolkata") from exc
        return value

    @model_validator(mode="after")
    def consent(self):
        if self.memory_consent and not self.ai_consent:
            raise ValueError("AI consent is required before sharing memories with AI")
        if self.knowledge_consent and not self.ai_consent:
            raise ValueError("AI consent is required before processing knowledge with AI")
        return self


class ProfileRead(ProfileWrite):
    model_config = ConfigDict(from_attributes=True)
    user_id: UUID


class NamedWrite(Input):
    title: str = Field(min_length=1, max_length=120)
    notes: str = Field(default="", max_length=4000)


class GoalWrite(NamedWrite):
    progress: int = Field(default=0, ge=0, le=100)
    target_date: date | None = None


class GoalRead(GoalWrite):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    created_at: datetime


class TaskWrite(NamedWrite):
    status: Literal["todo", "done"] = "todo"
    priority: Literal["low", "normal", "high"] = "normal"
    due_at: AwareDatetime | None = None
    goal_id: UUID | None = None


class TaskRead(TaskWrite):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    created_at: datetime
    completed_at: datetime | None


class TaskStatus(Input):
    status: Literal["todo", "done"]


class EventWrite(NamedWrite):
    starts_at: AwareDatetime
    ends_at: AwareDatetime
    allow_overlap: bool = False

    @model_validator(mode="after")
    def valid_range(self):
        if self.ends_at <= self.starts_at:
            raise ValueError("The end must be after the start")
        if self.ends_at - self.starts_at > timedelta(days=31):
            raise ValueError("An event can span at most 31 days")
        return self


class EventRead(Output):
    id: UUID
    title: str
    notes: str
    starts_at: datetime
    ends_at: datetime
    created_at: datetime


class HabitWrite(NamedWrite):
    active: bool = True


class HabitRead(HabitWrite):
    model_config = ConfigDict(from_attributes=True)
    id: UUID
    created_at: datetime
    checked_today: bool
    current_streak: int
    today: date


class CheckInWrite(Input):
    day: date | None = None


class MemoryWrite(Input):
    title: str = Field(min_length=1, max_length=120)
    content: str = Field(min_length=1, max_length=2000)
    allow_ai: bool = False
    expires_at: AwareDatetime | None = None

    @field_validator("expires_at")
    @classmethod
    def future_expiry(cls, value):
        if value is not None and value <= datetime.now(timezone.utc):
            raise ValueError("Expiry must be in the future")
        return value


class MemoryRead(Output):
    id: UUID
    title: str
    content: str
    allow_ai: bool
    expires_at: datetime | None
    created_at: datetime


class EraseMemories(Input):
    confirmation: Literal["DELETE ALL MEMORIES"]


class ConversationRead(Output):
    id: UUID
    title: str
    created_at: datetime
    expires_at: datetime


class MessageRead(Output):
    id: UUID
    role: str
    content: str
    created_at: datetime
    memory_count: int
    plan_count: int
    model: str


class ChatWrite(Input):
    request_id: UUID
    conversation_id: UUID | None = None
    message: str = Field(min_length=1, max_length=4000)
    include_memory: bool = False
    include_plans: bool = False


class ChatRead(BaseModel):
    conversation_id: UUID
    reply: MessageRead
    cached: bool = False


class ActivityDay(BaseModel):
    day: date
    tasks_completed: int
    habit_checkins: int


class DashboardRead(BaseModel):
    timezone: str
    today: date
    tasks_open: int
    tasks_completed: int
    tasks_due_today: int
    tasks_overdue: int
    goals_active: int
    goals_completed: int
    habit_count: int
    habits_completed_today: int
    memories_active: int
    weekly_activity: list[ActivityDay]
