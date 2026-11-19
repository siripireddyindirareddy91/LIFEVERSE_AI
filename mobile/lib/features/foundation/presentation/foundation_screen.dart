import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/foundation_panel.dart';

class FoundationScreen extends ConsumerWidget {
  const FoundationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Container(
          padding: const EdgeInsets.all(Space.xl),
          decoration: BoxDecoration(
            gradient: Aurora.gradient,
            borderRadius: BorderRadius.circular(ShapeTokens.radius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'L I F E V E R S E  /  0 1',
                style: TextStyle(
                  color: Aurora.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Space.xl),
              Text(
                'A universe,\nbuilt with intention.',
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(color: Aurora.light),
              ),
              const SizedBox(height: Space.md),
              const Text(
                'Your Life. Your Intelligence. Your Universe.',
                style: TextStyle(color: Aurora.mist, height: 1.6),
              ),
              const SizedBox(height: Space.xl),
              const Text(
                'PROJECT FOUNDATION',
                style: TextStyle(color: Aurora.silver, letterSpacing: 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.lg),
        Text(
          'The beginning of your universe',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: Space.sm),
        const Text(
          'Phase 1 establishes the app, navigation, visual language and secure service connections. Life modules arrive in later phases.',
        ),
        const SizedBox(height: Space.lg),
        StatusMessage(
          icon: config.authConfigured
              ? Icons.verified_user_outlined
              : Icons.key_outlined,
          title: config.authConfigured
              ? 'Auth client configured'
              : 'Connect your identity',
          message: config.authConfigured
              ? 'Supabase is configured. Sign-in and onboarding will be added in the next phase; connectivity is not yet verified.'
              : 'Supabase needs a project URL and public key. The foundation remains available while you configure your project.',
          action: TextButton(
            onPressed: () => context.go('/settings'),
            child: const Text('View configuration'),
          ),
        ),
        const SizedBox(height: Space.md),
        FoundationPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service connection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Space.sm),
              const Text(
                'Check whether the backend and its required configuration are ready.',
              ),
              const SizedBox(height: Space.md),
              FilledButton.icon(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const _ConnectionSheet(),
                ),
                icon: const Icon(Icons.wifi_tethering),
                label: const Text('Check connection'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConnectionSheet extends ConsumerWidget {
  const _ConnectionSheet();
  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: ref
          .watch(readinessProvider)
          .when(
            loading: () => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Checking backend readiness…'),
              ],
            ),
            error: (error, stack) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error.toString()),
                const SizedBox(height: Space.md),
                TextButton(
                  onPressed: () => ref.invalidate(readinessProvider),
                  child: const Text('Retry connection'),
                ),
              ],
            ),
            data: (ready) => Text(
              ready ? 'Backend reports ready.' : 'Backend is not ready.',
            ),
          ),
    ),
  );
}
