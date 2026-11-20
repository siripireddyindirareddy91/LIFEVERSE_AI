import 'dart:convert';

class AppConfig {
  const AppConfig({
    this.environment = 'development',
    this.apiBaseUrl = 'http://10.0.2.2:8000',
    this.supabaseUrl = '',
    this.supabaseKey = '',
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
    environment: String.fromEnvironment('APP_ENV', defaultValue: 'development'),
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8000',
    ),
    supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
    supabaseKey: String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  final String environment;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseKey;

  bool get authConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;

  void validate() {
    if (!['development', 'staging', 'production'].contains(environment)) {
      throw const FormatException(
        'APP_ENV must be development, staging or production.',
      );
    }
    final api = Uri.tryParse(apiBaseUrl);
    if (api == null ||
        !['http', 'https'].contains(api.scheme) ||
        api.host.isEmpty ||
        (api.path.isNotEmpty && api.path != '/') ||
        api.hasQuery ||
        api.hasFragment ||
        api.userInfo.isNotEmpty) {
      throw const FormatException(
        'API_BASE_URL must be a valid HTTP(S) origin.',
      );
    }
    if (environment != 'development' && api.scheme != 'https') {
      throw const FormatException('HTTPS is required outside development.');
    }
    if (supabaseUrl.isEmpty != supabaseKey.isEmpty) {
      throw const FormatException('Provide both Supabase URL and public key.');
    }
    if (authConfigured) {
      final auth = Uri.tryParse(supabaseUrl);
      if (auth == null ||
          auth.scheme != 'https' ||
          auth.host.isEmpty ||
          auth.userInfo.isNotEmpty ||
          (auth.path.isNotEmpty && auth.path != '/') ||
          auth.hasQuery ||
          auth.hasFragment) {
        throw const FormatException('Supabase requires an HTTPS project URL.');
      }
      if (supabaseKey.startsWith('sb_secret_')) {
        throw const FormatException('Use a public Supabase key in the app.');
      }
      final parts = supabaseKey.split('.');
      if (parts.length == 3) {
        Map<String, dynamic>? claims;
        try {
          claims =
              jsonDecode(
                    utf8.decode(
                      base64Url.decode(base64Url.normalize(parts[1])),
                    ),
                  )
                  as Map<String, dynamic>;
        } catch (_) {
          throw const FormatException('Invalid Supabase public key.');
        }
        if (claims['role'] != 'anon') {
          throw const FormatException(
            'Use a public Supabase anon key in the app.',
          );
        }
      }
    }
    if (environment != 'development' && !authConfigured) {
      throw const FormatException(
        'Supabase configuration is required outside development.',
      );
    }
  }
}
