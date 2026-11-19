"""Advanced modules, encrypted vault and knowledge links."""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql as pg

revision = "0004"
down_revision = "0003"
branch_labels = depends_on = None


def owned():
    return [
        sa.Column("id", pg.UUID(as_uuid=True), primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
    ]


def upgrade():
    op.create_table(
        "module_records",
        *owned(),
        sa.Column("kind", sa.String(24), nullable=False),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("data", pg.JSONB, nullable=False),
        sa.Column("parent_id", pg.UUID(as_uuid=True)),
        sa.Column("allow_ai", sa.Boolean(), nullable=False),
        sa.Column("revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("input_hash", sa.String(64), nullable=False),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.UniqueConstraint("user_id", "id"),
        sa.UniqueConstraint("user_id", "request_id"),
        sa.ForeignKeyConstraint(
            ["user_id", "parent_id"],
            ["module_records.user_id", "module_records.id"],
            ondelete="CASCADE",
        ),
        sa.CheckConstraint(
            "kind IN ('entry','budget','saving','bill','course','study_note','flashcard','quiz','application','resume','wellness_log','routine','trip','itinerary','packing','scenario')"
        ),
    )
    op.create_table(
        "module_operations",
        *owned(),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("input_hash", sa.String(64), nullable=False),
        sa.Column("task_id", pg.UUID(as_uuid=True), nullable=False),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_table(
        "vault_files",
        *owned(),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("category", sa.String(40), nullable=False),
        sa.Column("filename", sa.String(180), nullable=False),
        sa.Column("mime", sa.String(80), nullable=False),
        sa.Column("size", sa.Integer(), nullable=False),
        sa.Column("sha256", sa.String(64), nullable=False),
        sa.Column("key_id", sa.String(40), nullable=False),
        sa.Column("ciphertext", sa.LargeBinary(), nullable=False),
        sa.Column("allow_ai", sa.Boolean(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True)),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_table(
        "knowledge_links",
        *owned(),
        sa.Column("source_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("target_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("label", sa.String(80), nullable=False),
        sa.UniqueConstraint("user_id", "source_id", "target_id"),
        sa.CheckConstraint("source_id <> target_id"),
        sa.ForeignKeyConstraint(
            ["user_id", "source_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["user_id", "target_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
    )
    for table in ["module_records", "module_operations", "vault_files", "knowledge_links"]:
        op.create_index(f"ix_{table}_user_id", table, ["user_id"])
        op.execute(f"ALTER TABLE {table} ENABLE ROW LEVEL SECURITY")
        op.execute(f"ALTER TABLE {table} FORCE ROW LEVEL SECURITY")
        op.execute(f"""CREATE POLICY {table}_owner ON {table}
            USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)
            WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)""")
    op.create_index("ix_module_records_kind", "module_records", ["kind"])
    op.create_index("ix_module_records_parent_id", "module_records", ["parent_id"])
    op.create_index("ix_vault_files_expires_at", "vault_files", ["expires_at"])


def downgrade():
    for table in ["knowledge_links", "vault_files", "module_operations", "module_records"]:
        op.drop_table(table)
