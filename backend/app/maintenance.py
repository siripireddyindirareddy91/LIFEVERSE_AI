"""Run daily as a trusted release/maintenance job using migration credentials."""

from sqlalchemy import create_engine, text
from app.config import get_settings


def main():
    engine = create_engine(get_settings().database_url)
    with engine.begin() as connection:
        authorized = connection.execute(
            text("SELECT rolsuper OR rolbypassrls FROM pg_roles WHERE rolname = current_user")
        ).scalar()
        if not authorized:
            raise RuntimeError(
                "Retention maintenance requires a dedicated operations role with BYPASSRLS"
            )
        # Requires an operations role authorized to enforce cross-user retention.
        connection.execute(text("DELETE FROM conversations WHERE expires_at <= now()"))
        connection.execute(text("DELETE FROM memories WHERE expires_at <= now()"))
        connection.execute(text("DELETE FROM vault_files WHERE expires_at <= now()"))
        connection.execute(text("DELETE FROM workflow_runs WHERE expires_at <= now()"))
        connection.execute(text("DELETE FROM inbox_notifications WHERE expires_at <= now()"))
        connection.execute(
            text("DELETE FROM calendar_operations WHERE created_at < now() - interval '30 days'")
        )
        connection.execute(
            text("DELETE FROM calendar_mirrors WHERE ends_at < now() - interval '30 days'")
        )
        connection.execute(
            text("DELETE FROM oauth_lookups WHERE expires_at < now() - interval '1 day'")
        )
        connection.execute(
            text("DELETE FROM oauth_states WHERE expires_at < now() - interval '1 day'")
        )
        connection.execute(
            text("DELETE FROM workflow_usage WHERE created_at < now() - interval '2 days'")
        )
        connection.execute(
            text("DELETE FROM automation_signals WHERE created_at < now() - interval '30 days'")
        )
        connection.execute(
            text(
                "DELETE FROM automation_jobs WHERE status = 'done' AND created_at < now() - interval '30 days'"
            )
        )
        connection.execute(
            text("DELETE FROM automation_workers WHERE last_seen < now() - interval '1 day'")
        )
        connection.execute(text("DELETE FROM knowledge_sources WHERE expires_at <= now()"))
        # Cascades remove proposals, queue entries, decisions, sources and steps.
        connection.execute(text("DELETE FROM agent_runs WHERE expires_at <= now()"))
        connection.execute(
            text("DELETE FROM agent_usage WHERE created_at < now() - interval '2 days'")
        )
        connection.execute(
            text("DELETE FROM agent_workers WHERE last_seen < now() - interval '1 day'")
        )
        connection.execute(
            text("DELETE FROM ai_usage WHERE created_at < now() - interval '2 days'")
        )
    engine.dispose()


if __name__ == "__main__":
    main()
