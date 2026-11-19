import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/data/life_repository.dart';
import '../../life/presentation/life_widgets.dart';
import '../../life/presentation/record_editor.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});
  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  LifeQuery _query = const LifeQuery();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      Text(
        'Dreams, with direction.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: Space.md),
      const Text(
        'Set a goal, report your progress and connect the tasks that move it forward.',
      ),
      const SizedBox(height: Space.lg),
      LifeverseButton(
        label: 'New goal',
        icon: Icons.add,
        onPressed: () => openRecordEditor(context, RecordKind.goals),
      ),
      const SizedBox(height: Space.lg),
      RecordSearch(
        onSearch: (value) => setState(() => _query = LifeQuery(search: value)),
      ),
      const SizedBox(height: Space.lg),
      RecordsView<GoalItem>(
        data: ref.watch(goalsProvider(_query)),
        onRetry: () => ref.invalidate(goalsProvider(_query)),
        onOffset: (value) =>
            setState(() => _query = _query.copyWith(offset: value)),
        emptyTitle: 'What would you like to work toward?',
        emptyMessage:
            'Your goals stay yours. Add one meaningful ambition to begin.',
        itemBuilder: (goal) => UniverseSurface(
          accent: Aurora.amber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal.title, style: Theme.of(context).textTheme.titleLarge),
              if (goal.notes.isNotEmpty) ...[
                const SizedBox(height: Space.sm),
                Text(goal.notes),
              ],
              const SizedBox(height: Space.md),
              LinearProgressIndicator(
                value: goal.progress / 100,
                minHeight: 7,
                borderRadius: BorderRadius.circular(5),
                semanticsLabel: '${goal.title} progress',
                semanticsValue: '${goal.progress}%',
              ),
              const SizedBox(height: Space.sm),
              Text('${goal.progress}% • Your reported progress'),
              if (goal.targetDate != null)
                Text('Target: ${plainDate(goal.targetDate!)}'),
              const SizedBox(height: Space.sm),
              Wrap(
                spacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: () => openRecordEditor(
                      context,
                      RecordKind.tasks,
                      goalId: goal.id,
                      goalTitle: goal.title,
                    ),
                    icon: const Icon(Icons.add_task),
                    label: const Text('Add task'),
                  ),
                  TextButton(
                    onPressed: () => context.push(
                      Uri(
                        path: '/planner',
                        queryParameters: {'goal': goal.id, 'label': goal.title},
                      ).toString(),
                    ),
                    child: const Text('Linked tasks'),
                  ),
                ],
              ),
              RecordActions(
                onEdit: () =>
                    openRecordEditor(context, RecordKind.goals, initial: goal),
                onDelete: () =>
                    removeRecord(context, ref, RecordKind.goals, goal.id),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
