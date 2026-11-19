from uuid import UUID, uuid4
from datetime import datetime
from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKeyConstraint,
    Integer,
    LargeBinary,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column
from app.life.models import Owned
from app.models import Base


class Workflow(Owned, Base):
    __tablename__ = "workflows"
    __table_args__ = (UniqueConstraint("user_id", "id"), UniqueConstraint("user_id", "request_id"))
    title: Mapped[str] = mapped_column(String(120))
    definition: Mapped[dict] = mapped_column(JSONB)
    revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), default=uuid4)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    input_hash: Mapped[str] = mapped_column(String(64))
    enabled: Mapped[bool] = mapped_column(Boolean, default=False)
    activated_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))


class WorkflowUsage(Owned, Base):
    __tablename__ = "workflow_usage"
    __table_args__ = (UniqueConstraint("user_id", "request_id"),)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))


class WorkflowRun(Owned, Base):
    __tablename__ = "workflow_runs"
    __table_args__ = (
        UniqueConstraint("user_id", "id"),
        UniqueConstraint("user_id", "request_id"),
        ForeignKeyConstraint(
            ["user_id", "workflow_id"], ["workflows.user_id", "workflows.id"], ondelete="CASCADE"
        ),
    )
    workflow_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    definition: Mapped[dict] = mapped_column(JSONB)
    status: Mapped[str] = mapped_column(String(24), default="queued")
    cursor: Mapped[int] = mapped_column(Integer, default=0)
    steps: Mapped[list] = mapped_column(JSONB, default=list)
    context: Mapped[dict] = mapped_column(JSONB, default=dict)
    summary: Mapped[str] = mapped_column(Text, default="")
    error: Mapped[str] = mapped_column(String(500), default="")
    attempts: Mapped[int] = mapped_column(Integer, default=0)
    agent_run_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True))
    proposal_run_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True))
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class AutomationJob(Owned, Base):
    __tablename__ = "automation_jobs"
    __table_args__ = (UniqueConstraint("user_id", "kind", "subject_id"),)
    kind: Mapped[str] = mapped_column(String(20))
    subject_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    status: Mapped[str] = mapped_column(String(12), default="pending")
    due_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    lease_until: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    attempts: Mapped[int] = mapped_column(Integer, default=0)


class AutomationWorker(Base):
    __tablename__ = "automation_workers"
    id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), primary_key=True)
    last_seen: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class AutomationSignal(Owned, Base):
    __tablename__ = "automation_signals"
    topic: Mapped[str] = mapped_column(String(32))
    record_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    record_kind: Mapped[str] = mapped_column(String(24))


class InboxNotification(Owned, Base):
    __tablename__ = "inbox_notifications"
    __table_args__ = (UniqueConstraint("user_id", "source_key"),)
    source_key: Mapped[str] = mapped_column(String(160))
    title: Mapped[str] = mapped_column(String(120))
    body: Mapped[str] = mapped_column(Text)
    route: Mapped[str] = mapped_column(String(120), default="/notifications")
    due_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)
    read_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    cancelled: Mapped[bool] = mapped_column(Boolean, default=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class CalendarConnection(Owned, Base):
    __tablename__ = "calendar_connections"
    __table_args__ = (UniqueConstraint("user_id", "id"),)
    title: Mapped[str] = mapped_column(String(120))
    provider: Mapped[str] = mapped_column(String(16))
    writable: Mapped[bool] = mapped_column(Boolean, default=False)
    active: Mapped[bool] = mapped_column(Boolean, default=True)
    revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), default=uuid4)
    token_cipher: Mapped[bytes] = mapped_column(LargeBinary, deferred=True)
    key_id: Mapped[str] = mapped_column(String(40))
    last_sync_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    error: Mapped[str] = mapped_column(String(500), default="")


class OAuthState(Owned, Base):
    __tablename__ = "oauth_states"
    provider: Mapped[str] = mapped_column(String(16))
    writable: Mapped[bool] = mapped_column(Boolean)
    verifier_cipher: Mapped[bytes] = mapped_column(LargeBinary)
    key_id: Mapped[str] = mapped_column(String(40))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    consumed: Mapped[bool] = mapped_column(Boolean, default=False)


class OAuthLookup(Owned, Base):
    __tablename__ = "oauth_lookups"
    __table_args__ = (UniqueConstraint("state_hash"),)
    state_hash: Mapped[str] = mapped_column(String(64))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))


class CalendarMirror(Owned, Base):
    __tablename__ = "calendar_mirrors"
    __table_args__ = (
        UniqueConstraint("user_id", "connection_id", "remote_id"),
        ForeignKeyConstraint(
            ["user_id", "connection_id"],
            ["calendar_connections.user_id", "calendar_connections.id"],
            ondelete="CASCADE",
        ),
    )
    connection_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    remote_id: Mapped[str] = mapped_column(String(512))
    title: Mapped[str] = mapped_column(String(120))
    starts_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    ends_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    all_day: Mapped[bool] = mapped_column(Boolean, default=False)
    local_event_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True))


class CalendarOperation(Owned, Base):
    __tablename__ = "calendar_operations"
    __table_args__ = (
        UniqueConstraint("user_id", "request_id"),
        ForeignKeyConstraint(
            ["user_id", "connection_id"],
            ["calendar_connections.user_id", "calendar_connections.id"],
            ondelete="CASCADE",
        ),
    )
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    connection_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    connection_revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    local_event_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    payload: Mapped[dict] = mapped_column(JSONB)
    digest: Mapped[str] = mapped_column(String(64))
    nonce: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), default=uuid4)
    status: Mapped[str] = mapped_column(String(24), default="awaiting_approval")
    remote_id: Mapped[str | None] = mapped_column(String(512))
    error: Mapped[str] = mapped_column(String(500), default="")
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
