import re
from decimal import Decimal, ROUND_HALF_UP
from collections import Counter
from uuid import uuid4
from fastapi import HTTPException
from pydantic import ValidationError
from sqlalchemy import func, select
from app.agentic.common import digest
from app.life.service import get_owned, now, user_today
from app.modules.models import ModuleRecord
from app.modules.schemas import MODULE_KINDS, PARENTS, SCHEMAS, Scenario


def money(value):
    return str(Decimal(value).quantize(Decimal(".01"), rounding=ROUND_HALF_UP))


def module_kinds(module):
    if module not in MODULE_KINDS:
        raise HTTPException(404, "Module not found")
    return MODULE_KINDS[module]


def record_read(row):
    return {
        key: getattr(row, key)
        for key in (
            "id",
            "kind",
            "title",
            "data",
            "parent_id",
            "allow_ai",
            "revision",
            "created_at",
            "updated_at",
        )
    }


def lock_owner(db, user):
    key = int.from_bytes(user.id.bytes[:8], "big", signed=True)
    if not db.scalar(select(func.pg_try_advisory_xact_lock(key))):
        raise HTTPException(409, "Another change is in progress. Retry shortly.")


def validate_data(db, user, kind, payload, existing=None):
    if kind not in SCHEMAS:
        raise HTTPException(404, "Record type not found")
    try:
        data = SCHEMAS[kind].model_validate(payload.data).model_dump(mode="json")
    except ValidationError as error:
        raise HTTPException(422, "; ".join(e["msg"] for e in error.errors())[:800]) from error
    expected = PARENTS.get(kind)
    if kind in {"itinerary", "packing"} and payload.parent_id is None:
        raise HTTPException(422, "Choose a trip first")
    if payload.parent_id:
        parent = get_owned(db, ModuleRecord, payload.parent_id, user)
        if expected is None or parent.kind != expected:
            raise HTTPException(422, "That parent cannot contain this record")
        if kind == "itinerary":
            if not parent.data["starts_on"] <= data["day"] <= parent.data["ends_on"]:
                raise HTTPException(422, "Itinerary date must fall within the selected trip")
    if kind == "trip" and existing is not None:
        for child in db.scalars(
            select(ModuleRecord).where(
                ModuleRecord.user_id == user.id,
                ModuleRecord.parent_id == existing.id,
                ModuleRecord.kind == "itinerary",
            )
        ):
            if not data["starts_on"] <= child.data["day"] <= data["ends_on"]:
                raise HTTPException(409, "Move itinerary dates before shortening this trip")
    if kind == "budget":
        budgets = db.scalars(
            select(ModuleRecord).where(
                ModuleRecord.user_id == user.id, ModuleRecord.kind == "budget"
            )
        )
        if any(
            b.id != getattr(existing, "id", None)
            and b.data["month"] == data["month"]
            and b.data["currency"] == data["currency"]
            and b.data["category"].casefold() == data["category"].casefold()
            for b in budgets
        ):
            raise HTTPException(
                409, "A budget already exists for this month, currency and category"
            )
    return data


def save_record(db, user, kind, payload, existing=None, record_id=None):
    lock_owner(db, user)
    previous = None
    if existing is None:
        previous = db.scalar(
            select(ModuleRecord).where(
                ModuleRecord.user_id == user.id, ModuleRecord.request_id == payload.request_id
            )
        )
    data = validate_data(db, user, kind, payload, existing or previous)
    fingerprint = digest(
        {"kind": kind, "data": data, "parent_id": payload.parent_id, "allow_ai": payload.allow_ai}
    )
    if existing is None:
        if previous:
            if previous.input_hash != fingerprint:
                raise HTTPException(409, "Request identifier was used for different content")
            return previous, True
        count = db.scalar(
            select(func.count()).select_from(ModuleRecord).where(ModuleRecord.user_id == user.id)
        )
        if count >= 5000:
            raise HTTPException(409, "The 5000-record account limit has been reached")
        existing = ModuleRecord(
            id=record_id or uuid4(),
            user_id=user.id,
            kind=kind,
            request_id=payload.request_id,
            input_hash=fingerprint,
        )
        db.add(existing)
    else:
        if payload.revision is None or payload.revision != existing.revision:
            if (
                data == existing.data
                and payload.parent_id == existing.parent_id
                and payload.allow_ai == existing.allow_ai
            ):
                return existing, True
            raise HTTPException(409, "This record changed. Refresh before editing it again.")
    existing.data, existing.title = data, data["title"]
    existing.parent_id, existing.allow_ai = payload.parent_id, payload.allow_ai
    existing.revision, existing.updated_at = uuid4(), now()
    db.flush()
    return existing, False


def projection(data):
    spec = Scenario.model_validate(data)
    balance = spec.starting_amount
    rate = spec.annual_rate / Decimal("1200")
    points = [{"month": 0, "balance": money(balance)}]
    for month in range(1, spec.horizon_months + 1):
        balance = balance * (1 + rate) + spec.monthly_contribution
        points.append({"month": month, "balance": money(balance)})
    hours = Decimal(spec.horizon_months) * Decimal(52) / Decimal(12) * spec.hours_per_week
    return {
        "title": spec.title,
        "type": spec.scenario_type,
        "currency": spec.currency,
        "projected_balance": money(balance),
        "contributed": money(
            spec.starting_amount + spec.monthly_contribution * spec.horizon_months
        ),
        "estimated_hours": str(hours.quantize(Decimal(".1"))),
        "target_hours": spec.target_hours,
        "points": points,
        "assumptions": spec.assumptions,
        "risks": spec.risks,
        "method": "Estimate using your inputs: annual rate / 12, monthly compounding, contributions at month end; time uses 52/12 weeks per month. No taxes, fees, inflation or guaranteed outcomes.",
    }


def resume_export(data):
    sections = [
        ("Summary", "summary"),
        ("Skills", "skills"),
        ("Experience", "experience"),
        ("Education", "education"),
        ("Projects", "projects"),
    ]
    text = data["title"] + "\n" + data.get("headline", "") + "\n\n"
    text += "\n\n".join(
        label + "\n" + data.get(key, "") for label, key in sections if data.get(key)
    )
    description = data.get("job_description", "")
    words = set(re.findall(r"[a-z][a-z+#.]{2,}", description.lower()))
    words -= {
        "the",
        "and",
        "with",
        "for",
        "you",
        "your",
        "our",
        "are",
        "this",
        "that",
        "will",
        "have",
        "from",
        "job",
        "work",
        "role",
        "team",
        "experience",
        "required",
        "skills",
        "can",
        "all",
        "not",
    }
    resume_words = set(re.findall(r"[a-z][a-z+#.]{2,}", text.lower()))
    return {
        "text": text.strip(),
        "missing_sections": [label for label, key in sections if not data.get(key)],
        "matched_terms": sorted(words & resume_words)[:40],
        "review_terms": sorted(words - resume_words)[:40],
        "method": "Literal keyword comparison, not an ATS score. Add only qualifications you actually have.",
    }


def overview(db, user, module, month=None, shared_only=False):
    kinds = module_kinds(module)
    query = select(ModuleRecord).where(
        ModuleRecord.user_id == user.id, ModuleRecord.kind.in_(kinds)
    )
    if shared_only:
        query = query.where(ModuleRecord.allow_ai.is_(True))
    rows = list(db.scalars(query.order_by(ModuleRecord.created_at.desc(), ModuleRecord.id)).all())
    today = user_today(db, user)
    month = (month or today).replace(day=1)
    metrics, lines = [], []

    def metric(label, value, detail=""):
        metrics.append({"label": label, "value": str(value), "detail": detail})

    def line(label, value):
        lines.append({"label": label, "value": str(value)})

    if module == "finance":
        entries = [
            r.data for r in rows if r.kind == "entry" and r.data["day"][:7] == month.isoformat()[:7]
        ]
        currencies = sorted(
            {d["currency"] for d in entries}
            | {
                r.data["currency"]
                for r in rows
                if r.kind == "budget" and r.data["month"] == month.isoformat()
            }
        )
        for currency in currencies:
            income = sum(
                (
                    Decimal(d["amount"])
                    for d in entries
                    if d["currency"] == currency and d["direction"] == "income"
                ),
                Decimal(0),
            )
            spent = sum(
                (
                    Decimal(d["amount"])
                    for d in entries
                    if d["currency"] == currency and d["direction"] == "expense"
                ),
                Decimal(0),
            )
            metric(f"{currency} income", money(income), month.strftime("%B %Y"))
            metric(f"{currency} expenses", money(spent), "Manual entries")
            metric(
                f"{currency} net",
                money(income - spent),
                "Income minus expenses; currencies are not combined",
            )
            categories = sorted(
                {
                    d["category"]
                    for d in entries
                    if d["currency"] == currency and d["direction"] == "expense"
                }
            )
            for category in categories:
                value = sum(
                    (
                        Decimal(d["amount"])
                        for d in entries
                        if d["currency"] == currency
                        and d["direction"] == "expense"
                        and d["category"] == category
                    ),
                    Decimal(0),
                )
                line(f"{currency} · {category}", money(value))
        for row in rows:
            d = row.data
            if row.kind == "budget" and d["month"] == month.isoformat():
                spent = sum(
                    (
                        Decimal(e["amount"])
                        for e in entries
                        if e["currency"] == d["currency"]
                        and e["direction"] == "expense"
                        and e["category"].casefold() == d["category"].casefold()
                    ),
                    Decimal(0),
                )
                line(
                    f"{d['title']} · {d['currency']} remaining", money(Decimal(d["amount"]) - spent)
                )
            if row.kind == "saving":
                line(d["title"], f"{d['currency']} {d['saved_amount']} / {d['target_amount']}")
            if row.kind == "bill" and not d["paid"]:
                line(
                    ("Overdue · " if d["due_date"] < today.isoformat() else "Due · ") + d["title"],
                    f"{d['due_date']} · {d['currency']} {d['amount']}",
                )
    elif module == "learning":
        courses = [r.data for r in rows if r.kind == "course"]
        metric("Courses", len(courses))
        metric(
            "Completed units",
            sum(d["completed_units"] for d in courses),
            f"of {sum(d['total_units'] for d in courses)} planned units",
        )
        metric("Weekly study minutes", sum(d["weekly_minutes"] for d in courses), "Your targets")
        for d in courses:
            line(d["title"], f"{d['completed_units']} / {d['total_units']} units")
        line("Practice cards", sum(r.kind == "flashcard" for r in rows))
        line("Authored quiz questions", sum(r.kind == "quiz" for r in rows))
    elif module == "career":
        applications = [r.data for r in rows if r.kind == "application"]
        metric("Applications tracked", len(applications))
        metric("Interviews", sum(d["status"] == "interview" for d in applications))
        metric("Offers", sum(d["status"] == "offer" for d in applications))
        for status, count in sorted(Counter(d["status"] for d in applications).items()):
            line(status.capitalize(), count)
        for d in applications:
            if (
                d.get("follow_up")
                and d["follow_up"] <= today.isoformat()
                and d["status"] not in {"rejected", "withdrawn"}
            ):
                line("Follow up · " + d["company"], d["follow_up"])
    elif module == "wellness":
        logs = [
            r.data for r in rows if r.kind == "wellness_log" and r.data["day"] == today.isoformat()
        ]
        metric(
            "Water logged today",
            f"{sum(d['water_ml'] for d in logs)} ml",
            "Self-reported, not a recommendation",
        )
        metric("Activity today", f"{sum(d['activity_minutes'] for d in logs)} min")
        metric("Sleep logged today", f"{sum(Decimal(d['sleep_hours']) for d in logs)} h")
        line("Active routines", sum(r.kind == "routine" and r.data["active"] for r in rows))
        line(
            "Journal entries",
            sum(r.kind == "wellness_log" and bool(r.data["journal"]) for r in rows),
        )
    elif module == "travel":
        trips = [r for r in rows if r.kind == "trip"]
        metric("Trips", len(trips))
        metric("Upcoming trips", sum(r.data["starts_on"] >= today.isoformat() for r in trips))
        for trip in trips:
            d = trip.data
            costs = [r.data for r in rows if r.kind == "itinerary" and r.parent_id == trip.id]
            total = sum(
                (Decimal(c["cost"]) for c in costs if c["currency"] == d["currency"]), Decimal(0)
            )
            line(d["title"], f"{d['currency']} {money(total)} planned / {d['budget']} budget")
            for currency in sorted(
                {c["currency"] for c in costs if c["currency"] != d["currency"]}
            ):
                extra = sum(Decimal(c["cost"]) for c in costs if c["currency"] == currency)
                line(d["title"] + " · separate currency", f"{currency} {money(extra)}")
            packing = [r for r in rows if r.kind == "packing" and r.parent_id == trip.id]
            line(
                d["title"] + " · packing",
                f"{sum(r.data['packed'] for r in packing)} / {len(packing)} packed",
            )
    elif module == "future":
        metric("Saved scenarios", len(rows))
        for row in rows:
            result = projection(row.data)
            line(
                row.title,
                f"Estimated {result['currency']} {result['projected_balance']} · {result['estimated_hours']} study/work hours",
            )
    if not rows:
        metric(
            "A fresh start", "0 records", "Add your own information to see this space take shape."
        )
    return {
        "module": module,
        "today": today,
        "month": month,
        "metrics": metrics,
        "lines": lines,
        "record_count": len(rows),
        "shared_only": shared_only,
    }
