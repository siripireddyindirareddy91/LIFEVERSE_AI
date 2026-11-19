// Explicitly labeled TEST DATA; these adapters never enter production.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';
import '../test/core_life_test.dart' as helpers;
import '../test/fixtures/fake_life_repository.dart';
import '../test/fixtures/fake_automation_repository.dart';

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

  for (final route in [
    '/automation',
    '/automation/new',
    '/automation/workflows/test-workflow',
    '/automation/runs/test-run',
    '/notifications',
    '/integrations',
  ]) {
    testWidgets(
      'render $route with labeled test data',
      (tester) async {
        await helpers.mountCore(
          tester,
          FakeLifeRepository(),
          route,
          automation: FakeAutomationRepository(),
          device: FakeDeviceGateway(),
          capture: true,
        );
        await expectLater(
          find.byKey(const ValueKey('capture-root')),
          matchesGoldenFile(
            '../build/previews/phase6${route.replaceAll('/', '-')}.png',
          ),
        );
      },
      skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
    );
  }
}
