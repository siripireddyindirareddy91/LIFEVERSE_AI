# Foundation API

Interactive OpenAPI: `http://localhost:8000/docs` during local development.

| Method | Path | Authentication | Behavior |
|---|---|---|---|
| GET | `/health/live` | None | Process liveness |
| GET | `/health/ready` | None | 503 until auth is configured and migrated DB reachable |
| GET | `/api/v1/me` | Supabase bearer JWT | Verified UUID identity |
| GET | `/api/v1/profile` | Supabase bearer JWT | Owner profile; 404 until onboarding creates it |

401 means missing/invalid/expired authentication. 503 means missing configuration
or unavailable infrastructure. No registration, onboarding or module endpoints
are included. The mobile app obtains sessions directly through Supabase Auth;
passwords never pass through this API.
