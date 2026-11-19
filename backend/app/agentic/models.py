from datetime import datetime
from uuid import UUID, uuid4

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    DateTime,
    Float,
    ForeignKeyConstraint,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.life.models import Owned
from app.models import Base


class AgentRun(Owned, Base):
    __tablename__ = "agent_runs"
    __table_args__ = (
        UniqueConstraint("user_id", "id"),
        UniqueConstraint("user_id", "request_id"),
        CheckConstraint(
            "status IN ('queued','running','awaiting_approval','completed','failed','rejected','cancelled','expired','stale')"
        ),
    )
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    origin: Mapped[str] = mapped_column(String(16), default="ai", server_default="ai")
    input_hash: Mapped[str] = mapped_column(String(64))
    prompt: Mapped[str] = mapped_column(Text)
    scopes: Mapped[list[str]] = mapped_column(ARRAY(String(20)), default=list)
    allow_proposals: Mapped[bool] = mapped_column(Boolean, default=False)
    status: Mapped[str] = mapped_column(String(24), default="queued", index=True)
    summary: Mapped[str] = mapped_column(Text, default="")
    error: Mapped[str] = mapped_column(Text, default="")
    plan: Mapped[str] = mapped_column(Text, default="")
    agents: Mapped[list] = mapped_column(JSONB, default=list)
    sources: Mapped[list] = mapped_column(JSONB, default=list)
    model_calls: Mapped[int] = mapped_column(Integer, default=0)
    tool_calls: Mapped[int] = mapped_column(Integer, default=0)
    event_seq: Mapped[int] = mapped_column(Integer, default=0)
    approval_digest: Mapped[str | None] = mapped_column(String(64))
    review_nonce: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True))
    review_expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    started_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    deadline_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    queue_expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


def run_fk():
    return ForeignKeyConstraint(
        ["user_id", "run_id"], ["agent_runs.user_id", "agent_runs.id"], ondelete="CASCADE"
    )


class AgentAction(Owned, Base):
    __tablename__ = "agent_actions"
    __table_args__ = (
        run_fk(),
        UniqueConstraint("user_id", "run_id", "position"),
        CheckConstraint("status IN ('pending','applied','rejected','blocked')"),
    )
    run_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    position: Mapped[int] = mapped_column(Integer)
    agent: Mapped[str] = mapped_column(String(24))
    tool: Mapped[str] = mapped_column(String(64))
    label: Mapped[str] = mapped_column(String(200))
    arguments: Mapped[dict] = mapped_column(JSONB)
    before: Mapped[dict | None] = mapped_column(JSONB)
    expected_hash: Mapped[str | None] = mapped_column(String(64))
    record_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    dependencies: Mapped[list[UUID]] = mapped_column(ARRAY(PGUUID(as_uuid=True)), default=list)
    status: Mapped[str] = mapped_column(String(16), default="pending")
    result: Mapped[dict | None] = mapped_column(JSONB)


class AgentStep(Owned, Base):
    __tablename__ = "agent_steps"
    __table_args__ = (run_fk(), UniqueConstraint("user_id", "run_id", "sequence"))
    run_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    sequence: Mapped[int] = mapped_column(Integer)
    kind: Mapped[str] = mapped_column(String(24))
    agent: Mapped[str] = mapped_column(String(24), default="system")
    tool: Mapped[str | None] = mapped_column(String(64))
    status: Mapped[str] = mapped_column(String(24))
    summary: Mapped[str] = mapped_column(Text)
    details: Mapped[dict] = mapped_column(JSONB, default=dict)


class AgentDecision(Owned, Base):
    __tablename__ = "agent_decisions"
    __table_args__ = (run_fk(), UniqueConstraint("user_id", "request_id"))
    run_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    payload_hash: Mapped[str] = mapped_column(String(64))
    decision: Mapped[str] = mapped_column(String(12))
    selected_ids: Mapped[list[UUID]] = mapped_column(ARRAY(PGUUID(as_uuid=True)))
    outcome: Mapped[str] = mapped_column(String(24))


class AgentUsage(Owned, Base):
    __tablename__ = "agent_usage"
    __table_args__ = (UniqueConstraint("user_id", "request_id"),)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))


class AgentJob(Owned, Base):
    __tablename__ = "agent_jobs"
    __table_args__ = (
        run_fk(),
        UniqueConstraint("user_id", "run_id"),
        CheckConstraint("status IN ('pending','leased','done')"),
    )
    run_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), index=True)
    status: Mapped[str] = mapped_column(String(12), default="pending", index=True)
    lease_until: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    attempts: Mapped[int] = mapped_column(Integer, default=0)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class AgentWorker(Base):
    __tablename__ = "agent_workers"
    id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), primary_key=True)
    last_seen: Mapped[datetime] = mapped_column(DateTime(timezone=True), index=True)


class KnowledgeSource(Owned, Base):
    __tablename__ = "knowledge_sources"
    __table_args__ = (UniqueConstraint("user_id", "id"),)
    title: Mapped[str] = mapped_column(String(120))
    content: Mapped[str] = mapped_column(Text)
    allow_ai: Mapped[bool] = mapped_column(Boolean, default=False)
    expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), default=uuid4)


class RetrievalChunk(Owned, Base):
    __tablename__ = "retrieval_chunks"
    __table_args__ = (
        ForeignKeyConstraint(
            ["user_id", "memory_id"], ["memories.user_id", "memories.id"], ondelete="CASCADE"
        ),
        ForeignKeyConstraint(
            ["user_id", "source_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
        UniqueConstraint("user_id", "memory_id", "ordinal"),
        UniqueConstraint("user_id", "source_id", "ordinal"),
        CheckConstraint("(memory_id IS NOT NULL) <> (source_id IS NOT NULL)"),
    )
    memory_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True), index=True)
    source_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True), index=True)
    source_revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    ordinal: Mapped[int] = mapped_column(Integer)
    content: Mapped[str] = mapped_column(Text)
    embedding: Mapped[list[float] | None] = mapped_column(ARRAY(Float))
    embedding_model: Mapped[str | None] = mapped_column(String(120))
    indexed_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
