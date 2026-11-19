# Contributing

Implement one user-authorized phase at a time. Keep scope and verification status
in `docs/PHASE_1_PLAN.md` and `docs/VERIFICATION.md`.

Python: `ruff format backend`, `ruff check backend`, `pytest backend/tests -q`.
Flutter (from `mobile/`): `dart format lib test`, `flutter analyze`, `flutter test`.
Run database tests against a disposable PostgreSQL with the runtime role.
Do not check in `.tools`, `.venv`, build output or local credentials.
