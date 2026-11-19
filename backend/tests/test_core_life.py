import json
import os
from datetime import datetime, timedelta, timezone
from types import SimpleNamespace
from unittest.mock import patch
from uuid import uuid4

import httpx
import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text

from app.auth import Identity, current_identity
from app.config import Settings
from app.life.assistant import OpenAIProvider, get_provider
from app.main import app

pytestmark = pytest.mark.skipif(
    not os.getenv("TEST_DATABASE_URL"), reason="Disposable PostgreSQL not configured"
)


@pytest.fixture
def api():
    engine = create_engine(os.environ["TEST_DATABASE_URL"])
    actor = SimpleNamespace(id=uuid4())
    actors = [actor.id]
    prompts = []

    class TestProvider:
        def generate(self, messages):
            prompts.append(messages)
            return "A test-only suggestion; no records were changed."

    app.dependency_overrides[current_identity] = lambda: Identity(actor.id)
    app.dependency_overrides[get_provider] = lambda: TestProvider()
    settings = Settings(ai_model="test-model", ai_api_key="test-only", ai_requests_per_minute=30)
    with (
        patch("app.database.engine", return_value=engine),
        patch("app.life.assistant.get_settings", return_value=settings),
        TestClient(app) as client,
    ):

        def switch():
            actor.id = uuid4()
            actors.append(actor.id)

        yield client, actor, switch, prompts, settings
    app.dependency_overrides.clear()
    # Cleanup uses the same restricted role and verified owner context as requests.
    with engine.begin() as conn:
        for owner in actors:
            conn.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(owner)})
            for table in (
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
                conn.execute(text(f"DELETE FROM {table}"))
    engine.dispose()


def save_profile(client, **changes):
    payload = {
        "display_name": "Indira",
        "timezone": "Asia/Kolkata",
        "ai_consent": True,
        "memory_consent": False,
    }
    payload.update(changes)
    response = client.put("/api/v1/profile", json=payload)
    assert response.status_code == 200, response.text
    return response.json()


def create(client, kind, **fields):
    response = client.post(f"/api/v1/{kind}", json={"title": "My record", **fields})
    assert response.status_code == 201, response.text
    return response.json()


def test_profile_validation_and_consents(api):
    client, actor, _, _, _ = api
    assert client.get("/api/v1/profile").status_code == 404
    assert save_profile(client)["user_id"] == str(actor.id)
    assert (
        client.put("/api/v1/profile", json={"display_name": " ", "timezone": "UTC"}).status_code
        == 422
    )
    assert (
        client.put(
            "/api/v1/profile", json={"display_name": "Name", "timezone": "bad/zone"}
        ).status_code
        == 422
    )
    assert (
        client.put(
            "/api/v1/profile", json={"display_name": "Name", "memory_consent": True}
        ).status_code
        == 422
    )
    assert (
        client.put(
            "/api/v1/profile", json={"display_name": "Name", "user_id": str(uuid4())}
        ).status_code
        == 422
    )


def test_task_goal_lifecycle_and_dashboard(api):
    client = api[0]
    save_profile(client)
    goal = create(client, "goals", title="Learn Dart", progress=20)
    task = create(
        client,
        "tasks",
        title="Read a chapter",
        goal_id=goal["id"],
        due_at=datetime.now(timezone.utc).isoformat(),
    )
    assert (
        client.get("/api/v1/tasks", params={"q": "chapter", "goal_id": goal["id"]}).json()["total"]
        == 1
    )
    done = client.patch(f"/api/v1/tasks/{task['id']}/status", json={"status": "done"})
    assert done.json()["completed_at"] is not None
    assert client.get("/api/v1/dashboard").json()["tasks_completed"] == 1
    assert (
        client.put(
            f"/api/v1/goals/{goal['id']}", json={"title": "Learn Dart", "progress": 100}
        ).status_code
        == 200
    )
    assert client.get("/api/v1/dashboard").json()["goals_completed"] == 1
    assert client.delete(f"/api/v1/goals/{goal['id']}").status_code == 204
    assert client.get("/api/v1/tasks").json()["items"][0]["goal_id"] is None
    assert client.delete(f"/api/v1/tasks/{task['id']}").status_code == 204
    assert client.get("/api/v1/dashboard").json()["tasks_completed"] == 0


def test_calendar_overlap_requires_explicit_confirmation(api):
    client = api[0]
    begin = datetime.now(timezone.utc) + timedelta(days=1)
    event = {"starts_at": begin.isoformat(), "ends_at": (begin + timedelta(hours=1)).isoformat()}
    first = create(client, "events", **event)
    assert client.post("/api/v1/events", json={"title": "Overlap", **event}).status_code == 409
    assert (
        client.post(
            "/api/v1/events", json={"title": "Confirmed", **event, "allow_overlap": True}
        ).status_code
        == 201
    )
    assert (
        client.put(
            f"/api/v1/events/{first['id']}",
            json={"title": "Invalid", "starts_at": event["ends_at"], "ends_at": event["starts_at"]},
        ).status_code
        == 422
    )
    assert (
        client.post(
            "/api/v1/events",
            json={
                "title": "Naive",
                "starts_at": "2026-11-20T09:00:00",
                "ends_at": "2026-11-20T10:00:00",
            },
        ).status_code
        == 422
    )
    assert (
        client.get(
            "/api/v1/events", params={"starts_after": (begin + timedelta(days=2)).isoformat()}
        ).json()["total"]
        == 0
    )


def test_habit_timezone_idempotency_streak_undo(api):
    client = api[0]
    save_profile(client, timezone="Pacific/Kiritimati")
    habit = create(client, "habits", title="Read")
    today = datetime.now(timezone(timedelta(hours=14))).date()
    assert habit["today"] == str(today)
    route = f"/api/v1/habits/{habit['id']}/checkins"
    for _ in range(2):
        assert client.post(route, json={}).json()["current_streak"] == 1
    assert (
        client.post(route, json={"day": str(today - timedelta(days=1))}).json()["current_streak"]
        == 2
    )
    assert client.post(route, json={"day": str(today + timedelta(days=1))}).status_code == 422
    assert client.get("/api/v1/dashboard").json()["habits_completed_today"] == 1
    result = client.delete(route).json()
    assert result["checked_today"] is False and result["current_streak"] == 1
    client.put(f"/api/v1/habits/{habit['id']}", json={"title": "Read", "active": False})
    assert client.post(route, json={}).status_code == 409


def test_owner_isolation_for_every_resource(api):
    client, _, switch, _, _ = api
    goal = create(client, "goals")
    task = create(client, "tasks", goal_id=goal["id"])
    habit = create(client, "habits")
    memory = create(client, "memories", content="Private memory")
    begin = datetime.now(timezone.utc)
    event = create(
        client,
        "events",
        starts_at=begin.isoformat(),
        ends_at=(begin + timedelta(hours=1)).isoformat(),
    )
    save_profile(client)
    chat = client.post(
        "/api/v1/assistant/chat", json={"message": "Hello", "request_id": str(uuid4())}
    ).json()
    switch()
    for kind, item in (
        ("tasks", task),
        ("goals", goal),
        ("habits", habit),
        ("memories", memory),
        ("events", event),
    ):
        assert client.get(f"/api/v1/{kind}").json()["total"] == 0
        assert client.delete(f"/api/v1/{kind}/{item['id']}").status_code == 404
    assert (
        client.post(
            "/api/v1/tasks", json={"title": "Foreign link", "goal_id": goal["id"]}
        ).status_code
        == 404
    )
    assert (
        client.get(
            f"/api/v1/assistant/conversations/{chat['conversation_id']}/messages"
        ).status_code
        == 404
    )
    assert client.get("/api/v1/dashboard").json()["tasks_open"] == 0


def test_memory_export_search_expiry_and_delete(api):
    client, actor, _, _, _ = api
    memory = create(
        client, "memories", title="Learning preference", content="Use Dart examples", allow_ai=False
    )
    assert client.get("/api/v1/memories", params={"q": "Learning"}).json()["total"] == 1
    assert client.get("/api/v1/memories/export").json()[0]["content"] == "Use Dart examples"
    assert (
        client.post(
            "/api/v1/memories",
            json={"title": "Expired", "content": "No", "expires_at": "2000-01-01T00:00:00Z"},
        ).status_code
        == 422
    )
    with create_engine(os.environ["TEST_DATABASE_URL"]).begin() as conn:
        conn.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)})
        conn.execute(
            text("UPDATE memories SET expires_at = now() - interval '1 second' WHERE id = :id"),
            {"id": memory["id"]},
        )
    assert client.get("/api/v1/memories").json()["total"] == 0
    create(client, "memories", content="New memory")
    assert (
        client.request("DELETE", "/api/v1/memories", json={"confirmation": "yes"}).status_code
        == 422
    )
    assert (
        client.request(
            "DELETE", "/api/v1/memories", json={"confirmation": "DELETE ALL MEMORIES"}
        ).status_code
        == 204
    )
    assert client.get("/api/v1/memories/export").json() == []


def test_assistant_consent_context_idempotency_rate_and_delete(api):
    client, _, _, prompts, settings = api
    payload = {
        "message": "Help with Dart learning",
        "request_id": str(uuid4()),
        "include_memory": True,
        "include_plans": True,
    }
    assert client.post("/api/v1/assistant/chat", json=payload).status_code == 403
    save_profile(client)
    assert client.post("/api/v1/assistant/chat", json=payload).status_code == 403
    save_profile(client, memory_consent=True)
    create(client, "memories", title="Dart learning", content="Use diagrams", allow_ai=True)
    create(client, "memories", title="Dart secret", content="Never share this", allow_ai=False)
    create(client, "tasks", title="Practice Dart")
    first = client.post("/api/v1/assistant/chat", json=payload)
    assert first.status_code == 200, first.text
    data = first.json()
    assert data["reply"]["memory_count"] == 1
    assert data["reply"]["plan_count"] == 1
    assert "Use diagrams" in json.dumps(prompts[-1])
    assert "Never share this" not in json.dumps(prompts[-1])
    assert client.post("/api/v1/assistant/chat", json=payload).json()["cached"] is True
    assert len(prompts) == 1
    assert (
        client.post("/api/v1/assistant/chat", json={**payload, "message": "Changed"}).status_code
        == 409
    )
    assert (
        client.get(f"/api/v1/assistant/conversations/{data['conversation_id']}/messages").json()[
            "total"
        ]
        == 2
    )
    client.delete(f"/api/v1/assistant/conversations/{data['conversation_id']}")
    settings.ai_requests_per_day = 1
    assert (
        client.post(
            "/api/v1/assistant/chat", json={"message": "Hello again", "request_id": str(uuid4())}
        ).status_code
        == 429
    )


def test_provider_failure_leaves_no_false_history(api):
    client = api[0]
    save_profile(client)

    class FailingProvider:
        def generate(self, messages):
            raise HTTPException(503, "Unavailable")

    app.dependency_overrides[get_provider] = lambda: FailingProvider()
    assert (
        client.post(
            "/api/v1/assistant/chat", json={"message": "Hello", "request_id": str(uuid4())}
        ).status_code
        == 503
    )
    assert client.get("/api/v1/assistant/conversations").json()["total"] == 0


def test_openai_adapter_contract_and_failure_sanitization():
    def respond(request):
        body = json.loads(request.content)
        assert body["store"] is False and body["max_completion_tokens"] == 1000
        return httpx.Response(
            200, json={"choices": [{"message": {"content": "Real adapter test"}}]}
        )

    provider = OpenAIProvider("test-secret", "test-model", httpx.MockTransport(respond))
    assert provider.generate([{"role": "user", "content": "Hello"}]) == "Real adapter test"
    provider.transport = httpx.MockTransport(
        lambda _: httpx.Response(401, json={"error": "test-secret"})
    )
    with pytest.raises(HTTPException) as error:
        provider.generate([])
    assert "test-secret" not in error.value.detail


def test_new_tables_enforce_rls_without_api_owner_filters(api):
    client, actor, switch, _, _ = api
    owner = actor.id
    goal = create(client, "goals")
    create(client, "tasks", goal_id=goal["id"])
    create(client, "memories", content="Private")
    save_profile(client)
    switch()
    engine = create_engine(os.environ["TEST_DATABASE_URL"])
    with engine.connect() as conn, conn.begin():
        conn.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)})
        for table in ("goals", "tasks", "memories", "consent_events"):
            assert conn.scalar(text(f"SELECT count(*) FROM {table}")) == 0
        tables = conn.execute(
            text(
                "SELECT relname, relrowsecurity, relforcerowsecurity FROM pg_class WHERE relname IN ('tasks','goals','habits','habit_checkins','calendar_events','memories','messages','conversations','consent_events','ai_usage')"
            )
        ).all()
        assert len(tables) == 10 and all(row[1] and row[2] for row in tables)
        from sqlalchemy.exc import DBAPIError

        with pytest.raises(DBAPIError), conn.begin_nested():
            conn.execute(
                text(
                    "INSERT INTO tasks(id,user_id,title,notes,status,priority) VALUES (:id,:owner,'Foreign','','todo','normal')"
                ),
                {"id": str(uuid4()), "owner": str(owner)},
            )
    engine.dispose()


def test_deleted_memory_is_not_resent_from_old_chat_context(api):
    client, _, _, prompts, _ = api
    save_profile(client, memory_consent=True)
    memory = create(
        client,
        "memories",
        title="Dart learning",
        content="private diagrams preference",
        allow_ai=True,
    )
    first = client.post(
        "/api/v1/assistant/chat",
        json={"message": "Dart learning", "include_memory": True, "request_id": str(uuid4())},
    ).json()
    client.delete(f"/api/v1/memories/{memory['id']}")
    save_profile(client, memory_consent=False)
    response = client.post(
        "/api/v1/assistant/chat",
        json={
            "message": "Continue",
            "conversation_id": first["conversation_id"],
            "request_id": str(uuid4()),
        },
    )
    assert response.status_code == 200
    assert "private diagrams preference" not in json.dumps(prompts[-1])
    assert response.json()["reply"]["memory_count"] == 0


def test_missing_ai_configuration_never_creates_a_fake_reply(api):
    client, _, _, _, settings = api
    save_profile(client)
    app.dependency_overrides.pop(get_provider)
    settings.ai_model = ""
    assert client.get("/api/v1/assistant/status").json()["configured"] is False
    result = client.post(
        "/api/v1/assistant/chat", json={"message": "Hello", "request_id": str(uuid4())}
    )
    assert result.status_code == 503
    assert client.get("/api/v1/assistant/conversations").json()["total"] == 0


def test_expired_conversation_is_removed_with_its_messages(api):
    client, actor, _, _, _ = api
    save_profile(client)
    result = client.post(
        "/api/v1/assistant/chat", json={"message": "Hello", "request_id": str(uuid4())}
    ).json()
    engine = create_engine(os.environ["TEST_DATABASE_URL"])
    with engine.begin() as connection:
        connection.execute(
            text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)}
        )
        connection.execute(
            text("UPDATE conversations SET expires_at = now() - interval '1 second'")
        )
    assert client.get("/api/v1/assistant/conversations").json()["total"] == 0
    assert (
        client.get(
            f"/api/v1/assistant/conversations/{result['conversation_id']}/messages"
        ).status_code
        == 404
    )
    with engine.begin() as connection:
        connection.execute(
            text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)}
        )
        assert connection.scalar(text("SELECT count(*) FROM messages")) == 0
    engine.dispose()
