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
