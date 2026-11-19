# PostgreSQL foundation

Alembic revision `0001` creates `profiles`: a Supabase user UUID primary key,
display name, locale, timezone and creation timestamp. The external Supabase
identity is authoritative; there is no duplicated password/user credential store.
When using standalone PostgreSQL, a cross-service FK to Supabase `auth.users`
cannot be created. Future account lifecycle work must reconcile deleted identities.

Forced row-level security requires `user_id` to equal transaction-local
`app.user_id`. FastAPI sets it only from a cryptographically verified JWT. Runtime
connections must be non-owner, non-superuser and `NOBYPASSRLS`. Never use the
migration connection for requests.

Local Docker initialization provisions `lifeverse_app`. For existing/hosted
databases, provision that role yourself and grant schema usage and table DML,
including default privileges for the migration owner. Do not grant this backend
role to clients. The table is backend-only: do not expose it through Supabase's
Data API; it intentionally does not use client-controlled JWT settings.

Run from `backend/`: `alembic upgrade head`. Downgrade is destructive:
`alembic downgrade base` removes profiles. Back up real data first.
Database tests require a disposable migrated database and `TEST_DATABASE_URL`
pointing to the restricted runtime role; they roll back their rows.
