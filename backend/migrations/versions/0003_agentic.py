"""Durable agent runs, scoped dispatch, approval history and retrieval."""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql as pg

revision = "0003"
down_revision = "0002"
branch_labels = None
depends_on = None
OWNED = (
    "agent_runs",
    "agent_actions",
    "agent_steps",
    "agent_decisions",
    "agent_usage",
    "agent_jobs",
    "knowledge_sources",
    "retrieval_chunks",
)


def owned():
    return [
        sa.Column("id", pg.UUID(as_uuid=True), primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    ]


def json_col(name, array=False):
    return sa.Column(
        name,
        pg.JSONB(),
        nullable=False,
        server_default=sa.text("'[]'::jsonb" if array else "'{}'::jsonb"),
    )


def run_fk():
    return sa.ForeignKeyConstraint(
        ["user_id", "run_id"], ["agent_runs.user_id", "agent_runs.id"], ondelete="CASCADE"
    )


def upgrade():
    op.drop_constraint("consent_events_kind_check", "consent_events", type_="check")
    op.create_check_constraint(
        "consent_events_kind_check", "consent_events", "kind IN ('ai', 'memory', 'knowledge')"
    )
    op.add_column(
        "profiles",
        sa.Column("knowledge_consent", sa.Boolean(), nullable=False, server_default=sa.false()),
    )
    op.add_column(
        "memories",
        sa.Column(
            "revision",
            pg.UUID(as_uuid=True),
            nullable=False,
            server_default=sa.text("gen_random_uuid()"),
        ),
    )
    op.create_unique_constraint("uq_memories_user_id_id", "memories", ["user_id", "id"])
    op.create_table(
        "agent_runs",
        *owned(),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("input_hash", sa.String(64), nullable=False),
        sa.Column("prompt", sa.Text(), nullable=False),
        sa.Column("scopes", pg.ARRAY(sa.String(20)), nullable=False),
        sa.Column("allow_proposals", sa.Boolean(), nullable=False),
        sa.Column("status", sa.String(24), nullable=False),
        sa.Column("summary", sa.Text(), nullable=False),
        sa.Column("error", sa.Text(), nullable=False),
        sa.Column("plan", sa.Text(), nullable=False),
        json_col("agents", True),
        json_col("sources", True),
        sa.Column("model_calls", sa.Integer(), nullable=False),
        sa.Column("tool_calls", sa.Integer(), nullable=False),
        sa.Column("event_seq", sa.Integer(), nullable=False),
        sa.Column("approval_digest", sa.String(64)),
        sa.Column("review_nonce", pg.UUID(as_uuid=True)),
        sa.Column("review_expires_at", sa.DateTime(timezone=True)),
        sa.Column("started_at", sa.DateTime(timezone=True)),
        sa.Column("finished_at", sa.DateTime(timezone=True)),
        sa.Column("deadline_at", sa.DateTime(timezone=True)),
        sa.Column("queue_expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.UniqueConstraint("user_id", "id"),
        sa.UniqueConstraint("user_id", "request_id"),
        sa.CheckConstraint(
            "status IN ('queued','running','awaiting_approval','completed','failed','rejected','cancelled','expired','stale')"
        ),
    )
    op.create_table(
        "agent_actions",
        *owned(),
        sa.Column("run_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("position", sa.Integer(), nullable=False),
        sa.Column("agent", sa.String(24), nullable=False),
        sa.Column("tool", sa.String(64), nullable=False),
        sa.Column("label", sa.String(200), nullable=False),
        sa.Column("arguments", pg.JSONB(), nullable=False),
        sa.Column("before", pg.JSONB()),
        sa.Column("expected_hash", sa.String(64)),
        sa.Column("record_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("dependencies", pg.ARRAY(pg.UUID(as_uuid=True)), nullable=False),
        sa.Column("status", sa.String(16), nullable=False),
        sa.Column("result", pg.JSONB()),
        run_fk(),
        sa.UniqueConstraint("user_id", "run_id", "position"),
        sa.CheckConstraint("status IN ('pending','applied','rejected','blocked')"),
    )
    op.create_table(
        "agent_steps",
        *owned(),
        sa.Column("run_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("sequence", sa.Integer(), nullable=False),
        sa.Column("kind", sa.String(24), nullable=False),
        sa.Column("agent", sa.String(24), nullable=False),
        sa.Column("tool", sa.String(64)),
        sa.Column("status", sa.String(24), nullable=False),
        sa.Column("summary", sa.Text(), nullable=False),
        json_col("details"),
        run_fk(),
        sa.UniqueConstraint("user_id", "run_id", "sequence"),
    )
    op.create_table(
        "agent_decisions",
        *owned(),
        sa.Column("run_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("payload_hash", sa.String(64), nullable=False),
        sa.Column("decision", sa.String(12), nullable=False),
        sa.Column("selected_ids", pg.ARRAY(pg.UUID(as_uuid=True)), nullable=False),
        sa.Column("outcome", sa.String(24), nullable=False),
        run_fk(),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_table(
        "agent_usage",
        *owned(),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_table(
        "agent_jobs",
        *owned(),
        sa.Column("run_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("status", sa.String(12), nullable=False),
        sa.Column("lease_until", sa.DateTime(timezone=True)),
        sa.Column("attempts", sa.Integer(), nullable=False),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        run_fk(),
        sa.UniqueConstraint("user_id", "run_id"),
        sa.CheckConstraint("status IN ('pending','leased','done')"),
    )
    op.create_table(
        "agent_workers",
        sa.Column("id", pg.UUID(as_uuid=True), primary_key=True),
        sa.Column("last_seen", sa.DateTime(timezone=True), nullable=False),
    )
    op.create_table(
        "knowledge_sources",
        *owned(),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("allow_ai", sa.Boolean(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True)),
        sa.Column("revision", pg.UUID(as_uuid=True), nullable=False),
        sa.UniqueConstraint("user_id", "id"),
    )
    op.create_table(
        "retrieval_chunks",
        *owned(),
        sa.Column("memory_id", pg.UUID(as_uuid=True)),
        sa.Column("source_id", pg.UUID(as_uuid=True)),
        sa.Column("source_revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("ordinal", sa.Integer(), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("embedding", pg.ARRAY(sa.Float())),
        sa.Column("embedding_model", sa.String(120)),
        sa.Column("indexed_at", sa.DateTime(timezone=True)),
        sa.ForeignKeyConstraint(
            ["user_id", "memory_id"], ["memories.user_id", "memories.id"], ondelete="CASCADE"
        ),
        sa.ForeignKeyConstraint(
            ["user_id", "source_id"],
            ["knowledge_sources.user_id", "knowledge_sources.id"],
            ondelete="CASCADE",
        ),
        sa.UniqueConstraint("user_id", "memory_id", "ordinal"),
        sa.UniqueConstraint("user_id", "source_id", "ordinal"),
        sa.CheckConstraint("(memory_id IS NOT NULL) <> (source_id IS NOT NULL)"),
    )
    for table in OWNED:
        op.create_index(f"ix_{table}_user_id", table, ["user_id"])
        op.execute(f"ALTER TABLE {table} ENABLE ROW LEVEL SECURITY")
        op.execute(f"ALTER TABLE {table} FORCE ROW LEVEL SECURITY")
        op.execute(f"""CREATE POLICY {table}_owner ON {table}
          USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)
          WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)""")
    for table, cols in {
        "agent_runs": ["status", "expires_at"],
        "agent_actions": ["run_id"],
        "agent_steps": ["run_id"],
        "agent_decisions": ["run_id"],
        "agent_jobs": ["run_id", "status"],
        "retrieval_chunks": ["memory_id", "source_id"],
        "agent_workers": ["last_seen"],
    }.items():
        for column in cols:
            op.create_index(f"ix_{table}_{column}", table, [column])
    op.execute(
        "CREATE INDEX ix_knowledge_search ON knowledge_sources USING gin(to_tsvector('english', title || ' ' || content))"
    )
    op.execute(
        "CREATE INDEX ix_chunks_search ON retrieval_chunks USING gin(to_tsvector('english', content))"
    )
    op.execute("""CREATE FUNCTION lifeverse_cosine(a double precision[], b double precision[])
        RETURNS double precision LANGUAGE SQL IMMUTABLE STRICT AS $$
        SELECT CASE WHEN cardinality(a) = cardinality(b) THEN
          sum(x*y) / NULLIF(sqrt(sum(x*x))*sqrt(sum(y*y)), 0) ELSE NULL END
        FROM unnest(a,b) AS pair(x,y) $$""")
    op.execute(
        "CREATE POLICY agent_jobs_dispatch ON agent_jobs TO lifeverse_dispatcher USING (true) WITH CHECK (true)"
    )
    op.execute("GRANT SELECT ON agent_jobs TO lifeverse_dispatcher")
    op.execute(
        "GRANT UPDATE(status,lease_until,attempts,updated_at) ON agent_jobs TO lifeverse_dispatcher"
    )
    op.execute("ALTER TABLE agent_workers ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE agent_workers FORCE ROW LEVEL SECURITY")
    op.execute("REVOKE ALL ON agent_workers FROM lifeverse_app")
    op.execute("GRANT SELECT ON agent_workers TO lifeverse_app")
    op.execute(
        "CREATE POLICY workers_read ON agent_workers FOR SELECT TO lifeverse_app USING (true)"
    )
    op.execute("GRANT SELECT, INSERT, UPDATE ON agent_workers TO lifeverse_dispatcher")
    op.execute(
        "CREATE POLICY workers_dispatch ON agent_workers TO lifeverse_dispatcher USING (true) WITH CHECK (true)"
    )


def downgrade():
    op.execute("DROP FUNCTION lifeverse_cosine(double precision[], double precision[])")
    op.drop_table("retrieval_chunks")
    op.drop_table("knowledge_sources")
    op.drop_table("agent_workers")
    for table in reversed(OWNED[:6]):
        op.drop_table(table)
    op.drop_constraint("uq_memories_user_id_id", "memories", type_="unique")
    op.drop_column("memories", "revision")
    op.drop_column("profiles", "knowledge_consent")
    op.execute("DELETE FROM consent_events WHERE kind = 'knowledge'")
    op.drop_constraint("consent_events_kind_check", "consent_events", type_="check")
    op.create_check_constraint(
        "consent_events_kind_check", "consent_events", "kind IN ('ai', 'memory')"
    )
