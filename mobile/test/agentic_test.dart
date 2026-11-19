import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'core_life_test.dart' as helpers;
import 'fixtures/fake_agent_repository.dart';
import 'fixtures/fake_life_repository.dart';

void main() {
  testWidgets('approval starts empty and enforces dependencies', (
    tester,
  ) async {
    final agents = FakeAgentRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/agents/test-run',
      agents: agents,
    );
    final approve = find.widgetWithText(
      FilledButton,
      'Approve 0 selected changes',
    );
    await helpers.tapVisible(
      tester,
      find.text('Change 2 · Create a linked task'),
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Approve 1 selected changes'),
          )
          .onPressed,
      isNull,
    );
    expect(agents.decisions, isEmpty);
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 500));
    await tester.pumpAndSettle();
    await helpers.tapVisible(tester, find.text('Change 1 · Create a goal'));
    await helpers.tapVisible(tester, find.text('Approve 2 selected changes'));
    expect(agents.decisions.single['action_ids'], [
      'goal-action',
      'task-action',
    ]);
    expect(agents.decisions.single['digest'], 'test-digest');
    expect(approve, findsNothing);
  });
  testWidgets('failed decision retry keeps its idempotency key', (
    tester,
  ) async {
    final agents = FakeAgentRepository()..fail = true;
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/agents/test-run',
      agents: agents,
    );
    await helpers.tapVisible(tester, find.text('Change 1 · Create a goal'));
    await helpers.tapVisible(tester, find.text('Approve 1 selected changes'));
    await helpers.tapVisible(tester, find.text('Approve 1 selected changes'));
    expect(agents.decisions.length, 2);
    expect(
      agents.decisions[0]['request_id'],
      agents.decisions[1]['request_id'],
    );
  });
  testWidgets('reject requires confirmation and sends no selected actions', (
    tester,
  ) async {
    final agents = FakeAgentRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/agents/test-run',
      agents: agents,
    );
    await helpers.tapVisible(tester, find.text('Reject all proposals'));
    expect(agents.decisions, isEmpty);
    await tester.tap(find.widgetWithText(FilledButton, 'Reject all'));
    await tester.pumpAndSettle();
    expect(agents.decisions.single['decision'], 'reject');
    expect(agents.decisions.single['action_ids'], isEmpty);
  });
  testWidgets('new runs default to read only and empty scopes', (tester) async {
    final agents = FakeAgentRepository()..fail = true;
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/agents/new',
      agents: agents,
    );
    await tester.enterText(find.byType(TextField), 'Plan a study session');
    await helpers.tapVisible(tester, find.text('Send to supervisor'));
    await helpers.tapVisible(tester, find.text('Send to supervisor'));
    expect(agents.requests.singleOrNull, isNull);
    expect(agents.requests.first['allow_proposals'], false);
    expect(agents.requests.first['scopes'], isEmpty);
    expect(agents.requests[0]['request_id'], agents.requests[1]['request_id']);
  });
  testWidgets('knowledge sources start private', (tester) async {
    final agents = FakeAgentRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/knowledge',
      agents: agents,
    );
    await tester.tap(find.text('Add knowledge source'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'My notes',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reference text'),
      'A private reference.',
    );
    await tester.tap(find.text('Save source'));
    await tester.pumpAndSettle();
    expect(agents.savedSource!['allow_ai'], false);
    expect(agents.savedSource!['expires_at'], null);
  });
  for (final route in [
    '/agents',
    '/agents/new',
    '/agents/test-run',
    '/knowledge',
  ]) {
    testWidgets('$route fits narrow screens with enlarged text', (
      tester,
    ) async {
      await helpers.mountCore(
        tester,
        FakeLifeRepository(),
        route,
        agents: FakeAgentRepository(),
        size: const Size(360, 800),
        scale: 1.5,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
