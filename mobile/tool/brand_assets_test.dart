// Flutter's test engine provides a deterministic Canvas for code-native assets.
// Run: flutter test tool/brand_assets_test.dart --dart-define=WRITE_BRAND_ASSETS=true
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/shared/brand/lifeverse_brand.dart';
import 'package:lifeverse_ai/shared/theme/tokens.dart';

Future<void> writeMark(String path, int pixels) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = pixels.toDouble();
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size, size),
    Paint()..color = Aurora.voidColor,
  );
  canvas.translate(size * .13, size * .13);
  const BrandMarkPainter(
    Aurora.orchid,
    Aurora.teal,
  ).paint(canvas, Size.square(size * .74));
  final picture = recorder.endRecording();
  final image = await picture.toImage(pixels, pixels);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsBytes(bytes!.buffer.asUint8List());
  image.dispose();
  picture.dispose();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'export original LIFEVERSE brand assets',
    () async {
      for (final entry in {
        'mdpi': 48,
        'hdpi': 72,
        'xhdpi': 96,
        'xxhdpi': 144,
        'xxxhdpi': 192,
      }.entries) {
        await writeMark(
          'android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png',
          entry.value,
        );
      }
      for (final entry in {
        '20x20@1x': 20,
        '20x20@2x': 40,
        '20x20@3x': 60,
        '29x29@1x': 29,
        '29x29@2x': 58,
        '29x29@3x': 87,
        '40x40@1x': 40,
        '40x40@2x': 80,
        '40x40@3x': 120,
        '60x60@2x': 120,
        '60x60@3x': 180,
        '76x76@1x': 76,
        '76x76@2x': 152,
        '83.5x83.5@2x': 167,
        '1024x1024@1x': 1024,
      }.entries) {
        await writeMark(
          'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-${entry.key}.png',
          entry.value,
        );
      }
      await writeMark('assets/brand/lifeverse-mark.png', 1024);
    },
    skip: !const bool.fromEnvironment('WRITE_BRAND_ASSETS'),
  );
}
