"""Run against a migrated disposable PostgreSQL database; never production."""

import os
from uuid import UUID, uuid4

import pytest
from sqlalchemy import create_engine, text
from sqlalchemy.exc import DBAPIError


@pytest.mark.skipif(
    not os.getenv("TEST_DATABASE_URL"), reason="Disposable PostgreSQL not configured"
)
def test_rls_isolation_and_pool_reset():
    engine = create_engine(os.environ["TEST_DATABASE_URL"], pool_size=1, max_overflow=0)
    first, second = str(uuid4()), str(uuid4())
    with engine.connect() as connection:
        transaction = connection.begin()
        role = connection.execute(
            text("SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user")
        ).one()
        assert role == (False, False)
        connection.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": first})
        connection.execute(text("INSERT INTO profiles(user_id) VALUES (:id)"), {"id": first})
        assert connection.execute(text("SELECT user_id FROM profiles")).scalars().all() == [
            UUID(first)
        ]
        connection.execute(text("SELECT set_config('app.user_id', :id, true)"), {"id": second})
        assert connection.execute(text("SELECT user_id FROM profiles")).all() == []
        assert connection.execute(text("UPDATE profiles SET display_name = 'other'")).rowcount == 0
        assert connection.execute(text("DELETE FROM profiles")).rowcount == 0
        with pytest.raises(DBAPIError), connection.begin_nested():
            connection.execute(text("INSERT INTO profiles(user_id) VALUES (:id)"), {"id": first})
        transaction.rollback()
    with engine.connect() as connection:
        assert (
            connection.execute(
                text("SELECT NULLIF(current_setting('app.user_id', true), '')")
            ).scalar()
            is None
        )
    engine.dispose()


@pytest.mark.skipif(
    not os.getenv("TEST_DATABASE_URL"), reason="Disposable PostgreSQL not configured"
)
def test_all_owner_tables_force_rls_and_deny_unscoped_reads():
    engine = create_engine(os.environ["TEST_DATABASE_URL"])
    with engine.begin() as db:
        tables = db.execute(
            text("""
            SELECT c.relname, c.relrowsecurity, c.relforcerowsecurity
            FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
            JOIN pg_attribute a ON a.attrelid=c.oid
            WHERE n.nspname='public' AND c.relkind='r' AND a.attname='user_id'
            AND NOT a.attisdropped
        """)
        ).all()
        assert len(tables) >= 30
        for name, enabled, forced in tables:
            assert enabled and forced, name
            assert db.execute(text(f'SELECT count(*) FROM "{name}"')).scalar() == 0, name
        role = db.execute(
            text(
                "SELECT rolsuper,rolbypassrls,rolcreaterole,rolcreatedb FROM pg_roles WHERE rolname=current_user"
            )
        ).one()
        assert role == (False, False, False, False)
        assert not db.execute(
            text("SELECT pg_has_role(current_user, 'lifeverse', 'MEMBER')")
        ).scalar()
    engine.dispose()
