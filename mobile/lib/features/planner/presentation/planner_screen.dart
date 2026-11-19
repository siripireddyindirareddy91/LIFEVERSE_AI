import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/data/life_repository.dart';
import '../../life/presentation/life_widgets.dart';
import '../../life/presentation/record_editor.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({this.goalId, this.goalTitle, super.key});
  final String? goalId;
  final String? goalTitle;
  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  late LifeQuery _tasks = LifeQuery(goalId: widget.goalId);
  LifeQuery _events = const LifeQuery();
  bool _calendar = false;
  bool _allEvents = true;
  DateTime _day = DateTime.now();
  void _dateQuery() => _events = _events.copyWith(
    offset: 0,
    startsAfter: _allEvents ? null : DateTime(_day.year, _day.month, _day.day),
    endsBefore: _allEvents
        ? null
        : DateTime(_day.year, _day.month, _day.day + 1),
  );

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(mutationProvider).isLoading;
    return ListView(
      padding: const EdgeInsets.all(Space.lg),
      children: [
        Text(
          'A little space for your day.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: Space.md),
        Text(
          widget.goalTitle == null
              ? 'Tasks and commitments, brought together. Calendar dates use your device time zone.'
              : 'Tasks linked to ${widget.goalTitle}. Calendar dates use your device time zone.',
        ),
        const SizedBox(height: Space.lg),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Tasks'),
              selected: !_calendar,
              onSelected: (_) => setState(() => _calendar = false),
            ),
            ChoiceChip(
              label: const Text('Calendar'),
              selected: _calendar,
              onSelected: (_) => setState(() => _calendar = true),
            ),
          ],
        ),
        const SizedBox(height: Space.lg),
        LifeverseButton(
          label: _calendar ? 'New event' : 'New task',
          icon: Icons.add,
          onPressed: () => openRecordEditor(
            context,
            _calendar ? RecordKind.events : RecordKind.tasks,
            goalId: widget.goalId,
            goalTitle: widget.goalTitle,
          ),
        ),
        const SizedBox(height: Space.lg),
        if (!_calendar) ...[
          Wrap(
            spacing: 8,
            children: [
              for (final entry in {
                null: 'All',
                'todo': 'Open',
                'done': 'Completed',
              }.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: _tasks.status == entry.key,
                  onSelected: (_) => setState(
                    () =>
                        _tasks = _tasks.copyWith(status: entry.key, offset: 0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Space.md),
          RecordSearch(
            key: const ValueKey('task-search'),
            onSearch: (value) => setState(
              () => _tasks = _tasks.copyWith(search: value, offset: 0),
            ),
          ),
          const SizedBox(height: Space.lg),
          RecordsView<TaskItem>(
            data: ref.watch(tasksProvider(_tasks)),
            onRetry: () => ref.invalidate(tasksProvider(_tasks)),
            onOffset: (value) =>
                setState(() => _tasks = _tasks.copyWith(offset: value)),
            emptyTitle: 'Room to focus',
            emptyMessage: 'Add a task, or change your search or status filter.',
            itemBuilder: (task) => UniverseSurface(
              accent: Aurora.teal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      task.title,
                      style: task.status == 'done'
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )
                          : null,
                    ),
                    value: task.status == 'done',
                    onChanged: busy
                        ? null
                        : (_) => runLifeAction(
                            context,
                            ref,
                            (repo) => repo.taskStatus(task),
                            success: task.status == 'done'
                                ? 'Task reopened'
                                : 'Task completed',
                          ),
                  ),
                  if (task.notes.isNotEmpty) Text(task.notes),
                  const SizedBox(height: Space.sm),
                  StatusPill('${task.priority} priority'),
                  if (task.dueAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Due: ${deviceDate(task.dueAt!)}'),
                    ),
                  if (task.goalId != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Linked to a goal'),
                    ),
                  RecordActions(
                    onEdit: () => openRecordEditor(
                      context,
                      RecordKind.tasks,
                      initial: task,
                    ),
                    onDelete: () =>
                        removeRecord(context, ref, RecordKind.tasks, task.id),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show all events'),
            value: _allEvents,
            onChanged: (value) => setState(() {
              _allEvents = value;
              _dateQuery();
            }),
          ),
          if (!_allEvents)
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text(DateFormat.yMMMEd().format(_day)),
              onPressed: () async {
                final value = await showDatePicker(
                  context: context,
                  initialDate: _day,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (value != null && mounted) {
                  setState(() {
                    _day = value;
                    _dateQuery();
                  });
                }
              },
            ),
          const SizedBox(height: Space.md),
          RecordSearch(
            key: const ValueKey('event-search'),
            onSearch: (value) => setState(
              () => _events = _events.copyWith(search: value, offset: 0),
            ),
          ),
          const SizedBox(height: Space.lg),
          RecordsView<CalendarItem>(
            data: ref.watch(eventsProvider(_events)),
            onRetry: () => ref.invalidate(eventsProvider(_events)),
            onOffset: (value) =>
                setState(() => _events = _events.copyWith(offset: value)),
            emptyTitle: 'An open horizon',
            emptyMessage:
                'No events match this view. Add a commitment or choose another day.',
            itemBuilder: (event) => UniverseSurface(
              accent: Aurora.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: Space.md),
                  Text(
                    '${deviceDate(event.startsAt)}\n${deviceDate(event.endsAt)}',
                  ),
                  if (event.notes.isNotEmpty) ...[
                    const SizedBox(height: Space.sm),
                    Text(event.notes),
                  ],
                  RecordActions(
                    onEdit: () => openRecordEditor(
                      context,
                      RecordKind.events,
                      initial: event,
                    ),
                    onDelete: () =>
                        removeRecord(context, ref, RecordKind.events, event.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
