import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/core/models/module_models.dart';
import 'package:lifeverse_ai/features/modules/presentation/module_editor.dart';
import 'package:lifeverse_ai/features/modules/presentation/module_screen.dart';
import 'core_life_test.dart' as helpers;
import 'fixtures/fake_life_repository.dart';
import 'fixtures/fake_module_repository.dart';

Future<void> tapEditor(WidgetTester tester, String label) async {
  final scroll = find
      .descendant(
        of: find.byType(ModuleEditor),
        matching: find.byType(Scrollable),
      )
      .first;
  await tester.scrollUntilVisible(
    find.text(label).hitTestable(),
    200,
    scrollable: scroll,
  );
  await tester.tap(find.text(label).hitTestable());
  await tester.pumpAndSettle();
}

ModuleRecord sample(
  String kind, {
  String id = 'test-record',
  String title = 'Test record',
  Map<String, dynamic> data = const {},
}) => ModuleRecord(
  id: id,
  kind: kind,
  title: title,
  data: {'title': title, ...data},
  allowAi: false,
  revision: 'test-revision',
  createdAt: FakeModuleRepository.time,
  updatedAt: FakeModuleRepository.time,
);

void main() {
  testWidgets('finance form saves a decimal amount and stays private', (
    tester,
  ) async {
    final repo = FakeModuleRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/modules/finance',
      modules: repo,
    );
    await helpers.tapVisible(tester, find.text('New transaction'));
    await tester.enterText(find.byKey(const ValueKey('field-title')), 'Lunch');
    await tester.enterText(
      find.byKey(const ValueKey('field-amount')),
      '120.50',
    );
    await tapEditor(tester, 'Save transaction');
    expect(repo.items.single.data['amount'], '120.50');
    expect(repo.items.single.allowAi, false);
    expect(find.text('Lunch'), findsOneWidget);
  });
  testWidgets('record retry retains request identifier and draft', (
    tester,
  ) async {
    final repo = FakeModuleRepository()..failSave = true;
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/modules/learning',
      modules: repo,
    );
    await helpers.tapVisible(tester, find.text('New course'));
    await tester.enterText(
      find.byKey(const ValueKey('field-title')),
      'Learn Dart',
    );
    await tapEditor(tester, 'Save course');
    await tapEditor(tester, 'Save course');
    expect(repo.saves.length, 2);
    expect(repo.saves[0]['request_id'], repo.saves[1]['request_id']);
    expect(repo.saves[0]['data']['title'], 'Learn Dart');
  });
  testWidgets('quiz scoring shows actual repository result', (tester) async {
    final repo = FakeModuleRepository()
      ..items.add(
        sample(
          'quiz',
          data: {
            'question': 'Which language does Flutter use?',
            'option_a': 'Dart',
            'option_b': 'Other',
            'option_c': 'Third',
            'option_d': 'Fourth',
            'correct': 'A',
            'explanation': 'Flutter uses Dart.',
          },
        ),
      );
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/modules/learning',
      modules: repo,
    );
    await helpers.tapVisible(tester, find.text('Quizzes'));
    await helpers.tapVisible(tester, find.text('Practice'));
    await tester.tap(find.text('B. Other'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.text('Keep exploring · 0 / 1'), findsOneWidget);
    await tester.tap(find.text('A. Dart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.text('Correct · 1 / 1'), findsOneWidget);
  });
  testWidgets('flashcard answers stay hidden until revealed', (tester) async {
    final record = sample(
      'flashcard',
      data: {'question': 'Question text', 'answer': 'Private practice answer'},
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FlashcardDialog(record: record)),
      ),
    );
    expect(find.text('Private practice answer'), findsNothing);
    await tester.tap(find.text('Reveal answer'));
    await tester.pumpAndSettle();
    expect(find.text('Private practice answer'), findsOneWidget);
  });
  testWidgets('resume export uses stored factual text', (tester) async {
    final repo = FakeModuleRepository()..items.add(sample('resume'));
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/modules/career',
      modules: repo,
    );
    await helpers.tapVisible(tester, find.text('Resumes'));
    await helpers.tapVisible(tester, find.text('Resume & keyword review'));
    expect(find.text('Test resume\nFlutter developer'), findsOneWidget);
    expect(find.textContaining('Review terms: sql'), findsOneWidget);
  });
  testWidgets('vault picker uploads privately and download uses save gateway', (
    tester,
  ) async {
    final repo = FakeModuleRepository(), files = FakeVaultGateway();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/vault',
      modules: repo,
      files: files,
    );
    await helpers.tapVisible(tester, find.text('Upload document'));
    await tester.tap(find.text('Upload securely'));
    await tester.pumpAndSettle();
    expect(repo.uploads.single['allow_ai'], false);
    expect(repo.uploads.single['filename'], 'test.txt');
    await helpers.tapVisible(tester, find.text('Download'));
    expect(files.downloads, 1);
  });
  testWidgets('knowledge connections are removable with confirmation', (
    tester,
  ) async {
    final repo = FakeModuleRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/knowledge-universe',
      modules: repo,
    );
    await helpers.tapVisible(tester, find.byTooltip('Remove connection'));
    expect(repo.connections.edges.length, 1);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove connection'));
    await tester.pumpAndSettle();
    expect(repo.connections.edges, isEmpty);
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
    testWidgets('$route supports narrow layouts and large text', (
      tester,
    ) async {
      await helpers.mountCore(
        tester,
        FakeLifeRepository(),
        route,
        modules: FakeModuleRepository(),
        size: const Size(360, 800),
        scale: 1.5,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
