"""Remove the alpha channel from generated, opaque iOS app icons (requires Pillow)."""

from pathlib import Path

from PIL import Image

root = Path(__file__).resolve().parents[1]
for path in (root / "mobile/ios/Runner/Assets.xcassets/AppIcon.appiconset").glob(
    "*.png"
):
    with Image.open(path) as image:
        image.convert("RGB").save(path)
