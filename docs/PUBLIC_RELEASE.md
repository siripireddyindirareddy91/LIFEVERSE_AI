# Public downloads and web publishing

The official download website is **https://lifeverse-ai-universe.pages.dev/**.
The Flutter browser preview is **https://lifeverse-ai-universe.pages.dev/app/**.
These are Cloudflare Pages static deployments in the user's own account.

The current Android release-preview file is `LIFEVERSE_AI-0.1.1-arm64.apk`,
version 0.1.1/build 2, 22,343,782 bytes. It is a release-mode ARM64 build with a
dedicated RSA-3072 LIFEVERSE AI signing certificate, not the Android debug key.
It requires Android 7.0 or newer. Its size fits Pages' 25 MiB per-file limit,
so it can be served directly at `/downloads/LIFEVERSE_AI-0.1.1-arm64.apk`.
Larger historical debug/profile previews remain in GitHub Releases.

SHA-256: `1be258b34d836454abc8315efd083072cb67f0b27416c08a7afbe01063a7b0b7`.
Signing-certificate SHA-256:
`8f3b9b9fff5562c6eb158ab45d738cd0604106afb14a4c63ffadf0a2dc6e80f7`.

This is still an **interface preview**. A signed release build does not configure
Supabase, the API, AI providers or production monitoring. Those services and
full-account lifecycle/release requirements remain outstanding. The download
page explains these limits without simulating login, records or AI.

## Rebuild and retain signing identity

On this Windows workspace run `scripts/build-signed-preview.ps1`. An optional
`-ConfigPath` accepts a real public Flutter environment configuration; without it
the script builds the unconfigured preview explicitly. Release Gradle settings
require four signing environment variables and never fall back to debug signing.

The encrypted upload keystore and Windows-user-protected password are kept under
ignored `.tools/android-signing/`. They are not in the website, APK or repository.
Only this Windows user can decrypt the DPAPI password file. Before a long-term
store release, retain the signing key and password in a secure recovery/backup
system; copying the DPAPI blob alone to another machine is not portable recovery.
Never commit keys or passwords. The new certificate cannot update an older
debug-signed preview; uninstalling that preview removes its local app data.

## Rebuild the website and browser application

From `mobile/`, using Flutter 3.38.3:

```text
flutter pub get --enforce-lockfile
flutter build web --release --base-href /app/ --no-pub --no-wasm-dry-run --dart-define=APP_ENV=development --dart-define=API_BASE_URL=https://api.invalid
```

From the repository root:

```text
python tools/package_download_site.py
```

The packager combines `website/`, the actual compiled Flutter web output, brand
assets, and the checksum-verified signed APK. It refuses oversized assets and
signing material. In CI, it fetches the pinned public APK if no local build exists
and verifies its SHA-256 before packaging. Output is ignored
`.tools/lifeverse-cloudflare-pages.zip`; upload that to the existing Pages
project `lifeverse-ai-universe`. Do not create a duplicate project on updates.

Cloudflare deployment uses the user's browser login; no persistent Cloudflare
API credential was created or committed. The CI web job uses `--site-only` to
build and retain web assets without a signing key or a dependency on the live
download server. That artifact is not a complete download deployment: use the
default full packaging command to add the verified APK before publishing. CI
does not silently publish or contain signing credentials.

The web build uses JavaScript/CanvasKit. The current secure-storage package does
not support a WebAssembly compilation; no Wasm support is claimed. Website/mobile
layouts and the actual Flutter Home Universe were checked in a browser. Physical
Android/Fire-tablet testing remains separate from compilation/signature checks.

## Amazon Appstore status

Amazon discontinued Appstore distribution to non-Amazon Android phones on
20 August 2025. A new submission must target supported Amazon devices, such as
Fire tablets. This touch-first app has not been validated for Fire TV/D-pad use
or Vega OS, and must not be advertised as supporting those devices.

Amazon submission requires a developer account, publisher/privacy information,
appropriate listing assets, and physical-device validation. Existing release gaps
and unconfigured online services must be resolved or accurately represented before
submission. No Amazon approval or completed submission is claimed here.

References: [Amazon distribution change](https://developer.amazon.com/apps-and-games/blogs/2025/02/upcoming-changes-to-amazon-appstore-for-android-devices-and-coins-program),
[Amazon submission requirements](https://developer.amazon.com/docs/app-submission/submitting-apps-to-amazon-appstore.html),
[Cloudflare Pages limits](https://developers.cloudflare.com/pages/platform/limits/).
