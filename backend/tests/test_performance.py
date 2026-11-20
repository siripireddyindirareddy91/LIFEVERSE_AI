"""Repeatable in-process API benchmark against disposable PostgreSQL only."""

import json
import math
import os
import statistics
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timedelta, timezone
from pathlib import Path
from uuid import uuid4

import pytest
from sqlalchemy import event, insert, text

from app.life.models import Task
from test_core_life import api, save_profile  # noqa: F401

pytestmark = pytest.mark.skipif(
    not os.getenv("TEST_DATABASE_URL"), reason="Disposable PostgreSQL required"
)


def test_concurrent_private_reads_have_bounded_results(api):  # noqa: F811
    client, actor, _, _, _ = api
    save_profile(client)
    from app.database import engine

    db_engine = engine()
    instant = datetime.now(timezone.utc)
    with db_engine.begin() as db:
        db.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)})
        db.execute(
            insert(Task),
            [
                {
                    "id": uuid4(),
                    "user_id": actor.id,
                    "title": f"Synthetic task {i:04d}",
                    "status": "done" if i % 5 == 0 else "todo",
                    "completed_at": instant - timedelta(days=i % 7) if i % 5 == 0 else None,
                    "due_at": instant + timedelta(days=(i % 9) - 4),
                }
                for i in range(2000)
            ],
        )

    # Warm connection/route initialization separately from measured requests.
    assert client.get("/api/v1/dashboard").status_code == 200
    assert client.get("/api/v1/tasks?limit=30").status_code == 200

    def read(i):
        path = "/api/v1/dashboard" if i % 3 == 0 else "/api/v1/tasks?limit=30&offset=30"
        start = time.perf_counter()
        response = client.get(path)
        elapsed = (time.perf_counter() - start) * 1000
        assert response.status_code == 200, response.text
        body = response.json()
        if "items" in body:
            assert body["total"] == 2000 and len(body["items"]) == 30
        else:
            assert body["tasks_open"] == 1600 and body["tasks_completed"] == 400
        return elapsed

    start = time.perf_counter()
    with ThreadPoolExecutor(max_workers=8) as pool:
        elapsed = list(pool.map(read, range(48)))
    duration = time.perf_counter() - start
    p95 = sorted(elapsed)[math.ceil(len(elapsed) * 0.95) - 1]
    report = {
        "scope": "in-process ASGI with disposable PostgreSQL; no production network/TLS/provider latency",
        "records": 2000,
        "requests": 48,
        "concurrency": 8,
        "errors": 0,
        "median_ms": round(statistics.median(elapsed), 2),
        "p95_ms": round(p95, 2),
        "max_ms": round(max(elapsed), 2),
        "requests_per_second": round(48 / duration, 2),
        "p95_budget_ms": 5000,
    }
    if output := os.getenv("PERFORMANCE_REPORT"):
        Path(output).parent.mkdir(parents=True, exist_ok=True)
        Path(output).write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    assert p95 < 5000, report


def test_dashboard_query_budget_and_local_day_boundaries(api):  # noqa: F811
    from app.database import engine
    from zoneinfo import ZoneInfo

    client, actor, _, _, _ = api
    save_profile(client, timezone="Pacific/Kiritimati")
    today = datetime.now(ZoneInfo("Pacific/Kiritimati")).date()
    local_midnight = datetime.combine(today, datetime.min.time(), ZoneInfo("Pacific/Kiritimati"))
    rows = [
        {
            "id": uuid4(),
            "user_id": actor.id,
            "title": "Boundary task",
            "status": "done",
            "completed_at": local_midnight + timedelta(seconds=delta),
        }
        for delta in (-1, 0, 1)
    ]
    with engine().begin() as db:
        db.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": str(actor.id)})
        db.execute(insert(Task), rows)
    statements = []

    def count(conn, cursor, statement, params, context, many):
        statements.append(statement)

    event.listen(engine(), "before_cursor_execute", count)
    try:
        response = client.get("/api/v1/dashboard")
    finally:
        event.remove(engine(), "before_cursor_execute", count)
    assert response.status_code == 200, response.text
    week = response.json()["weekly_activity"]
    assert week[-1]["day"] == str(today)
    assert week[-1]["tasks_completed"] == 2
    assert week[-2]["tasks_completed"] == 1
    assert len(statements) <= 12, (
        f"Dashboard issued {len(statements)} database statements; budget is 12"
    )
    if output := os.getenv("PERFORMANCE_REPORT"):
        path = Path(output)
        if path.exists():
            report = json.loads(path.read_text(encoding="utf-8"))
            report["dashboard_statements"] = len(statements)
            path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
