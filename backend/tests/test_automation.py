import base64
import json
from datetime import datetime, timedelta, timezone
from unittest.mock import patch
from uuid import UUID, uuid4
from urllib.parse import parse_qs, urlsplit
import httpx
import pytest
from fastapi import HTTPException
from sqlalchemy import text, select
from pydantic import SecretStr, ValidationError
from test_agentic import agent_api, ScriptedProvider  # noqa: F401
from app.agentic.common import owned_session, identity
from app.automation.models import CalendarConnection
from app.automation import calendar
from app.automation.queue import claim
from app.automation.worker import process
from app.automation.schemas import Definition, Trigger, External
from app.automation.service import next_due
from app.automation.external import fetch
from app.life.service import now


@pytest.fixture
def automation(agent_api):  # noqa: F811
    a = agent_api
    settings = a.settings.model_copy(
        update={
            "external_apis_enabled": True,
            "oauth_public_base_url": "https://lifeverse.example",
            "google_client_id": "test-client",
            "google_client_secret": SecretStr("test-secret"),
            "microsoft_client_id": "test-client",
            "microsoft_client_secret": SecretStr("test-secret"),
            "vault_encryption_keys": {"v1": SecretStr(base64.b64encode(b"x" * 32).decode())},
        }
    )
    with (
        patch("app.automation.router.get_settings", return_value=settings),
        patch("app.automation.service.get_settings", return_value=settings),
        patch("app.automation.calendar.get_settings", return_value=settings),
        patch("app.modules.vault.get_settings", return_value=settings),
        patch("app.automation.external.get_settings", return_value=settings),
    ):
        yield a


def flow(a, nodes, activate=True):
    payload = {"request_id": str(uuid4()), "title": "Test workflow", "definition": {"nodes": nodes}}
    response = a.client.post("/api/v1/automation/workflows", json=payload)
    assert response.status_code == 201, response.text
    value = response.json()
    if activate:
        response = a.client.post(
            f"/api/v1/automation/workflows/{value['id']}/activate",
            json={"revision": value["revision"], "digest": value["digest"]},
        )
        assert response.status_code == 200, response.text
    return value


def run(a, workflow):
    response = a.client.post(
        f"/api/v1/automation/workflows/{workflow['id']}/run", json={"request_id": str(uuid4())}
    )
    assert response.status_code == 201, response.text
    return response.json()


def tick(a, external_fetch=None):
    with a.dispatch.begin() as db:
        db.execute(
            text(
                "UPDATE automation_jobs SET due_at = now() - interval '1 second' WHERE user_id=:owner AND status='pending' AND kind IN ('run','signal','export')"
            ),
            {"owner": a.actor.id},
        )
    job = claim(uuid4(), a.dispatch)
    if job:
        process(job, external_fetch)
    return job


def test_graph_validation_and_exact_activation(automation):
    a = automation
    with pytest.raises(ValidationError):
        Definition.model_validate(
            {
                "nodes": [
                    {"type": "trigger"},
                    {"type": "action", "arguments": {"title": "Missing approval"}},
                    {"type": "output"},
                ]
            }
        )
    with pytest.raises(ValidationError):
        Definition.model_validate(
            {"nodes": [{"type": "trigger"}, {"type": "output"}, {"type": "trigger"}]}
        )
    value = flow(a, [{"type": "trigger"}, {"type": "output"}], False)
    assert (
        a.client.post(
            f"/api/v1/automation/workflows/{value['id']}/activate",
            json={"revision": value["revision"], "digest": "0" * 64},
        ).status_code
        == 409
    )
    assert (
        a.client.post(
            f"/api/v1/automation/workflows/{value['id']}/run", json={"request_id": str(uuid4())}
        ).status_code
        == 409
    )


def test_workflow_report_notification_and_duplicate_run(automation):
    a = automation
    value = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "report", "module": "life"},
            {"type": "notify", "title": "My report", "body": "Ready", "include_output": True},
            {"type": "output"},
        ],
    )
    request = {"request_id": str(uuid4())}
    one = a.client.post(f"/api/v1/automation/workflows/{value['id']}/run", json=request).json()
    assert (
        a.client.post(f"/api/v1/automation/workflows/{value['id']}/run", json=request).json()["id"]
        == one["id"]
    )
    tick(a)
    result = a.client.get("/api/v1/automation/runs/" + one["id"]).json()
    assert result["status"] == "completed" and len(result["steps"]) == 4, result
    inbox = a.client.get("/api/v1/notifications").json()
    assert inbox["unread"] == 1 and "Tasks open" in inbox["items"][0]["body"]


def test_rule_actions_require_approval_without_ai_processing_consent(automation):
    a = automation
    a.client.put("/api/v1/profile", json={"display_name": "Owner", "ai_consent": False})
    value = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "action", "tool": "create_task", "arguments": {"title": "Explicit rule task"}},
            {"type": "approval"},
            {"type": "notify"},
            {"type": "output"},
        ],
    )
    queued = run(a, value)
    tick(a)
    detail = a.client.get("/api/v1/automation/runs/" + queued["id"]).json()
    assert detail["status"] == "waiting_approval", detail
    assert a.client.get("/api/v1/tasks").json()["total"] == 0
    proposal = a.client.get("/api/v1/agents/runs/" + detail["proposal_run_id"]).json()
    response, _ = a.review(proposal)
    assert response.json()["status"] == "completed", response.text
    for _ in range(3):
        tick(a)
    assert a.client.get("/api/v1/tasks").json()["total"] == 1
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "completed"


def test_pause_cancels_waiting_approval_and_no_records_apply(automation):
    a = automation
    value = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "action", "arguments": {"title": "Never apply"}},
            {"type": "approval"},
            {"type": "output"},
        ],
    )
    queued = run(a, value)
    tick(a)
    detail = a.client.get("/api/v1/automation/runs/" + queued["id"]).json()
    proposal = a.client.get("/api/v1/agents/runs/" + detail["proposal_run_id"]).json()
    a.client.post(f"/api/v1/automation/workflows/{value['id']}/pause")
    assert a.review(proposal)[0].status_code == 409
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_condition_skip_failure_retry_and_usage_survive_delete(automation):
    a = automation
    skipped = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "condition", "test": "open_tasks", "minimum": 1},
            {"type": "notify"},
            {"type": "output"},
        ],
    )
    queued = run(a, skipped)
    tick(a)
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "skipped"
    a.client.delete("/api/v1/automation/runs/" + queued["id"])
    with owned_session(a.actor.id) as db:
        assert db.scalar(text("SELECT count(*) FROM workflow_usage")) == 1
    value = flow(
        a, [{"type": "trigger"}, {"type": "external", "api": "weather"}, {"type": "output"}]
    )
    queued = run(a, value)

    def failed(_):
        raise RuntimeError("private provider detail")

    tick(a, failed)
    detail = a.client.get("/api/v1/automation/runs/" + queued["id"]).json()
    assert detail["status"] == "failed" and "private provider detail" not in detail["error"]
    assert a.client.post("/api/v1/automation/runs/" + queued["id"] + "/retry").status_code == 200
    tick(a, lambda _: {"provider": "TEST ONLY", "temperature_c": 20})
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "completed"


def test_schedules_dst_and_dispatch_permissions(automation):
    a = automation
    trigger = Trigger(mode="schedule", timezone="America/New_York", at="02:30")
    after = datetime(2026, 3, 8, 5, 0, tzinfo=timezone.utc)
    assert next_due(trigger, after).day == 9  # Spring-forward gap is skipped, not invented.
    with a.dispatch.begin() as db:
        assert (
            db.scalar(
                text("SELECT has_table_privilege(current_user,'calendar_connections','SELECT')")
            )
            is False
        )
        assert (
            db.scalar(
                text(
                    "SELECT has_column_privilege(current_user,'automation_jobs','user_id','UPDATE')"
                )
            )
            is False
        )


def test_event_outbox_triggers_once_after_activation(automation):
    a = automation
    value = flow(
        a,
        [
            {"type": "trigger", "mode": "event", "topic": "goal.created"},
            {"type": "notify", "title": "New goal saved"},
            {"type": "output"},
        ],
    )
    a.client.post("/api/v1/goals", json={"title": "A real goal"})
    for _ in range(3):
        tick(a)
    history = a.client.get("/api/v1/automation/runs", params={"workflow_id": value["id"]}).json()
    assert history["total"] == 1 and history["items"][0]["status"] == "completed", history


def test_reminder_retry_owner_and_cancel(automation):
    a = automation
    payload = {
        "request_id": str(uuid4()),
        "title": "My reminder",
        "body": "Private text",
        "due_at": (now() + timedelta(hours=1)).isoformat(),
    }
    one = a.client.post("/api/v1/notifications", json=payload).json()
    assert a.client.post("/api/v1/notifications", json=payload).json()["id"] == one["id"]
    old = a.actor.id
    a.actor.id = uuid4()
    a.owners.append(a.actor.id)
    assert a.client.post("/api/v1/notifications/" + one["id"] + "/read").status_code == 404
    a.actor.id = old
    assert a.client.delete("/api/v1/notifications/" + one["id"]).status_code == 204
    assert a.client.get("/api/v1/notifications", params={"pending": True}).json()["total"] == 0


def test_external_adapter_fixed_origins_and_attribution(automation):
    seen = []

    def provider(request):
        seen.append(str(request.url))
        return httpx.Response(
            200,
            json={"current": {"temperature_2m": 23, "weather_code": 0, "time": "2026-11-19T00:00"}}
            if request.url.host == "api.open-meteo.com"
            else {"rate": 83.2, "date": "2026-11-18"},
        )

    transport = httpx.MockTransport(provider)
    assert fetch(External(api="weather"), transport)["provider"] == "Open-Meteo"
    assert fetch(External(api="exchange"), transport)["rate"] == "83.2"
    assert all(urlsplit(url).scheme == "https" for url in seen)


def connection(a, provider="google"):
    cid = uuid4()
    token = {
        "access_token": "test-access",
        "refresh_token": "test-refresh",
        "expires_at": (now() + timedelta(hours=1)).isoformat(),
    }
    with owned_session(a.actor.id) as db:
        db.add(
            CalendarConnection(
                id=cid,
                user_id=a.actor.id,
                title="Test calendar",
                provider=provider,
                writable=True,
                active=True,
                key_id="v1",
                token_cipher=calendar.seal(token, "v1", f"calendar:{a.actor.id}:{cid}"),
            )
        )
    return cid


def test_oauth_state_pkce_encryption_and_replay(automation):
    a = automation
    start = a.client.post("/api/v1/integrations/oauth/google/start", json={"writable": False})
    assert start.status_code == 200, start.text
    query = parse_qs(urlsplit(start.json()["authorization_url"]).query)
    assert query["code_challenge_method"] == ["S256"] and "readonly" in query["scope"][0]
    requests = []

    def exchange(request):
        requests.append(parse_qs(request.content.decode()))
        return httpx.Response(
            200,
            json={
                "access_token": "test-access",
                "refresh_token": "test-refresh",
                "scope": "https://www.googleapis.com/auth/calendar.events.readonly",
                "expires_in": 3600,
            },
        )

    state = query["state"][0]
    assert (
        calendar.callback(
            "google",
            state,
            "test-code",
            dispatch=a.dispatch,
            transport=httpx.MockTransport(exchange),
        )
        is True
    )
    assert "code_verifier" in requests[0]
    with pytest.raises(HTTPException):
        calendar.callback(
            "google",
            state,
            "test-code",
            dispatch=a.dispatch,
            transport=httpx.MockTransport(exchange),
        )
    rows = a.client.get("/api/v1/integrations/calendars").json()["items"]
    assert len(rows) == 1 and "token_cipher" not in rows[0]
    with owned_session(a.actor.id) as db:
        stored = db.scalar(select(CalendarConnection))
        assert b"test-access" not in stored.token_cipher


@pytest.mark.parametrize("provider", ["google", "microsoft"])
def test_calendar_sync_import_and_export_idempotency(automation, provider):
    a = automation
    cid = connection(a, provider)
    posted = []
    begin = now() + timedelta(days=2)
    end = begin + timedelta(hours=1)

    def remote(request):
        if request.method == "POST":
            payload = json.loads(request.content)
            posted.append(payload)
            return httpx.Response(
                200,
                json={
                    "id": payload.get("id", "remote-created"),
                    "extendedProperties": payload.get("extendedProperties", {}),
                },
            )
        if request.url.path.endswith("/events/" + operation["id"]):
            return httpx.Response(404, json={})
        if request.url.path.endswith("/events/" + operation["id"].replace("-", "")):
            return httpx.Response(404, json={})
        return httpx.Response(
            200,
            json={
                "items": [
                    {
                        "id": "remote-event",
                        "summary": "A real fixture event",
                        "start": {"dateTime": begin.isoformat()},
                        "end": {"dateTime": end.isoformat()},
                    }
                ]
            }
            if provider == "google"
            else {
                "value": [
                    {
                        "id": "remote-event",
                        "subject": "A real fixture event",
                        "start": {"dateTime": begin.replace(tzinfo=None).isoformat()},
                        "end": {"dateTime": end.replace(tzinfo=None).isoformat()},
                    }
                ]
            },
        )

    operation = {"id": "placeholder"}
    transport = httpx.MockTransport(remote)
    with owned_session(a.actor.id) as db:
        assert calendar.sync(db, identity(a.actor.id), cid, transport)["events"] == 1
    mirrors = a.client.get(f"/api/v1/integrations/calendars/{cid}/events").json()["items"]
    imported = a.client.post("/api/v1/integrations/events/" + mirrors[0]["id"] + "/import").json()
    assert (
        a.client.post("/api/v1/integrations/events/" + mirrors[0]["id"] + "/import").json()[
            "event_id"
        ]
        == imported["event_id"]
    )
    response = a.client.post(
        f"/api/v1/integrations/calendars/{cid}/exports",
        json={"request_id": str(uuid4()), "local_event_id": imported["event_id"]},
    )
    assert response.status_code == 201, response.text
    operation = response.json()
    assert not posted
    a.client.post(
        "/api/v1/integrations/exports/" + operation["id"] + "/decision",
        json={"digest": operation["digest"], "nonce": operation["nonce"], "approve": True},
    )
    with owned_session(a.actor.id) as db:
        calendar.publish(db, identity(a.actor.id), UUID(operation["id"]), transport)
    with owned_session(a.actor.id) as db:
        calendar.publish(db, identity(a.actor.id), UUID(operation["id"]), transport)
    assert len(posted) == 1
    assert (
        posted[0].get("transactionId") == operation["id"]
        if provider == "microsoft"
        else posted[0]["id"] == operation["id"].replace("-", "")
    )


def test_workflow_waits_for_real_queued_ai_and_resumes(automation):
    a = automation
    value = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "ai", "prompt": "Prepare a read-only life reflection", "scopes": ["planner"]},
            {"type": "output"},
        ],
    )
    queued = run(a, value)
    tick(a)
    pending = a.client.get("/api/v1/automation/runs/" + queued["id"]).json()
    assert pending["status"] == "waiting_agent"
    agent = a.work(
        ScriptedProvider(agent="planner", answer="Test-only reflection. No records changed.")
    )
    assert agent["status"] == "completed", agent
    tick(a)
    finished = a.client.get("/api/v1/automation/runs/" + queued["id"]).json()
    assert finished["status"] == "completed" and "Test-only reflection" in finished["summary"]
    assert a.client.get("/api/v1/tasks").json()["total"] == 0


def test_expired_lease_discards_old_worker_and_notification_is_once(automation):
    a = automation
    value = flow(
        a,
        [
            {"type": "trigger"},
            {"type": "notify", "title": "Exactly one update"},
            {"type": "output"},
        ],
    )
    queued = run(a, value)
    first = claim(uuid4(), a.dispatch)
    with a.dispatch.begin() as db:
        db.execute(
            text("UPDATE automation_jobs SET lease_until=now()-interval '1 second' WHERE id=:id"),
            {"id": first["id"]},
        )
    second = claim(uuid4(), a.dispatch)
    assert second["attempt"] == first["attempt"] + 1
    process(first)
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "queued"
    process(second)
    assert a.client.get("/api/v1/notifications").json()["total"] == 1


def test_busy_owner_reschedules_instead_of_failing_run(automation):
    a = automation
    value = flow(a, [{"type": "trigger"}, {"type": "output"}])
    queued = run(a, value)
    job = claim(uuid4(), a.dispatch)
    with a.runtime.begin() as db:
        key = int.from_bytes(a.actor.id.bytes[:8], "big", signed=True)
        db.execute(text("SELECT pg_advisory_xact_lock(:key)"), {"key": key})
        process(job)
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "queued"
    tick(a)
    assert a.client.get("/api/v1/automation/runs/" + queued["id"]).json()["status"] == "completed"


def test_calendar_stale_event_and_expired_authorization_never_publish(automation):
    a = automation
    cid = connection(a)
    begin = now() + timedelta(days=1)
    local = a.client.post(
        "/api/v1/events",
        json={
            "title": "Original",
            "starts_at": begin.isoformat(),
            "ends_at": (begin + timedelta(hours=1)).isoformat(),
        },
    ).json()
    operation = a.client.post(
        f"/api/v1/integrations/calendars/{cid}/exports",
        json={"request_id": str(uuid4()), "local_event_id": local["id"]},
    ).json()
    a.client.post(
        "/api/v1/integrations/exports/" + operation["id"] + "/decision",
        json={"digest": operation["digest"], "nonce": operation["nonce"], "approve": True},
    )
    a.client.put(
        "/api/v1/events/" + local["id"],
        json={
            "title": "Changed later",
            "starts_at": begin.isoformat(),
            "ends_at": (begin + timedelta(hours=1)).isoformat(),
        },
    )
    called = []
    transport = httpx.MockTransport(
        lambda r: (
            called.append(str(r.url)) or httpx.Response(200, json={"id": "should-not-exist"})
        )
    )
    with pytest.raises(HTTPException), owned_session(a.actor.id) as db:
        calendar.publish(db, identity(a.actor.id), UUID(operation["id"]), transport)
    assert called == []


def test_uncertain_google_export_reconciles_without_second_post(automation):
    a = automation
    cid = connection(a)
    begin = now() + timedelta(days=1)
    event = a.client.post(
        "/api/v1/events",
        json={
            "title": "Approved once",
            "starts_at": begin.isoformat(),
            "ends_at": (begin + timedelta(hours=1)).isoformat(),
        },
    ).json()
    op = a.client.post(
        f"/api/v1/integrations/calendars/{cid}/exports",
        json={"request_id": str(uuid4()), "local_event_id": event["id"]},
    ).json()
    decision = {"digest": op["digest"], "nonce": op["nonce"], "approve": True}
    a.client.post("/api/v1/integrations/exports/" + op["id"] + "/decision", json=decision)
    state = {"posts": 0, "created": None}

    def provider(request):
        if request.method == "POST":
            state["posts"] += 1
            state["created"] = json.loads(request.content)
            return httpx.Response(503, json={"detail": "simulated uncertain response"})
        return (
            httpx.Response(404, json={})
            if state["created"] is None
            else httpx.Response(200, json=state["created"])
        )

    transport = httpx.MockTransport(provider)
    with a.dispatch.begin() as db:
        db.execute(
            text("UPDATE automation_jobs SET status='done' WHERE user_id=:owner AND kind='signal'"),
            {"owner": a.actor.id},
        )
    process(claim(uuid4(), a.dispatch), transport=transport)
    assert a.client.get("/api/v1/integrations/exports").json()["items"][0]["status"] == "uncertain"
    assert (
        a.client.post(
            "/api/v1/integrations/exports/" + op["id"] + "/decision", json=decision
        ).status_code
        == 200
    )
    process(claim(uuid4(), a.dispatch), transport=transport)
    assert a.client.get("/api/v1/integrations/exports").json()["items"][0]["status"] == "published"
    assert state["posts"] == 1


def test_microsoft_pagination_cannot_forward_tokens_to_another_origin(automation):
    a = automation
    cid = connection(a, "microsoft")
    hosts = []

    def provider(request):
        hosts.append(request.url.host)
        return httpx.Response(
            200, json={"value": [], "@odata.nextLink": "https://attacker.example/steal"}
        )

    with pytest.raises(HTTPException), owned_session(a.actor.id) as db:
        calendar.sync(db, identity(a.actor.id), cid, httpx.MockTransport(provider))
    assert hosts == ["graph.microsoft.com"]
