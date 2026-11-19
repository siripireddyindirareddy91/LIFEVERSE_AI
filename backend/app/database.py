from functools import lru_cache

from fastapi import Depends
from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session

from app.auth import Identity, current_identity
from app.config import get_settings


@lru_cache
def engine():
    return create_engine(
        get_settings().runtime_database_url,
        pool_pre_ping=True,
        connect_args={"connect_timeout": 5},
    )


def user_session(identity: Identity = Depends(current_identity)):
    with Session(engine()) as session, session.begin():
        # SET LOCAL equivalent: the verified subject cannot leak across pooled connections.
        session.execute(
            text("SELECT set_config('app.user_id', :user_id, true)"),
            {"user_id": str(identity.id)},
        )
        yield session
