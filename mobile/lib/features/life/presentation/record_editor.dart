import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../application/life_providers.dart';
import '../data/life_repository.dart';
import 'life_widgets.dart';

String recordId(Object item) => switch (item) {
  TaskItem v => v.id,
  GoalItem v => v.id,
  HabitItem v => v.id,
  MemoryItem v => v.id,
  CalendarItem v => v.id,
  _ => throw ArgumentError('Unsupported record'),
};
String recordTitle(Object? item) => switch (item) {
  TaskItem v => v.title,
  GoalItem v => v.title,
  HabitItem v => v.title,
  MemoryItem v => v.title,
  CalendarItem v => v.title,
  _ => '',
};
String recordNotes(Object? item) => switch (item) {
  TaskItem v => v.notes,
  GoalItem v => v.notes,
  HabitItem v => v.notes,
  MemoryItem v => v.content,
  CalendarItem v => v.notes,
  _ => '',
};

Future<void> openRecordEditor(
  BuildContext context,
  RecordKind kind, {
  Object? initial,
  String? goalId,
  String? goalTitle,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * .9,
    ),
    child: RecordEditor(
      kind: kind,
      initial: initial,
      goalId: goalId,
      goalTitle: goalTitle,
    ),
  ),
);

class RecordEditor extends ConsumerStatefulWidget {
  const RecordEditor({
    required this.kind,
    this.initial,
    this.goalId,
    this.goalTitle,
    super.key,
  });
  final RecordKind kind;
  final Object? initial;
  final String? goalId;
  final String? goalTitle;
  @override
  ConsumerState<RecordEditor> createState() => _RecordEditorState();
}

class _RecordEditorState extends ConsumerState<RecordEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: recordTitle(widget.initial));
  late final _notes = TextEditingController(text: recordNotes(widget.initial));
  late String _priority = widget.initial is TaskItem
      ? (widget.initial as TaskItem).priority
      : 'normal';
  late String _status = widget.initial is TaskItem
      ? (widget.initial as TaskItem).status
      : 'todo';
  late int _progress = widget.initial is GoalItem
      ? (widget.initial as GoalItem).progress
      : 0;
  late bool _active = widget.initial is HabitItem
      ? (widget.initial as HabitItem).active
      : true;
  late bool _allowAi = widget.initial is MemoryItem
      ? (widget.initial as MemoryItem).allowAi
      : false;
  DateTime? _date;
  DateTime? _end;
  String? _goalId;
  String? _goalTitle;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _date = switch (widget.initial) {
      TaskItem v => v.dueAt?.toLocal(),
      GoalItem v => v.targetDate == null ? null : DateTime.parse(v.targetDate!),
      MemoryItem v => v.expiresAt?.toLocal(),
      CalendarItem v => v.startsAt.toLocal(),
      _ => null,
    };
    if (widget.kind == RecordKind.events) {
      _date ??= DateTime.now().add(const Duration(hours: 1));
      _end = widget.initial is CalendarItem
          ? (widget.initial as CalendarItem).endsAt.toLocal()
          : _date!.add(const Duration(hours: 1));
    }
    _goalId = widget.initial is TaskItem
        ? (widget.initial as TaskItem).goalId
        : widget.goalId;
    _goalTitle = widget.goalTitle;
    if (_goalId != null && _goalTitle == null) {
      Future<void>(() async {
        try {
          final goal = await ref.read(lifeRepositoryProvider).goal(_goalId!);
          if (mounted) setState(() => _goalTitle = goal.title);
        } catch (_) {
          if (mounted) {
            setState(
              () => _goalTitle =
                  'Goal unavailable; choose again or clear the link',
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime? initial, {bool time = true}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return null;
    if (!time) return date;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial ?? DateTime.now()),
    );
    return picked == null
        ? null
        : DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
  }

  Widget _dateField(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> set, {
    bool required = false,
    bool time = true,
  }) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.calendar_today_outlined),
    title: Text(label),
    subtitle: Text(
      value == null
          ? 'Not set'
          : time
          ? deviceDate(value)
          : DateFormat.yMMMd().format(value),
    ),
    trailing: !required && value != null
        ? IconButton(
            tooltip: 'Clear $label',
            onPressed: _saving ? null : () => set(null),
            icon: const Icon(Icons.close),
          )
        : const Icon(Icons.edit_calendar_outlined),
    onTap: _saving
        ? null
        : () async {
            final date = await _pickDate(value, time: time);
            if (date != null && mounted) set(date);
          },
  );

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _saving) return;
    if (widget.kind == RecordKind.events &&
        (_date == null || _end == null || !_end!.isAfter(_date!))) {
      setState(() => _error = 'The event end must be after its start.');
      return;
    }
    if (widget.kind == RecordKind.memories &&
        _date != null &&
        !_date!.isAfter(DateTime.now())) {
      setState(() => _error = 'Choose a future expiry.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final payload = <String, dynamic>{'title': _title.text.trim()};
    if (widget.kind == RecordKind.memories) {
      payload.addAll({
        'content': _notes.text.trim(),
        'allow_ai': _allowAi,
        'expires_at': _date?.toUtc().toIso8601String(),
      });
    } else {
      payload['notes'] = _notes.text.trim();
    }
    switch (widget.kind) {
      case RecordKind.tasks:
        payload.addAll({
          'priority': _priority,
          'status': _status,
          'due_at': _date?.toUtc().toIso8601String(),
          'goal_id': _goalId,
        });
      case RecordKind.goals:
        payload.addAll({
          'progress': _progress,
          'target_date': _date == null
              ? null
              : DateFormat('yyyy-MM-dd').format(_date!),
        });
      case RecordKind.habits:
        payload['active'] = _active;
      case RecordKind.events:
        payload.addAll({
          'starts_at': _date!.toUtc().toIso8601String(),
          'ends_at': _end!.toUtc().toIso8601String(),
        });
      case RecordKind.memories:
        break;
    }
    Future<void> submit() => ref
        .read(mutationProvider.notifier)
        .run(
          (repo) => repo.save(
            widget.kind,
            payload,
            id: widget.initial == null ? null : recordId(widget.initial!),
          ),
        );
    try {
      try {
        await submit();
      } on ApiFailure catch (error) {
        if (widget.kind != RecordKind.events ||
            error.statusCode != 409 ||
            !error.message.toLowerCase().contains('overlaps') ||
            !mounted) {
          rethrow;
        }
        final confirmed = await confirmAction(
          context,
          title: 'Overlapping event',
          message: 'This event overlaps another commitment. Save it anyway?',
          action: 'Save overlap',
        );
        if (!confirmed) return;
        payload['allow_overlap'] = true;
        await submit();
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Record saved')));
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = switch (widget.kind) {
      RecordKind.tasks => 'task',
      RecordKind.goals => 'goal',
      RecordKind.habits => 'habit',
      RecordKind.events => 'event',
      RecordKind.memories => 'memory',
    };
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                tooltip: 'Close editor',
                onPressed: _saving ? null : () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ),
            Text(
              '${widget.initial == null ? 'New' : 'Edit'} $name',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Space.lg),
            TextFormField(
              controller: _title,
              enabled: !_saving,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: requiredTitle,
            ),
            const SizedBox(height: Space.md),
            TextFormField(
              controller: _notes,
              enabled: !_saving,
              minLines: 3,
              maxLines: 6,
              maxLength: widget.kind == RecordKind.memories ? 2000 : 4000,
              decoration: InputDecoration(
                labelText: widget.kind == RecordKind.memories
                    ? 'Memory'
                    : 'Notes',
              ),
              validator: widget.kind == RecordKind.memories
                  ? (value) => value?.trim().isNotEmpty == true
                        ? null
                        : 'Write a memory'
                  : null,
            ),
            if (widget.kind == RecordKind.tasks) ...[
              const Text('Priority'),
              Wrap(
                spacing: 8,
                children: [
                  for (final priority in ['low', 'normal', 'high'])
                    ChoiceChip(
                      label: Text(priority),
                      selected: _priority == priority,
                      onSelected: _saving
                          ? null
                          : (_) => setState(() => _priority = priority),
                    ),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Completed'),
                value: _status == 'done',
                onChanged: _saving
                    ? null
                    : (value) =>
                          setState(() => _status = value ? 'done' : 'todo'),
              ),
              _dateField(
                'Due date',
                _date,
                (value) => setState(() => _date = value),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Linked goal'),
                subtitle: Text(
                  _goalId == null
                      ? 'No goal selected'
                      : _goalTitle ?? 'Loading linked goal…',
                ),
                trailing: _goalId == null
                    ? const Icon(Icons.link)
                    : IconButton(
                        tooltip: 'Clear goal link',
                        onPressed: _saving
                            ? null
                            : () => setState(() {
                                _goalId = null;
                                _goalTitle = null;
                              }),
                        icon: const Icon(Icons.link_off),
                      ),
                onTap: _saving
                    ? null
                    : () async {
                        final goal = await showDialog<GoalItem>(
                          context: context,
                          builder: (_) => const GoalPicker(),
                        );
                        if (goal != null && mounted) {
                          setState(() {
                            _goalId = goal.id;
                            _goalTitle = goal.title;
                          });
                        }
                      },
              ),
            ],
            if (widget.kind == RecordKind.goals) ...[
              Text('Your reported progress: $_progress%'),
              Slider(
                value: _progress.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: '$_progress%',
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _progress = value.round()),
              ),
              _dateField(
                'Target date',
                _date,
                (value) => setState(() => _date = value),
                time: false,
              ),
            ],
            if (widget.kind == RecordKind.habits)
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active daily habit'),
                subtitle: const Text(
                  'You can pause this habit without deleting its history.',
                ),
                value: _active,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _active = value),
              ),
            if (widget.kind == RecordKind.memories) ...[
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Allow AI sharing'),
                subtitle: const Text(
                  'This memory is shared only when your profile permits it and you include memory context in a message.',
                ),
                value: _allowAi,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _allowAi = value),
              ),
              _dateField(
                'Expiry',
                _date,
                (value) => setState(() => _date = value),
              ),
            ],
            if (widget.kind == RecordKind.events) ...[
              _dateField(
                'Starts',
                _date,
                (value) => setState(() => _date = value),
                required: true,
              ),
              _dateField(
                'Ends',
                _end,
                (value) => setState(() => _end = value),
                required: true,
              ),
            ],
            if (widget.kind != RecordKind.goals &&
                widget.kind != RecordKind.habits)
              const Text('Date and time pickers use your device time zone.'),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Semantics(liveRegion: true, child: Text(_error!)),
              ),
            const SizedBox(height: Space.lg),
            LifeverseButton(
              label: 'Save $name',
              busy: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class GoalPicker extends ConsumerStatefulWidget {
  const GoalPicker({super.key});
  @override
  ConsumerState<GoalPicker> createState() => _GoalPickerState();
}

class _GoalPickerState extends ConsumerState<GoalPicker> {
  LifeQuery _query = const LifeQuery();
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Choose a goal'),
    content: SizedBox(
      width: 420,
      height: 460,
      child: Column(
        children: [
          RecordSearch(
            onSearch: (value) =>
                setState(() => _query = LifeQuery(search: value)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: RecordsView<GoalItem>(
                data: ref.watch(goalsProvider(_query)),
                onRetry: () => ref.invalidate(goalsProvider(_query)),
                onOffset: (value) =>
                    setState(() => _query = _query.copyWith(offset: value)),
                itemBuilder: (goal) => ListTile(
                  title: Text(goal.title),
                  subtitle: Text('${goal.progress}% complete'),
                  onTap: () => Navigator.pop(context, goal),
                ),
                emptyMessage:
                    'Create a goal first, or search for a different title.',
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  );
}
