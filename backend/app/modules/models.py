from uuid import UUID, uuid4
from datetime import datetime
from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKeyConstraint,
    Integer,
    LargeBinary,
    String,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import JSONB, UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column
from app.life.models import Owned
from app.models import Base


class ModuleRecord(Owned, Base):
    __tablename__ = "module_records"
    __table_args__ = (
        UniqueConstraint("user_id", "id"),
        UniqueConstraint("user_id", "request_id"),
        ForeignKeyConstraint(
            ["user_id", "parent_id"],
            ["module_records.user_id", "module_records.id"],
            ondelete="CASCADE",
        ),
    )
    kind: Mapped[str] = mapped_column(String(24), index=True)
    title: Mapped[str] = mapped_column(String(120))
    data: Mapped[dict] = mapped_column(JSONB)
    parent_id: Mapped[UUID | None] = mapped_column(PGUUID(as_uuid=True), index=True)
    allow_ai: Mapped[bool] = mapped_column(Boolean, default=False)
    revision: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True), default=uuid4)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    input_hash: Mapped[str] = mapped_column(String(64))
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class ModuleOperation(Owned, Base):
    __tablename__ = "module_operations"
    __table_args__ = (UniqueConstraint("user_id", "request_id"),)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    input_hash: Mapped[str] = mapped_column(String(64))
    task_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))


class VaultFile(Owned, Base):
    __tablename__ = "vault_files"
    __table_args__ = (UniqueConstraint("user_id", "request_id"),)
    request_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    title: Mapped[str] = mapped_column(String(120))
    category: Mapped[str] = mapped_column(String(40))
    filename: Mapped[str] = mapped_column(String(180))
    mime: Mapped[str] = mapped_column(String(80))
    size: Mapped[int] = mapped_column(Integer)
    sha256: Mapped[str] = mapped_column(String(64))
    key_id: Mapped[str] = mapped_column(String(40))
    ciphertext: Mapped[bytes] = mapped_column(LargeBinary, deferred=True)
    allow_ai: Mapped[bool] = mapped_column(Boolean, default=False)
    expires_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), index=True)

    @property
    def revision(self):
        from app.agentic.common import digest

        return digest(
            [self.title, self.category, self.filename, self.sha256, self.allow_ai, self.expires_at]
        )


class KnowledgeLink(Owned, Base):
    __tablename__ = "knowledge_links"
    __table_args__ = (
        UniqueConstraint("user_id", "source_id", "target_id"),
        ForeignKeyConstraint(
            ["user_id", "source_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
        ForeignKeyConstraint(
            ["user_id", "target_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
    )
    source_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    target_id: Mapped[UUID] = mapped_column(PGUUID(as_uuid=True))
    label: Mapped[str] = mapped_column(String(80))
