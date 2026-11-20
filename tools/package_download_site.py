"""Package the public download page and compiled Flutter web preview for Pages."""

import json
import hashlib
import argparse
from pathlib import Path
import shutil
import zipfile
import urllib.request


def copy_apk(root, output):
    release = json.loads((root / "website/release.json").read_text())["android"]
    name = release["filename"]
    if Path(name).name != name or not name.endswith(".apk"):
        raise RuntimeError("Invalid APK filename")
    apk = root / ".tools/phone-preview/LIFEVERSE_AI-signed-preview-arm64.apk"
    if not apk.is_file():
        apk.parent.mkdir(parents=True, exist_ok=True)
        url = release["download_origin"] + "/" + release["url"]
        if not url.startswith("https://lifeverse-ai-universe.pages.dev/downloads/"):
            raise RuntimeError("Unexpected APK download origin")
        with (
            urllib.request.urlopen(url, timeout=30) as response,
            apk.open("wb") as target,
        ):
            total = 0
            while chunk := response.read(1024 * 1024):
                total += len(chunk)
                if total >= 25 * 1024 * 1024:
                    raise RuntimeError("APK exceeds Pages asset limit")
                target.write(chunk)
    if hashlib.file_digest(apk.open("rb"), "sha256").hexdigest() != release["sha256"]:
        raise RuntimeError("APK checksum mismatch")
    (output / "downloads").mkdir(exist_ok=True)
    shutil.copyfile(apk, output / "downloads" / name)
    (output / "downloads/SHA256SUMS.txt").write_text(
        release["sha256"] + "  " + name + "\n"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--site-only",
        action="store_true",
        help="Build web assets without an APK; not a complete download deployment",
    )
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    output = root / (
        ".tools/cloudflare-web-assets" if args.site_only else ".tools/cloudflare-site"
    )
    output.mkdir(parents=True, exist_ok=True)
    shutil.copytree(root / "website", output, dirs_exist_ok=True)
    if not args.site_only:
        copy_apk(root, output)
    build = root / "mobile/build/web"
    if not (build / "main.dart.js").is_file():
        raise RuntimeError("Build Flutter web first; refusing to publish an empty app")
    shutil.copytree(build, output / "app", dirs_exist_ok=True)
    # Branding files are buildless inputs; they can change without recompiling Dart.
    shutil.copyfile(root / "mobile/web/manifest.json", output / "app/manifest.json")
    shutil.copyfile(root / "mobile/web/favicon.png", output / "app/favicon.png")
    shutil.copytree(root / "mobile/web/icons", output / "app/icons", dirs_exist_ok=True)
    for file in output.rglob("*"):
        if not file.is_file():
            continue
        if file.stat().st_size >= 25 * 1024 * 1024:
            raise RuntimeError(
                f"Cloudflare Pages file too large: {file.relative_to(output)}"
            )
        if file.suffix.lower() in {".p12", ".jks", ".dpapi"}:
            raise RuntimeError("Do not package signing secrets with the website")
    archive = root / (
        ".tools/cloudflare-web-assets.zip"
        if args.site_only
        else ".tools/lifeverse-cloudflare-pages.zip"
    )
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zipped:
        for file in sorted(output.rglob("*")):
            if file.is_file():
                zipped.write(file, file.relative_to(output).as_posix())
    print(
        json.dumps(
            {
                "directory": str(output),
                "archive": str(archive),
                "bytes": archive.stat().st_size,
                "includes_apk": not args.site_only,
            }
        )
    )


if __name__ == "__main__":
    main()
