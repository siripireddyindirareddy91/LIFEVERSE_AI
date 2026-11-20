# Testing and evidence

Use disposable databases. Tests create synthetic owner records and delete their
own records; never point these commands at production or a real account's database.

## Backend

Install Python 3.12, `pip install -r backend/requirements.lock`, then
`pip install --no-deps -e ./backend`. Provision the roles using
`infrastructure/init-db.sql`, and apply `alembic upgrade head` from `backend/`
with migration credentials. Set `TEST_DATABASE_URL` to the restricted runtime role
and `TEST_DISPATCH_DATABASE_URL` to the restricted dispatcher role. Include
`?connect_timeout=5` in local URLs to bound connection failures. CI refuses to run
without `TEST_DATABASE_URL`, so integration tests cannot silently disappear there.

From the repository root:

```text
ruff check backend tools
ruff format --check backend tools
coverage run --branch --source=backend/app -m pytest backend/tests -q --junitxml=reports/backend-tests.xml
coverage report --fail-under=80
coverage xml -o reports/backend-coverage.xml
```

Coverage includes all application modules, including worker/maintenance entry
points. The 80% gate is combined statement/branch coverage, not a claim that every
branch has 80% coverage. Worker CLI loops and real provider/OAuth services need
separate environment validation. Test providers/transports are confined to tests.

The API security matrix is generated from OpenAPI and calls every private
method/path without credentials. It covers newly added routes automatically.
The OAuth callback is deliberately public and separately tested for one-time
state, owner lookup, expiry, PKCE and replay. JWT tests use generated EC/RSA keys;
normal application requests never receive a development authentication bypass.

## Performance

Set `PERFORMANCE_REPORT=reports/performance.json`, then run:

```text
pytest backend/tests/test_performance.py -q
```

The test seeds 2,000 synthetic tasks and warms the routes. It makes 48 requests
with concurrency 8: 16 dashboard reads and 32 paginated task reads. Every response
must have correct totals and bounded results. It records median/p95/max latency,
throughput and errors, with a generous p95 smoke budget of 5 seconds. A separate
test caps dashboard statements at 12 and verifies local-day boundaries in UTC+14.

Compare runs on the same host without coverage instrumentation. This benchmark
includes in-process ASGI and PostgreSQL work; it excludes internet latency, TLS,
real authentication, model/provider latency, devices and production load. It is
not a production capacity/SLO measurement. Query-count checks provide the stable
regression guard when host timing varies.

## Flutter

Using Flutter 3.38.3/Dart 3.10.1, from `mobile/`:

```text
flutter pub get --enforce-lockfile
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test tool
flutter analyze
flutter test --coverage
flutter build apk --debug
```

`security_test.dart` tests secure-storage channel operations and configuration.
`api_transport_test.dart` uses a loopback HTTP server with test-only tokens to
verify token replacement, redirect denial and external-destination denial. It is
separate from widget bindings that intentionally intercept HTTP traffic. Secure
storage channel mocks do not prove physical Keychain/Keystore behavior.

## Advisory and secret checks

Install `backend/security-tools.txt` in an isolated environment, then run:

```text
pip-audit -r backend/requirements.lock --no-deps --disable-pip --timeout 30 -f json -o reports/python-advisories.json
python tools/audit_mobile.py
python tools/check_repository_security.py
```

Only public dependency names and versions are sent to advisory services. The
Python audit checks the fully pinned dependency closure; the mobile audit checks
all hosted locked Dart versions against OSV. Neither tool executes automatic
fixes or suppresses advisory IDs. Service failures fail the check rather than
producing a clean result. Unknown/new vulnerabilities and native OS/SDK libraries
are outside these results. The repository check detects selected high-confidence
secret formats/private configuration, not arbitrary secrets or git-history leaks.

CI saves synthetic-data test results, coverage, performance and advisory reports
as artifacts for 14 days. Do not put production payloads or credentials in these
artifacts. New Phase 7 workflow changes require a push before GitHub can run them.
