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
   Supabase when Phase 2 authentication screens are implemented.
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

## GitHub

Work is on `codex/phase-1-foundation` based on existing remote `main`.
CI runs backend/RLS tests and Flutter format/analyze/test/debug build when pushed.
No cloud deployment or GitHub push is implied by a successful local check.
