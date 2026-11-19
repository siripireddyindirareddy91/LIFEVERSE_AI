import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';

final configProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('Bootstrap configuration'),
);
final preferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Bootstrap preferences'),
);
final authProvider = Provider<SupabaseClient?>((ref) => null);
final apiProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    ref.watch(configProvider).apiBaseUrl,
    ref.watch(authProvider),
  );
  ref.onDispose(client.dispose);
  return client;
});
final readinessProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(apiProvider).checkReadiness(),
);

final themeProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

final reduceMotionProvider = NotifierProvider<ReduceMotionController, bool>(
  ReduceMotionController.new,
);

class ReduceMotionController extends Notifier<bool> {
  @override
  bool build() =>
      ref.watch(preferencesProvider).getBool('reduceMotion') ?? false;
  Future<void> setEnabled(bool enabled) async {
    final stored = await ref
        .read(preferencesProvider)
        .setBool('reduceMotion', enabled);
    if (!stored) throw StateError('Unable to save motion preference.');
    state = enabled;
  }
}

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final value = ref.watch(preferencesProvider).getString('theme');
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    final stored = await ref
        .read(preferencesProvider)
        .setString('theme', mode.name);
    if (!stored) throw StateError('Unable to save appearance preference.');
    state = mode;
  }
}
