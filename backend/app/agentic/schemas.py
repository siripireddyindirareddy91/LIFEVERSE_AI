from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import AwareDatetime, Field, model_validator
from app.life.schemas import Input, Output, MemoryWrite, NamedWrite

Scope = Literal["planner", "goals", "habits", "memory", "knowledge", "insights"]
AgentName = Literal["assistant", "planner", "goals", "habits", "memory", "knowledge", "insights"]


class RunWrite(Input):
    request_id: UUID
    prompt: str = Field(min_length=1, max_length=4000)
    scopes: list[Scope] = Field(default_factory=list, max_length=6)
    allow_proposals: bool = False

    @model_validator(mode="after")
    def normalize(self):
        self.scopes = sorted(set(self.scopes))
        return self


class DecisionWrite(Input):
    request_id: UUID
    decision: Literal["approve", "reject"]
    action_ids: list[UUID] = Field(default_factory=list, max_length=12)
    digest: str = Field(min_length=64, max_length=64, pattern=r"^[a-f0-9]{64}$")
    nonce: UUID

    @model_validator(mode="after")
    def selection(self):
        if len(set(self.action_ids)) != len(self.action_ids):
            raise ValueError("Select each action only once")
        if self.decision == "approve" and not self.action_ids:
            raise ValueError("Select at least one action to approve")
        if self.decision == "reject" and self.action_ids:
            raise ValueError("Reject decisions must have an empty action selection")
        return self


class PreviewField(Output):
    name: str
    before: str | None = None
    after: str


class ActionRead(Output):
    id: UUID
    position: int
    agent: str
    tool: str
    label: str
    status: str
    record_id: UUID
    dependencies: list[UUID]
    preview: list[PreviewField]
    permission_level: int = 2
    result: dict | None = None


class StepRead(Output):
    id: UUID
    sequence: int
    kind: str
    agent: str
    tool: str | None
    status: str
    summary: str
    details: dict
    created_at: datetime


class RunRead(Output):
    id: UUID
    prompt: str
    scopes: list[str]
    allow_proposals: bool
    status: str
    summary: str
    error: str
    plan: str
    agents: list[str]
    sources: list[dict]
    model_calls: int
    tool_calls: int
    approval_digest: str | None
    review_nonce: UUID | None
    review_expires_at: datetime | None
    created_at: datetime
    started_at: datetime | None
    finished_at: datetime | None
    expires_at: datetime


class RunDetail(RunRead):
    actions: list[ActionRead]
    steps: list[StepRead]


class KnowledgeWrite(MemoryWrite):
    content: str = Field(min_length=1, max_length=30000)


class KnowledgeRead(Output):
    id: UUID
    title: str
    content: str
    allow_ai: bool
    expires_at: datetime | None
    revision: UUID
    created_at: datetime
    chunk_count: int
    indexed_chunks: int


class SupervisorPlan(Input):
    agents: list[AgentName] = Field(min_length=1, max_length=3)
    plan: str = Field(min_length=1, max_length=800)


class FinalAnswer(Input):
    answer: str = Field(min_length=1, max_length=12000)
    citation_labels: list[str] = Field(default_factory=list, max_length=12)


class QueryArgs(Input):
    query: str = Field(default="", max_length=120)


class SearchArgs(Input):
    query: str = Field(min_length=1, max_length=2000)
    limit: int = Field(default=3, ge=1, le=5)


class CalendarArgs(Input):
    starts_after: AwareDatetime
    ends_before: AwareDatetime

    @model_validator(mode="after")
    def range(self):
        if (
            self.ends_before <= self.starts_after
            or (self.ends_before - self.starts_after).days > 31
        ):
            raise ValueError("Choose a calendar window of at most 31 days")
        return self


class PatchTaskArgs(Input):
    record_id: UUID
    title: str | None = Field(default=None, min_length=1, max_length=120)
    notes: str | None = Field(default=None, max_length=4000)
    priority: Literal["low", "normal", "high"] | None = None
    status: Literal["todo", "done"] | None = None
    due_at: AwareDatetime | None = None
    clear_due_date: bool = False

    @model_validator(mode="after")
    def changed(self):
        if self.due_at and self.clear_due_date:
            raise ValueError("Do not set and clear a due date together")
        if (
            all(
                getattr(self, field) is None
                for field in ("title", "notes", "priority", "status", "due_at")
            )
            and not self.clear_due_date
        ):
            raise ValueError("Provide at least one change")
        return self


class SetTaskArgs(Input):
    record_id: UUID
    status: Literal["todo", "done"]


class GoalProgressArgs(Input):
    record_id: UUID
    progress: int = Field(ge=0, le=100)


class CheckHabitArgs(Input):
    record_id: UUID
    checked: bool


class SaveMemoryArgs(Input):
    title: str = Field(min_length=1, max_length=120)
    content: str = Field(min_length=1, max_length=2000)
    expires_at: AwareDatetime | None = None


class AgentEventArgs(NamedWrite):
    starts_at: AwareDatetime
    ends_at: AwareDatetime
