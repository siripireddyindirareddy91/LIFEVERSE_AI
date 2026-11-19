import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/automation_providers.dart';

class AutomationScreen extends ConsumerStatefulWidget {
  const AutomationScreen({super.key});
  @override
  ConsumerState<AutomationScreen> createState() => _AutomationState();
}

class _AutomationState extends ConsumerState<AutomationScreen> {
  bool history = false;
  int offset = 0;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Icon(
        Icons.account_tree_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 12),
      Text(
        'Give the everyday a little help.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Build understandable workflows, approve personal record changes and see what actually happened.',
      ),
      const SizedBox(height: 24),
      ref
          .watch(automationStatusProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(automationStatusProvider),
            ),
            data: (status) => UniverseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status['worker_online'] == true
                        ? 'Automation worker is online'
                        : 'Worker is offline — queued work will wait',
                  ),
                  Text(
                    '${status['daily_limit']} runs per rolling day · history retained ${status['history_days']} days',
                  ),
                  Text(
                    status['external_apis_enabled'] == true
                        ? 'Fixed-provider external reads are enabled'
                        : 'External reads require server configuration',
                  ),
                ],
              ),
            ),
          ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          FilledButton.icon(
            onPressed: () => context.push('/automation/new'),
            icon: const Icon(Icons.add),
            label: const Text('Build a workflow'),
          ),
          TextButton(
            onPressed: () => context.push('/integrations'),
            child: const Text('Integrations'),
          ),
          TextButton(
            onPressed: () => context.push('/notifications'),
            child: const Text('Notification inbox'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ExpansionTile(
        title: const Text('Start with a template'),
        children: [
          for (var i = 0; i < 3; i++)
            ListTile(
              title: Text(
                [
                  'Daily life report',
                  'A gentle deadline check',
                  'Review a new goal',
                ][i],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/automation/new?template=$i'),
            ),
        ],
      ),
      const SizedBox(height: 24),
      SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text('Workflows')),
          ButtonSegment(value: true, label: Text('Run history')),
        ],
        selected: {history},
        onSelectionChanged: (v) => setState(() {
          history = v.single;
          offset = 0;
        }),
      ),
      const SizedBox(height: 16),
      if (!history)
        ref
            .watch(workflowListProvider(offset))
            .when(
              loading: () => const UniverseLoadingState(),
              error: (e, _) => UniverseErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(workflowListProvider),
              ),
              data: (page) => Column(
                children: [
                  if (page.items.isEmpty)
                    const UniverseEmptyState(
                      title: 'Start with something small',
                      message:
                          'Create a workflow or choose a template. Nothing runs until you activate it.',
                    ),
                  for (final item in page.items)
                    Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                          item.enabled
                              ? 'Active · ${item.definition['nodes'] is List ? (item.definition['nodes'] as List).length : 0} steps'
                              : 'Draft / paused',
                        ),
                        leading: Icon(
                          item.enabled
                              ? Icons.play_circle_outline
                              : Icons.pause_circle_outline,
                        ),
                        onTap: () =>
                            context.push('/automation/workflows/${item.id}'),
                        trailing: IconButton(
                          tooltip: 'Delete workflow',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            if (!await confirmAction(
                              context,
                              title: 'Delete this workflow?',
                              message:
                                  'Cancels unfinished runs and deletes workflow history. Completed life records and Agent history remain.',
                            )) {
                              return;
                            }
                            try {
                              await ref
                                  .read(automationRepositoryProvider)
                                  .removeWorkflow(item.id);
                              ref.invalidate(workflowListProvider);
                              ref.invalidate(workflowHistoryProvider);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  PageControls(
                    total: page.total,
                    offset: offset,
                    limit: page.limit,
                    onOffset: (v) => setState(() => offset = v),
                  ),
                ],
              ),
            )
      else
        ref
            .watch(workflowHistoryProvider(offset))
            .when(
              loading: () => const UniverseLoadingState(),
              error: (e, _) => UniverseErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(workflowHistoryProvider),
              ),
              data: (page) => Column(
                children: [
                  if (page.items.isEmpty)
                    const UniverseEmptyState(
                      title: 'A clear history starts here',
                      message:
                          'Your queued and completed runs will appear here.',
                    ),
                  for (final item in page.items)
                    Card(
                      child: ListTile(
                        title: Text(
                          item.summary.isEmpty ? 'Workflow run' : item.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${item.status.replaceAll('_', ' ')} · ${deviceDate(item.createdAt)}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            context.push('/automation/runs/${item.id}'),
                      ),
                    ),
                  PageControls(
                    total: page.total,
                    offset: offset,
                    limit: page.limit,
                    onOffset: (v) => setState(() => offset = v),
                  ),
                ],
              ),
            ),
      IconButton(
        tooltip: 'Refresh automation',
        onPressed: () {
          ref.invalidate(workflowListProvider);
          ref.invalidate(workflowHistoryProvider);
          ref.invalidate(automationStatusProvider);
        },
        icon: const Icon(Icons.refresh),
      ),
    ],
  );
}

class WorkflowRunScreen extends ConsumerStatefulWidget {
  const WorkflowRunScreen({required this.id, super.key});
  final String id;
  @override
  ConsumerState<WorkflowRunScreen> createState() => _RunState();
}

class _RunState extends ConsumerState<WorkflowRunScreen> {
  Timer? timer;
  bool busy = false;
  String? error;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void poll(bool active) {
    if (!active) {
      timer?.cancel();
      timer = null;
    } else {
      timer ??= Timer(const Duration(seconds: 10), () {
        timer = null;
        if (mounted) ref.invalidate(workflowRunProvider(widget.id));
      });
    }
  }

  Future<void> act(Future<void> Function() action) async {
    setState(() => busy = true);
    try {
      await action();
      ref.invalidate(workflowRunProvider(widget.id));
      ref.invalidate(workflowHistoryProvider);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(workflowRunProvider(widget.id))
      .when(
        loading: () => const Center(child: UniverseLoadingState()),
        error: (e, _) {
          poll(false);
          return Center(
            child: UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(workflowRunProvider(widget.id)),
            ),
          );
        },
        data: (run) {
          poll(run.active);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Every step, in view.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: StatusPill(run.status.replaceAll('_', ' ')),
              ),
              const SizedBox(height: 16),
              Text('${deviceDate(run.createdAt)} · ${run.attempts} attempts'),
              if (run.error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(run.error),
                ),
              if (run.summary.isNotEmpty && !run.summary.startsWith('{'))
                SelectableText(run.summary),
              if (run.proposalRunId != null)
                FilledButton.icon(
                  onPressed: () => context.push('/agents/${run.proposalRunId}'),
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Review proposed changes & outcomes'),
                ),
              if (run.agentRunId != null)
                TextButton(
                  onPressed: () => context.push('/agents/${run.agentRunId}'),
                  child: const Text('Open linked AI result'),
                ),
              const SizedBox(height: 24),
              for (final step in run.steps)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UniverseSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${step.index + 1}. ${step.summary}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${step.type} · ${step.status} · ${deviceDate(step.at)}',
                        ),
                        if (step.result != null &&
                            (step.type == 'report' || step.type == 'external'))
                          ReportResult(value: step.result!),
                      ],
                    ),
                  ),
                ),
              if (run.steps.isEmpty)
                const Text(
                  'Queued. The worker will save each completed step here.',
                ),
              if (error != null) Text(error!),
              Wrap(
                spacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(workflowRunProvider(widget.id)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                  TextButton.icon(
                    onPressed: () => act(() async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: const JsonEncoder.withIndent(
                            '  ',
                          ).convert(run.toJson()),
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workflow history copied'),
                          ),
                        );
                      }
                    }),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy history'),
                  ),
                  if (run.active)
                    TextButton(
                      onPressed: busy
                          ? null
                          : () async {
                              if (await confirmAction(
                                context,
                                title: 'Cancel this run?',
                                message:
                                    'Stops unfinished steps. Completed effects remain in their spaces.',
                                action: 'Cancel run',
                              )) {
                                await act(
                                  () => ref
                                      .read(automationRepositoryProvider)
                                      .cancel(run.id),
                                );
                              }
                            },
                      child: const Text('Cancel run'),
                    ),
                  if (run.status == 'failed' && run.attempts < 3)
                    FilledButton.tonal(
                      onPressed: busy
                          ? null
                          : () => act(
                              () => ref
                                  .read(automationRepositoryProvider)
                                  .retry(run.id),
                            ),
                      child: const Text('Retry unfinished steps'),
                    ),
                  if (!run.active)
                    TextButton(
                      onPressed: busy
                          ? null
                          : () async {
                              if (!await confirmAction(
                                context,
                                title: 'Delete run history?',
                                message:
                                    'Deletes this workflow timeline. Completed life records, notification inbox and linked Agent history remain.',
                              )) {
                                return;
                              }
                              await act(() async {
                                await ref
                                    .read(automationRepositoryProvider)
                                    .removeRun(run.id);
                                if (context.mounted) context.go('/automation');
                              });
                            },
                      child: const Text('Delete history'),
                    ),
                ],
              ),
            ],
          );
        },
      );
}

class ReportResult extends StatelessWidget {
  const ReportResult({required this.value, super.key});
  final Map<String, dynamic> value;
  @override
  Widget build(BuildContext context) {
    final report = (value['report'] as Map?) ?? value;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report['metrics'] is List)
            for (final metric in report['metrics'] as List)
              Text('${(metric as Map)['label']}: ${metric['value']}'),
          if (report['lines'] is List)
            for (final line in (report['lines'] as List).take(12))
              Text('${(line as Map)['label']}: ${line['value']}'),
          for (final entry
              in report.entries
                  .where(
                    (e) =>
                        e.value is String || e.value is num || e.value is bool,
                  )
                  .take(20))
            SelectableText(
              '${entry.key.toString().replaceAll('_', ' ')}: ${entry.value}',
            ),
        ],
      ),
    );
  }
}
