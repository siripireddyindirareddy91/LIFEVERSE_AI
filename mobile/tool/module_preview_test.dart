// Labeled test-data renders; no production fake adapters.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/core/models/module_models.dart';
import '../test/core_life_test.dart' as helpers;
import '../test/fixtures/fake_life_repository.dart';
import '../test/fixtures/fake_module_repository.dart';

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
    '/modules/finance',
    '/modules/learning',
    '/modules/career',
    '/modules/wellness',
    '/modules/travel',
    '/modules/future',
    '/vault',
    '/knowledge-universe',
  ]) {
    testWidgets(
      'render $route with labeled test data',
      (tester) async {
        final repo = FakeModuleRepository();
        final examples = <String, Map<String, dynamic>>{
          'entry': {
            'title': 'A quiet lunch with a friend',
            'amount': '350.00',
            'currency': 'INR',
            'direction': 'expense',
            'category': 'Food',
            'day': '2026-11-19',
          },
          'course': {
            'title': 'Build thoughtful Flutter apps',
            'subject': 'Programming',
            'total_units': 12,
            'completed_units': 4,
            'weekly_minutes': 180,
          },
          'application': {
            'title': 'A role that fits my next chapter',
            'company': 'Example company (test)',
            'role': 'Mobile developer',
            'status': 'interview',
            'follow_up': '2026-11-23',
          },
          'wellness_log': {
            'title': 'A little space for myself',
            'day': '2026-11-19',
            'sleep_hours': '7.5',
            'water_ml': 750,
            'activity_minutes': 25,
            'journal': 'A short walk helped me reset.',
          },
          'trip': {
            'title': 'A slower weekend away',
            'destination': 'Mysuru (test itinerary)',
            'starts_on': '2026-12-05',
            'ends_on': '2026-12-07',
            'budget': '10000.00',
            'currency': 'INR',
          },
          'scenario': {
            'title': 'One small habit, six months from now',
            'scenario_type': 'learning',
            'horizon_months': 6,
            'hours_per_week': '3',
            'starting_amount': '0',
            'monthly_contribution': '0',
            'annual_rate': '0',
            'currency': 'INR',
            'target_hours': 80,
            'assumptions': 'Three focused hours each week.',
            'risks': 'Schedules may change.',
          },
        };
        for (final e in examples.entries) {
          repo.items.add(
            ModuleRecord(
              id: e.key,
              kind: e.key,
              title: e.value['title'] as String,
              data: e.value,
              allowAi: false,
              revision: 'test',
              createdAt: FakeModuleRepository.time,
              updatedAt: FakeModuleRepository.time,
            ),
          );
        }
        repo.documents.add(
          VaultItem(
            id: 'test-file',
            title: 'Course certificate',
            category: 'Certificate',
            filename: 'certificate.pdf',
            mime: 'application/pdf',
            size: 125000,
            sha256: 'test-only',
            allowAi: false,
            createdAt: FakeModuleRepository.time,
          ),
        );
        await helpers.mountCore(
          tester,
          FakeLifeRepository(),
          route,
          modules: repo,
          capture: true,
        );
        await expectLater(
          find.byKey(const ValueKey('capture-root')),
          matchesGoldenFile(
            '../build/previews/phase5${route.replaceAll('/', '-')}.png',
          ),
        );
      },
      skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
    );
  }
}
