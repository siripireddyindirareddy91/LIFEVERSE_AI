# Foundation security

- Never commit `.env`, mobile config overrides, tokens or signing keys.
- Mobile receives only the public Supabase publishable/anon key. Never ship a
  Supabase service-role key, database password or provider secret.
- Auth tokens are stored in platform secure storage. Configure iOS Keychain
  entitlements and test device behavior before release.
- JWT signatures and issuer/audience/expiry are verified; no development bypass.
- Database ownership uses forced RLS and a restricted role. Migration credentials
  must not be exposed to clients or used as the runtime connection.
- Docker credentials are local development defaults only; services bind localhost.
- Production requires TLS, secret management, backups, migration release jobs,
  request throttling at ingress, monitoring and a security review.
- Android cleartext networking is allowed only by the debug manifest for local
  APIs. Release configurations require HTTPS. No sensitive payload logging.

Report vulnerabilities privately to the repository owner. This foundation is not
a production security audit or a claim of compliance.

Phase 3 requires explicit AI-processing consent and independent memory-sharing
permissions. Context-enriched chat turns are not silently reused in later prompts.
Successful AI request counters survive chat deletion and contain no prompt/reply.
Retention maintenance uses a separate operations role; runtime RLS must never be
bypassed. Live Supabase/provider behavior and native iOS flows still require
real-environment verification before release.


Phase 4 specialists receive strict allowlisted tools and selected scopes. There
is no SQL/code/network-browsing tool. Read tools are permission level 1; personal
record writes are level 2 proposals requiring an authenticated exact-preview
approval. External level 3 actions are unavailable; unsupported/restricted level 4
requests have no execution tool. Model prompts and retrieved text cannot grant
permissions or execute proposals. Consent and current evidence/targets are checked
again at approval. New agent-saved memories are private by default.

Prompt injection is addressed through typed tool validation, owner-scoped sessions,
per-agent tool lists and deterministic approval, not reliance on model compliance.
Citation labels must refer to real retrieved source records; this verifies source
identity, not the truth or entailment of every model sentence. Review AI advice.
Personal prompts/excerpts remain in owner-only run history until deletion/expiry;
index removal or consent revocation does not erase earlier history copies.
Provider errors are sanitized, tracing is disabled, and execution logs omit raw
provider bodies and hidden reasoning. A production audit remains outstanding.
