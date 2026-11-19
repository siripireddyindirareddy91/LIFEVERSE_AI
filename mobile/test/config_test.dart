import 'package:flutter_test/flutter_test.dart';
import 'package:lifeverse_ai/core/config/app_config.dart';

void main() {
  test('development supports explicit unconfigured auth', () {
    const config = AppConfig();
    config.validate();
    expect(config.authConfigured, isFalse);
  });
  test('rejects partial auth and unsafe production API', () {
    expect(
      () => const AppConfig(
        supabaseUrl: 'https://project.supabase.co',
      ).validate(),
      throwsFormatException,
    );
    expect(
      () => const AppConfig(environment: 'production').validate(),
      throwsFormatException,
    );
    expect(
      () => const AppConfig(apiBaseUrl: 'file:///tmp').validate(),
      throwsFormatException,
    );
  });
  test('production requires configured auth and HTTPS', () {
    expect(
      () => const AppConfig(
        environment: 'production',
        apiBaseUrl: 'https://api.example.com',
      ).validate(),
      throwsFormatException,
    );
    const AppConfig(
      environment: 'production',
      apiBaseUrl: 'https://api.example.com',
      supabaseUrl: 'https://project.supabase.co',
      supabaseKey: 'public-test-key',
    ).validate();
  });
}
