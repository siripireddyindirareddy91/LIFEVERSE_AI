# Phase 1 — project foundation

The user's current request limits implementation to this phase. The master prompt
is product reference material, not authorization to implement subsequent phases.

## Repository inspection

- Remote main: `9ce683e`, containing only `README.md`; no application to migrate.
- Local initial state: empty repository without commits or a remote.
- Python 3.12 available. Flutter/Dart/Docker not initially on PATH.
- Flutter SDK pinned to 3.38.3 (bundled Dart 3.10.1), workspace-local and ignored.

## Implementation

1. Preserve existing README intent; create `codex/phase-1-foundation` from remote main.
2. Generate Flutter Android/iOS project, feature structure, configuration and localization.
3. Provide Riverpod dependencies, GoRouter shell, Dio API client and secure Supabase session storage.
4. Establish Aurora Nebula tokens, light/dark themes, accessible reusable controls and a foundation preview.
5. Set up FastAPI, validated environment settings, health endpoints and verified Supabase JWT identity.
6. Add PostgreSQL profile migration, isolated runtime role, owner RLS and database tests.
7. Add CI, local setup and verification documentation.

## Boundary

No AI agents, conversations, automation, planner, finance, goals or other product
modules. Authentication infrastructure is included; registration/login screens,
onboarding and the animated home universe await the next authorized phase.

## External setup

A Supabase project URL and public publishable/anon key are needed to activate auth.
Use asymmetric signing keys. No service-role key belongs in the mobile app.
Docker or an installed PostgreSQL server is needed for database execution.
Android builds require Android SDK/JDK; iOS builds and signing require macOS/Xcode.
