# Foundation architecture

`mobile/` is a Flutter modular application: app composition and routing in `app/`,
configuration, HTTP and authentication in `core/`, reusable visual elements in
`shared/`, and foundation/settings screens in `features/`.

Riverpod owns dependencies and theme preference. GoRouter owns deep-linkable
routes. Dio attaches current Supabase access tokens only to the configured API.
Supabase owns refresh and session lifecycle; sessions persist through Flutter
Secure Storage. SharedPreferences stores only appearance and reduced motion.

`backend/` is a modular FastAPI monolith. Public liveness is separate from
configuration/database readiness. Protected routes verify Supabase JWTs against
the project's JWKS, requiring an issuer, authenticated audience, expiry and UUID
subject. Asymmetric ES256/RS256 signing is supported; legacy shared JWT secrets
are deliberately not accepted. Provider outages fail closed.

PostgreSQL access uses a restricted runtime role. Each authenticated transaction
sets a local verified owner ID and RLS enforces ownership. Alembic runs with a
separate migration role. Future finance, learning, travel and automation modules
remain outside the current core-life scope.

Phase 2 adds `features/universe/`: a typed destination catalog, Home Universe,
accessible radial/list navigation and explicit availability screens. Brand geometry,
reusable surfaces/states/buttons/sheets and the nine-state orb are shared widgets.
The orb paints through an animation-driven CustomPainter without rebuilding page
layout each frame. OS accessibility, TickerMode and a saved reduced-motion preference
control its ticker. Studio previews visual states without activating any AI service.

Phase 3 adds profile, planner, goals, habits, memory, Assistant and insight screens.
The shared repository uses generated immutable Freezed/JSON DTOs and Riverpod
query/mutation providers. Identity changes invalidate the repository dependency
and reset protected widget subtrees, preventing another account's cached records
or drafts from remaining in the visible UI.

The backend life domain owns validated CRUD, consent, calendar conflicts, habit
streaks, expiry and real-record dashboard aggregation. The Assistant's bounded
LangGraph and provider interface have no database handles or execution tools.
See AI_AGENT_DESIGN.md for context, request limits, retries and retention.
