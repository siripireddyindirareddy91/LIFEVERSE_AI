import 'package:lifeverse_ai/features/agents/data/agent_repository.dart';
import 'package:lifeverse_ai/features/agents/application/agent_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lifeverse_ai/app/app.dart';
import 'package:lifeverse_ai/app/providers.dart';
import 'package:lifeverse_ai/app/router.dart';
import 'package:lifeverse_ai/core/config/app_config.dart';
import 'package:lifeverse_ai/core/models/life_models.dart';
import 'package:lifeverse_ai/features/life/application/life_providers.dart';
import 'package:lifeverse_ai/features/profile/application/account_providers.dart';
import 'package:lifeverse_ai/features/life/presentation/record_editor.dart';
import 'fixtures/fake_life_repository.dart';

Future<void> mountCore(
  WidgetTester tester,
  FakeLifeRepository repo,
  String route, {
  Size size = const Size(430, 932),
  double scale = 1,
  bool capture = false,
  AgentRepository? agents,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  SharedPreferences.setMockInitialValues({
    'reduceMotion': true,
    'theme': 'dark',
  });
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        configProvider.overrideWithValue(const AppConfig()),
        preferencesProvider.overrideWithValue(preferences),
        lifeRepositoryProvider.overrideWithValue(repo),
        if (agents != null) agentRepositoryProvider.overrideWithValue(agents),
        currentSessionProvider.overrideWithValue(
          Session(
            accessToken: 'test-only',
            tokenType: 'bearer',
            user: User(
              id: 'test-user',
              appMetadata: {},
              userMetadata: {},
              aud: 'authenticated',
              createdAt: '2026-11-19T00:00:00Z',
            ),
          ),
        ),
      ],
      child: capture
          ? const RepaintBoundary(
              key: ValueKey('capture-root'),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Banner(
                  message: 'TEST DATA',
                  color: Color(0xFFFFCA79),
                  textStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  location: BannerLocation.topEnd,
                  child: LifeverseApp(),
                ),
              ),
            )
          : const LifeverseApp(),
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(LifeverseApp)),
  );
  container.read(routerProvider).go(route);
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(RecordEditor).evaluate().isNotEmpty
      ? find
            .descendant(
              of: find.byType(RecordEditor),
              matching: find.byType(Scrollable),
            )
            .first
      : find.byType(Scrollable).first;
  await tester.scrollUntilVisible(
    finder.hitTestable(),
    180,
    scrollable: scrollable,
  );
  await tester.tap(finder.hitTestable());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('goal progress and linked task save together', (tester) async {
    final repo = FakeLifeRepository();
    await mountCore(tester, repo, '/goals');
    await tester.tap(find.text('New goal'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Learn Dart',
    );
    await tapVisible(tester, find.byType(Slider));
    await tapVisible(tester, find.text('Save goal'));
    expect(repo.goalItems.single.progress, greaterThan(0));
    await tapVisible(tester, find.text('Add task'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Build a widget',
    );
    await tapVisible(tester, find.text('Save task'));
    expect(repo.taskItems.single.goalId, repo.goalItems.single.id);
  });

  testWidgets('daily habit creation, check-in and undo', (tester) async {
    final repo = FakeLifeRepository();
    await mountCore(tester, repo, '/habits');
    await tester.tap(find.text('New habit'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Read daily',
    );
    await tapVisible(tester, find.text('Save habit'));
    await tapVisible(tester, find.byType(CheckboxListTile));
    expect(repo.habitItems.single.checkedToday, isTrue);
    await tapVisible(tester, find.byType(CheckboxListTile));
    expect(repo.habitItems.single.checkedToday, isFalse);
  });

  testWidgets('memory is private by default and erase requires confirmation', (
    tester,
  ) async {
    final repo = FakeLifeRepository();
    await mountCore(tester, repo, '/memory');
    await tester.tap(find.text('New memory'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Learning preference',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Memory'),
      'Use diagrams',
    );
    await tapVisible(tester, find.text('Save memory'));
    expect(repo.memoryItems.single.allowAi, isFalse);
    await tapVisible(tester, find.text('Erase all memories'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repo.memoryItems, hasLength(1));
    await tapVisible(tester, find.text('Erase all memories'));
    await tester.tap(find.widgetWithText(FilledButton, 'Erase all'));
    await tester.pumpAndSettle();
    expect(repo.memoryItems, isEmpty);
  });

  testWidgets('revoking AI consent also revokes memory sharing', (
    tester,
  ) async {
    final repo = FakeLifeRepository();
    await mountCore(tester, repo, '/profile');
    await tapVisible(
      tester,
      find.widgetWithText(SwitchListTile, 'Allow AI processing'),
    );
    await tapVisible(tester, find.text('Save profile'));
    expect(repo.savedProfile!.aiConsent, isFalse);
    expect(repo.savedProfile!.memoryConsent, isFalse);
  });
  test('DTO contracts keep snake_case, nulls and UTC timestamps', () {
    final task = TaskItem.fromJson({
      'id': 'id',
      'title': 'Read',
      'due_at': '2026-11-19T12:00:00Z',
      'created_at': '2026-11-19T00:00:00Z',
    });
    expect(task.dueAt!.isUtc, isTrue);
    expect(task.toJson()['goal_id'], isNull);
    expect(task.copyWith(status: 'done').status, 'done');
  });

  testWidgets('task creation validation, completion and confirmed deletion', (
    tester,
  ) async {
    final repo = FakeLifeRepository();
    await mountCore(tester, repo, '/planner');
    await tester.tap(find.text('New task'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Save task'));
    expect(find.text('Enter a title'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Read a chapter',
    );
    await tapVisible(tester, find.text('Save task'));
    expect(repo.taskItems.single.title, 'Read a chapter');
    await tapVisible(tester, find.byType(CheckboxListTile));
    expect(repo.taskItems.single.status, 'done');
    await tapVisible(tester, find.byTooltip('Delete record'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repo.taskItems, hasLength(1));
    await tapVisible(tester, find.byTooltip('Delete record'));
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(repo.taskItems, isEmpty);
  });

  testWidgets('provider errors retry without inventing records', (
    tester,
  ) async {
    final repo = FakeLifeRepository()..failTasks = true;
    await mountCore(tester, repo, '/planner');
    expect(find.text('Test connection failure'), findsOneWidget);
    repo.failTasks = false;
    await tapVisible(tester, find.text('Retry'));
    expect(find.text('Room to focus'), findsOneWidget);
  });

  testWidgets('assistant failure preserves draft and request ID on retry', (
    tester,
  ) async {
    final repo = FakeLifeRepository()..failChat = true;
    await mountCore(tester, repo, '/assistant');
    await tester.scrollUntilVisible(
      find.widgetWithText(TextField, 'Ask LIFEVERSE').hitTestable(),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Ask LIFEVERSE'),
      'Help me plan',
    );
    await tapVisible(tester, find.text('Send message'));
    expect(find.text('Test provider unavailable'), findsOneWidget);
    expect(repo.messageItems, isEmpty);
    repo.failChat = false;
    await tapVisible(tester, find.text('Retry message'));
    expect(repo.requestIds[0], repo.requestIds[1]);
    expect(repo.messageItems, hasLength(2));
  });

  testWidgets('dashboard uses repository counts', (tester) async {
    final repo = FakeLifeRepository();
    repo.taskItems.add(
      TaskItem(
        id: 'task',
        title: 'Done',
        status: 'done',
        createdAt: FakeLifeRepository.timestamp,
      ),
    );
    await mountCore(tester, repo, '/insights');
    await tester.scrollUntilVisible(
      find.text('Completed tasks: 1').hitTestable(),
      200,
    );
    expect(find.text('Completed tasks: 1'), findsOneWidget);
  });

  for (final route in [
    '/profile',
    '/planner',
    '/goals',
    '/habits',
    '/memory',
    '/insights',
    '/assistant',
  ]) {
    testWidgets('$route supports narrow screens and enlarged text', (
      tester,
    ) async {
      await mountCore(
        tester,
        FakeLifeRepository(),
        route,
        size: const Size(320, 640),
        scale: 1.5,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
