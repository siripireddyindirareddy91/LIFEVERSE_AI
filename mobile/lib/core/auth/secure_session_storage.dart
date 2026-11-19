import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase refresh tokens never enter ordinary shared preferences.
class SecureSessionStorage extends LocalStorage {
  SecureSessionStorage(this.storage);
  final FlutterSecureStorage storage;
  static const key = 'lifeverse.auth.session';

  @override
  Future<void> initialize() async {}
  @override
  Future<String?> accessToken() => storage.read(key: key);
  @override
  Future<bool> hasAccessToken() => storage.containsKey(key: key);
  @override
  Future<void> persistSession(String persistSessionString) =>
      storage.write(key: key, value: persistSessionString);
  @override
  Future<void> removePersistedSession() => storage.delete(key: key);
}

class SecurePkceStorage extends GotrueAsyncStorage {
  const SecurePkceStorage(this.storage);
  final FlutterSecureStorage storage;

  @override
  Future<String?> getItem({required String key}) =>
      storage.read(key: 'lifeverse.pkce.$key');
  @override
  Future<void> setItem({required String key, required String value}) =>
      storage.write(key: 'lifeverse.pkce.$key', value: value);
  @override
  Future<void> removeItem({required String key}) =>
      storage.delete(key: 'lifeverse.pkce.$key');
}
