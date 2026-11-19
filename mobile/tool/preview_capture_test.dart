// Run with --update-goldens --dart-define=WRITE_UI_PREVIEWS=true.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/app/app.dart';
import '../test/app_test.dart' as helpers;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final config =
        jsonDecode(await File('.dart_tool/package_config.json').readAsString())
            as Map<String, dynamic>;
    final package = (config['packages'] as List)
        .cast<Map<String, dynamic>>()
        .singleWhere((p) => p['name'] == 'flutter');
    final root = Directory(
      Uri.parse(package['rootUri'] as String).toFilePath(),
    ).parent.parent.path;
    final font = await File(
      '$root/bin/cache/artifacts/material_fonts/roboto-regular.ttf',
    ).readAsBytes();
    for (final family in ['Roboto', 'Ahem']) {
      await (FontLoader(
        family,
      )..addFont(Future.value(ByteData.sublistView(font)))).load();
    }
    final icons = await File(
      '$root/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
    ).readAsBytes();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(Future.value(ByteData.sublistView(icons)))).load();
  });
  for (final theme in ['dark', 'light']) {
    testWidgets(
      'render $theme Home Universe',
      (tester) async {
        await helpers.mount(tester, size: const Size(430, 932), theme: theme);
        await expectLater(
          find.byType(LifeverseApp),
          matchesGoldenFile('../build/previews/home-$theme.png'),
        );
      },
      skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
    );
  }
  testWidgets(
    'render tablet Home Universe',
    (tester) async {
      await helpers.mount(tester, size: const Size(1024, 1366), theme: 'dark');
      await expectLater(
        find.byType(LifeverseApp),
        matchesGoldenFile('../build/previews/home-tablet.png'),
      );
    },
    skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
  );
  testWidgets(
    'render accessible narrow Home Universe',
    (tester) async {
      await helpers.mount(
        tester,
        size: const Size(320, 640),
        scale: 1.5,
        theme: 'light',
      );
      await expectLater(
        find.byType(LifeverseApp),
        matchesGoldenFile('../build/previews/home-large-text.png'),
      );
    },
    skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
  );
}
