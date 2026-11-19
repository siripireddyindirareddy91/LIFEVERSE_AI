"""Core user-owned life records, consent and retained chat history."""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql as pg

revision = "0002"
down_revision = "0001"
branch_labels = None
depends_on = None

TABLES = (
    "goals",
    "tasks",
    "calendar_events",
    "habits",
    "habit_checkins",
    "memories",
    "conversations",
    "messages",
    "consent_events",
    "ai_usage",
)


def owned():
    return [
        sa.Column("id", pg.UUID(as_uuid=True), primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    ]


def named():
    return [
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("notes", sa.Text(), nullable=False),
    ]


def upgrade():
    op.add_column(
        "profiles", sa.Column("ai_consent", sa.Boolean(), nullable=False, server_default=sa.false())
    )
    op.add_column(
        "profiles",
        sa.Column("memory_consent", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    op.create_table(
        "goals",
        *owned(),
        *named(),
        sa.Column("progress", sa.Integer(), nullable=False),
        sa.Column("target_date", sa.Date()),
        sa.UniqueConstraint("user_id", "id"),
        sa.CheckConstraint("progress BETWEEN 0 AND 100"),
    )
    op.create_table(
        "tasks",
        *owned(),
        *named(),
        sa.Column("status", sa.String(8), nullable=False),
        sa.Column("priority", sa.String(8), nullable=False),
        sa.Column("due_at", sa.DateTime(timezone=True)),
        sa.Column("completed_at", sa.DateTime(timezone=True)),
        sa.Column("goal_id", pg.UUID(as_uuid=True)),
        sa.ForeignKeyConstraint(["user_id", "goal_id"], ["goals.user_id", "goals.id"]),
        sa.CheckConstraint("status IN ('todo', 'done')"),
        sa.CheckConstraint("priority IN ('low', 'normal', 'high')"),
    )
    op.create_table(
        "calendar_events",
        *owned(),
        *named(),
        sa.Column("starts_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("ends_at", sa.DateTime(timezone=True), nullable=False),
        sa.CheckConstraint("ends_at > starts_at"),
    )
    op.create_table(
        "habits",
        *owned(),
        *named(),
        sa.Column("active", sa.Boolean(), nullable=False),
        sa.UniqueConstraint("user_id", "id"),
    )
    op.create_table(
        "habit_checkins",
        *owned(),
        sa.Column("habit_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("day", sa.Date(), nullable=False),
        sa.ForeignKeyConstraint(
            ["user_id", "habit_id"], ["habits.user_id", "habits.id"], ondelete="CASCADE"
        ),
        sa.UniqueConstraint("user_id", "habit_id", "day"),
    )
    op.create_table(
        "memories",
        *owned(),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("allow_ai", sa.Boolean(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True)),
    )
    op.create_table(
        "conversations",
        *owned(),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.UniqueConstraint("user_id", "id"),
    )
    op.create_table(
        "messages",
        *owned(),
        sa.Column("conversation_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("role", sa.String(12), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("memory_count", sa.Integer(), nullable=False),
        sa.Column("plan_count", sa.Integer(), nullable=False),
        sa.Column("model", sa.String(120), nullable=False),
        sa.ForeignKeyConstraint(
            ["user_id", "conversation_id"],
            ["conversations.user_id", "conversations.id"],
            ondelete="CASCADE",
        ),
        sa.UniqueConstraint("user_id", "request_id", "role"),
        sa.CheckConstraint("role IN ('user', 'assistant')"),
    )
    op.create_table(
        "consent_events",
        *owned(),
        sa.Column("kind", sa.String(12), nullable=False),
        sa.Column("allowed", sa.Boolean(), nullable=False),
        sa.CheckConstraint("kind IN ('ai', 'memory')"),
    )
    op.create_table(
        "ai_usage", *owned(), sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False)
    )
    for table in TABLES:
        op.create_index(f"ix_{table}_user_id", table, ["user_id"])
        op.execute(f"ALTER TABLE {table} ENABLE ROW LEVEL SECURITY")
        op.execute(f"ALTER TABLE {table} FORCE ROW LEVEL SECURITY")
        op.execute(f"""CREATE POLICY {table}_owner ON {table}
          USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)
          WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)""")
    for table, columns in {
        "tasks": ["due_at", "completed_at", "goal_id"],
        "calendar_events": ["starts_at"],
        "habit_checkins": ["day"],
        "memories": ["expires_at"],
        "conversations": ["expires_at"],
        "messages": ["conversation_id"],
    }.items():
        for column in columns:
            op.create_index(f"ix_{table}_{column}", table, [column])
    op.execute(
        "CREATE INDEX ix_memories_search ON memories USING gin(to_tsvector('english', title || ' ' || content))"
    )


def downgrade():
    for table in reversed(TABLES):
        op.drop_table(table)
    op.drop_column("profiles", "memory_consent")
    op.drop_column("profiles", "ai_consent")
