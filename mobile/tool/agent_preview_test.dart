// Explicitly labeled test-data previews, never registered in production.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test/core_life_test.dart' as helpers;
import '../test/fixtures/fake_life_repository.dart';
import '../test/fixtures/fake_agent_repository.dart';

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
    '/agents',
    '/agents/new',
    '/agents/test-run',
    '/knowledge',
  ]) {
    testWidgets(
      'render $route with labeled test data',
      (tester) async {
        final repo = FakeLifeRepository();
        repo.savedProfile = repo.savedProfile!.copyWith(knowledgeConsent: true);
        await helpers.mountCore(
          tester,
          repo,
          route,
          agents: FakeAgentRepository(),
          capture: true,
        );
        final name = route.replaceAll('/', '-');
        await expectLater(
          find.byKey(const ValueKey('capture-root')),
          matchesGoldenFile('../build/previews/phase4$name.png'),
        );
        if (route == '/agents/test-run') {
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -550),
          );
          await tester.pumpAndSettle();
          await expectLater(
            find.byKey(const ValueKey('capture-root')),
            matchesGoldenFile('../build/previews/phase4-approval.png'),
          );
        }
      },
      skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
    );
  }
}
