# LIFEVERSE AI — Aurora Nebula

**Your Life. Your Intelligence. Your Universe.**

## Identity

The original mark combines an open orbit, a rising L-shaped path and a four-point
north star. The orbit represents connected life spaces; its opening leaves room
for growth. Orchid signals intelligence; teal provides the human point of focus.
The mark is drawn in Flutter by `BrandMarkPainter`, not sourced from stock artwork.

Keep clear space around the mark of at least one-quarter its height. Use the
full wordmark in headers and the mark alone for launcher icons. Do not stretch,
rotate, add lettering inside the mark or place it on a busy background. A
monochrome option follows the current theme's foreground color.

## Palette

| Token | Hex | Purpose |
|---|---|---|
| Obsidian Void | `#090B17` | Dark background and icon field |
| Cosmic Plum | `#291538` | Ambient depth |
| Electric Orchid | `#B45CFF` | Intelligence and brand accent |
| Aurora Teal | `#37E5C5` | Positive emphasis |
| Solar Amber | `#FFCA79` | Attention and planning |
| Nebula Rose | `#F18DBD` | Personal and creative spaces |
| Glacier Mist | `#D9F5F0` | Light accents |
| Lunar Silver | `#A8A9BC` | Secondary text in dark mode |
| Pure Light | `#F8F6FF` | Light background and dark-mode foreground |

Raw accents are decorative. Interactive controls and body text use semantic theme
colors, including deeper orchid/teal values in light mode for readability. Status
is communicated with words/icons as well as color. Typography uses platform
fonts with clear hierarchy, restrained tracking and generous line height.

## Living interface

- Breathing light, thin orbital lines and sparse stars establish depth.
- Home is an entry into the universe, not a wall of fabricated metrics.
- Every radial destination also has conventional navigation.
- Small screens and large text switch to a linear list automatically.
- The orb has nine explicit states; Studio labels them as visual previews.
- Reduced motion freezes the orb. Device accessibility settings take precedence.
- Focus, semantics, touch targets and text scaling remain functional in both themes.

## Asset generation

From `mobile/`, run:

```powershell
..\scripts\flutter.ps1 test tool/brand_assets_test.dart --dart-define=WRITE_BRAND_ASSETS=true
```

From the repository root, run `python scripts/finalize_brand_icons.py` with Pillow
available to remove alpha channels from the opaque iOS icons. This is format
conversion of the generated artwork. The original vector geometry remains in
`mobile/lib/shared/brand/lifeverse_brand.dart`.

Generated assets cover Android launcher densities and every size in the existing
iOS app-icon catalog. A 1024px reference is in `mobile/assets/brand/`.
iOS asset compilation and launch behavior still require verification on macOS.
