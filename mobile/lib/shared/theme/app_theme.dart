import 'package:flutter/material.dart';
import 'tokens.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final colors =
        ColorScheme.fromSeed(
          seedColor: Aurora.orchid,
          brightness: brightness,
        ).copyWith(
          primary: dark ? Aurora.orchid : const Color(0xFF6C279E),
          onPrimary: dark ? Aurora.voidColor : Colors.white,
          secondary: dark ? Aurora.teal : const Color(0xFF006B5A),
          onSecondary: dark ? Aurora.voidColor : Colors.white,
          surface: dark ? Aurora.voidColor : Aurora.light,
          onSurface: dark ? Aurora.light : Aurora.voidColor,
          onSurfaceVariant: dark ? Aurora.silver : const Color(0xFF585968),
        );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      brightness: brightness,
    );
    return base.copyWith(
      scaffoldBackgroundColor: colors.surface,
      textTheme: base.textTheme.copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShapeTokens.controlRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ShapeTokens.controlRadius),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: ShapeTokens.elevation,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShapeTokens.radius),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceContainerLow,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShapeTokens.controlRadius),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        scrolledUnderElevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainerLow,
        showDragHandle: true,
      ),
    );
  }
}
