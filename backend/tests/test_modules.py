import base64
from datetime import date, timedelta
from unittest.mock import patch
from uuid import UUID, uuid4
import pytest
from pydantic import SecretStr
from sqlalchemy import text
from test_agentic import agent_api, ScriptedProvider  # noqa: F401
from app.agentic.common import owned_session, identity
from app.modules.agent_context import context
from app.modules.models import VaultFile
from app.life.service import now


@pytest.fixture
def modules(agent_api):  # noqa: F811 - imported pytest fixture
    a = agent_api
    settings = a.settings.model_copy(
        update={"vault_encryption_keys": {"v1": SecretStr(base64.b64encode(b"x" * 32).decode())}}
    )
    with patch("app.modules.vault.get_settings", return_value=settings):
        yield a


def create(a, kind, data, **fields):
    payload = {"request_id": str(uuid4()), "data": {"title": "My record", **data}, **fields}
    response = a.client.post("/api/v1/modules/records/" + kind, json=payload)
    assert response.status_code == 201, response.text
    return response.json(), payload


def test_finance_decimal_currencies_budgets_and_conversion(modules):
    a = modules
    today = date.today().isoformat()
    for amount in ["0.10", "0.20"]:
        create(a, "entry", {"amount": amount, "day": today, "category": "Food"})
    create(a, "entry", {"amount": "3.40", "currency": "USD", "day": today})
    budget, payload = create(a, "budget", {"amount": "1.00", "category": "Food", "month": today})
    assert a.client.post("/api/v1/modules/records/budget", json=payload).status_code == 200
    report = a.client.get("/api/v1/modules/finance/overview").json()
    assert next(m["value"] for m in report["metrics"] if m["label"] == "INR expenses") == "0.30"
    assert next(m["value"] for m in report["metrics"] if m["label"] == "USD expenses") == "3.40"
    assert any(line["value"] == "0.70" for line in report["lines"])
    invalid = a.client.post(
        "/api/v1/modules/records/entry",
        json={
            "request_id": str(uuid4()),
            "data": {"title": "Invalid", "amount": "1.001", "day": today},
        },
    )
    assert invalid.status_code == 422
    result = a.client.post(
        "/api/v1/finance/convert",
        json={
            "amount": "10",
            "from_currency": "USD",
            "to_currency": "INR",
            "rate": "83.125",
            "rate_date": today,
        },
    )
    assert result.json()["amount"] == "831.25"


def test_learning_quiz_parent_validation_and_revision(modules):
    a = modules
    course, _ = create(a, "course", {"total_units": 10, "completed_units": 2})
    quiz, _ = create(
        a,
        "quiz",
        {
            "question": "Which number is even?",
            "option_a": "1",
            "option_b": "2",
            "option_c": "3",
            "option_d": "5",
            "correct": "B",
            "explanation": "Two is divisible by two.",
        },
        parent_id=course["id"],
    )
    practice = a.client.get("/api/v1/learning/practice/" + quiz["id"]).json()
    assert "correct" not in practice and "explanation" not in practice
    assert (
        a.client.post("/api/v1/learning/practice/" + quiz["id"], json={"answer": "A"}).json()[
            "score"
        ]
        == 0
    )
    assert (
        a.client.post("/api/v1/learning/practice/" + quiz["id"], json={"answer": "B"}).json()[
            "score"
        ]
        == 1
    )
    payload = {
        "request_id": str(uuid4()),
        "revision": course["revision"],
        "data": {**course["data"], "completed_units": 5},
    }
    assert a.client.put("/api/v1/modules/record/" + course["id"], json=payload).status_code == 200
    assert a.client.put("/api/v1/modules/record/" + course["id"], json=payload).status_code == 200
    payload["data"]["completed_units"] = 6
    assert a.client.put("/api/v1/modules/record/" + course["id"], json=payload).status_code == 409
    assert a.client.delete("/api/v1/modules/record/" + course["id"]).status_code == 204
    assert a.client.get("/api/v1/modules/record/" + quiz["id"]).status_code == 404


def test_career_resume_and_wellness_reports(modules):
    a = modules
    resume, _ = create(
        a,
        "resume",
        {
            "headline": "Flutter developer",
            "skills": "Dart Flutter",
            "experience": "Built an app",
            "job_description": "Flutter Dart Python SQL",
        },
    )
    result = a.client.get("/api/v1/career/resume/" + resume["id"]).json()
    assert "python" in result["review_terms"] and "flutter" in result["matched_terms"]
    assert "Education" in result["missing_sections"] and "Built an app" in result["text"]
    create(
        a,
        "application",
        {"company": "User supplied company", "role": "Engineer", "status": "interview"},
    )
    report = a.client.get("/api/v1/modules/career/overview").json()
    assert next(m["value"] for m in report["metrics"] if m["label"] == "Interviews") == "1"
    create(
        a,
        "wellness_log",
        {
            "day": date.today().isoformat(),
            "sleep_hours": "7.5",
            "water_ml": 500,
            "journal": "My own reflection",
        },
    )
    assert (
        a.client.get("/api/v1/modules/wellness/overview").json()["metrics"][0]["value"] == "500 ml"
    )


def test_travel_links_dates_and_idempotent_planner(modules):
    a = modules
    today = date.today()
    trip, _ = create(
        a,
        "trip",
        {
            "destination": "User entered destination",
            "starts_on": today.isoformat(),
            "ends_on": (today + timedelta(days=5)).isoformat(),
            "budget": "100",
        },
    )
    item, _ = create(a, "itinerary", {"day": today.isoformat(), "cost": "25"}, parent_id=trip["id"])
    report = a.client.get("/api/v1/modules/travel/overview").json()
    assert any("25.00" in line["value"] for line in report["lines"])
    payload = {"request_id": str(uuid4())}
    first = a.client.post("/api/v1/modules/record/" + item["id"] + "/planner", json=payload)
    second = a.client.post("/api/v1/modules/record/" + item["id"] + "/planner", json=payload)
    assert first.status_code == 200, first.text
    assert second.json()["cached"] and first.json()["task_id"] == second.json()["task_id"]
    assert a.client.get("/api/v1/tasks").json()["total"] == 1
    invalid = a.client.post(
        "/api/v1/modules/records/itinerary",
        json={
            "request_id": str(uuid4()),
            "parent_id": trip["id"],
            "data": {"title": "Outside", "day": (today + timedelta(days=6)).isoformat()},
        },
    )
    assert invalid.status_code == 422


def test_future_estimates_and_limits(modules):
    a = modules
    row, _ = create(
        a,
        "scenario",
        {
            "starting_amount": "100",
            "monthly_contribution": "10",
            "annual_rate": "0",
            "horizon_months": 12,
            "hours_per_week": "2",
            "assumptions": "Constant contribution, no fees.",
        },
    )
    result = a.client.get("/api/v1/future/scenarios/" + row["id"]).json()
    assert result["projected_balance"] == "220.00" and result["estimated_hours"] == "104.0"
    assert len(result["points"]) == 13 and "Estimate" in result["method"]


def test_module_owner_isolation_and_ai_sharing(modules):
    a = modules
    private, _ = create(
        a, "entry", {"amount": "20", "day": date.today().isoformat(), "title": "Private salary"}
    )
    public, _ = create(
        a,
        "entry",
        {"amount": "5", "day": date.today().isoformat(), "title": "Shared food"},
        allow_ai=True,
    )
    with owned_session(a.actor.id) as db:
        result = context(db, identity(a.actor.id), "finance", "")
        assert [r["id"] for r in result["items"]] == [public["id"]]
    a.actor.id = uuid4()
    a.owners.append(a.actor.id)
    assert a.client.get("/api/v1/modules/record/" + private["id"]).status_code == 404
    assert a.client.get("/api/v1/modules/finance/records").json()["total"] == 0
    with owned_session(a.actor.id) as db:
        assert db.scalar(text("SELECT count(*) FROM module_records")) == 0


def test_vault_encryption_retries_tamper_and_expiry(modules):
    a = modules
    content = b"Private document text"
    payload = {
        "request_id": str(uuid4()),
        "title": "My certificate",
        "filename": "certificate.txt",
        "content_base64": base64.b64encode(content).decode(),
    }
    response = a.client.post("/api/v1/vault/files", json=payload)
    assert response.status_code == 201, response.text
    file = response.json()
    assert "ciphertext" not in file
    assert a.client.post("/api/v1/vault/files", json=payload).status_code == 200
    download = a.client.get("/api/v1/vault/files/" + file["id"] + "/download")
    assert base64.b64decode(download.json()["content_base64"]) == content
    assert download.headers["cache-control"] == "no-store"
    with owned_session(a.actor.id) as db:
        row = db.get(VaultFile, UUID(file["id"]))
        assert content not in row.ciphertext
        row.ciphertext = row.ciphertext[:-1] + bytes([row.ciphertext[-1] ^ 1])
    assert a.client.get("/api/v1/vault/files/" + file["id"] + "/download").status_code == 503
    with owned_session(a.actor.id) as db:
        db.get(VaultFile, UUID(file["id"])).expires_at = now() - timedelta(seconds=1)
    assert a.client.get("/api/v1/vault/files/" + file["id"] + "/download").status_code == 404
    assert a.client.get("/api/v1/vault/files").json()["total"] == 0


def test_vault_types_and_missing_key(modules):
    a = modules
    payload = {
        "request_id": str(uuid4()),
        "title": "No executable",
        "filename": "app.exe",
        "content_base64": base64.b64encode(b"MZ-executable").decode(),
    }
    assert a.client.post("/api/v1/vault/files", json=payload).status_code == 422
    with patch("app.modules.vault.get_settings", return_value=a.settings):
        assert a.client.get("/api/v1/vault/status").json()["configured"] is False
        assert a.client.post("/api/v1/vault/files", json=payload).status_code == 503


def test_knowledge_graph_owner_links_and_delete_cascade(modules):
    a = modules

    def source(title):
        return a.client.post(
            "/api/v1/knowledge", json={"title": title, "content": "My notes"}
        ).json()

    one, two = source("Flutter"), source("Dart")
    response = a.client.post(
        "/api/v1/knowledge-universe/links",
        json={"source_id": one["id"], "target_id": two["id"], "label": "built with"},
    )
    assert response.status_code == 201, response.text
    graph = a.client.get("/api/v1/knowledge-universe/graph").json()
    assert len(graph["nodes"]) == 2 and len(graph["edges"]) == 1
    a.client.delete("/api/v1/knowledge/" + one["id"])
    assert a.client.get("/api/v1/knowledge-universe/graph").json()["edges"] == []


def test_advanced_agent_proposals_require_approval_and_stay_private(modules):
    a = modules
    provider = ScriptedProvider(
        agent="learning",
        calls=[
            (
                "create_course",
                {
                    "title": "A proposed learning path",
                    "subject": "Dart",
                    "total_units": 8,
                    "completed_units": 0,
                },
            )
        ],
    )
    a.enqueue(provider)
    run = a.work(provider)
    assert run["status"] == "awaiting_approval", run
    assert a.client.get("/api/v1/modules/learning/records").json()["total"] == 0
    response, _ = a.review(run)
    assert response.json()["status"] == "completed", response.text
    saved = a.client.get("/api/v1/modules/learning/records").json()["items"][0]
    assert saved["id"] == run["actions"][0]["record_id"] and saved["allow_ai"] is False


def test_shared_module_evidence_revision_blocks_stale_approval(modules):
    a = modules
    source, _ = create(a, "course", {"title": "My current plan", "total_units": 10}, allow_ai=True)
    provider = ScriptedProvider(
        agent="learning",
        calls=[
            ("read_learning", {}),
            (
                "create_study_note",
                {"title": "Study summary", "content": "A proposed summary of my shared course"},
            ),
        ],
    )
    a.enqueue(provider)
    run = a.work(provider)
    assert run["status"] == "awaiting_approval" and len(run["sources"]) == 1, run
    a.client.put(
        "/api/v1/modules/record/" + source["id"],
        json={
            "request_id": str(uuid4()),
            "revision": source["revision"],
            "data": source["data"],
            "allow_ai": False,
        },
    )
    response, _ = a.review(run)
    assert response.json()["status"] == "stale", response.text
    assert (
        a.client.get("/api/v1/modules/learning/records", params={"kind": "study_note"}).json()[
            "total"
        ]
        == 0
    )


def test_parent_vault_and_graph_cross_owner_denied(modules):
    a = modules
    trip, _ = create(
        a,
        "trip",
        {
            "destination": "My destination",
            "starts_on": date.today().isoformat(),
            "ends_on": date.today().isoformat(),
        },
    )
    file = a.client.post(
        "/api/v1/vault/files",
        json={
            "request_id": str(uuid4()),
            "title": "Private",
            "filename": "note.txt",
            "content_base64": base64.b64encode(b"Owner only").decode(),
        },
    ).json()
    source = a.client.post(
        "/api/v1/knowledge", json={"title": "My source", "content": "Private notes"}
    ).json()
    a.actor.id = uuid4()
    a.owners.append(a.actor.id)
    assert a.client.get("/api/v1/vault/files/" + file["id"] + "/download").status_code == 404
    assert (
        a.client.post(
            "/api/v1/modules/records/packing",
            json={
                "request_id": str(uuid4()),
                "parent_id": trip["id"],
                "data": {"title": "Unauthorized"},
            },
        ).status_code
        == 404
    )
    own = a.client.post(
        "/api/v1/knowledge", json={"title": "Other source", "content": "Other notes"}
    ).json()
    assert (
        a.client.post(
            "/api/v1/knowledge-universe/links",
            json={"source_id": source["id"], "target_id": own["id"]},
        ).status_code
        == 404
    )


def test_upload_body_limit_and_quota(modules):
    a = modules
    response = a.client.post(
        "/api/v1/vault/files",
        content=b"x" * (8 * 1024 * 1024 + 1),
        headers={"Content-Type": "application/json"},
    )
    assert response.status_code == 413
    payload = {
        "request_id": str(uuid4()),
        "title": "Quota test",
        "filename": "note.txt",
        "content_base64": base64.b64encode(b"Owned document").decode(),
    }
    response = a.client.post("/api/v1/vault/files", json=payload)
    assert response.status_code == 201, response.text
    with owned_session(a.actor.id) as db:
        db.execute(text("UPDATE vault_files SET size = 104857600"))
    payload["request_id"] = str(uuid4())
    assert a.client.post("/api/v1/vault/files", json=payload).status_code == 409


def test_knowledge_connections_are_shared_evidence_and_changes_block_approval(modules):
    from app.agentic.schemas import SupervisorPlan
    from app.modules.agent_context import knowledge_connections
    import json

    a = modules
    sources = [
        a.client.post(
            "/api/v1/knowledge",
            json={"title": title, "content": "My shared study reference", "allow_ai": True},
        ).json()
        for title in ["Dart", "Flutter"]
    ]
    link = {"source_id": sources[0]["id"], "target_id": sources[1]["id"], "label": "builds with"}
    assert a.client.post("/api/v1/knowledge-universe/links", json=link).status_code == 201
    with owned_session(a.actor.id) as db:
        result = knowledge_connections(db, identity(a.actor.id), "")
        assert len(result["connections"]) == 1 and len(result["sources"]) == 2

    class GraphPlan(ScriptedProvider):
        def plan(self, *args):
            return SupervisorPlan(
                agents=["knowledge", "learning"],
                plan="Review shared connections and prepare a note.",
            )

        def turn(self, agent, messages, tools):
            count = sum(m.get("role") == "tool" for m in messages)
            if agent == "knowledge" and count == 0:
                name, arguments = "read_knowledge_connections", {}
            elif agent == "learning" and count == 1:
                name, arguments = (
                    "create_study_note",
                    {
                        "title": "Related concepts",
                        "content": "Dart and Flutter are connected in my notes.",
                    },
                )
            else:
                return {"content": "Ready."}
            return {
                "tool_calls": [
                    {
                        "id": "call_" + agent,
                        "type": "function",
                        "function": {"name": name, "arguments": json.dumps(arguments)},
                    }
                ]
            }

    provider = GraphPlan()
    a.enqueue(provider, scopes=["knowledge", "learning"])
    run = a.work(provider)
    assert run["status"] == "awaiting_approval", run
    assert (
        a.client.post(
            "/api/v1/knowledge-universe/links", json={**link, "label": "updated connection"}
        ).status_code
        == 201
    )
    assert a.review(run)[0].json()["status"] == "stale"
