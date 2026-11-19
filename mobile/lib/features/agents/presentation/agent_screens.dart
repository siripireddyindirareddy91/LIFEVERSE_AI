import '../../modules/application/module_providers.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/providers.dart';
import '../../../core/models/agent_models.dart';
import '../../../shared/widgets/ai_orb.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/agent_providers.dart';

const scopes = {
  'planner': 'Planner',
  'goals': 'Goals',
  'habits': 'Habits',
  'memory': 'Personal Memory',
  'knowledge': 'Knowledge',
  'insights': 'Life Intelligence',
  'finance': 'Finance',
  'learning': 'Learning',
  'career': 'Career',
  'wellness': 'Wellness',
  'travel': 'Travel',
  'vault': 'Vault metadata',
  'future': 'Future Studio',
};
String statusLabel(String status) => status.replaceAll('_', ' ');

class AgentCenterScreen extends ConsumerStatefulWidget {
  const AgentCenterScreen({super.key});
  @override
  ConsumerState<AgentCenterScreen> createState() => _AgentCenterState();
}

class _AgentCenterState extends ConsumerState<AgentCenterScreen> {
  int offset = 0;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(
        'A little help. A clear plan.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Your specialists can read the spaces you choose and prepare changes. You decide what happens next.',
      ),
      const SizedBox(height: 24),
      ref
          .watch(agentStatusProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(agentStatusProvider),
            ),
            data: (status) => UniverseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.configured
                        ? (status.workerOnline
                              ? 'Agents are ready'
                              : 'Worker is offline — queued plans will wait')
                        : 'Connect your AI provider on the server',
                  ),
                  if (status.consentRequired)
                    TextButton(
                      onPressed: () => context.push('/profile'),
                      child: const Text('Review AI permission in your profile'),
                    ),
                  Text(
                    '${status.dailyLimit} plans per rolling day · history kept ${status.historyDays} days',
                  ),
                  Text(
                    status.embeddingsConfigured
                        ? 'Semantic and keyword retrieval available for indexed sources'
                        : 'Keyword retrieval available · embeddings not configured',
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: status.configured && !status.consentRequired
                        ? () => context.push('/agents/new')
                        : null,
                    icon: const Icon(Icons.auto_awesome_outlined),
                    label: const Text('Create a plan'),
                  ),
                ],
              ),
            ),
          ),
      const SizedBox(height: 16),
      TextButton.icon(
        onPressed: () => context.push('/knowledge'),
        icon: const Icon(Icons.library_books_outlined),
        label: const Text('Your knowledge sources'),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: Text(
              'Execution history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(
            tooltip: 'Refresh history',
            onPressed: () {
              ref.invalidate(agentRunsProvider);
              ref.invalidate(agentStatusProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      ref
          .watch(agentRunsProvider(offset))
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(agentRunsProvider),
            ),
            data: (page) => Column(
              children: [
                if (page.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Your first plan starts here. No agents have run yet.',
                    ),
                  ),
                for (final run in page.items)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        run.reviewable ? Icons.pending_actions : Icons.history,
                      ),
                      title: Text(
                        run.prompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${statusLabel(run.status)} · ${deviceDate(run.createdAt)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/agents/${run.id}'),
                    ),
                  ),
                PageControls(
                  total: page.total,
                  offset: offset,
                  limit: page.limit,
                  onOffset: (value) => setState(() => offset = value),
                ),
              ],
            ),
          ),
    ],
  );
}

class NewAgentRunScreen extends ConsumerStatefulWidget {
  const NewAgentRunScreen({this.initialScope, super.key});
  final String? initialScope;
  @override
  ConsumerState<NewAgentRunScreen> createState() => _NewRunState();
}

class _NewRunState extends ConsumerState<NewAgentRunScreen> {
  final prompt = TextEditingController();
  late final selected = <String>{
    if (scopes.containsKey(widget.initialScope)) widget.initialScope!,
  };
  bool proposals = false, busy = false;
  String? error, fingerprint, requestId;
  @override
  void dispose() {
    prompt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider).asData?.value;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'What would make life lighter?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: prompt,
          enabled: !busy,
          minLines: 3,
          maxLines: 8,
          maxLength: 4000,
          decoration: const InputDecoration(
            labelText: 'Ask your specialists',
            hintText: 'Help me plan a realistic study week.',
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Choose what agents may read for this run. Nothing is selected by default.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final scope in scopes.entries)
              FilterChip(
                label: Text(scope.value),
                selected: selected.contains(scope.key),
                onSelected:
                    busy ||
                        (scope.key == 'memory' &&
                            profile?.memoryConsent != true) ||
                        (scope.key == 'knowledge' &&
                            profile?.knowledgeConsent != true)
                    ? null
                    : (value) => setState(() {
                        value
                            ? selected.add(scope.key)
                            : selected.remove(scope.key);
                      }),
              ),
          ],
        ),
        TextButton(
          onPressed: busy ? null : () => context.push('/profile'),
          child: const Text('Manage memory and knowledge permissions'),
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Prepare changes for review'),
          subtitle: const Text(
            'Off: read-only advice. On: specialists may propose changes to selected spaces. Each change still needs approval.',
          ),
          value: proposals,
          onChanged: busy ? null : (v) => setState(() => proposals = v),
        ),
        const SizedBox(height: 16),
        if (error != null) Semantics(liveRegion: true, child: Text(error!)),
        LifeverseButton(
          label: 'Send to supervisor',
          busy: busy,
          onPressed: () async {
            if (prompt.text.trim().isEmpty) {
              setState(() => error = 'Describe what you would like help with.');
              return;
            }
            final chosen = selected.toList()..sort();
            final content = jsonEncode({
              'prompt': prompt.text.trim(),
              'scopes': chosen,
              'allow_proposals': proposals,
            });
            if (content != fingerprint) {
              fingerprint = content;
              requestId = const Uuid().v4();
            }
            setState(() {
              busy = true;
              error = null;
            });
            try {
              final run = await ref.read(agentRepositoryProvider).create({
                ...jsonDecode(content) as Map<String, dynamic>,
                'request_id': requestId,
              });
              ref.invalidate(agentRunsProvider);
              if (context.mounted) context.replace('/agents/${run.id}');
            } catch (e) {
              if (mounted) setState(() => error = e.toString());
            } finally {
              if (mounted) setState(() => busy = false);
            }
          },
        ),
      ],
    );
  }
}

class AgentRunScreen extends ConsumerStatefulWidget {
  const AgentRunScreen({required this.id, super.key});
  final String id;
  @override
  ConsumerState<AgentRunScreen> createState() => _RunState();
}

class _RunState extends ConsumerState<AgentRunScreen> {
  Timer? timer;
  final selected = <String>{};
  bool busy = false;
  String? error, decisionKey, decisionFingerprint, previewDigest;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void poll(bool active) {
    if (!active) {
      timer?.cancel();
      timer = null;
      return;
    }
    timer ??= Timer(const Duration(seconds: 3), () {
      timer = null;
      if (mounted) ref.invalidate(agentRunProvider(widget.id));
    });
  }

  Future<void> decide(AgentRun run, bool approve) async {
    if (!approve &&
        !await confirmAction(
          context,
          title: 'Reject all proposals?',
          message: 'No changes from this plan will be applied.',
          action: 'Reject all',
        )) {
      return;
    }
    final ids = approve ? (selected.toList()..sort()) : <String>[];
    final hash = jsonEncode([
      run.approvalDigest,
      run.reviewNonce,
      approve,
      ids,
    ]);
    if (decisionFingerprint != hash) {
      decisionFingerprint = hash;
      decisionKey = const Uuid().v4();
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await ref.read(agentRepositoryProvider).decide(run.id, {
        'request_id': decisionKey,
        'decision': approve ? 'approve' : 'reject',
        'action_ids': ids,
        'digest': run.approvalDigest,
        'nonce': run.reviewNonce,
      });
      ref.invalidate(agentRunProvider(run.id));
      ref.invalidate(agentRunsProvider);
      if (result.status == 'completed') {
        ref.invalidate(moduleRecordsProvider);
        ref.invalidate(moduleReportProvider);
        ref.invalidate(tasksProvider);
        ref.invalidate(goalsProvider);
        ref.invalidate(habitsProvider);
        ref.invalidate(memoriesProvider);
        ref.invalidate(eventsProvider);
        ref.invalidate(dashboardProvider);
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ref
      .watch(agentRunProvider(widget.id))
      .when(
        loading: () => const Center(child: UniverseLoadingState()),
        error: (e, _) {
          poll(false);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(agentRunProvider(widget.id)),
            ),
          );
        },
        data: (run) {
          poll(run.active);
          if (previewDigest != run.approvalDigest) {
            previewDigest = run.approvalDigest;
            selected.clear();
          }
          final dependenciesMet = run.actions
              .where((a) => selected.contains(a.id))
              .every((a) => a.dependencies.every(selected.contains));
          final expired =
              run.reviewExpiresAt != null &&
              !run.reviewExpiresAt!.isAfter(DateTime.now());
          final orb = switch (run.status) {
            'queued' => OrbState.understanding,
            'running' => OrbState.planning,
            'awaiting_approval' => OrbState.awaitingApproval,
            'completed' => OrbState.completed,
            'failed' || 'stale' => OrbState.error,
            _ => OrbState.idle,
          };
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: AIOrb(
                  size: 110,
                  state: orb,
                  animate: !ref.watch(reduceMotionProvider),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    statusLabel(run.status).toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SelectableText(
                run.prompt,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (run.plan.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(run.plan),
                ),
              Wrap(
                spacing: 8,
                children: [
                  for (final agent in run.agents)
                    Chip(label: Text(scopes[agent] ?? 'Assistant')),
                ],
              ),
              if (run.summary.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SelectableText(run.summary),
                ),
              if (run.error.isNotEmpty)
                Text(
                  run.error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              if (run.active)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'You can leave this page. The worker saves progress, and no proposals are applied automatically.',
                  ),
                ),
              if (run.reviewable) ...[
                const SizedBox(height: 24),
                Text(
                  'Review every change',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Select the changes you want. Unselected proposals will be rejected. Expires ${run.reviewExpiresAt == null ? '' : deviceDate(run.reviewExpiresAt!)}.',
                ),
              ],
              for (final action in run.actions)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: UniverseSurface(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (run.reviewable)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Change ${action.position} · ${action.label}',
                            ),
                            value: selected.contains(action.id),
                            onChanged: busy || expired
                                ? null
                                : (value) => setState(() {
                                    value == true
                                        ? selected.add(action.id)
                                        : selected.remove(action.id);
                                  }),
                          )
                        else
                          Text(
                            '${action.position}. ${action.label} · ${action.status}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        if (action.dependencies.isNotEmpty)
                          Text(
                            'Requires change ${run.actions.where((a) => action.dependencies.contains(a.id)).map((a) => a.position).join(', ')} to be selected.',
                          ),
                        for (final field in action.preview)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  field.name,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                if (field.before != null)
                                  Text('Before: ${field.before}'),
                                SelectableText('After: ${field.after}'),
                              ],
                            ),
                          ),
                        if (action.result?['applied'] == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text('Applied to your account'),
                          ),
                      ],
                    ),
                  ),
                ),
              if (run.reviewable) ...[
                const SizedBox(height: 16),
                if (!dependenciesMet)
                  const Text(
                    'Select the prerequisite changes, or deselect their dependent changes.',
                  ),
                if (expired)
                  const Text('This preview has expired. Start a new plan.'),
                FilledButton(
                  onPressed:
                      busy || expired || selected.isEmpty || !dependenciesMet
                      ? null
                      : () => decide(run, true),
                  child: Text(
                    busy
                        ? 'Saving decision…'
                        : 'Approve ${selected.length} selected changes',
                  ),
                ),
                TextButton(
                  onPressed: busy ? null : () => decide(run, false),
                  child: const Text('Reject all proposals'),
                ),
              ],
              if (error != null)
                Semantics(liveRegion: true, child: Text(error!)),
              const SizedBox(height: 24),
              if (run.sources.isNotEmpty) ...[
                Text(
                  'Reference sources',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                for (final source in run.sources)
                  Card(
                    child: ListTile(
                      title: Text('[${source.label}] ${source.title}'),
                      subtitle: Text(
                        '${source.kind} · ${source.mode} retrieval',
                      ),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => showSource(context, ref, source),
                    ),
                  ),
              ],
              ExpansionTile(
                title: const Text('Execution timeline'),
                subtitle: Text(
                  '${run.modelCalls} model calls · ${run.toolCalls} tool calls',
                ),
                children: [
                  for (final step in run.steps)
                    ListTile(
                      leading: Icon(
                        step.status == 'failed'
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                      ),
                      title: Text(step.summary),
                      subtitle: Text(
                        '${step.sequence} · ${step.agent} · ${step.kind} · ${step.status}\n${deviceDate(step.createdAt)}',
                      ),
                    ),
                ],
              ),
              Wrap(
                spacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        ref.invalidate(agentRunProvider(widget.id)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
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
                            content: Text(
                              'Run history copied. It may contain personal information.',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy history'),
                  ),
                  if (run.active || run.reviewable)
                    TextButton(
                      onPressed: busy
                          ? null
                          : () async {
                              if (!await confirmAction(
                                context,
                                title: 'Cancel this plan?',
                                message:
                                    'Unapproved changes will not be applied.',
                                action: 'Cancel plan',
                              )) {
                                return;
                              }
                              setState(() => busy = true);
                              try {
                                await ref
                                    .read(agentRepositoryProvider)
                                    .cancel(run.id);
                                ref.invalidate(agentRunProvider(run.id));
                                ref.invalidate(agentRunsProvider);
                              } catch (e) {
                                if (mounted) {
                                  setState(() => error = e.toString());
                                }
                              } finally {
                                if (mounted) setState(() => busy = false);
                              }
                            },
                      child: const Text('Cancel plan'),
                    )
                  else
                    TextButton(
                      onPressed: busy
                          ? null
                          : () async {
                              if (!await confirmAction(
                                context,
                                title: 'Delete this history?',
                                message:
                                    'Deletes the prompt, proposals and timeline. Applied life records remain in their spaces.',
                              )) {
                                return;
                              }
                              setState(() => busy = true);
                              try {
                                await ref
                                    .read(agentRepositoryProvider)
                                    .remove(run.id);
                                ref.invalidate(agentRunsProvider);
                                if (context.mounted) context.go('/agents');
                              } catch (e) {
                                if (mounted) {
                                  setState(() => error = e.toString());
                                }
                              } finally {
                                if (mounted) setState(() => busy = false);
                              }
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

Future<void> showSource(
  BuildContext context,
  WidgetRef ref,
  AgentSource source,
) async {
  try {
    final current = await ref
        .read(agentRepositoryProvider)
        .source(source.kind, source.sourceId);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('[${source.label}] ${current['title']}'),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: SelectableText(
              'Current source\n${current['content']}\n\nExcerpt used for this run\n${source.excerpt}',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Source unavailable: $e')));
    }
  }
}
