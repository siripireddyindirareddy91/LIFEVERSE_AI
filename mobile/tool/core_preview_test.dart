// Explicit, labeled test-data previews; this adapter never enters production.
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/core/models/life_models.dart';
import '../test/core_life_test.dart' as helpers;
import '../test/fixtures/fake_life_repository.dart';

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
    '/planner',
    '/goals',
    '/habits',
    '/memory',
    '/insights',
    '/assistant',
    '/profile',
  ]) {
    testWidgets(
      'render $route with labeled test data',
      (tester) async {
        final repo = FakeLifeRepository();
        repo.savedProfile = repo.savedProfile!.copyWith(
          displayName: 'Indira (test account)',
          timezone: 'Asia/Kolkata',
        );
        repo.goalItems.add(
          GoalItem(
            id: 'test-goal',
            title: 'Build my Flutter foundation',
            notes: 'Practice by building one small feature at a time.',
            progress: 35,
            targetDate: '2026-12-15',
            createdAt: FakeLifeRepository.timestamp,
          ),
        );
        repo.taskItems.add(
          TaskItem(
            id: 'test-task',
            title: 'Review the navigation flow',
            notes: 'Check the small-screen layout and accessible labels.',
            priority: 'high',
            goalId: 'test-goal',
            createdAt: FakeLifeRepository.timestamp,
          ),
        );
        repo.habitItems.add(
          HabitItem(
            id: 'test-habit',
            title: 'Read for 15 minutes',
            notes: 'A little curiosity, every day.',
            checkedToday: true,
            currentStreak: 4,
            today: '2026-11-19',
            createdAt: FakeLifeRepository.timestamp,
          ),
        );
        repo.memoryItems.add(
          MemoryItem(
            id: 'test-memory',
            title: 'How I like to learn',
            content: 'Short explanations followed by a practical example.',
            allowAi: false,
            createdAt: FakeLifeRepository.timestamp,
          ),
        );
        await helpers.mountCore(tester, repo, route, capture: true);
        await expectLater(
          find.byKey(const ValueKey('capture-root')),
          matchesGoldenFile('../build/previews/core-${route.substring(1)}.png'),
        );
      },
      skip: !const bool.fromEnvironment('WRITE_UI_PREVIEWS'),
    );
  }
}
