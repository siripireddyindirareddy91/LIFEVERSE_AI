import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lifeverse_ai/app/app.dart';
import 'package:lifeverse_ai/app/providers.dart';
import 'package:lifeverse_ai/core/config/app_config.dart';

Future<void> mount(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double scale = 1,
  bool reduceMotion = true,
  String theme = 'system',
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  SharedPreferences.setMockInitialValues({
    'reduceMotion': reduceMotion,
    'theme': theme,
  });
  final preferences = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        configProvider.overrideWithValue(const AppConfig()),
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: const LifeverseApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('navigation and appearance preference work', (tester) async {
    await mount(tester);
    expect(
      find.text('A little clarity.\nA world of possibility.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect((await SharedPreferences.getInstance()).getString('theme'), 'dark');
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(find.text('Aurora Nebula'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Preview dialog').hitTestable(),
      200,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Designed for clarity'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Designed for clarity'), findsNothing);
  });

  for (final size in [
    const Size(320, 640),
    const Size(430, 932),
    const Size(1024, 1366),
  ]) {
    testWidgets('responsive shell at $size', (tester) async {
      await mount(tester, size: size, scale: 1.5);
      expect(tester.takeException(), isNull);
      expect(
        size.width >= 760
            ? find.byType(NavigationRail)
            : find.byType(NavigationBar),
        findsOneWidget,
      );
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Appearance'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
