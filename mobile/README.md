# LIFEVERSE mobile

Flutter 3.38.3 / Dart 3.10.1. Android and iOS are the supported native targets.
From this directory, use `..\scripts\flutter.ps1 pub get` and
`..\scripts\flutter.ps1 run` for the workspace-local SDK on Windows.
Otherwise use Flutter from your PATH/FVM.

Copy `config/development.example.json` to `config/development.json`, set your
API URL and optional Supabase public configuration, then run:

```powershell
..\scripts\flutter.ps1 run --dart-define-from-file=config/development.json
```

Routes: `/` (foundation), `/design` (visual system), `/settings` (appearance).
Mobile uses bottom navigation; wide screens use a navigation rail. Routes can
be opened programmatically using GoRouter. Verified HTTPS app/universal links
require an owned domain and platform association files in a later phase.

Sessions use platform secure storage. No sign-in UI is included until Phase 2.
Preferences store appearance only. The Supabase client owns token refresh;
the API client refreshes expired sessions before attaching a bearer token.
Public config is compile-time data, never a place for server-side secrets.

English ARB localization is generated into `lib/l10n/`; add another ARB locale
and regenerate to extend it. Flutter localization delegates supply text direction.
The current foundation's product copy is English; future feature copy must also
be moved into ARB resources before adding translations.

Native iOS builds need macOS/Xcode and device signing. Test Keychain behavior
on an iOS device before release. Android cleartext traffic is debug-only;
production API/Supabase endpoints require HTTPS. Final application IDs, icons
and release signing should be finalized before distribution.
