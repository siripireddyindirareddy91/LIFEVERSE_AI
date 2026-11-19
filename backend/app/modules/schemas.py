from datetime import date
from decimal import Decimal
from typing import Annotated, Literal
from uuid import UUID

from pydantic import AwareDatetime, Field, HttpUrl, model_validator
from app.life.schemas import Input

Money = Annotated[Decimal, Field(ge=0, le=999999999999, max_digits=14, decimal_places=2)]
Currency = Literal["INR", "USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "CNY", "SGD", "AED"]


class Named(Input):
    title: str = Field(min_length=1, max_length=120)
    notes: str = Field(default="", max_length=8000)


class Entry(Named):
    amount: Money = Field(gt=0)
    currency: Currency = "INR"
    direction: Literal["income", "expense"] = "expense"
    category: str = Field(default="Other", min_length=1, max_length=60)
    day: date


class Budget(Named):
    amount: Money
    currency: Currency = "INR"
    category: str = Field(min_length=1, max_length=60)
    month: date

    @model_validator(mode="after")
    def month_start(self):
        self.month = self.month.replace(day=1)
        return self


class Saving(Named):
    target_amount: Money = Field(gt=0)
    saved_amount: Money = Decimal("0")
    currency: Currency = "INR"
    target_date: date | None = None


class Bill(Named):
    amount: Money
    currency: Currency = "INR"
    due_date: date
    recurrence: Literal["none", "monthly", "yearly"] = "none"
    subscription: bool = False
    paid: bool = False


class Course(Named):
    subject: str = Field(default="General", max_length=80)
    resource_url: HttpUrl | None = None
    total_units: int = Field(default=1, ge=1, le=10000)
    completed_units: int = Field(default=0, ge=0, le=10000)
    weekly_minutes: int = Field(default=60, ge=0, le=10080)
    target_date: date | None = None

    @model_validator(mode="after")
    def progress(self):
        if self.completed_units > self.total_units:
            raise ValueError("Completed units cannot exceed total units")
        return self


class StudyNote(Named):
    content: str = Field(min_length=1, max_length=12000)


class Flashcard(Named):
    question: str = Field(min_length=1, max_length=2000)
    answer: str = Field(min_length=1, max_length=4000)


class Quiz(Named):
    question: str = Field(min_length=1, max_length=2000)
    option_a: str = Field(min_length=1, max_length=500)
    option_b: str = Field(min_length=1, max_length=500)
    option_c: str = Field(min_length=1, max_length=500)
    option_d: str = Field(min_length=1, max_length=500)
    correct: Literal["A", "B", "C", "D"]
    explanation: str = Field(default="", max_length=4000)

    @model_validator(mode="after")
    def distinct(self):
        if len({getattr(self, "option_" + letter).casefold() for letter in "abcd"}) != 4:
            raise ValueError("Quiz choices must be different")
        return self


class Application(Named):
    company: str = Field(min_length=1, max_length=120)
    role: str = Field(min_length=1, max_length=120)
    status: Literal[
        "saved", "applied", "screening", "interview", "offer", "rejected", "withdrawn"
    ] = "saved"
    job_url: HttpUrl | None = None
    applied_on: date | None = None
    follow_up: date | None = None


class Resume(Named):
    headline: str = Field(default="", max_length=160)
    summary: str = Field(default="", max_length=4000)
    skills: str = Field(default="", max_length=2000)
    experience: str = Field(default="", max_length=8000)
    education: str = Field(default="", max_length=4000)
    projects: str = Field(default="", max_length=4000)
    job_description: str = Field(default="", max_length=12000)


class Wellness(Named):
    day: date
    sleep_hours: Annotated[Decimal, Field(ge=0, le=24, decimal_places=1)] = Decimal("0")
    water_ml: int = Field(default=0, ge=0, le=20000)
    activity_minutes: int = Field(default=0, ge=0, le=1440)
    mood: int | None = Field(default=None, ge=1, le=5)
    journal: str = Field(default="", max_length=12000)


class Routine(Named):
    time_of_day: Literal["morning", "afternoon", "evening", "anytime"] = "anytime"
    minutes: int = Field(default=10, ge=1, le=1440)
    active: bool = True


class Trip(Named):
    destination: str = Field(min_length=1, max_length=160)
    country: str = Field(default="", max_length=80)
    starts_on: date
    ends_on: date
    budget: Money = Decimal("0")
    currency: Currency = "INR"

    @model_validator(mode="after")
    def dates(self):
        if self.ends_on < self.starts_on or (self.ends_on - self.starts_on).days > 366:
            raise ValueError("Choose a trip of at most 367 days with end on or after start")
        return self


class Itinerary(Named):
    day: date
    time: str = Field(default="09:00", pattern=r"^([01][0-9]|2[0-3]):[0-5][0-9]$")
    location: str = Field(default="", max_length=200)
    category: Literal["activity", "flight", "stay", "transport", "meal"] = "activity"
    cost: Money = Decimal("0")
    currency: Currency = "INR"
    booking_reference: str = Field(default="", max_length=120)


class Packing(Named):
    packed: bool = False


class Scenario(Named):
    scenario_type: Literal["savings", "learning", "career", "time"] = "savings"
    horizon_months: int = Field(default=12, ge=1, le=120)
    starting_amount: Money = Decimal("0")
    monthly_contribution: Money = Decimal("0")
    annual_rate: Annotated[Decimal, Field(ge=-50, le=50, decimal_places=2)] = Decimal("0")
    currency: Currency = "INR"
    hours_per_week: Annotated[Decimal, Field(ge=0, le=168, decimal_places=1)] = Decimal("0")
    target_hours: int = Field(default=100, ge=1, le=100000)
    assumptions: str = Field(min_length=1, max_length=4000)
    risks: str = Field(default="", max_length=4000)


SCHEMAS = {
    "entry": Entry,
    "budget": Budget,
    "saving": Saving,
    "bill": Bill,
    "course": Course,
    "study_note": StudyNote,
    "flashcard": Flashcard,
    "quiz": Quiz,
    "application": Application,
    "resume": Resume,
    "wellness_log": Wellness,
    "routine": Routine,
    "trip": Trip,
    "itinerary": Itinerary,
    "packing": Packing,
    "scenario": Scenario,
}
MODULE_KINDS = {
    "finance": ["entry", "budget", "saving", "bill"],
    "learning": ["course", "study_note", "flashcard", "quiz"],
    "career": ["application", "resume"],
    "wellness": ["wellness_log", "routine"],
    "travel": ["trip", "itinerary", "packing"],
    "future": ["scenario"],
}
PARENTS = {
    "study_note": "course",
    "flashcard": "course",
    "quiz": "course",
    "itinerary": "trip",
    "packing": "trip",
}


class RecordWrite(Input):
    request_id: UUID
    revision: UUID | None = None
    parent_id: UUID | None = None
    allow_ai: bool = False
    data: dict


class QuizAnswer(Input):
    answer: Literal["A", "B", "C", "D"]


class Conversion(Input):
    amount: Money
    from_currency: Currency
    to_currency: Currency
    rate: Annotated[Decimal, Field(gt=0, le=1000000, max_digits=18, decimal_places=8)]
    rate_date: date


class LinkWrite(Input):
    source_id: UUID
    target_id: UUID
    label: str = Field(default="related", min_length=1, max_length=80)


class RetrievalQuery(Input):
    query: str = Field(min_length=1, max_length=2000)
    semantic: bool = False


class PlannerLink(Input):
    request_id: UUID
    due_at: AwareDatetime | None = None
