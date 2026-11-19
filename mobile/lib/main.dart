import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/providers.dart';
import 'core/auth/secure_session_storage.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final config = AppConfig.fromEnvironment()..validate();
    final preferences = await SharedPreferences.getInstance();
    SupabaseClient? auth;
    if (config.authConfigured) {
      await Supabase.initialize(
        url: config.supabaseUrl,
        publishableKey: config.supabaseKey,
        debug: false,
        authOptions: FlutterAuthClientOptions(
          pkceAsyncStorage: const SecurePkceStorage(FlutterSecureStorage()),
          localStorage: SecureSessionStorage(const FlutterSecureStorage()),
        ),
      );
      auth = Supabase.instance.client;
    }
    runApp(
      ProviderScope(
        overrides: [
          configProvider.overrideWithValue(config),
          preferencesProvider.overrideWithValue(preferences),
          authProvider.overrideWithValue(auth),
        ],
        child: const LifeverseApp(),
      ),
    );
  } catch (_) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'LIFEVERSE could not start. Check environment configuration and secure storage, then restart.',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
