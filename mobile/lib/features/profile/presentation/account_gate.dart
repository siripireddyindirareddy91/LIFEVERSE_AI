import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../application/account_providers.dart';

class AccountGate extends ConsumerWidget {
  const AccountGate({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session != null) {
      return KeyedSubtree(key: ValueKey(session.user.id), child: child);
    }
    if (ref.watch(authProvider) == null) {
      return ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          UniverseEmptyState(
            title: 'Connect your account',
            icon: Icons.lock_outline_rounded,
            message:
                'Private life spaces need a connected identity service. Your Home Universe remains available while account setup is completed.',
            action: LifeverseButton(
              label: 'View connection setup',
              onPressed: () => context.push('/foundation'),
            ),
          ),
        ],
      );
    }
    return const SignInScreen();
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _obscure = true;
  String? _notice;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(accountActionProvider).isLoading;
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Text(
          _register
              ? 'Your universe starts here.'
              : 'Welcome to your universe.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Space.md),
        const Text(
          'Sign in to keep your plans, goals and memories private and connected.',
        ),
        const SizedBox(height: Space.lg),
        Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                enabled: !busy,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    RegExp(
                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                    ).hasMatch(value?.trim() ?? '')
                    ? null
                    : 'Enter a valid email address',
              ),
              const SizedBox(height: Space.md),
              TextFormField(
                controller: _password,
                enabled: !busy,
                obscureText: _obscure,
                autofillHints: [
                  _register
                      ? AutofillHints.newPassword
                      : AutofillHints.password,
                ],
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => (value ?? '').length < (_register ? 8 : 1)
                    ? (_register
                          ? 'Use at least 8 characters'
                          : 'Enter your password')
                    : null,
              ),
              if (_notice != null) ...[
                const SizedBox(height: Space.md),
                Semantics(liveRegion: true, child: Text(_notice!)),
              ],
              const SizedBox(height: Space.lg),
              LifeverseButton(
                label: _register ? 'Create account' : 'Sign in',
                busy: busy,
                onPressed: () async {
                  if (!_form.currentState!.validate()) return;
                  setState(() => _notice = null);
                  try {
                    final message = await ref
                        .read(accountActionProvider.notifier)
                        .authenticate(
                          email: _email.text.trim(),
                          password: _password.text,
                          register: _register,
                        );
                    if (mounted) {
                      setState(() {
                        _notice = message;
                        if (message != null) _register = false;
                      });
                    }
                  } catch (error) {
                    if (mounted) setState(() => _notice = error.toString());
                  }
                },
              ),
              TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() {
                        _register = !_register;
                        _notice = null;
                      }),
                child: Text(
                  _register
                      ? 'Already have an account? Sign in'
                      : 'New here? Create an account',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
