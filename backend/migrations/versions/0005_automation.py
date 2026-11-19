"""Workflow queues, notifications and encrypted calendar integrations."""

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql as pg

revision = "0005"
down_revision = "0004"
branch_labels = depends_on = None


def upgrade():
    op.add_column(
        "agent_runs", sa.Column("origin", sa.String(16), nullable=False, server_default="ai")
    )
    op.create_table(
        "workflow_usage",
        sa.Column("id", pg.UUID(as_uuid=True), primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_index("ix_workflow_usage_user_id", "workflow_usage", ["user_id"])
    op.execute("ALTER TABLE workflow_usage ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE workflow_usage FORCE ROW LEVEL SECURITY")
    op.execute(
        "CREATE POLICY workflow_usage_owner ON workflow_usage USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"
    )
    op.create_table(
        "automation_jobs",
        sa.Column("kind", sa.String(20), nullable=False),
        sa.Column("subject_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("status", sa.String(12), nullable=False),
        sa.Column("due_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("lease_until", sa.DateTime(timezone=True), nullable=True),
        sa.Column("attempts", sa.Integer(), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("user_id", "kind", "subject_id"),
    )
    op.create_index("ix_automation_jobs_due_at", "automation_jobs", ["due_at"])
    op.create_index("ix_automation_jobs_user_id", "automation_jobs", ["user_id"])
    op.execute("ALTER TABLE automation_jobs ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE automation_jobs FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY automation_jobs_owner ON automation_jobs USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "automation_signals",
        sa.Column("topic", sa.String(32), nullable=False),
        sa.Column("record_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("record_kind", sa.String(24), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    )
    op.create_index("ix_automation_signals_user_id", "automation_signals", ["user_id"])
    op.execute("ALTER TABLE automation_signals ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE automation_signals FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY automation_signals_owner ON automation_signals USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "automation_workers",
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("last_seen", sa.DateTime(timezone=True), nullable=False),
    )
    op.create_index("ix_automation_workers_last_seen", "automation_workers", ["last_seen"])
    op.create_table(
        "calendar_connections",
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("provider", sa.String(16), nullable=False),
        sa.Column("writable", sa.Boolean(), nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False),
        sa.Column("revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("token_cipher", sa.LargeBinary(), nullable=False),
        sa.Column("key_id", sa.String(40), nullable=False),
        sa.Column("last_sync_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("error", sa.String(500), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("user_id", "id"),
    )
    op.create_index("ix_calendar_connections_user_id", "calendar_connections", ["user_id"])
    op.execute("ALTER TABLE calendar_connections ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE calendar_connections FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY calendar_connections_owner ON calendar_connections USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "inbox_notifications",
        sa.Column("source_key", sa.String(160), nullable=False),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("route", sa.String(120), nullable=False),
        sa.Column("due_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("read_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("cancelled", sa.Boolean(), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("user_id", "source_key"),
    )
    op.create_index("ix_inbox_notifications_due_at", "inbox_notifications", ["due_at"])
    op.create_index("ix_inbox_notifications_expires_at", "inbox_notifications", ["expires_at"])
    op.create_index("ix_inbox_notifications_user_id", "inbox_notifications", ["user_id"])
    op.execute("ALTER TABLE inbox_notifications ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE inbox_notifications FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY inbox_notifications_owner ON inbox_notifications USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "oauth_lookups",
        sa.Column("state_hash", sa.String(64), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("state_hash"),
    )
    op.create_index("ix_oauth_lookups_user_id", "oauth_lookups", ["user_id"])
    op.execute("ALTER TABLE oauth_lookups ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE oauth_lookups FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY oauth_lookups_owner ON oauth_lookups USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "oauth_states",
        sa.Column("provider", sa.String(16), nullable=False),
        sa.Column("writable", sa.Boolean(), nullable=False),
        sa.Column("verifier_cipher", sa.LargeBinary(), nullable=False),
        sa.Column("key_id", sa.String(40), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("consumed", sa.Boolean(), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
    )
    op.create_index("ix_oauth_states_user_id", "oauth_states", ["user_id"])
    op.execute("ALTER TABLE oauth_states ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE oauth_states FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY oauth_states_owner ON oauth_states USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "workflows",
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("definition", pg.JSONB(), nullable=False),
        sa.Column("revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("input_hash", sa.String(64), nullable=False),
        sa.Column("enabled", sa.Boolean(), nullable=False),
        sa.Column("activated_at", sa.DateTime(timezone=True)),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.UniqueConstraint("user_id", "id"),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_index("ix_workflows_user_id", "workflows", ["user_id"])
    op.execute("ALTER TABLE workflows ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE workflows FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY workflows_owner ON workflows USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "calendar_mirrors",
        sa.Column("connection_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("remote_id", sa.String(512), nullable=False),
        sa.Column("title", sa.String(120), nullable=False),
        sa.Column("starts_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("ends_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("all_day", sa.Boolean(), nullable=False),
        sa.Column("local_event_id", pg.UUID(as_uuid=True), nullable=True),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.ForeignKeyConstraint(
            ["user_id", "connection_id"],
            ["calendar_connections.user_id", "calendar_connections.id"],
            ondelete="CASCADE",
        ),
        sa.UniqueConstraint("user_id", "connection_id", "remote_id"),
    )
    op.create_index("ix_calendar_mirrors_user_id", "calendar_mirrors", ["user_id"])
    op.execute("ALTER TABLE calendar_mirrors ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE calendar_mirrors FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY calendar_mirrors_owner ON calendar_mirrors USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "calendar_operations",
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("connection_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("connection_revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("local_event_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("payload", pg.JSONB(), nullable=False),
        sa.Column("digest", sa.String(64), nullable=False),
        sa.Column("nonce", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("status", sa.String(24), nullable=False),
        sa.Column("remote_id", sa.String(512), nullable=True),
        sa.Column("error", sa.String(500), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.ForeignKeyConstraint(
            ["user_id", "connection_id"],
            ["calendar_connections.user_id", "calendar_connections.id"],
            ondelete="CASCADE",
        ),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_index("ix_calendar_operations_user_id", "calendar_operations", ["user_id"])
    op.execute("ALTER TABLE calendar_operations ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE calendar_operations FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY calendar_operations_owner ON calendar_operations USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.create_table(
        "workflow_runs",
        sa.Column("workflow_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("request_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("revision", pg.UUID(as_uuid=True), nullable=False),
        sa.Column("definition", pg.JSONB(), nullable=False),
        sa.Column("status", sa.String(24), nullable=False),
        sa.Column("cursor", sa.Integer(), nullable=False),
        sa.Column("steps", pg.JSONB(), nullable=False),
        sa.Column("context", pg.JSONB(), nullable=False),
        sa.Column("summary", sa.Text(), nullable=False),
        sa.Column("error", sa.String(500), nullable=False),
        sa.Column("attempts", sa.Integer(), nullable=False),
        sa.Column("agent_run_id", pg.UUID(as_uuid=True), nullable=True),
        sa.Column("proposal_run_id", pg.UUID(as_uuid=True), nullable=True),
        sa.Column("started_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("finished_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", pg.UUID(as_uuid=True), nullable=False, primary_key=True),
        sa.Column("user_id", pg.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()
        ),
        sa.ForeignKeyConstraint(
            ["user_id", "workflow_id"], ["workflows.user_id", "workflows.id"], ondelete="CASCADE"
        ),
        sa.UniqueConstraint("user_id", "id"),
        sa.UniqueConstraint("user_id", "request_id"),
    )
    op.create_index("ix_workflow_runs_expires_at", "workflow_runs", ["expires_at"])
    op.create_index("ix_workflow_runs_user_id", "workflow_runs", ["user_id"])
    op.create_index("ix_workflow_runs_workflow_id", "workflow_runs", ["workflow_id"])
    op.execute("ALTER TABLE workflow_runs ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE workflow_runs FORCE ROW LEVEL SECURITY")
    op.execute(
        """CREATE POLICY workflow_runs_owner ON workflow_runs USING (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid) WITH CHECK (user_id = NULLIF(current_setting('app.user_id', true), '')::uuid)"""
    )
    op.execute(
        "CREATE POLICY jobs_dispatch ON automation_jobs TO lifeverse_dispatcher USING (true) WITH CHECK (true)"
    )
    op.execute("GRANT SELECT ON automation_jobs TO lifeverse_dispatcher")
    op.execute(
        "GRANT UPDATE(status,due_at,lease_until,attempts) ON automation_jobs TO lifeverse_dispatcher"
    )
    op.execute(
        "CREATE POLICY oauth_lookup_dispatch ON oauth_lookups FOR SELECT TO lifeverse_dispatcher USING (true)"
    )
    op.execute("GRANT SELECT ON oauth_lookups TO lifeverse_dispatcher")
    op.execute("ALTER TABLE automation_workers ENABLE ROW LEVEL SECURITY")
    op.execute("ALTER TABLE automation_workers FORCE ROW LEVEL SECURITY")
    op.execute("REVOKE ALL ON automation_workers FROM lifeverse_app")
    op.execute("GRANT SELECT ON automation_workers TO lifeverse_app")
    op.execute(
        "CREATE POLICY automation_workers_read ON automation_workers FOR SELECT TO lifeverse_app USING (true)"
    )
    op.execute("GRANT SELECT,INSERT,UPDATE ON automation_workers TO lifeverse_dispatcher")
    op.execute(
        "CREATE POLICY automation_workers_dispatch ON automation_workers TO lifeverse_dispatcher USING (true) WITH CHECK (true)"
    )


def downgrade():
    op.drop_table("workflow_runs")
    op.drop_table("calendar_operations")
    op.drop_table("calendar_mirrors")
    op.drop_table("workflows")
    op.drop_table("oauth_states")
    op.drop_table("oauth_lookups")
    op.drop_table("inbox_notifications")
    op.drop_table("calendar_connections")
    op.drop_table("automation_workers")
    op.drop_table("automation_signals")
    op.drop_table("automation_jobs")

    op.drop_table("workflow_usage")
    op.drop_column("agent_runs", "origin")
