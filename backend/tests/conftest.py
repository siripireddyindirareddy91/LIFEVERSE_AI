"""CI must exercise the database integration suite, not silently skip it."""

import os
import pytest


def pytest_sessionstart(session):
    if os.getenv("CI", "").lower() == "true" and not os.getenv("TEST_DATABASE_URL"):
        raise pytest.UsageError("CI requires a disposable TEST_DATABASE_URL for integration tests")
