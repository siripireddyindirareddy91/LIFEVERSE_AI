import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifeverse_ai/features/universe/domain/life_space.dart';
import 'package:lifeverse_ai/shared/widgets/ai_orb.dart';
import 'app_test.dart' as helpers;

void main() {
  testWidgets('motion preference persists and reaches the Home orb', (
    tester,
  ) async {
    await helpers.mount(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    final toggle = find.byType(SwitchListTile);
    await tester.scrollUntilVisible(toggle.hitTestable(), 200);
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getBool('reduceMotion'),
      isFalse,
    );
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getBool('reduceMotion'),
      isTrue,
    );
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(tester.widget<AIOrb>(find.byType(AIOrb)).animate, isFalse);
  });
  testWidgets('all eight spaces navigate and disclose availability', (
    tester,
  ) async {
    await helpers.mount(tester);
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    for (final space in LifeSpace.values) {
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('destination-${space.id}')).hitTestable(),
        200,
      );
      await tester.tap(find.byKey(ValueKey('destination-${space.id}')));
      await tester.pumpAndSettle();
      expect(find.text(space.headline), findsOneWidget);
      expect(find.text('Coming in a later phase'), findsOneWidget);
      await tester.tap(find.text('Back to your universe'));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('orb opens honest AI information instead of simulating work', (
    tester,
  ) async {
    await helpers.mount(tester);
    await tester.scrollUntilVisible(find.byType(AIOrb).hitTestable(), 100);
    await tester.tap(find.byType(AIOrb));
    await tester.pumpAndSettle();
    expect(find.text('Meet your future AI space'), findsOneWidget);
    expect(find.textContaining('No microphone is active'), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Meet your future AI space'), findsNothing);
  });

  testWidgets('radial navigation opens a destination', (tester) async {
    await helpers.mount(tester, size: const Size(430, 932));
    final target = find.byKey(const ValueKey('destination-goals'));
    await tester.scrollUntilVisible(target.hitTestable(), 100);
    await tester.tap(target);
    await tester.pumpAndSettle();
    expect(find.text(LifeSpace.goals.headline), findsOneWidget);
  });

  testWidgets('all orb states are semantic and still under reduced motion', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    for (final state in OrbState.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Center(child: AIOrb(state: state)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.bySemanticsLabel('LIFEVERSE AI orb. ${state.label}'),
        findsOneWidget,
      );
      expect(tester.binding.hasScheduledFrame, isFalse);
    }
    semantics.dispose();
  });

  testWidgets('orb animates normally and stops when motion is disabled', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Center(child: AIOrb())));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(
      const MaterialApp(home: Center(child: AIOrb(animate: false))),
    );
    await tester.pumpAndSettle();
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
