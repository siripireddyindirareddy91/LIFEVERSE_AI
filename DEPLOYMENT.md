# Local setup and deployment boundary

Copy `.env.example` to `.env`. Install Docker Desktop, then run
`docker compose up --build`. The API migrates the local DB before starting.
Data lives in a named Docker volume; initialization scripts only run on first
creation. Production migrations should be a separate release job, not per replica.

Without Docker: create a Python 3.12 virtual environment, install
`pip install -r backend/requirements.lock` and `pip install --no-deps -e ./backend`
from the repository root, provision PostgreSQL 17 and its runtime
role (see DATABASE.md), and run `alembic upgrade head` from `backend/`.
Start the API there with `uvicorn app.main:app --reload`.

## Supabase setup

1. Create a Supabase project in your account and retain its project URL.
2. Enable asymmetric JWT signing keys (ES256 or RS256).
3. Put the URL in root `.env` as `SUPABASE_URL`.
4. Copy `mobile/config/development.example.json` to `development.json` and add
   the URL plus the public publishable/anon key. Configure email/provider auth in
   Supabase for email sign-in/sign-up. Configure the project's Site URL and
   confirmation email destination, then test confirmation before launch.
5. Use the local Postgres for application data or a separately provisioned hosted
   database with migration/runtime roles. Auth configuration alone does not
   create database tables or prove the service is reachable.

## Flutter

Use Flutter 3.38.3 (Dart bundled with the SDK); `.fvmrc` pins it for FVM users.
An ignored SDK may exist at `.tools/flutter` in this workspace.
On Windows, `scripts/flutter.ps1` is a wrapper for that SDK; invoke it from
`mobile/` as `..\scripts\flutter.ps1 <command>`.
From `mobile/`: `flutter pub get`, then
`flutter run --dart-define-from-file=config/development.json`.
Default setup works without credentials and explicitly reports auth setup needed.

Android emulator API URL: `http://10.0.2.2:8000`; desktop/iOS simulator:
`http://localhost:8000`. A physical device needs a reachable development machine
address and appropriate local networking. Never use cleartext outside development.

Run `flutter doctor -v`; Android debug build: `flutter build apk --debug`.
Android release signing and final application ID must be configured before release.
iOS builds/signing require macOS, Xcode, CocoaPods and an Apple signing identity.
No iOS build can be validated on this Windows workspace.

## Core life management and AI

Apply Alembic revision `0002` before using core life spaces. Sign in, save a profile
and choose an IANA time zone. Habits and dashboard totals use that profile zone;
planner pickers/display explicitly use the device zone.

Set server-only `AI_API_KEY` and `AI_MODEL` in root `.env` to activate AI. Use an
OpenAI model supporting Chat Completions and `max_completion_tokens`. Never put
the key in mobile config. The Assistant is unavailable without configuration;
other core records work without an AI provider. Providing a key is not proof of
a successful live call. Review profile consent and opt into context per message.
See AI_AGENT_DESIGN.md for limits, privacy and retention behavior.

In production, run `python -m app.maintenance` daily from a trusted operations
environment using a dedicated role with `BYPASSRLS`. Never use that role for API
requests. The command refuses ordinary runtime roles. It physically purges inactive
users' expired chats/memories and old content-free usage counters.

Generate Flutter DTOs with `dart run build_runner build` from `mobile/`.
Generated Freezed/JSON files are included; CI regenerates them before checks.

## GitHub

Phases 1 and 2 are pushed to milestone branches with successful Actions runs.
Current Phase 3 work is local on `codex/phase-3-core-life-management`.
CI runs backend/RLS tests and Flutter format/analyze/test/debug build when pushed.
No cloud deployment or GitHub push is implied by a successful local check.
