import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/data/life_repository.dart';
import '../../life/presentation/life_widgets.dart';
import '../../life/presentation/record_editor.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});
  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  LifeQuery _query = const LifeQuery();
  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(mutationProvider).isLoading;
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Text(
          'Small steps. Your pace.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Space.md),
        const Text(
          'Daily check-ins follow the time zone in your profile. Missing a day is a chance to begin again.',
        ),
        const SizedBox(height: Space.lg),
        LifeverseButton(
          label: 'New habit',
          icon: Icons.add,
          onPressed: () => openRecordEditor(context, RecordKind.habits),
        ),
        const SizedBox(height: Space.lg),
        RecordSearch(
          onSearch: (value) =>
              setState(() => _query = LifeQuery(search: value)),
        ),
        const SizedBox(height: Space.lg),
        RecordsView<HabitItem>(
          data: ref.watch(habitsProvider(_query)),
          onRetry: () => ref.invalidate(habitsProvider(_query)),
          onOffset: (value) =>
              setState(() => _query = _query.copyWith(offset: value)),
          emptyTitle: 'Start with something kind to yourself',
          emptyMessage:
              'A daily habit can be as small as a glass of water or a page of reading.',
          itemBuilder: (habit) => UniverseSurface(
            accent: Aurora.rose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (habit.notes.isNotEmpty) ...[
                  const SizedBox(height: Space.sm),
                  Text(habit.notes),
                ],
                const SizedBox(height: Space.md),
                StatusPill(
                  habit.active ? '${habit.currentStreak} day streak' : 'Paused',
                ),
                const SizedBox(height: Space.sm),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    habit.checkedToday
                        ? 'Today is checked in'
                        : 'Check in for today',
                  ),
                  subtitle: Text(plainDate(habit.today)),
                  value: habit.checkedToday,
                  onChanged: !habit.active || busy
                      ? null
                      : (_) => runLifeAction(
                          context,
                          ref,
                          (repo) => repo.checkHabit(habit),
                          success: habit.checkedToday
                              ? 'Today’s check-in removed'
                              : 'Check-in saved',
                        ),
                ),
                RecordActions(
                  onEdit: () => openRecordEditor(
                    context,
                    RecordKind.habits,
                    initial: habit,
                  ),
                  onDelete: () =>
                      removeRecord(context, ref, RecordKind.habits, habit.id),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
