import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/core/auth/secure_session_storage.dart';
import 'package:lifeverse_ai/core/config/app_config.dart';
import 'package:lifeverse_ai/features/automation/application/notification_coordinator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'secure session and PKCE lifecycle use the platform secure channel',
    () async {
      const channel = MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      );
      final values = <String, String>{};
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            final args = Map<String, dynamic>.from(call.arguments as Map);
            final key = args['key'] as String;
            switch (call.method) {
              case 'write':
                values[key] = args['value'] as String;
                return null;
              case 'read':
                return values[key];
              case 'containsKey':
                return values.containsKey(key);
              case 'delete':
                values.remove(key);
                return null;
              default:
                throw StateError('Unexpected secure storage method');
            }
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final session = SecureSessionStorage(const FlutterSecureStorage());
      const pkce = SecurePkceStorage(FlutterSecureStorage());
      await session.persistSession('test-only-session');
      await pkce.setItem(key: 'verifier', value: 'test-only-verifier');
      expect(await session.hasAccessToken(), true);
      expect(await session.accessToken(), 'test-only-session');
      expect(await pkce.getItem(key: 'verifier'), 'test-only-verifier');
      expect(
        values.keys,
        containsAll(['lifeverse.auth.session', 'lifeverse.pkce.verifier']),
      );
      await session.removePersistedSession();
      await pkce.removeItem(key: 'verifier');
      expect(values, isEmpty);
    },
  );

  test('configuration rejects credential URLs, paths and server-only keys', () {
    for (final url in [
      'https://user:password@project.supabase.co',
      'https://project.supabase.co/auth/v1',
    ]) {
      expect(
        () =>
            AppConfig(supabaseUrl: url, supabaseKey: 'public-test').validate(),
        throwsFormatException,
      );
    }
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'role': 'service_role'})))
        .replaceAll('=', '');
    for (final key in ['sb_secret_test-only', 'header.$payload.signature']) {
      expect(
        () => AppConfig(
          supabaseUrl: 'https://project.supabase.co',
          supabaseKey: key,
        ).validate(),
        throwsFormatException,
      );
    }
    expect(
      () =>
          const AppConfig(apiBaseUrl: 'https://api.example/private').validate(),
      throwsFormatException,
    );
  });

  test(
    'notification links cannot select external or query-bearing destinations',
    () {
      for (final route in [
        '//attacker.example',
        '/agents/id?redirect=https://attacker.example',
        '/agents/../settings',
        '/automation/runs/id#secret',
        '/vault',
      ]) {
        expect(safeNotificationRoute(route), false);
      }
      expect(safeNotificationRoute('/agents/test-id'), true);
    },
  );
}
