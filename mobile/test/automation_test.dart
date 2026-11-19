import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/features/automation/presentation/workflow_builder.dart';
import 'package:lifeverse_ai/features/automation/application/notification_coordinator.dart';
import 'core_life_test.dart' as helpers;
import 'fixtures/fake_life_repository.dart';
import 'fixtures/fake_automation_repository.dart';

void main() {
  test('workflow validation rejects unapproved or misplaced writes', () {
    expect(
      validateNodes([
        {'type': 'trigger'},
        {'type': 'action'},
        {'type': 'output'},
      ]),
      isNotNull,
    );
    expect(
      validateNodes([
        {'type': 'trigger'},
        {'type': 'action'},
        {'type': 'approval'},
        {'type': 'output'},
      ]),
      isNull,
    );
    expect(safeNotificationRoute('https://evil.example/'), false);
    expect(safeNotificationRoute('/automation/runs/test-run'), true);
  });
  testWidgets(
    'builder saves an inactive draft and retry retains its identifier',
    (tester) async {
      final repo = FakeAutomationRepository()..failSave = true;
      await helpers.mountCore(
        tester,
        FakeLifeRepository(),
        '/automation/new',
        automation: repo,
        device: FakeDeviceGateway(),
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Workflow name'),
        'My daily report',
      );
      await helpers.tapVisible(tester, find.text('Save draft'));
      await helpers.tapVisible(tester, find.text('Save draft'));
      expect(repo.saves.length, 2);
      expect(repo.saves[0]['request_id'], repo.saves[1]['request_id']);
      expect(repo.activations, isEmpty);
    },
  );
  testWidgets('activation requires reviewing the exact workflow preview', (
    tester,
  ) async {
    final repo = FakeAutomationRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/automation/workflows/test-workflow',
      automation: repo,
      device: FakeDeviceGateway(),
    );
    await helpers.tapVisible(tester, find.text('Review & activate'));
    expect(repo.activations, isEmpty);
    expect(find.textContaining('Read your own saved records'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'Activate reviewed workflow'),
    );
    await tester.pumpAndSettle();
    expect(repo.activations.single.digest, 'test-digest');
    expect(repo.item.enabled, true);
  });
  testWidgets('builder supports adding a configured condition node', (
    tester,
  ) async {
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/automation/new',
      automation: FakeAutomationRepository(),
      device: FakeDeviceGateway(),
    );
    await helpers.tapVisible(tester, find.text('Add step'));
    await tester.tap(find.text('Condition'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save step'));
    await tester.pumpAndSettle();
    expect(find.text('4. Output'), findsOneWidget);
  });
  testWidgets('reminder saves without enabling device permissions', (
    tester,
  ) async {
    final repo = FakeAutomationRepository(), device = FakeDeviceGateway();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/notifications',
      automation: repo,
      device: device,
    );
    await helpers.tapVisible(tester, find.text('Create a reminder'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Title'),
      'Take a quiet break',
    );
    await tester.tap(find.text('Save reminder'));
    await tester.pumpAndSettle();
    expect(repo.reminders.single['title'], 'Take a quiet break');
    expect(device.permissions, 0);
  });
  testWidgets('device delivery is explicit opt in and can be cleared', (
    tester,
  ) async {
    final device = FakeDeviceGateway();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/notifications',
      automation: FakeAutomationRepository(),
      device: device,
    );
    await tester.tap(find.text('Allow device notifications'));
    await tester.pumpAndSettle();
    expect(device.permissions, 1);
    expect(device.syncs, greaterThan(0));
    await tester.tap(find.text('Allow device notifications'));
    await tester.pumpAndSettle();
    expect(device.clears, 1);
  });
  testWidgets('calendar OAuth defaults to read access', (tester) async {
    final repo = FakeAutomationRepository(), device = FakeDeviceGateway();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/integrations',
      automation: repo,
      device: device,
    );
    await helpers.tapVisible(tester, find.text('Connect').first);
    await tester.tap(find.text('Continue to provider'));
    await tester.pumpAndSettle();
    expect(repo.oauth.single, false);
    expect(device.opens, 1);
  });
  testWidgets('calendar export requires its exact preview confirmation', (
    tester,
  ) async {
    final repo = FakeAutomationRepository();
    await helpers.mountCore(
      tester,
      FakeLifeRepository(),
      '/integrations',
      automation: repo,
      device: FakeDeviceGateway(),
    );
    await helpers.tapVisible(tester, find.text('Approve export'));
    expect(repo.exportDecisions, isEmpty);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'Approve export'),
      ),
    );
    await tester.pumpAndSettle();
    expect(repo.exportDecisions, [true]);
  });
  for (final route in [
    '/automation',
    '/automation/new',
    '/automation/runs/test-run',
    '/notifications',
    '/integrations',
  ]) {
    testWidgets('$route handles narrow screens and large text', (tester) async {
      final repo = FakeAutomationRepository();
      repo.execution = repo.execution.copyWith(status: 'completed');
      await helpers.mountCore(
        tester,
        FakeLifeRepository(),
        route,
        automation: repo,
        device: FakeDeviceGateway(),
        size: const Size(360, 800),
        scale: 1.5,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
