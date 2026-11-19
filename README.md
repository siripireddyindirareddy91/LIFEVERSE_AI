# LIFEVERSE AI

**Your Life. Your Intelligence. Your Universe.**

Phase 1 foundation for an Android/iOS application built with Flutter and Dart,
FastAPI, PostgreSQL and Supabase Auth. Further phases await explicit direction.

## Included

- Flutter 3.38.3 / Dart 3.10.1 Android and iOS projects.
- Riverpod dependencies, GoRouter responsive shell and Dio service connection check.
- Aurora Nebula design tokens, light/dark/system themes and English localization.
- Secure Supabase session storage; honest setup-required state without credentials.
- FastAPI health and verified identity/profile routes.
- Alembic migration, PostgreSQL owner isolation and separate runtime database role.
- Docker development stack, environment examples, dependency locks and GitHub CI.

## Start locally

1. Copy `.env.example` to `.env`.
2. With Docker Desktop installed: `docker compose up --build`.
3. In `mobile/`, run `flutter pub get`, then `flutter run` using Flutter 3.38.3.
4. To configure services, copy `mobile/config/development.example.json` to
   `development.json`, fill in your public Supabase settings and run
   `flutter run --dart-define-from-file=config/development.json`.

The default Android emulator API URL is `http://10.0.2.2:8000`. Auth remains
unconfigured until you connect a Supabase project. Sign-in/onboarding screens
and life-management features are outside Phase 1.

See [setup and deployment](DEPLOYMENT.md), [architecture](ARCHITECTURE.md),
[database](DATABASE.md), [security](SECURITY.md), [API](API_DOCUMENTATION.md),
[scope](docs/PHASE_1_PLAN.md) and [verification](docs/VERIFICATION.md).
