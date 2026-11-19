import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(dashboardProvider)
      .when(
        loading: () => const Center(child: UniverseLoadingState()),
        error: (error, stack) => SingleChildScrollView(
          padding: const EdgeInsets.all(Space.lg),
          child: UniverseErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(dashboardProvider),
          ),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(Space.lg),
          children: [
            Text(
              'Your life, in perspective.',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: Space.md),
            Text('${plainDate(data.today)} • ${data.timezone}'),
            const SizedBox(height: Space.sm),
            const Text(
              'A view of your saved records. Your progress is personal, never a comparison.',
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                tooltip: 'Refresh dashboard',
                onPressed: () => ref.invalidate(dashboardProvider),
                icon: const Icon(Icons.refresh),
              ),
            ),
            _metric(
              context,
              'Your focus',
              'Open tasks: ${data.tasksOpen}',
              '${data.tasksDueToday} due today • ${data.tasksOverdue} overdue',
              Icons.checklist_rounded,
              '/planner',
            ),
            _metric(
              context,
              'Your ambitions',
              'Completed goals: ${data.goalsCompleted}',
              'Active goals: ${data.goalsActive} • progress is self-reported',
              Icons.auto_awesome_outlined,
              '/goals',
            ),
            _metric(
              context,
              'Your daily rhythm',
              '${data.habitsCompletedToday} of ${data.habitCount} habits checked in',
              'Daily check-ins use your profile time zone.',
              Icons.spa_outlined,
              '/habits',
            ),
            _metric(
              context,
              'Your memory',
              '${data.memoriesActive} saved memories',
              'Only unexpired records are counted.',
              Icons.psychology_outlined,
              '/memory',
            ),
            const SizedBox(height: Space.lg),
            UniverseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading(
                    title: 'The last seven days',
                    subtitle:
                        'Completed tasks and habit check-ins, from your records.',
                  ),
                  const SizedBox(height: Space.lg),
                  ActivityBars(days: data.weeklyActivity),
                  const SizedBox(height: Space.md),
                  Text('Completed tasks: ${data.tasksCompleted}'),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _metric(
    BuildContext context,
    String label,
    String value,
    String detail,
    IconData icon,
    String route,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: Space.md),
    child: UniverseSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: Space.md),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: Space.sm),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: Space.sm),
          Text(detail),
          TextButton(
            onPressed: () => context.push(route),
            child: const Text('Open space'),
          ),
        ],
      ),
    ),
  );
}

class ActivityBars extends StatelessWidget {
  const ActivityBars({required this.days, super.key});
  final List<ActivityDay> days;
  @override
  Widget build(BuildContext context) {
    final largest = days.fold<int>(
      0,
      (value, day) => math.max(value, day.tasksCompleted + day.habitCheckins),
    );
    if (largest == 0) {
      return const Text(
        'No completions in this period yet. Small steps count.',
      );
    }
    return SizedBox(
      height: 112 + MediaQuery.textScalerOf(context).scale(14) * 2.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final day in days)
            Expanded(
              child: Semantics(
                label:
                    '${plainDate(day.day)}: ${day.tasksCompleted} completed tasks and ${day.habitCheckins} habit check-ins',
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${day.tasksCompleted + day.habitCheckins}'),
                      const SizedBox(height: 4),
                      Container(
                        height:
                            80 *
                                (day.tasksCompleted + day.habitCheckins) /
                                largest +
                            2,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.E()
                            .format(DateTime.parse(day.day))
                            .substring(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
