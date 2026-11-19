"""Real PostgreSQL ownership and execution tests; providers are explicitly test-only."""

import json
import os
from contextlib import ExitStack
from datetime import timedelta
from types import SimpleNamespace
from unittest.mock import patch
from uuid import UUID, uuid4

import pytest
import httpx
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text
from sqlalchemy.exc import DBAPIError

from app.auth import Identity, current_identity
from app.config import Settings
from app.main import app
from app.agentic.common import AgentError, owned_session
from app.agentic.models import AgentRun
from app.agentic.provider import get_embedder
from app.agentic.provider import OpenAIAgentProvider, OpenAIEmbeddings
from app.agentic.queue import claim, verify_dispatcher
from app.agentic.rag import search
from app.agentic.runtime import process_claim
from app.agentic.schemas import FinalAnswer, SupervisorPlan
from app.life.service import now

pytestmark = pytest.mark.skipif(not os.getenv("TEST_DATABASE_URL"), reason="PostgreSQL required")


class ScriptedProvider:
    def __init__(self, agent="planner", calls=(), answer="Your records were reviewed."):
        self.agent, self.calls, self.answer = agent, list(calls), answer
        self.count = 0

    def plan(self, *args):
        self.count += 1
        return SupervisorPlan(
            agents=[self.agent], plan="Review authorized data and prepare changes."
        )

    def turn(self, agent, messages, tools):
        self.count += 1
        if self.calls:
            name, arguments = self.calls.pop(0)
            return {
                "tool_calls": [
                    {
                        "id": f"call_{self.count}",
                        "type": "function",
                        "function": {"name": name, "arguments": json.dumps(arguments)},
                    }
                ]
            }
        return {"content": "Planning finished."}

    def finish(self, messages, labels):
        self.count += 1
        return FinalAnswer(answer=self.answer)


class TestVectors:
    __test__ = False
    model, dimensions = "test-vectors", 64

    def embed(self, texts):
        return [[1.0] + [0.0] * 63 for _ in texts]


@pytest.fixture
def agent_api():
    runtime = create_engine(os.environ["TEST_DATABASE_URL"])
    dispatch_url = os.getenv("TEST_DISPATCH_DATABASE_URL")
    if not dispatch_url:
        dispatch_url = os.environ["TEST_DATABASE_URL"].replace(
            "lifeverse_app:lifeverse_app_local", "lifeverse_dispatcher:dispatcher_local"
        )
    dispatch = create_engine(dispatch_url)
    actor = SimpleNamespace(id=uuid4())
    owners = [actor.id]
    settings = Settings(
        ai_model="test-only",
        ai_api_key="test-only",
        ai_embedding_model="test-vectors",
        ai_embedding_dimensions=64,
        agent_runs_per_day=100,
    )
    app.dependency_overrides[current_identity] = lambda: Identity(actor.id)
    app.dependency_overrides[get_embedder] = lambda: TestVectors()
    with ExitStack() as stack:
        stack.enter_context(patch("app.database.engine", return_value=runtime))
        for module in ("router", "rag", "runtime", "tools", "provider"):
            stack.enter_context(patch(f"app.agentic.{module}.get_settings", return_value=settings))
        client = stack.enter_context(TestClient(app))
        profile = {
            "display_name": "Test owner",
            "ai_consent": True,
            "memory_consent": True,
            "knowledge_consent": True,
        }
        assert client.put("/api/v1/profile", json=profile).status_code == 200

        def enqueue(provider, scopes=None, proposals=True, request_id=None):
            payload = {
                "request_id": str(request_id or uuid4()),
                "prompt": "Help organize my life",
                "scopes": scopes or [provider.agent],
                "allow_proposals": proposals,
            }
            response = client.post("/api/v1/agents/runs", json=payload)
            assert response.status_code in (200, 201), response.text
            return response.json(), payload

        def work(provider):
            job = claim(uuid4(), dispatch)
            assert job is not None
            process_claim(job, provider, TestVectors(), settings)
            response = client.get(f"/api/v1/agents/runs/{job['run_id']}")
            assert response.status_code == 200, response.text
            return response.json()

        def review(run, decision="approve", ids=None, **changes):
            payload = {
                "request_id": str(uuid4()),
                "decision": decision,
                "action_ids": ids if ids is not None else [a["id"] for a in run["actions"]],
                "digest": run["approval_digest"],
                "nonce": run["review_nonce"],
                **changes,
            }
            return client.post(f"/api/v1/agents/runs/{run['id']}/decision", json=payload), payload

        yield SimpleNamespace(
            client=client,
            actor=actor,
            owners=owners,
            runtime=runtime,
            dispatch=dispatch,
            settings=settings,
            enqueue=enqueue,
            work=work,
            review=review,
            profile=profile,
        )
        for owner in owners:
            with owned_session(owner) as db:
                for table in (
                    "module_records",
                    "module_operations",
                    "vault_files",
                    "knowledge_links",
                    "agent_runs",
                    "agent_usage",
                    "knowledge_sources",
                    "messages",
                    "conversations",
                    "habit_checkins",
                    "tasks",
                    "goals",
                    "habits",
                    "memories",
                    "consent_events",
                    "ai_usage",
                    "profiles",
                ):
                    db.execute(text(f"DELETE FROM {table}"))
    app.dependency_overrides.clear()
    runtime.dispose()
    dispatch.dispose()


def test_queue_preview_exact_approval_and_duplicate_decision(agent_api):
    a = agent_api
    provider = ScriptedProvider(calls=[("create_task", {"title": "Read a chapter"})])
    run, payload = a.enqueue(provider)
    assert run["status"] == "queued" and provider.count == 0
    assert a.client.post("/api/v1/agents/runs", json=payload).status_code == 200
    run = a.work(provider)
    assert run["status"] == "awaiting_approval", run
    assert a.client.get("/api/v1/tasks").json()["total"] == 0
    assert any(
        field["name"] == "Title" and field["after"] == "Read a chapter"
        for field in run["actions"][0]["preview"]
    )
    wrong, _ = a.review(run, digest="0" * 64)
    assert wrong.status_code == 409
    response, decision = a.review(run)
    assert response.status_code == 200, response.text
    assert response.json()["status"] == "completed", response.text
    assert (
        a.client.post(f"/api/v1/agents/runs/{run['id']}/decision", json=decision).status_code == 200
    )
    assert a.client.get("/api/v1/tasks").json()["total"] == 1
    assert any(s["kind"] == "execution" for s in response.json()["steps"])


@pytest.mark.parametrize("stop", ["reject", "cancel", "expire", "revoke"])
def test_stopped_plans_never_write(agent_api, stop):
    a = agent_api
    p = ScriptedProvider(calls=[("create_task", {"title": "Unapproved"})])
    a.enqueue(p)
    run = a.work(p)
    if stop == "reject":
        response, _ = a.review(run, "reject", [])
        assert response.json()["status"] == "rejected"
    elif stop == "cancel":
        a.client.post(f"/api/v1/agents/runs/{run['id']}/cancel")
        assert a.review(run)[0].status_code == 409
    elif stop == "expire":
        with owned_session(a.actor.id) as db:
            db.get(AgentRun, UUID(run["id"])).review_expires_at = now() - timedelta(seconds=1)
        assert a.review(run)[0].status_code == 409
    else:
        a.client.put("/api/v1/profile", json={"display_name": "Test", "ai_consent": False})
        assert a.review(run)[0].json()["status"] == "stale"
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_stale_target_blocks_entire_batch(agent_api):
    a = agent_api
    task = a.client.post("/api/v1/tasks", json={"title": "Original"}).json()
    p = ScriptedProvider(
        calls=[
            ("create_task", {"title": "Should roll back"}),
            ("set_task_status", {"record_id": task["id"], "status": "done"}),
        ]
    )
    a.enqueue(p)
    run = a.work(p)
    a.client.put(f"/api/v1/tasks/{task['id']}", json={"title": "Manually edited"})
    response, _ = a.review(run)
    assert response.json()["status"] == "stale", response.text
    page = a.client.get("/api/v1/tasks").json()
    assert page["total"] == 1 and page["items"][0]["status"] == "todo"


@pytest.mark.parametrize("tool,proposals", [("delete_everything", True), ("create_task", False)])
def test_unauthorized_tools_fail_without_write(agent_api, tool, proposals):
    a = agent_api
    p = ScriptedProvider(calls=[(tool, {"title": "No permission"})])
    a.enqueue(p, proposals=proposals)
    run = a.work(p)
    assert run["status"] == "failed", run
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_model_budget_is_persisted(agent_api):
    a = agent_api
    a.settings.agent_max_model_calls = 3
    p = ScriptedProvider(calls=[("list_tasks", {})] * 8)
    a.enqueue(p)
    run = a.work(p)
    assert run["status"] == "failed" and run["model_calls"] == 3
    assert "budget" in run["error"]


def test_owner_isolation_and_usage_survives_history_deletion(agent_api):
    a = agent_api
    p = ScriptedProvider()
    a.enqueue(p)
    run = a.work(p)
    assert run["status"] == "completed", run
    old = a.actor.id
    a.actor.id = uuid4()
    a.owners.append(a.actor.id)
    assert a.client.get(f"/api/v1/agents/runs/{run['id']}").status_code == 404
    assert a.client.get("/api/v1/agents/runs").json()["total"] == 0
    a.actor.id = old
    assert a.client.delete(f"/api/v1/agents/runs/{run['id']}").status_code == 204
    with owned_session(old) as db:
        assert db.scalar(text("SELECT count(*) FROM agent_usage")) == 1


def test_dispatch_role_is_queue_only(agent_api):
    a = agent_api
    verify_dispatcher(a.dispatch)
    with pytest.raises(AgentError):
        verify_dispatcher(a.runtime)
    with a.dispatch.begin() as conn:
        with pytest.raises(DBAPIError), conn.begin_nested():
            conn.execute(text("SELECT * FROM profiles"))
        with pytest.raises(DBAPIError), conn.begin_nested():
            conn.execute(text("UPDATE agent_jobs SET user_id = :id"), {"id": str(uuid4())})
    with a.runtime.begin() as conn:
        with pytest.raises(DBAPIError), conn.begin_nested():
            conn.execute(
                text("INSERT INTO agent_workers(id,last_seen) VALUES (:id,now())"),
                {"id": str(uuid4())},
            )


def test_rag_keyword_hybrid_invalidation_and_consent(agent_api):
    a = agent_api
    source = a.client.post(
        "/api/v1/knowledge",
        json={
            "title": "Study guide",
            "content": "Practice Flutter every morning",
            "allow_ai": True,
        },
    ).json()
    with owned_session(a.actor.id) as db:
        result = search(db, a.actor.id, "knowledge", "Flutter")
        assert result["mode"] == "keyword" and result["sources"][0]["source_id"] == source["id"]
    response = a.client.post(f"/api/v1/retrieval/knowledge/{source['id']}/index")
    assert response.status_code == 200, response.text
    assert response.json()["cached"] is False
    assert (
        a.client.post(f"/api/v1/retrieval/knowledge/{source['id']}/index").json()["cached"] is True
    )
    with owned_session(a.actor.id) as db:
        result = search(db, a.actor.id, "knowledge", "Flutter", embedder=TestVectors())
        assert result["mode"] == "hybrid", result
    response = a.client.put(
        f"/api/v1/knowledge/{source['id']}",
        json={"title": "Private", "content": "Flutter", "allow_ai": False},
    )
    assert response.json()["indexed_chunks"] == 0
    with owned_session(a.actor.id) as db:
        assert (
            search(db, a.actor.id, "knowledge", "Flutter", embedder=TestVectors())["sources"] == []
        )
    a.client.put("/api/v1/profile", json={**a.profile, "knowledge_consent": False})
    assert a.client.post(f"/api/v1/retrieval/knowledge/{source['id']}/index").status_code == 403


def test_invalid_citations_are_not_presented_as_verified(agent_api):
    a = agent_api
    p = ScriptedProvider(answer="An invented claim [S99]")
    a.enqueue(p)
    assert a.work(p)["status"] == "failed"


def test_dependency_selection_and_transactional_execution(agent_api):
    a = agent_api

    class LinkedPlan(ScriptedProvider):
        def plan(self, *args):
            return SupervisorPlan(
                agents=["goals", "planner"], plan="Create a linked goal and task."
            )

        def turn(self, agent, messages, tools):
            if agent == "goals" and not any(m.get("role") == "tool" for m in messages):
                name, arguments = "create_goal", {"title": "Learn Flutter"}
            elif agent == "planner" and sum(m.get("role") == "tool" for m in messages) == 1:
                goal = json.loads(next(m["content"] for m in messages if m.get("role") == "tool"))
                name, arguments = (
                    "create_task",
                    {"title": "Build a screen", "goal_id": goal["proposed_record_id"]},
                )
            else:
                return {"content": "Specialist finished."}
            return {
                "tool_calls": [
                    {
                        "id": f"call_{agent}",
                        "type": "function",
                        "function": {"name": name, "arguments": json.dumps(arguments)},
                    }
                ]
            }

    p = LinkedPlan()
    a.enqueue(p, scopes=["goals", "planner"])
    run = a.work(p)
    assert run["status"] == "awaiting_approval", run
    assert len(run["actions"]) == 2
    assert a.review(run, ids=[run["actions"][1]["id"]])[0].status_code == 422
    response, _ = a.review(run)
    assert response.json()["status"] == "completed", response.text
    goal = a.client.get("/api/v1/goals").json()["items"][0]
    task = a.client.get("/api/v1/tasks").json()["items"][0]
    assert task["goal_id"] == goal["id"]


def test_execution_failure_rolls_back_preceding_write(agent_api):
    a = agent_api
    start = now() + timedelta(days=1)
    times = {"starts_at": start.isoformat(), "ends_at": (start + timedelta(hours=1)).isoformat()}
    p = ScriptedProvider(
        calls=[
            ("create_task", {"title": "Rollback this"}),
            ("create_event", {"title": "Proposed calendar", **times}),
        ]
    )
    a.enqueue(p)
    run = a.work(p)
    assert run["status"] == "awaiting_approval", run
    assert (
        a.client.post("/api/v1/events", json={"title": "New conflict", **times}).status_code == 201
    )
    response, _ = a.review(run)
    assert response.json()["status"] == "stale", response.text
    assert a.client.get("/api/v1/tasks").json()["total"] == 0
    assert a.client.get("/api/v1/events").json()["total"] == 1


def test_recovery_leases_and_cancelled_queue(agent_api):
    a = agent_api
    p = ScriptedProvider(calls=[("create_task", {"title": "Recovery proposal"})])
    run, _ = a.enqueue(p)
    first = claim(uuid4(), a.dispatch)
    assert first["attempts"] == 1
    assert claim(uuid4(), a.dispatch) is None
    with a.dispatch.begin() as conn:
        conn.execute(
            text("UPDATE agent_jobs SET lease_until = now() - interval '1 second' WHERE id = :id"),
            {"id": first["id"]},
        )
    second = claim(uuid4(), a.dispatch)
    assert second["attempts"] == 2
    process_claim(second, p, TestVectors(), a.settings)
    detail = a.client.get(f"/api/v1/agents/runs/{run['id']}").json()
    assert detail["status"] == "awaiting_approval", detail
    assert a.client.get("/api/v1/tasks").json()["total"] == 0
    a.client.post(f"/api/v1/agents/runs/{run['id']}/cancel")
    another, _ = a.enqueue(ScriptedProvider())
    a.client.post(f"/api/v1/agents/runs/{another['id']}/cancel")
    assert claim(uuid4(), a.dispatch) is None


def test_changed_rag_source_blocks_proposals(agent_api):
    a = agent_api
    source = a.client.post(
        "/api/v1/knowledge",
        json={"title": "Flutter schedule", "content": "Study on Monday", "allow_ai": True},
    ).json()

    class RAGPlan(ScriptedProvider):
        def plan(self, *args):
            return SupervisorPlan(agents=["knowledge", "planner"], plan="Use shared study notes.")

        def turn(self, agent, messages, tools):
            count = sum(m.get("role") == "tool" for m in messages)
            if agent == "knowledge" and count == 0:
                name, args = "search_knowledge", {"query": "Flutter"}
            elif agent == "planner" and count == 1:
                name, args = "create_task", {"title": "Study Flutter"}
            else:
                return {"content": "Ready."}
            return {
                "tool_calls": [
                    {
                        "id": f"call_{agent}",
                        "type": "function",
                        "function": {"name": name, "arguments": json.dumps(args)},
                    }
                ]
            }

    p = RAGPlan()
    a.enqueue(p, scopes=["knowledge", "planner"])
    run = a.work(p)
    assert run["status"] == "awaiting_approval" and len(run["sources"]) == 1, run
    a.client.put(
        f"/api/v1/knowledge/{source['id']}",
        json={"title": "Flutter schedule", "content": "Now study on Tuesday", "allow_ai": True},
    )
    assert a.review(run)[0].json()["status"] == "stale"
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_old_worker_cannot_publish_after_recovery(agent_api):
    a = agent_api
    replacement = []

    class PausedProvider(ScriptedProvider):
        def plan(self, *args):
            with a.dispatch.begin() as conn:
                conn.execute(
                    text(
                        "UPDATE agent_jobs SET lease_until = now() - interval '1 second' WHERE run_id = :run"
                    ),
                    {"run": UUID(run["id"])},
                )
            replacement.append(claim(uuid4(), a.dispatch))
            return super().plan(*args)

    p = PausedProvider()
    run, _ = a.enqueue(p)
    old = claim(uuid4(), a.dispatch)
    process_claim(old, p, TestVectors(), a.settings)
    with a.dispatch.connect() as conn:
        assert (
            conn.scalar(text("SELECT status FROM agent_jobs WHERE id = :id"), {"id": old["id"]})
            == "leased"
        )
    process_claim(replacement[0], ScriptedProvider(), TestVectors(), a.settings)
    detail = a.client.get(f"/api/v1/agents/runs/{run['id']}").json()
    assert detail["status"] == "completed", detail
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_provider_wire_contract_and_embedding_validation(agent_api):
    bodies = []

    def respond(request):
        body = json.loads(request.content)
        bodies.append(body)
        if request.url.path.endswith("embeddings"):
            return httpx.Response(
                200, json={"data": [{"index": 0, "embedding": [1.0] + [0.0] * 63}]}
            )
        return httpx.Response(
            200,
            json={
                "choices": [
                    {
                        "message": {
                            "content": json.dumps(
                                {"agents": ["planner"], "plan": "Review the plan."}
                            )
                        }
                    }
                ]
            },
        )

    transport = httpx.MockTransport(respond)
    result = OpenAIAgentProvider("test-only", "test-model", transport).plan(
        "Help", ["planner"], ["planner"]
    )
    assert result.agents == ["planner"]
    assert bodies[0]["store"] is False
    assert bodies[0]["response_format"]["json_schema"]["strict"] is True
    vectors = OpenAIEmbeddings("test-only", "test-vectors", 64, transport).embed(["Test text"])
    assert len(vectors[0]) == 64
    assert bodies[1]["dimensions"] == 64


def test_rag_other_owner_and_expired_source_unavailable(agent_api):
    a = agent_api
    source = a.client.post(
        "/api/v1/knowledge",
        json={
            "title": "Private owner Flutter",
            "content": "Owner-specific reference",
            "allow_ai": True,
        },
    ).json()
    original = a.actor.id
    a.actor.id = uuid4()
    a.owners.append(a.actor.id)
    a.client.put("/api/v1/profile", json=a.profile)
    assert a.client.get(f"/api/v1/knowledge/{source['id']}").status_code == 404
    with owned_session(a.actor.id) as db:
        assert search(db, a.actor.id, "knowledge", "Flutter")["sources"] == []
        assert db.scalar(text("SELECT count(*) FROM knowledge_sources")) == 0
    a.actor.id = original
    with owned_session(original) as db:
        db.execute(text("UPDATE knowledge_sources SET expires_at = now() - interval '1 second'"))
    assert a.client.get(f"/api/v1/knowledge/{source['id']}").status_code == 404
    with owned_session(original) as db:
        assert search(db, original, "knowledge", "Flutter")["sources"] == []
