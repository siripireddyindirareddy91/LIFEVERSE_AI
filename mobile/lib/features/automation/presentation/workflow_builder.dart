import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/automation_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../agents/presentation/agent_screens.dart' show scopes;
import '../../life/presentation/life_widgets.dart';
import '../application/automation_providers.dart';

const nodeLabels = {
  'trigger': 'Trigger',
  'condition': 'Condition',
  'report': 'Life report',
  'external': 'External API read',
  'ai': 'AI assistant',
  'action': 'Record action',
  'approval': 'Approval checkpoint',
  'notify': 'Notification',
  'output': 'Output',
};
const nodeIcons = {
  'trigger': Icons.bolt,
  'condition': Icons.filter_alt_outlined,
  'report': Icons.insights_outlined,
  'external': Icons.cloud_outlined,
  'ai': Icons.auto_awesome_outlined,
  'action': Icons.edit_note,
  'approval': Icons.fact_check_outlined,
  'notify': Icons.notifications_outlined,
  'output': Icons.check_circle_outline,
};
String nodeSummary(Map<String, dynamic> node) => switch (node['type']) {
  'trigger' =>
    node['mode'] == 'schedule'
        ? '${node['at'] ?? '07:00'} · ${node['timezone'] ?? 'UTC'} · selected weekdays'
        : node['mode'] == 'event'
        ? 'When ${node['topic'] ?? 'goal.created'}'
        : 'When you tap Run now',
  'condition' =>
    'Continue if ${node['test'] ?? 'open_tasks'} meets your condition',
  'report' => 'Read your ${node['module'] ?? 'life'} records',
  'external' => 'Read ${node['api'] ?? 'weather'} from a fixed provider',
  'ai' => 'Read-only AI · ${(node['scopes'] as List? ?? []).join(', ')}',
  'action' =>
    'Propose ${node['tool'] ?? 'create_task'} · ${(node['arguments'] as Map?)?['title'] ?? ''}',
  'approval' => 'Wait for your exact-preview decision',
  'notify' => 'Save an in-app update · ${node['title'] ?? 'Workflow update'}',
  _ => 'Save verified results in execution history',
};
String? validateNodes(List<Map<String, dynamic>> nodes) {
  final types = nodes.map((n) => n['type']).toList();
  if (types.length > 12) return 'Use at most 12 steps.';
  if (types.first != 'trigger' ||
      types.last != 'output' ||
      types.where((t) => t == 'trigger').length != 1 ||
      types.where((t) => t == 'output').length != 1) {
    return 'Keep one trigger first and one output last.';
  }
  if (types.where((t) => t == 'approval').length > 1 ||
      types.where((t) => t == 'ai').length > 1) {
    return 'Use at most one approval and one AI step.';
  }
  if (types.contains('action')) {
    final approval = types.indexOf('approval');
    if (approval < 0 || types.lastIndexOf('action') > approval) {
      return 'Add an approval checkpoint after every record action.';
    }
    if (types
        .sublist(types.indexOf('action'), approval)
        .any((t) => t != 'action')) {
      return 'Keep record actions together immediately before approval.';
    }
    if (types
        .sublist(approval + 1)
        .any((t) => t != 'notify' && t != 'output')) {
      return 'Only notifications and output can follow approval.';
    }
    if (types.contains('notify') && types.indexOf('notify') < approval) {
      return 'Move notifications after approval.';
    }
  } else if (types.contains('approval')) {
    return 'An approval checkpoint needs a record action.';
  }
  return null;
}

class WorkflowBuilderScreen extends ConsumerStatefulWidget {
  const WorkflowBuilderScreen({this.id, this.template, super.key});
  final String? id;
  final int? template;
  @override
  ConsumerState<WorkflowBuilderScreen> createState() => _BuilderState();
}

class _BuilderState extends ConsumerState<WorkflowBuilderScreen> {
  final title = TextEditingController(text: 'My workflow');
  List<Map<String, dynamic>> nodes = [
    {'type': 'trigger', 'mode': 'manual'},
    {'type': 'report', 'module': 'life'},
    {'type': 'output'},
  ];
  WorkflowItem? saved;
  bool loading = true, busy = false;
  String? error, requestId, fingerprint;
  String runRequest = const Uuid().v4();
  final nodeKeys = Map<Map<String, dynamic>, String>.identity();
  @override
  void initState() {
    super.initState();
    Future.microtask(load);
  }

  Future<void> load() async {
    try {
      final repo = ref.read(automationRepositoryProvider);
      if (widget.id != null) {
        saved = await repo.workflow(widget.id!);
        title.text = saved!.title;
        nodes = (jsonDecode(jsonEncode(saved!.definition['nodes'])) as List)
            .cast<Map<String, dynamic>>();
      } else if (widget.template != null) {
        final templates = await repo.templates();
        final item = templates[widget.template!.clamp(0, templates.length - 1)];
        title.text = item['title'] as String;
        nodes = ((item['definition'] as Map)['nodes'] as List)
            .cast<Map<String, dynamic>>();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  bool get dirty =>
      saved == null ||
      title.text != saved!.title ||
      jsonEncode(nodes) != jsonEncode(saved!.definition['nodes']);
  Future<void> act(Future<void> Function() action) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
      ref.invalidate(workflowListProvider);
      ref.invalidate(workflowHistoryProvider);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> editNode(int index) async {
    final value = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => WorkflowNodeEditor(initial: nodes[index]),
    );
    if (value != null) setState(() => nodes[index] = value);
  }

  Future<void> add() async {
    if (nodes.length >= 12) return;
    final type = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Add a workflow step'),
        children: [
          for (final type in nodeLabels.keys.where(
            (t) => t != 'trigger' && t != 'output',
          ))
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, type),
              child: ListTile(
                leading: Icon(nodeIcons[type]),
                title: Text(nodeLabels[type]!),
              ),
            ),
        ],
      ),
    );
    if (type == null || !mounted) return;
    final value = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => WorkflowNodeEditor(initial: {'type': type}),
    );
    if (value != null) setState(() => nodes.insert(nodes.length - 1, value));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: UniverseLoadingState());
    final validation = validateNodes(nodes);
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(24),
      buildDefaultDragHandles: false,
      itemCount: nodes.length,
      onReorder: (old, newIndex) {
        if (newIndex > old) newIndex--;
        if (old == 0 ||
            old == nodes.length - 1 ||
            newIndex == 0 ||
            newIndex >= nodes.length - 1) {
          return;
        }
        setState(() {
          final node = nodes.removeAt(old);
          nodes.insert(newIndex, node);
        });
      },
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Make the routine feel lighter.',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          const Text(
            'Connect clear steps, then review permissions before activation. Drag the handles to reorder. Conditions stop the remaining flow when false.',
          ),
          const SizedBox(height: 24),
          TextField(
            controller: title,
            maxLength: 120,
            enabled: !busy,
            decoration: const InputDecoration(labelText: 'Workflow name'),
            onChanged: (_) => setState(() {}),
          ),
          if (saved?.enabled == true)
            const Text(
              'Active workflow. Saving edits pauses it and cancels unfinished runs; review and activate again.',
            ),
          const SizedBox(height: 16),
        ],
      ),
      itemBuilder: (context, index) {
        final node = nodes[index];
        final type = node['type'] as String;
        return Padding(
          key: ValueKey(nodeKeys.putIfAbsent(node, () => const Uuid().v4())),
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              UniverseSurface(
                child: Row(
                  children: [
                    Icon(
                      nodeIcons[type],
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${nodeLabels[type]}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(nodeSummary(node)),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit step ${index + 1}',
                      onPressed: busy || type == 'output'
                          ? null
                          : () => editNode(index),
                      icon: const Icon(Icons.tune),
                    ),
                    if (index > 0 && index < nodes.length - 1)
                      ReorderableDragStartListener(
                        index: index,
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.drag_indicator),
                        ),
                      ),
                  ],
                ),
              ),
              if (index < nodes.length - 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.south, size: 18),
                    if (index > 0)
                      IconButton(
                        tooltip: 'Remove step ${index + 1}',
                        onPressed: busy
                            ? null
                            : () => setState(() => nodes.removeAt(index)),
                        icon: const Icon(Icons.remove_circle_outline, size: 18),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: busy || nodes.length >= 12 ? null : add,
            icon: const Icon(Icons.add),
            label: const Text('Add step'),
          ),
          if (validation != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                validation,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (error != null) Semantics(liveRegion: true, child: Text(error!)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: busy || validation != null
                ? null
                : () => act(() async {
                    if (title.text.trim().isEmpty) {
                      throw StateError('Enter a workflow name.');
                    }
                    final content = jsonEncode([title.text.trim(), nodes]);
                    if (content != fingerprint) {
                      fingerprint = content;
                      requestId = const Uuid().v4();
                    }
                    final item = await ref
                        .read(automationRepositoryProvider)
                        .save({
                          'request_id': requestId,
                          'revision': saved?.revision,
                          'title': title.text.trim(),
                          'definition': {'nodes': nodes},
                        }, id: saved?.id);
                    if (context.mounted) {
                      setState(() {
                        saved = item;
                        nodes =
                            (jsonDecode(jsonEncode(item.definition['nodes']))
                                    as List)
                                .cast<Map<String, dynamic>>();
                      });
                      if (widget.id == null) {
                        context.replace('/automation/workflows/${item.id}');
                      }
                    }
                  }),
            child: Text(busy ? 'Saving…' : 'Save draft'),
          ),
          if (saved != null) ...[
            TextButton(
              onPressed: busy || dirty
                  ? null
                  : () async {
                      final item = saved!;
                      final approve = await confirmAction(
                        context,
                        title: 'Activate this workflow?',
                        message:
                            '${item.permissions.join('\n')}\n\n${nodeSummary(nodes.first)}\nThis definition will run until paused. Record changes still require per-run approval.',
                        action: 'Activate reviewed workflow',
                      );
                      if (approve) {
                        await act(() async {
                          saved = await ref
                              .read(automationRepositoryProvider)
                              .activate(item);
                          if (mounted) setState(() {});
                        });
                      }
                    },
              child: const Text('Review & activate'),
            ),
            if (saved!.enabled)
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: busy || dirty
                        ? null
                        : () => act(() async {
                            final result = await ref
                                .read(automationRepositoryProvider)
                                .run(saved!.id, runRequest);
                            runRequest = const Uuid().v4();
                            if (context.mounted) {
                              context.push('/automation/runs/${result.id}');
                            }
                          }),
                    child: const Text('Run now'),
                  ),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () async {
                            if (!await confirmAction(
                              context,
                              title: 'Pause this workflow?',
                              message:
                                  'Stops future triggers and cancels unfinished runs. Completed effects remain.',
                              action: 'Pause workflow',
                            )) {
                              return;
                            }
                            await act(() async {
                              await ref
                                  .read(automationRepositoryProvider)
                                  .pause(saved!.id);
                              saved = await ref
                                  .read(automationRepositoryProvider)
                                  .workflow(saved!.id);
                              if (mounted) setState(() {});
                            });
                          },
                    child: const Text('Pause'),
                  ),
                ],
              ),
            if (dirty)
              const Text('Save your changes before activation or running.'),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class WorkflowNodeEditor extends StatefulWidget {
  const WorkflowNodeEditor({required this.initial, super.key});
  final Map<String, dynamic> initial;
  @override
  State<WorkflowNodeEditor> createState() => _NodeEditorState();
}

class _NodeEditorState extends State<WorkflowNodeEditor> {
  final form = GlobalKey<FormState>();
  final controllers = <String, TextEditingController>{};
  late final data = Map<String, dynamic>.from(widget.initial);
  String get type => data['type'] as String;
  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget text(
    String key,
    String label, {
    String initial = '',
    bool multiline = false,
    bool required = false,
    bool number = false,
  }) {
    final c = controllers.putIfAbsent(
      key,
      () => TextEditingController(text: (data[key] ?? initial).toString()),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        minLines: multiline ? 3 : 1,
        maxLines: multiline ? 6 : 1,
        maxLength: multiline ? 2000 : 120,
        decoration: InputDecoration(labelText: label),
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true, signed: true)
            : TextInputType.text,
        validator: (v) {
          if (required && (v?.trim().isEmpty ?? true)) return 'Enter $label';
          if (number && num.tryParse(v ?? '') == null) return 'Enter a number';
          return null;
        },
      ),
    );
  }

  Widget choice(
    String key,
    String label,
    List<String> options,
    String initial,
  ) {
    data.putIfAbsent(key, () => initial);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: data[key] as String,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final option in options)
            DropdownMenuItem(
              value: option,
              child: Text(option.replaceAll('_', ' ')),
            ),
        ],
        onChanged: (v) => setState(() => data[key] = v),
      ),
    );
  }

  Widget timestamp(String key, String label, DateTime fallback) {
    data.putIfAbsent(
      key,
      () =>
          (data['arguments'] as Map?)?[key] ??
          fallback.toUtc().toIso8601String(),
    );
    final value = DateTime.parse(data[key] as String).toLocal();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.calendar_month_outlined),
        label: Text('$label (device time): ${deviceDate(value)}'),
        onPressed: () async {
          final day = await showDatePicker(
            context: context,
            initialDate: value,
            firstDate: DateTime(2000),
            lastDate: DateTime(2200),
          );
          if (day == null || !mounted) return;
          final clock = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(value),
          );
          if (clock != null && mounted) {
            setState(
              () => data[key] = DateTime(
                day.year,
                day.month,
                day.day,
                clock.hour,
                clock.minute,
              ).toUtc().toIso8601String(),
            );
          }
        },
      ),
    );
  }

  void save() {
    if (!form.currentState!.validate()) return;
    for (final e in controllers.entries) {
      data[e.key] = e.value.text.trim();
    }
    if (type == 'trigger') {
      data.putIfAbsent('timezone', () => 'UTC');
      data.putIfAbsent('at', () => '07:00');
      data.putIfAbsent('weekdays', () => List.generate(7, (i) => i));
    }
    if (type == 'condition') {
      data['minimum'] = int.tryParse(data['minimum']?.toString() ?? '1') ?? 1;
    }
    if (type == 'external') {
      data['latitude'] =
          double.tryParse(data['latitude']?.toString() ?? '0') ?? 0;
      data['longitude'] =
          double.tryParse(data['longitude']?.toString() ?? '0') ?? 0;
    }
    if (type == 'action') {
      final args = <String, dynamic>{
        'title':
            data.remove('action_title') ??
            (data['arguments'] as Map?)?['title'] ??
            '',
        'notes':
            data.remove('action_notes') ??
            (data['arguments'] as Map?)?['notes'] ??
            '',
      };
      if (data['tool'] == 'create_event') {
        args['starts_at'] = data.remove('starts_at');
        args['ends_at'] = data.remove('ends_at');
      } else {
        data.remove('starts_at');
        data.remove('ends_at');
      }
      data['arguments'] = args;
    }
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(nodeLabels[type]!),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (type == 'trigger') ...[
                choice('mode', 'When to run', [
                  'manual',
                  'schedule',
                  'event',
                ], 'manual'),
                if (data['mode'] == 'schedule') ...[
                  text(
                    'timezone',
                    'IANA time zone',
                    initial: 'UTC',
                    required: true,
                  ),
                  text('at', 'Time (HH:MM)', initial: '07:00', required: true),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (var i = 0; i < 7; i++)
                        FilterChip(
                          label: Text(
                            [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ][i],
                          ),
                          selected:
                              (data['weekdays'] as List? ??
                                      List.generate(7, (i) => i))
                                  .contains(i),
                          onSelected: (v) => setState(() {
                            final values = List<int>.from(
                              data['weekdays'] as List? ??
                                  List.generate(7, (i) => i),
                            );
                            v ? values.add(i) : values.remove(i);
                            data['weekdays'] = values;
                          }),
                        ),
                    ],
                  ),
                ],
                if (data['mode'] == 'event')
                  choice('topic', 'App event', [
                    'task.created',
                    'goal.created',
                    'module.created',
                  ], 'goal.created'),
              ],
              if (type == 'condition') ...[
                choice('test', 'Continue when', [
                  'open_tasks',
                  'overdue_tasks',
                  'has_events',
                  'trigger_kind',
                ], 'open_tasks'),
                if (data['test'] == 'trigger_kind')
                  text('record_kind', 'Record kind', initial: 'course')
                else
                  text(
                    'minimum',
                    'Minimum matching records',
                    initial: '1',
                    number: true,
                  ),
              ],
              if (type == 'report')
                choice('module', 'Report space', [
                  'life',
                  'finance',
                  'learning',
                  'career',
                  'wellness',
                  'travel',
                  'future',
                ], 'life'),
              if (type == 'external') ...[
                choice('api', 'Provider read', [
                  'weather',
                  'exchange',
                ], 'weather'),
                if (data['api'] == 'weather') ...[
                  text('latitude', 'Latitude', initial: '0', number: true),
                  text('longitude', 'Longitude', initial: '0', number: true),
                  const Text(
                    'Coordinates are sent to Open-Meteo. Check its terms before commercial use.',
                  ),
                ] else ...[
                  text('base', 'Base currency', initial: 'USD'),
                  text('quote', 'Quote currency', initial: 'INR'),
                  const Text(
                    'Frankfurter provides reference rates, not live market quotes.',
                  ),
                ],
              ],
              if (type == 'ai') ...[
                text(
                  'prompt',
                  'What should the assistant prepare?',
                  multiline: true,
                  required: true,
                ),
                const Text(
                  'Read-only AI. Only explicitly shared records in selected scopes are available.',
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    for (final entry in scopes.entries)
                      FilterChip(
                        label: Text(entry.value),
                        selected: (data['scopes'] as List? ?? []).contains(
                          entry.key,
                        ),
                        onSelected: (v) => setState(() {
                          final selected = List<String>.from(
                            data['scopes'] as List? ?? [],
                          );
                          v
                              ? selected.add(entry.key)
                              : selected.remove(entry.key);
                          data['scopes'] = selected;
                        }),
                      ),
                  ],
                ),
              ],
              if (type == 'action') ...[
                choice('tool', 'Prepare a change', [
                  'create_task',
                  'create_event',
                ], 'create_task'),
                text(
                  'action_title',
                  'Title',
                  initial:
                      (data['arguments'] as Map?)?['title'] as String? ?? '',
                  required: true,
                ),
                text(
                  'action_notes',
                  'Notes',
                  initial:
                      (data['arguments'] as Map?)?['notes'] as String? ?? '',
                  multiline: true,
                ),
                if (data['tool'] == 'create_event') ...[
                  timestamp(
                    'starts_at',
                    'Start',
                    DateTime.now().add(const Duration(days: 1)),
                  ),
                  timestamp(
                    'ends_at',
                    'End',
                    DateTime.now().add(const Duration(days: 1, hours: 1)),
                  ),
                ],
                const Text(
                  'This prepares a proposal only. Add an approval checkpoint after record actions.',
                ),
              ],
              if (type == 'approval')
                const Text(
                  'The workflow waits while you review exact fields in Agent Center. Rejection, expiry or pause prevents remaining steps.',
                ),
              if (type == 'notify') ...[
                text(
                  'title',
                  'Notification title',
                  initial: 'Workflow update',
                  required: true,
                ),
                text(
                  'body',
                  'Message',
                  initial: 'Your workflow has an update.',
                  multiline: true,
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Include the last report or result'),
                  value: data['include_output'] == true,
                  onChanged: (v) => setState(() => data['include_output'] = v),
                ),
                const Text(
                  'Saved to your private inbox. Device alerts require opt-in; remote push is not configured.',
                ),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(onPressed: save, child: const Text('Save step')),
    ],
  );
}
