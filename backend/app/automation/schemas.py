from typing import Annotated, Literal
from uuid import UUID
from zoneinfo import ZoneInfo, ZoneInfoNotFoundError
from pydantic import AwareDatetime, Field, TypeAdapter, model_validator
from app.life.schemas import Input, TaskWrite, EventWrite
from app.agentic.schemas import Scope


class Trigger(Input):
    type: Literal["trigger"] = "trigger"
    mode: Literal["manual", "schedule", "event"] = "manual"
    timezone: str = Field(default="UTC", max_length=64)
    at: str = Field(default="07:00", pattern=r"^([01][0-9]|2[0-3]):[0-5][0-9]$")
    weekdays: list[int] = Field(default_factory=lambda: list(range(7)), min_length=1, max_length=7)
    topic: Literal["task.created", "goal.created", "module.created"] = "goal.created"

    @model_validator(mode="after")
    def valid(self):
        try:
            ZoneInfo(self.timezone)
        except (ZoneInfoNotFoundError, ValueError) as e:
            raise ValueError("Use an IANA time zone") from e
        if any(d < 0 or d > 6 for d in self.weekdays) or len(set(self.weekdays)) != len(
            self.weekdays
        ):
            raise ValueError("Choose distinct weekdays 0 to 6")
        return self


class Condition(Input):
    type: Literal["condition"] = "condition"
    test: Literal["open_tasks", "overdue_tasks", "has_events", "trigger_kind"] = "open_tasks"
    minimum: int = Field(default=1, ge=0, le=10000)
    record_kind: str = Field(default="course", max_length=24)


class Report(Input):
    type: Literal["report"] = "report"
    module: Literal["life", "finance", "learning", "career", "wellness", "travel", "future"] = (
        "life"
    )


class External(Input):
    type: Literal["external"] = "external"
    api: Literal["weather", "exchange"] = "weather"
    latitude: float = Field(default=0, ge=-90, le=90, allow_inf_nan=False)
    longitude: float = Field(default=0, ge=-180, le=180, allow_inf_nan=False)
    base: str = Field(default="USD", pattern=r"^[A-Z]{3}$")
    quote: str = Field(default="INR", pattern=r"^[A-Z]{3}$")


class AI(Input):
    type: Literal["ai"] = "ai"
    prompt: str = Field(min_length=1, max_length=2000)
    scopes: list[Scope] = Field(default_factory=list, max_length=13)


class Action(Input):
    type: Literal["action"] = "action"
    tool: Literal["create_task", "create_event"] = "create_task"
    arguments: dict

    @model_validator(mode="after")
    def arguments_valid(self):
        schema = TaskWrite if self.tool == "create_task" else EventWrite
        parsed = schema.model_validate(self.arguments)
        if self.tool == "create_event" and parsed.allow_overlap:
            raise ValueError("Workflow events cannot bypass overlap checks")
        self.arguments = parsed.model_dump(mode="json", exclude={"allow_overlap"})
        return self


class Approval(Input):
    type: Literal["approval"] = "approval"


class Notify(Input):
    type: Literal["notify"] = "notify"
    title: str = Field(default="Workflow update", min_length=1, max_length=120)
    body: str = Field(default="Your workflow has an update.", max_length=2000)
    include_output: bool = False


class Output(Input):
    type: Literal["output"] = "output"


Node = Annotated[
    Trigger | Condition | Report | External | AI | Action | Approval | Notify | Output,
    Field(discriminator="type"),
]
NODE_ADAPTER = TypeAdapter(Node)


class Definition(Input):
    nodes: list[Node] = Field(min_length=2, max_length=12)

    @model_validator(mode="after")
    def safe_flow(self):
        types = [n.type for n in self.nodes]
        if (
            types[0] != "trigger"
            or types[-1] != "output"
            or types.count("trigger") != 1
            or types.count("output") != 1
        ):
            raise ValueError("Start with one trigger and finish with one output")
        if types.count("approval") > 1 or types.count("ai") > 1:
            raise ValueError("At most one approval and one AI step are supported")
        if types.count("external") > 2 or types.count("action") > 8:
            raise ValueError("At most two external reads and eight actions are supported")
        if "action" in types:
            if "approval" not in types or max(
                i for i, t in enumerate(types) if t == "action"
            ) > types.index("approval"):
                raise ValueError("All record actions must precede an approval checkpoint")
            if any(t != "action" for t in types[types.index("action") : types.index("approval")]):
                raise ValueError("Action steps must be together immediately before approval")
            if any(t not in {"notify", "output"} for t in types[types.index("approval") + 1 :]):
                raise ValueError("Only notification and output may follow approval")
        elif "approval" in types:
            raise ValueError("An approval checkpoint requires record actions")
        if (
            "notify" in types
            and "action" in types
            and min(i for i, t in enumerate(types) if t == "notify") < types.index("approval")
        ):
            raise ValueError(
                "Notifications must follow approval when the workflow modifies records"
            )
        return self


class WorkflowWrite(Input):
    request_id: UUID
    title: str = Field(min_length=1, max_length=120)
    definition: Definition
    revision: UUID | None = None


class Activate(Input):
    revision: UUID
    digest: str = Field(pattern=r"^[a-f0-9]{64}$")


class Request(Input):
    request_id: UUID


class Reminder(Input):
    request_id: UUID
    title: str = Field(min_length=1, max_length=120)
    body: str = Field(default="", max_length=2000)
    due_at: AwareDatetime


class OAuthStart(Input):
    writable: bool = False


class ExportWrite(Request):
    local_event_id: UUID


class ExportDecision(Input):
    digest: str = Field(pattern=r"^[a-f0-9]{64}$")
    nonce: UUID
    approve: bool
