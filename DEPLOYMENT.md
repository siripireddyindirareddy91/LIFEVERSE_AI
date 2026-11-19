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
Phase 3 is pushed at `100a7a1` on `codex/phase-3-core-life-management` with both Actions jobs green. Phase 4 is pushed at `716233f` with both Actions jobs green. Phase 5 is local on `codex/phase-5-advanced-modules`.
CI runs backend/RLS tests and Flutter format/analyze/test/debug build when pushed.
No cloud deployment or GitHub push is implied by a successful local check.


## Phase 4 worker and retrieval

Before revision `0003`, provision the dispatcher role with `infrastructure/init-db.sql`
using migration credentials. For an existing Docker volume, run:

```sh
docker compose exec db psql -U lifeverse -d lifeverse -v ON_ERROR_STOP=1 -f /docker-entrypoint-initdb.d/01-roles.sql
docker compose up --build
```

The API applies migrations before its liveness health check releases the worker.
Outside Compose, run `alembic upgrade head` then `python -m app.agentic.worker`
from `backend/`, alongside the API. Configure `RUNTIME_DATABASE_URL` with the
restricted application role and `DISPATCH_DATABASE_URL` with the queue-only
`lifeverse_dispatcher` role. The worker rejects dispatch credentials that are
superuser, bypass RLS, or can select profiles. Production must rotate the example
passwords and provision roles/default grants using its actual migration owner.
Do not give the worker migration or operations credentials.

Set `AI_MODEL` to an OpenAI Chat Completions model supporting strict structured
outputs and function calling, and `AI_API_KEY` server-side. `AI_EMBEDDING_MODEL`
is optional; choose a compatible embeddings model and set its supported dimension
count through `AI_EMBEDDING_DIMENSIONS` (default 1536). Without it, shared sources
are retrieved by keyword. Enabling it does not index existing data automatically:
choose Index on each shared source after profile consent. Model/dimension changes
require re-indexing sources. No AI credentials are included in the Flutter app.

Start at Agent center, grant AI permission in Profile, choose per-run read scopes,
and optionally enable Prepare changes. Queued work survives API requests and
worker restarts. Monitor heartbeat age, queue depth, failed runs and provider costs;
the UI reports an offline worker. Defaults: 10 runs/day, 10 model calls, 12 tool
calls, 8 proposals, 240 seconds/run, 60-minute approvals, 30-day history. Configure
these bounded settings in `.env.example`. Budgets are application controls; also
set provider account spending limits. A maximum of three claimed attempts may
recover a run; cumulative model/tool budgets are retained.

Run the trusted daily retention command for expired knowledge, memory, chat and
agent history and old content-free counters. Deleting a source clears its index;
older chat/run excerpts are separate history and can be deleted by their owner.
Live provider calls and Supabase account flows require actual configuration and
have not been validated with credentials in this workspace.


## Phase 5 advanced modules and encrypted vault

Apply `alembic upgrade head` (revision `0004`). Manual records/reports, quizzes,
resume review, graph links, planner links and scenario calculations need no AI
provider. Advanced specialists use the existing worker/provider configuration and
explicit record sharing. Each proposed record still requires preview approval.

Vault upload/download requires a server-only 32-byte AES key, base64-encoded, in
`VAULT_ENCRYPTION_KEYS`, and its ID in `VAULT_ACTIVE_KEY_ID`. For example, generate
one locally with Python's `base64.b64encode(os.urandom(32)).decode()` and set:

```dotenv
VAULT_ENCRYPTION_KEYS={"v1":"YOUR_BASE64_32_BYTE_SECRET"}
VAULT_ACTIVE_KEY_ID=v1
```

Keep keys outside Git/mobile config. Back up keys separately and restrict their
access. To rotate, add a new key ID and make it active while retaining previous
IDs for existing files. Removing a key makes files encrypted under it unreadable;
there is no automatic re-encryption job in this phase. Missing/invalid keys show
setup-required states, never plaintext storage. This is server-side encryption,
not end-to-end encryption or a production security certification.

PostgreSQL holds ciphertext with a 5 MiB/file and 100 MiB/user limit, suitable for
the current bounded vault. Plan encrypted backups, restore testing, storage quotas,
TLS/ingress rate limits and malware scanning before production expansion. Downloads
are explicit user saves, never executed or auto-opened. Native file dialogs use
pinned `file_picker` 10.3.10; Android compiled here, while iOS dialog/device behavior
still requires Xcode and device verification. No broad storage permission is added.

No banking/booking/health/job-discovery integration, live exchange feed, push alarm,
OCR pipeline or biometric gate is configured. Bills/follow-ups/expiry dates and
routines are saved records; users can explicitly add Planner tasks. Existing daily
retention operations now include expired vault files. Live Supabase and model calls
remain unverified until real credentials are supplied.

## Phase 6 workers, calendars and notifications

Apply migration `0005` with migration credentials. Run the API plus
`python -m app.automation.worker` using restricted runtime/dispatcher URLs.
Compose includes this service and waits for API health. Read-only AI workflow
steps additionally need `python -m app.agentic.worker` and configured AI services.
Monitor `/api/v1/automation/status`; a heartbeat older than 60 seconds is offline.
Run trusted `python -m app.maintenance` daily with the operations role.

Register Google and/or Microsoft OAuth clients with exact HTTPS redirects:
`{OAUTH_PUBLIC_BASE_URL}/api/v1/integrations/oauth/google/callback` and
`{OAUTH_PUBLIC_BASE_URL}/api/v1/integrations/oauth/microsoft/callback`.
Set the corresponding server-only client ID/secret in `.env`; enable Google
Calendar API and the required Microsoft delegated calendar permissions.
Use the existing `VAULT_ENCRYPTION_KEYS`/`VAULT_ACTIVE_KEY_ID` AES-256 keyring;
preserve old keys during rotation. OAuth state and tokens use separate authenticated
encryption contexts. No secret belongs in Flutter configuration.

Connections request read access by default. Users explicitly select write access
before connecting and approve each export. Only primary/default calendars are
supported: sync reads the past 30 and next 90 days, at most 500 events. Imports
require a click and do not track subsequent remote changes automatically. Exports
contain no attendees/invitations. Disconnect wipes locally stored tokens and
mirrors; users can also revoke the application grant in the provider account.
Disable/redact OAuth callback query strings in reverse-proxy logs. The API removes
callback queries before access logging; Compose disables Uvicorn access logs.

`EXTERNAL_APIS_ENABLED=false` is the default. Enable only after reviewing
[Open-Meteo terms](https://open-meteo.com/en/terms) and
[Frankfurter documentation](https://frankfurter.dev/). The app supplies attribution;
weather coordinates and currency codes are sent only to these fixed providers.
Reference rates are not executable exchange quotes.

Native local notifications require explicit device opt-in. Android includes the
notification permission, boot receivers and desugaring; delivery uses inexact
alarms. iOS permission/delegate setup is included but requires macOS/device
validation. At most 50 pending alerts synchronize while the app is open. Device
previews are generic, and account changes clear local alerts and delivery state.
FCM/APNs remote push is not configured; a closed app cannot refresh its queue from
new server changes. Validate OAuth, notification permissions and reboot delivery
on real devices before release.
