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

Routes: `/` (Home Universe), `/explore` (all spaces), `/universe/:space`
(future-space introduction), `/design` (Studio), `/settings` (appearance/motion),
`/foundation` (connection setup), `/profile`, `/planner`, `/goals`, `/habits`,
`/memory`, `/insights` and `/assistant`. Private routes require an account.
Mobile uses bottom navigation; wide screens use a navigation rail. Routes can
be opened programmatically using GoRouter. Verified HTTPS app/universal links
require an owned domain and platform association files in a later phase.

Sessions use platform secure storage. Email sign-in/sign-up/sign-out use Supabase.
Preferences store appearance and reduced motion only. The Supabase client owns token refresh;
the API client refreshes expired sessions before attaching a bearer token.
Public config is compile-time data, never a place for server-side secrets.

English ARB localization is generated into `lib/l10n/`; add another ARB locale
and regenerate to extend it. Flutter localization delegates supply text direction.
The current foundation's product copy is English; future feature copy must also
be moved into ARB resources before adding translations.

Native iOS builds need macOS/Xcode and device signing. Test Keychain behavior
on an iOS device before release. Android cleartext traffic is debug-only;
production API/Supabase endpoints require HTTPS. Final application IDs
and release signing should be finalized before distribution.

The original code-native brand and generated launcher icons are described in
`../docs/BRAND_GUIDE.md`. Home shows an idle orb; Assistant shows thinking only
while a real request is pending. Studio's other states are animation previews.
Device reduced-motion
and accessible-navigation settings stop the orb, as does the saved motion setting.

To reproduce visual QA captures, run:

```powershell
..\scripts\flutter.ps1 test tool/preview_capture_test.dart --update-goldens --dart-define=WRITE_UI_PREVIEWS=true
```

Captures are written to ignored `build/previews/`; they are not baseline tests.

Phase 3 preview command: `flutter test tool/core_preview_test.dart --update-goldens
--dart-define=WRITE_UI_PREVIEWS=true`. These captures use clearly labeled test-only
data, not a live account. No test adapter is registered by production bootstrap.

Core DTOs live in `lib/core/models/`; regenerate with `dart run build_runner build`.
Feature screens use the life repository and query/mutation providers. Account
changes reset protected subtrees and repository identity dependencies.
