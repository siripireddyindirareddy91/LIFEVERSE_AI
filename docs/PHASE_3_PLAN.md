# Phase 3 — core life management

Phase 1 is pushed at `1c069a6`; Phase 2 is pushed at `cf43211`.
Both exact commits have successful GitHub Actions runs. Phase 2 run:
https://github.com/siripireddyindirareddy91/LIFEVERSE_AI/actions/runs/44511430405

## Authorized scope and acceptance

- User profile, Supabase email sign-in/sign-up/sign-out and consent settings.
- Planner: persistent tasks, completion, goal links and calendar events with explicit overlap confirmation.
- Goals: CRUD, target dates and user-reported progress.
- Daily habits: CRUD, idempotent check-ins, undo and timezone-aware streaks.
- Personal memory: CRUD, search, expiry, explicit AI sharing, export and deletion.
- AI Assistant: real provider adapter, bounded LangGraph orchestration, conversation history,
  deletion/retention, idempotency, rate limits and opt-in authorized context.
- Life Intelligence dashboard calculated from the authenticated user's actual records.

Every new table uses forced owner RLS and restricted runtime credentials. Test
against real PostgreSQL, including cross-user access, validation, planner conflict,
habit date handling, memory consent/expiry and provider failure behavior. Flutter
uses typed immutable DTOs, repository/providers, validated forms and real API calls.

No external action engine, autonomous changes, booking, finance, integrations or
future modules are included. AI has no execution tools and must not claim actions.
Supabase public configuration and a server-side AI key/model are still external
setup requirements. Missing configuration produces honest setup-required states;
test doubles are confined to tests. No production authentication bypass is added.
