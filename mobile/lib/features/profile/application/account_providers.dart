import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/providers.dart';
import '../../../core/network/api_client.dart';

final authEventsProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(authProvider);
  return client?.auth.onAuthStateChange ?? const Stream<AuthState>.empty();
});
final currentSessionProvider = Provider<Session?>((ref) {
  ref.watch(authEventsProvider);
  return ref.watch(authProvider)?.auth.currentSession;
});

final accountActionProvider =
    NotifierProvider<AccountController, AsyncValue<void>>(
      AccountController.new,
    );

class AccountController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<String?> authenticate({
    required String email,
    required String password,
    required bool register,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(authProvider);
      if (client == null) {
        throw const ApiFailure('Identity service is not configured.');
      }
      String? info;
      if (register) {
        final result = await client.auth.signUp(
          email: email,
          password: password,
        );
        if (result.session == null) {
          info = 'Check your email to confirm your account, then sign in.';
        }
      } else {
        await client.auth.signInWithPassword(email: email, password: password);
      }
      state = const AsyncData(null);
      return info;
    } catch (error, stack) {
      final failure = ApiFailure(
        error is AuthException
            ? error.message
            : 'Could not sign in. Please retry.',
      );
      state = AsyncError(failure, stack);
      throw failure;
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await ref.read(authProvider)?.auth.signOut();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
      rethrow;
    }
  }
}
