import json
import re
from datetime import timedelta
from functools import lru_cache
from typing import TypedDict
from uuid import uuid4

from fastapi import HTTPException
from langgraph.graph import END, START, StateGraph
from langsmith import tracing_context
from pydantic import ValidationError
from sqlalchemy import delete, select

from app.agentic.common import AgentError, TERMINAL, check_consent, event, owned_run, owned_session
from app.agentic.models import AgentAction, AgentJob, AgentStep
from app.agentic.provider import get_agent_provider, get_embedder
from app.agentic.tools import AGENTS, actions_digest, get_tool, permitted_tools, prepare, read_tool
from app.config import get_settings
from app.life.service import now


class AgentRuntime:
    """Narrow owner-scoped operations; no model is given a session or SQL tool."""

    def __init__(self, user_id, run_id, provider=None, embedder=None, settings=None, attempt=1):
        self.user_id, self.run_id = user_id, run_id
        self.settings = settings or get_settings()
        self.provider = provider or get_agent_provider()
        self.embedder = embedder
        self.attempt = attempt

    def _guard(self, db, run):
        if run.status != "running":
            raise AgentError("cancelled", "This run is no longer running.")
        if run.deadline_at <= now():
            raise AgentError("time_budget", "The agent run reached its time limit.")
        check_consent(db, self.user_id, run.scopes)
        job = db.scalar(
            select(AgentJob).where(AgentJob.user_id == self.user_id, AgentJob.run_id == run.id)
        )
        if job is None or job.status != "leased" or job.attempts != self.attempt:
            raise AgentError("lease_lost", "A newer worker owns this run.")
        job.lease_until = now() + timedelta(seconds=60)
        job.updated_at = now()

    def _finish_step(self, step_id, status, summary, details=None):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            job = db.scalar(
                select(AgentJob).where(AgentJob.user_id == self.user_id, AgentJob.run_id == run.id)
            )
            if job is None or job.attempts != self.attempt:
                raise AgentError("lease_lost", "A newer worker owns this run.")
            step = db.scalar(
                select(AgentStep).where(
                    AgentStep.user_id == self.user_id,
                    AgentStep.id == step_id,
                    AgentStep.run_id == run.id,
                )
            )
            if run.status in TERMINAL:
                status, summary = "cancelled", "The result was discarded because the run stopped."
            step.status, step.summary = status, summary
            if details is not None:
                step.details = details

    def model(self, agent, callback):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            self._guard(db, run)
            if run.model_calls >= self.settings.agent_max_model_calls:
                raise AgentError(
                    "model_budget", "The model-call budget was reached. Try a smaller request."
                )
            run.model_calls += 1
            step_id = event(
                db,
                run,
                "model",
                "AI step started",
                status="started",
                agent=agent,
                details={"call": run.model_calls},
            ).id
        try:
            with tracing_context(enabled=False):
                result = callback()
            self._finish_step(step_id, "succeeded", "AI step returned a structured result.")
            with owned_session(self.user_id) as db:
                self._guard(db, owned_run(db, self.user_id, self.run_id, True))
            return result
        except Exception:
            self._finish_step(step_id, "failed", "The AI step did not complete.")
            raise

    def metadata(self):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id)
            return {
                "prompt": run.prompt,
                "scopes": list(run.scopes),
                "allow_proposals": run.allow_proposals,
            }

    def set_plan(self, plan):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            self._guard(db, run)
            allowed = {"assistant", *run.scopes}
            agents = list(dict.fromkeys(plan.agents))
            if any(agent not in allowed or agent not in AGENTS for agent in agents):
                raise AgentError(
                    "agent_denied", "The supervisor selected an agent outside your permissions."
                )
            run.agents, run.plan = agents, plan.plan
            event(
                db, run, "supervisor", "Selected authorized specialists", details={"agents": agents}
            )
            return agents

    def tool(self, agent, call):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            self._guard(db, run)
            if run.tool_calls >= self.settings.agent_max_tool_calls:
                raise AgentError("tool_budget", "The tool-call budget was reached.")
            run.tool_calls += 1
            spec = get_tool(call["function"]["name"], agent, run)
            step = event(db, run, "tool", spec.label, status="started", agent=agent, tool=spec.name)
            try:
                args = spec.args.model_validate_json(call["function"]["arguments"])
                with db.begin_nested():
                    result = (
                        prepare(db, run, spec, args)
                        if spec.write
                        else read_tool(db, self.user_id, spec, args, self.embedder)
                    )
                if "sources" in result:
                    existing = list(run.sources)
                    returned = []
                    for source in result["sources"]:
                        found = next(
                            (
                                row
                                for row in existing
                                if row["kind"] == source["kind"]
                                and row["source_id"] == source["source_id"]
                                and row["revision"] == source["revision"]
                            ),
                            None,
                        )
                        if found is None:
                            if len(existing) >= 12:
                                raise AgentError(
                                    "source_budget",
                                    "This run reached its source limit. Narrow the request.",
                                )
                            found = {**source, "label": f"S{len(existing) + 1}"}
                            existing.append(found)
                        returned.append(found)
                    run.sources = existing
                    result["sources"] = returned
                encoded = json.dumps(result, default=str)
                if len(encoded) > 12000:
                    raise AgentError(
                        "output_budget", "The tool result is too large. Narrow the query."
                    )
                step.status = "succeeded"
                step.summary = (
                    "Prepared a proposal; no records changed."
                    if spec.write
                    else "Read authorized records."
                )
                step.details = {
                    "proposal_id": result.get("proposal_id"),
                    "source_count": len(result.get("sources", [])),
                    "item_count": len(result.get("items", [])),
                    "mode": result.get("mode"),
                    "warning": result.get("warning"),
                }
                return result
            except (ValidationError, HTTPException) as error:
                step.status = "failed"
                step.summary = "Tool arguments or record constraints were not valid."
                return {
                    "error": error.detail
                    if isinstance(error, HTTPException) and isinstance(error.detail, str)
                    else "Check the tool arguments and record IDs.",
                    "applied": False,
                }
            except AgentError as error:
                if error.code in {"tool_denied", "consent_required", "cancelled", "time_budget"}:
                    raise
                step.status = "failed"
                step.summary = error.message
                return {"error": error.message, "applied": False}

    def finish(self, messages):
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            self._guard(db, run)
            labels = [source["label"] for source in run.sources]
        result = self.model("assistant", lambda: self.provider.finish(messages, labels))
        cited = set(re.findall(r"\[(S[1-9][0-9]*)\]", result.answer))
        if cited != set(result.citation_labels) or not cited.issubset(set(labels)):
            raise AgentError(
                "invalid_citation", "The AI response contained an unverified source reference."
            )
        with owned_session(self.user_id) as db:
            run = owned_run(db, self.user_id, self.run_id, True)
            self._guard(db, run)
            actions = list(
                db.scalars(
                    select(AgentAction)
                    .where(AgentAction.user_id == self.user_id, AgentAction.run_id == run.id)
                    .order_by(AgentAction.position)
                )
            )
            if actions:
                run.status = "awaiting_approval"
                run.summary = (
                    f"Prepared {len(actions)} changes for your review. No life records have been changed.\n\n"
                    + result.answer
                )
                run.approval_digest = actions_digest(actions)
                run.review_nonce = uuid4()
                run.review_expires_at = now() + timedelta(
                    minutes=self.settings.agent_approval_minutes
                )
                event(db, run, "approval", "Waiting for your exact-preview approval.")
            else:
                run.status = "completed"
                run.summary = "Read-only result. No life records changed.\n\n" + result.answer
                run.finished_at = now()
                event(db, run, "system", "Read-only run completed.")


class GraphState(TypedDict):
    runtime: AgentRuntime
    agents: list[str]
    index: int
    messages: list[dict]
    call: dict | None


@lru_cache
def supervisor_graph():
    graph = StateGraph(GraphState)

    def supervise(state):
        runtime = state["runtime"]
        meta = runtime.metadata()
        plan = runtime.model(
            "supervisor",
            lambda: runtime.provider.plan(
                meta["prompt"], ["assistant", *meta["scopes"]], meta["scopes"]
            ),
        )
        return {
            "agents": runtime.set_plan(plan),
            "index": 0,
            "messages": [{"role": "user", "content": meta["prompt"]}],
            "call": None,
        }

    def specialist(state):
        runtime = state["runtime"]
        meta = runtime.metadata()
        agent = state["agents"][state["index"]]
        if sum(len(json.dumps(message, default=str)) for message in state["messages"]) > 48000:
            raise AgentError(
                "context_budget", "The agent context budget was reached. Try a smaller request."
            )
        tools = [
            spec.definition()
            for spec in permitted_tools(agent, meta["scopes"], meta["allow_proposals"])
        ]
        response = runtime.model(
            agent, lambda: runtime.provider.turn(agent, state["messages"], tools)
        )
        calls = response.get("tool_calls") or []
        if len(calls) > 1:
            raise AgentError(
                "invalid_model_output", "The provider exceeded the one-tool-per-turn limit."
            )
        if calls:
            call = calls[0]
            if (
                not isinstance(call, dict)
                or not re.fullmatch(r"[-a-zA-Z0-9_]{1,128}", str(call.get("id", "")))
                or call.get("type") != "function"
                or not isinstance(call.get("function"), dict)
                or not isinstance(call["function"].get("arguments"), str)
                or len(call["function"]["arguments"]) > 10000
            ):
                raise AgentError(
                    "invalid_model_output", "The provider returned an invalid tool request."
                )
            return {
                "call": call,
                "messages": [
                    *state["messages"],
                    {"role": "assistant", "content": None, "tool_calls": calls},
                ],
            }
        content = response.get("content") or "Specialist completed its planning step."
        if not isinstance(content, str) or len(content) > 6000:
            raise AgentError(
                "invalid_model_output", "The provider returned an invalid specialist result."
            )
        return {
            "call": None,
            "index": state["index"] + 1,
            "messages": [*state["messages"], {"role": "assistant", "content": content}],
        }

    def tools_node(state):
        call = state["call"]
        result = state["runtime"].tool(state["agents"][state["index"]], call)
        return {
            "messages": [
                *state["messages"],
                {
                    "role": "tool",
                    "tool_call_id": call["id"],
                    "content": json.dumps(result, default=str),
                },
            ],
            "call": None,
        }

    def route(state):
        if state["call"] is not None:
            return "tools"
        return "specialist" if state["index"] < len(state["agents"]) else "finalize"

    def finalize(state):
        state["runtime"].finish(state["messages"])
        return {}

    graph.add_node("supervisor", supervise)
    graph.add_node("specialist", specialist)
    graph.add_node("tools", tools_node)
    graph.add_node("finalize", finalize)
    graph.add_edge(START, "supervisor")
    graph.add_edge("supervisor", "specialist")
    graph.add_conditional_edges(
        "specialist", route, {"tools": "tools", "specialist": "specialist", "finalize": "finalize"}
    )
    graph.add_edge("tools", "specialist")
    graph.add_edge("finalize", END)
    return graph.compile()


def process_claim(job, provider=None, embedder=None, settings=None):
    settings = settings or get_settings()
    user_id, run_id = job["user_id"], job["run_id"]
    try:
        with owned_session(user_id) as db:
            run = owned_run(db, user_id, run_id, True)
            lease = db.get(AgentJob, job["id"])
            if lease is None or lease.status != "leased" or lease.attempts != job["attempts"]:
                return
            if run.status in TERMINAL or run.status == "awaiting_approval":
                return
            check_consent(db, user_id, run.scopes)
            if job["attempts"] > 3:
                raise AgentError("recovery_budget", "Worker recovery attempts were exhausted.")
            if run.queue_expires_at <= now() and run.started_at is None:
                raise AgentError("queue_expired", "This queued request expired. Start a new plan.")
            run.status = "running"
            if run.started_at is None:
                run.started_at = now()
                run.deadline_at = now() + timedelta(seconds=settings.agent_run_timeout_seconds)
            if job["attempts"] > 1:
                db.execute(
                    delete(AgentAction).where(
                        AgentAction.user_id == user_id, AgentAction.run_id == run_id
                    )
                )
                run.sources = []
                run.agents = []
                run.plan = ""
            event(
                db,
                run,
                "system",
                "Worker started"
                if job["attempts"] == 1
                else "Worker recovered the unapproved plan",
                details={"attempt": job["attempts"]},
            )
        runtime = AgentRuntime(
            user_id,
            run_id,
            provider,
            embedder if embedder is not None else get_embedder(),
            settings,
            job["attempts"],
        )
        with tracing_context(enabled=False):
            supervisor_graph().invoke(
                {"runtime": runtime, "agents": [], "index": 0, "messages": [], "call": None},
                config={"recursion_limit": 100},
            )
    except Exception as error:
        with owned_session(user_id) as db:
            try:
                run = owned_run(db, user_id, run_id, True)
            except AgentError:
                return  # A cancelled run may have been deleted by its owner.
            lease = db.get(AgentJob, job["id"])
            if lease is None or lease.attempts != job["attempts"]:
                return
            if run.status not in TERMINAL:
                run.status = (
                    "expired"
                    if isinstance(error, AgentError) and error.code == "queue_expired"
                    else "failed"
                )
                run.error = (
                    error.message
                    if isinstance(error, AgentError)
                    else "The worker could not finish this plan. No proposals were applied."
                )
                run.finished_at = now()
                for action in db.scalars(
                    select(AgentAction).where(
                        AgentAction.user_id == user_id, AgentAction.run_id == run_id
                    )
                ):
                    action.status = "blocked"
                event(db, run, "system", run.error, status="failed")
    finally:
        with owned_session(user_id) as db:
            row = db.scalar(
                select(AgentJob).where(AgentJob.user_id == user_id, AgentJob.id == job["id"])
            )
            if row is not None and row.attempts == job["attempts"]:
                row.status = "done"
                row.lease_until = None
                row.updated_at = now()
