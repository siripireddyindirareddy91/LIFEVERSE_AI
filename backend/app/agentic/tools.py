from app.modules.schemas import SCHEMAS as MODULE_SCHEMAS
from dataclasses import dataclass
from datetime import date
from uuid import UUID, uuid4

from pydantic import BaseModel
from sqlalchemy import delete, select
from sqlalchemy.dialects.postgresql import insert

from app.agentic.common import AgentError, digest, identity
from app.agentic.models import AgentAction
from app.agentic.provider import strict_schema
from app.agentic.rag import search
from app.agentic.schemas import (
    AgentEventArgs,
    CalendarArgs,
    CheckHabitArgs,
    GoalProgressArgs,
    PatchTaskArgs,
    QueryArgs,
    SaveMemoryArgs,
    SearchArgs,
    SetTaskArgs,
)
from app.config import get_settings
from app.life.models import CalendarEvent, Goal, Habit, HabitCheckIn, Memory, Task
from app.life.router import dashboard, set_task, validate_event
from app.life.schemas import (
    EventRead,
    EventWrite,
    GoalRead,
    GoalWrite,
    HabitWrite,
    Input,
    MemoryWrite,
    TaskRead,
    TaskWrite,
)
from app.life.service import get_owned, habit_read, list_owned, now


@dataclass(frozen=True)
class ToolSpec:
    name: str
    label: str
    agent: str
    scope: str
    args: type[BaseModel]
    write: bool = False

    def definition(self):
        return {
            "type": "function",
            "function": {
                "name": self.name,
                "description": self.label
                + (
                    ". Prepare for user approval; does NOT apply changes."
                    if self.write
                    else ". Read only authorized user data."
                ),
                "parameters": strict_schema(self.args),
                "strict": True,
            },
        }


TOOLS = {
    spec.name: spec
    for spec in [
        ToolSpec("list_tasks", "Read up to ten matching tasks", "planner", "planner", QueryArgs),
        ToolSpec(
            "list_events",
            "Read events in a calendar window of at most 31 days",
            "planner",
            "planner",
            CalendarArgs,
        ),
        ToolSpec("list_goals", "Read up to ten matching goals", "goals", "goals", QueryArgs),
        ToolSpec(
            "list_habits", "Read up to ten matching daily habits", "habits", "habits", QueryArgs
        ),
        ToolSpec(
            "search_memories",
            "Retrieve relevant shared memory with sources",
            "memory",
            "memory",
            SearchArgs,
        ),
        ToolSpec(
            "search_knowledge",
            "Retrieve relevant shared knowledge with sources",
            "knowledge",
            "knowledge",
            SearchArgs,
        ),
        ToolSpec(
            "read_dashboard", "Read actual life intelligence totals", "insights", "insights", Input
        ),
        ToolSpec(
            "create_task",
            "Create a task, optionally linked to an existing or proposed goal",
            "planner",
            "planner",
            TaskWrite,
            True,
        ),
        ToolSpec(
            "update_task",
            "Change task fields and completion in one proposal per record",
            "planner",
            "planner",
            PatchTaskArgs,
            True,
        ),
        ToolSpec(
            "set_task_status", "Complete or reopen a task", "planner", "planner", SetTaskArgs, True
        ),
        ToolSpec(
            "create_event",
            "Create a non-overlapping calendar event",
            "planner",
            "planner",
            AgentEventArgs,
            True,
        ),
        ToolSpec("create_goal", "Create a goal", "goals", "goals", GoalWrite, True),
        ToolSpec(
            "set_goal_progress",
            "Update a goal's reported progress",
            "goals",
            "goals",
            GoalProgressArgs,
            True,
        ),
        ToolSpec("create_habit", "Create a daily habit", "habits", "habits", HabitWrite, True),
        ToolSpec(
            "check_habit",
            "Check in or undo today's check-in",
            "habits",
            "habits",
            CheckHabitArgs,
            True,
        ),
        ToolSpec(
            "save_memory",
            "Save a private memory; AI sharing remains off",
            "memory",
            "memory",
            SaveMemoryArgs,
            True,
        ),
    ]
}
AGENTS = {
    "assistant": "General life assistant",
    "planner": "Planner specialist",
    "goals": "Goal specialist",
    "habits": "Habit specialist",
    "memory": "Memory specialist",
    "knowledge": "Knowledge specialist",
    "insights": "Insights specialist",
}


ADVANCED_AGENTS = {
    "finance": "Finance education and manual-record analysis",
    "learning": "Learning tutor and study support",
    "career": "Career and factual resume support",
    "wellness": "Supportive routines, never diagnosis",
    "travel": "Travel planning, never booking",
    "vault": "Shared document metadata, never file contents",
    "future": "Assumption-based scenario comparison",
}
AGENTS.update(ADVANCED_AGENTS)
TOOLS["read_knowledge_connections"] = ToolSpec(
    "read_knowledge_connections",
    "Read connections among up to ten shared knowledge sources",
    "knowledge",
    "knowledge",
    QueryArgs,
)
for _name, _label in ADVANCED_AGENTS.items():
    TOOLS["read_" + _name] = ToolSpec("read_" + _name, _label, _name, _name, QueryArgs)

# Domain schemas define the complete proposal; consent/AI-sharing cannot be model arguments.

ADVANCED_WRITES = {
    "create_entry": ("finance", "entry"),
    "create_course": ("learning", "course"),
    "create_study_note": ("learning", "study_note"),
    "create_flashcard": ("learning", "flashcard"),
    "create_quiz": ("learning", "quiz"),
    "create_resume": ("career", "resume"),
    "create_routine": ("wellness", "routine"),
    "create_trip": ("travel", "trip"),
    "create_scenario": ("future", "scenario"),
}
for _tool, (_agent, _kind) in ADVANCED_WRITES.items():
    TOOLS[_tool] = ToolSpec(
        _tool,
        "Prepare a private " + _kind.replace("_", " "),
        _agent,
        _agent,
        MODULE_SCHEMAS[_kind],
        True,
    )


def permitted_tools(agent, scopes, allow_proposals):
    return [
        spec
        for spec in TOOLS.values()
        if spec.agent == agent and spec.scope in scopes and (allow_proposals or not spec.write)
    ]


def get_tool(name, agent, run):
    spec = TOOLS.get(name)
    if (
        spec is None
        or spec.agent != agent
        or spec.scope not in run.scopes
        or (spec.write and not run.allow_proposals)
    ):
        raise AgentError(
            "tool_denied", "The requested tool is not permitted for this agent and selected scope."
        )
    return spec


def snapshot(db, user_id, tool, record_id):
    user = identity(user_id)
    if tool in {"update_task", "set_task_status"}:
        row = get_owned(db, Task, record_id, user)
        return TaskRead.model_validate(row).model_dump(mode="json")
    if tool == "set_goal_progress":
        return GoalRead.model_validate(get_owned(db, Goal, record_id, user)).model_dump(mode="json")
    if tool == "check_habit":
        return habit_read(db, get_owned(db, Habit, record_id, user), user)
    return None


def read_tool(db, user_id, spec, args, embedder=None):
    user = identity(user_id)
    if spec.name == "read_knowledge_connections":
        from app.modules.agent_context import knowledge_connections

        return knowledge_connections(db, user, args.query)
    if spec.agent in ADVANCED_AGENTS:
        from app.modules.agent_context import context

        return context(db, user, spec.agent, args.query)
    if spec.name == "read_dashboard":
        return dashboard(user, db)
    if spec.name in {"search_memories", "search_knowledge"}:
        return search(db, user_id, spec.scope, args.query, args.limit, embedder)
    if spec.name == "list_events":
        from app.agentic.schemas import CalendarArgs

        CalendarArgs.model_validate(args.model_dump())
        rows = db.scalars(
            select(CalendarEvent)
            .where(
                CalendarEvent.user_id == user_id,
                CalendarEvent.ends_at > args.starts_after,
                CalendarEvent.starts_at < args.ends_before,
            )
            .order_by(CalendarEvent.starts_at, CalendarEvent.id)
            .limit(20)
        ).all()
        return {"items": [EventRead.model_validate(row).model_dump(mode="json") for row in rows]}
    model = {"list_tasks": Task, "list_goals": Goal, "list_habits": Habit}[spec.name]
    rows = list_owned(db, model, user, 10, 0, args.query)["items"]
    values = []
    for row in rows:
        value = (
            TaskRead.model_validate(row).model_dump(mode="json")
            if model is Task
            else GoalRead.model_validate(row).model_dump(mode="json")
            if model is Goal
            else habit_read(db, row, user)
        )
        value["notes"] = value["notes"][:250]
        values.append(value)
    return {"items": values}


def prepare(db, run, spec, args):
    user = identity(run.user_id)
    existing = list(
        db.scalars(
            select(AgentAction)
            .where(AgentAction.user_id == run.user_id, AgentAction.run_id == run.id)
            .order_by(AgentAction.position)
        )
    )
    if len(existing) >= get_settings().agent_max_proposals:
        raise AgentError("proposal_budget", "This plan reached its proposal limit.")
    payload = args.model_dump(mode="json")
    record_id = getattr(args, "record_id", None) or uuid4()
    before = snapshot(db, run.user_id, spec.name, record_id)
    if before is not None and any(action.record_id == record_id for action in existing):
        raise AgentError(
            "duplicate_target",
            "Only one proposal per existing record is supported. Combine changes in one tool call.",
        )
    # Snapshot JSON must preserve dates/UUIDs in a stable canonical representation.
    if before is not None:
        import json

        before = json.loads(json.dumps(before, default=str))
    dependencies = []
    if spec.name == "create_task" and args.goal_id:
        goal = db.scalar(select(Goal).where(Goal.user_id == run.user_id, Goal.id == args.goal_id))
        if goal is None:
            parent = next(
                (
                    action
                    for action in existing
                    if action.tool == "create_goal" and action.record_id == args.goal_id
                ),
                None,
            )
            if parent is None:
                raise AgentError(
                    "invalid_record", "The goal is not available in your account or this plan."
                )
            dependencies.append(parent.id)
        else:
            before = {"linked_goal": GoalRead.model_validate(goal).model_dump(mode="json")}
    if spec.name == "create_event":
        validate_event(EventWrite.model_validate({**payload, "allow_overlap": False}), user, db)
    if spec.name == "save_memory":
        MemoryWrite.model_validate({**payload, "allow_ai": False})
    if spec.name == "check_habit" and not before["active"]:
        raise AgentError("inactive_habit", "Activate the habit before proposing a check-in.")
    action = AgentAction(
        id=uuid4(),
        user_id=run.user_id,
        run_id=run.id,
        position=len(existing) + 1,
        agent=spec.agent,
        tool=spec.name,
        label=spec.label,
        arguments=payload,
        before=before,
        expected_hash=digest(before) if before is not None else None,
        record_id=record_id,
        dependencies=dependencies,
        status="pending",
    )
    db.add(action)
    db.flush()
    return {
        "proposal_id": str(action.id),
        "proposed_record_id": str(record_id),
        "status": "pending_user_approval",
        "applied": False,
    }


def current_snapshot(db, user_id, action):
    if action.before is None:
        return None
    if action.tool == "create_task" and "linked_goal" in action.before:
        row = db.scalar(
            select(Goal)
            .where(Goal.user_id == user_id, Goal.id == UUID(action.arguments["goal_id"]))
            .with_for_update()
        )
        if row is None:
            raise AgentError("stale_target", "The linked goal is no longer available.")
        return {"linked_goal": GoalRead.model_validate(row).model_dump(mode="json")}
    model = {
        "update_task": Task,
        "set_task_status": Task,
        "set_goal_progress": Goal,
        "check_habit": Habit,
    }[action.tool]
    row = db.scalar(
        select(model)
        .where(model.user_id == user_id, model.id == action.record_id)
        .with_for_update()
    )
    if row is None:
        raise AgentError("stale_target", "A target record is no longer available.")
    return snapshot(db, user_id, action.tool, action.record_id)


def actions_digest(actions):
    return digest(
        [
            {
                "id": str(action.id),
                "tool": action.tool,
                "record_id": str(action.record_id),
                "arguments": action.arguments,
                "before": action.before,
                "expected_hash": action.expected_hash,
                "dependencies": [str(value) for value in action.dependencies],
                "position": action.position,
            }
            for action in actions
        ]
    )


def execute(db, user_id, action):
    spec = TOOLS.get(action.tool)
    if spec is None or not spec.write:
        raise AgentError("tool_denied", "This action is not executable.")
    args = spec.args.model_validate(action.arguments)
    user = identity(user_id)
    if action.tool in ADVANCED_WRITES:
        from app.modules.service import save_record
        from app.modules.schemas import RecordWrite

        save_record(
            db,
            user,
            ADVANCED_WRITES[action.tool][1],
            RecordWrite(request_id=action.id, data=args.model_dump(mode="json"), allow_ai=False),
            record_id=action.record_id,
        )
        return {
            "record_id": str(action.record_id),
            "tool": action.tool,
            "applied": True,
            "applied_at": now().isoformat(),
        }
    if action.tool == "create_task":
        row = Task(id=action.record_id, user_id=user_id)
        set_task(row, args, user, db)
        db.add(row)
    elif action.tool == "create_goal":
        db.add(Goal(id=action.record_id, user_id=user_id, **args.model_dump()))
    elif action.tool == "create_habit":
        db.add(Habit(id=action.record_id, user_id=user_id, **args.model_dump()))
    elif action.tool == "save_memory":
        payload = MemoryWrite.model_validate({**args.model_dump(), "allow_ai": False})
        db.add(Memory(id=action.record_id, user_id=user_id, **payload.model_dump()))
    elif action.tool == "create_event":
        payload = EventWrite.model_validate({**args.model_dump(), "allow_overlap": False})
        validate_event(payload, user, db)
        db.add(
            CalendarEvent(
                id=action.record_id,
                user_id=user_id,
                **payload.model_dump(exclude={"allow_overlap"}),
            )
        )
    elif action.tool in {"update_task", "set_task_status"}:
        row = get_owned(db, Task, action.record_id, user)
        data = TaskRead.model_validate(row).model_dump(exclude={"id", "created_at", "completed_at"})
        if action.tool == "set_task_status":
            data["status"] = args.status
        else:
            data.update(args.model_dump(exclude={"record_id", "clear_due_date"}, exclude_none=True))
            if args.clear_due_date:
                data["due_at"] = None
        set_task(row, TaskWrite.model_validate(data), user, db)
    elif action.tool == "set_goal_progress":
        get_owned(db, Goal, action.record_id, user).progress = args.progress
    elif action.tool == "check_habit":
        habit = get_owned(db, Habit, action.record_id, user)
        current = habit_read(db, habit, user)
        if not habit.active or current["today"].isoformat() != action.before["today"]:
            raise AgentError(
                "stale_target", "The habit date or active state changed. Make a new plan."
            )
        day = date.fromisoformat(action.before["today"])
        if args.checked:
            db.execute(
                insert(HabitCheckIn)
                .values(id=uuid4(), user_id=user_id, habit_id=habit.id, day=day)
                .on_conflict_do_nothing(index_elements=["user_id", "habit_id", "day"])
            )
        else:
            db.execute(
                delete(HabitCheckIn).where(
                    HabitCheckIn.user_id == user_id,
                    HabitCheckIn.habit_id == habit.id,
                    HabitCheckIn.day == day,
                )
            )
    else:
        raise AgentError("tool_denied", "Unsupported action")
    db.flush()
    return {
        "record_id": str(action.record_id),
        "tool": action.tool,
        "applied": True,
        "applied_at": now().isoformat(),
    }
