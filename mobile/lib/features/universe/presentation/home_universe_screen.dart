import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../profile/application/account_providers.dart';
import '../../life/application/life_providers.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/ai_orb.dart';
import '../../../shared/widgets/universe_components.dart';
import '../domain/life_space.dart';
import 'widgets/radial_navigation.dart';
import 'widgets/universe_backdrop.dart';

class HomeUniverseScreen extends ConsumerWidget {
  const HomeUniverseScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => UniverseBackdrop(
    child: ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        const SizedBox(height: Space.md),
        const StatusPill('YOUR PERSONAL UNIVERSE'),
        if (ref.watch(currentSessionProvider) != null &&
            ref.watch(profileProvider).value != null)
          Padding(
            padding: const EdgeInsets.only(top: Space.lg),
            child: Text(
              'Welcome back, ${ref.watch(profileProvider).value!.displayName}.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        const SizedBox(height: Space.lg),
        Text(
          'A little clarity.\nA world of possibility.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Space.md),
        Text(
          'Your Life. Your Intelligence. Your Universe.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: Space.lg),
        RadialNavigation(
          center: AIOrb(
            size: 148,
            animate: !ref.watch(reduceMotionProvider),
            onPressed: () => _openAI(context),
          ),
          onSelected: (space) => context.push(space.route),
        ),
        const SizedBox(height: Space.sm),
        Center(
          child: Text(
            'One intelligence. Every part of your life.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        Center(
          child: LifeverseButton(
            label: 'Ask LIFEVERSE anything',
            icon: Icons.auto_awesome_outlined,
            onPressed: () => _openAI(context),
          ),
        ),
        const SizedBox(height: Space.xxl),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in {
              'Planner': '/planner',
              'Goals': '/goals',
              'Habits': '/habits',
              'Memory': '/memory',
              'Life Intelligence': '/insights',
            }.entries)
              ActionChip(
                label: Text(entry.key),
                onPressed: () => context.push(entry.value),
              ),
          ],
        ),
        const SizedBox(height: Space.lg),
        SectionHeading(
          title: 'Your universe, connected',
          subtitle: 'Choose a space and discover where it can take you.',
          action: TextButton.icon(
            onPressed: () => context.go('/explore'),
            icon: const Icon(Icons.apps_rounded, size: 18),
            label: const Text('All spaces'),
          ),
        ),
        const SizedBox(height: Space.lg),
        if (ref.watch(currentSessionProvider) != null)
          const _HomeLifeOverview()
        else
          UniverseEmptyState(
            title: 'Make room for your day',
            message:
                'Bring your tasks, goals, daily habits and selected memories together. Sign in to your account to work with your private records.',
            icon: Icons.wb_twilight_rounded,
            action: LifeverseButton(
              label: 'Explore your spaces',
              secondary: true,
              onPressed: () => context.go('/explore'),
            ),
          ),
        const SizedBox(height: Space.xl),
        Text(
          'Designed around your life. At your pace.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Space.lg),
      ],
    ),
  );

  void _openAI(BuildContext context) => context.push('/assistant');
}

class _HomeLifeOverview extends ConsumerWidget {
  const _HomeLifeOverview();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(dashboardProvider)
      .when(
        loading: () =>
            const UniverseLoadingState(label: 'Gathering your life overview…'),
        error: (error, stack) => UniverseErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (data) => UniverseSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today, in your universe',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: Space.md),
              Text(
                '${data.tasksDueToday} tasks due today • ${data.goalsActive} active goals',
              ),
              const SizedBox(height: Space.sm),
              Text(
                '${data.habitsCompletedToday} of ${data.habitCount} daily habits checked in • ${data.timezone}',
              ),
              const SizedBox(height: Space.md),
              LifeverseButton(
                label: 'View Life Intelligence',
                secondary: true,
                onPressed: () => context.push('/insights'),
              ),
            ],
          ),
        ),
      );
}

class ExploreUniverseScreen extends StatelessWidget {
  const ExploreUniverseScreen({super.key});
  @override
  Widget build(BuildContext context) => UniverseBackdrop(
    child: ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Text(
          'Every part of you.\nOne universe.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Space.md),
        const Text(
          'Your planner, goals, daily habits and personal memory are ready to connect to your account. Other spaces show what is planned.',
        ),
        const SizedBox(height: Space.xl),
        for (final space in LifeSpace.values)
          SpaceListTile(space: space, onTap: () => context.push(space.route)),
      ],
    ),
  );
}

class LifeSpaceScreen extends StatelessWidget {
  const LifeSpaceScreen({required this.space, super.key});
  final LifeSpace space;
  @override
  Widget build(BuildContext context) => UniverseBackdrop(
    child: ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/explore');
              }
            },
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to your universe'),
          ),
        ),
        const SizedBox(height: Space.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: space.accent.withValues(alpha: .15),
            ),
            child: Icon(
              space.icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: Space.lg),
        Text(
          space.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: Space.md),
        Text(space.headline, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: Space.lg),
        Text(space.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: Space.xl),
        const StatusPill('Coming in a later phase'),
        const SizedBox(height: Space.lg),
        const UniverseEmptyState(
          title: 'A space for what’s next',
          message:
              'This introduction is part of the UI foundation. This life module is not active yet, and no personal records have been created.',
          icon: Icons.auto_awesome_outlined,
        ),
        const SizedBox(height: Space.lg),
        LifeverseButton(
          label: 'Explore other spaces',
          onPressed: () => context.go('/explore'),
          secondary: true,
        ),
      ],
    ),
  );
}
