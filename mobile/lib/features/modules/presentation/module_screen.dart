import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/module_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/module_providers.dart';
import '../domain/module_spec.dart';
import 'module_editor.dart';

class AdvancedModuleScreen extends ConsumerStatefulWidget {
  const AdvancedModuleScreen({required this.module, super.key});
  final String module;
  @override
  ConsumerState<AdvancedModuleScreen> createState() => _ModuleState();
}

class _ModuleState extends ConsumerState<AdvancedModuleScreen> {
  late final spec = advancedModules[widget.module]!;
  late String kind = spec.kinds.keys.first;
  int offset = 0;
  String search = '';
  DateTime? month;
  bool busy = false;
  final selected = <String>{};
  final plannerIds = <String, String>{};
  Future<void> action(Future<void> Function() callback) async {
    setState(() => busy = true);
    try {
      await callback();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void refresh() {
    ref.invalidate(moduleRecordsProvider);
    ref.invalidate(moduleReportProvider);
  }

  Future<void> practice(ModuleRecord row) async {
    if (row.kind == 'flashcard') {
      await showDialog<void>(
        context: context,
        builder: (_) => FlashcardDialog(record: row),
      );
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => QuizDialog(id: row.id),
    );
  }

  Future<void> showResume(ModuleRecord row) async {
    final result = await ref.read(moduleRepositoryProvider).resume(row.id);
    if (!mounted) return;
    setState(() => busy = false);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your resume & keyword review'),
        content: SizedBox(
          width: 650,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(result['text'] as String),
                const SizedBox(height: 24),
                Text(
                  'Missing sections: ${(result['missing_sections'] as List).join(', ')}',
                ),
                Text(
                  'Matched terms: ${(result['matched_terms'] as List).join(', ')}',
                ),
                Text(
                  'Review terms: ${(result['review_terms'] as List).join(', ')}',
                ),
                const SizedBox(height: 12),
                Text(result['method'] as String),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: result['text'] as String),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Resume text copied')),
                );
              }
            },
            child: const Text('Copy resume'),
          ),
        ],
      ),
    );
  }

  Future<void> scenarios(List<String> ids) async {
    final results = <Map<String, dynamic>>[];
    for (final id in ids) {
      results.add(await ref.read(moduleRepositoryProvider).projection(id));
    }
    if (!mounted) return;
    setState(() => busy = false);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          ids.length == 1 ? 'Scenario estimate' : 'Compare your assumptions',
        ),
        content: SizedBox(
          width: 760,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Values are calculated estimates using your inputs. Different currencies are shown separately and are not converted.',
                ),
                const SizedBox(height: 16),
                for (var i = 0; i < results.length; i++) ...[
                  Text(
                    '${results[i]['title'] ?? 'Scenario ${i + 1}'} · ${results[i]['type']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${results[i]['currency']} ${results[i]['projected_balance']} projected balance · ${results[i]['contributed']} contributed',
                  ),
                  Text(
                    '${results[i]['estimated_hours']} estimated hours / ${results[i]['target_hours']} target hours',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    width: 500,
                    child: CustomPaint(
                      painter: ProjectionPainter(
                        (results[i]['points'] as List)
                            .map(
                              (p) =>
                                  double.parse((p as Map)['balance'] as String),
                            )
                            .toList(),
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Text('Assumptions: ${results[i]['assumptions']}'),
                  Text('Risks: ${results[i]['risks']}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(results[i]['method'] as String),
                  ),
                  const Divider(),
                ],
              ],
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
  }

  @override
  Widget build(BuildContext context) {
    final query = (
      module: widget.module,
      kind: kind,
      offset: offset,
      search: search,
    );
    final reportQuery = (
      module: widget.module,
      month: month?.toIso8601String().substring(0, 10),
    );
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(spec.icon, size: 36, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(spec.headline, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 12),
        Text(spec.description),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              onPressed: () =>
                  context.push('/agents/new?scope=${widget.module}'),
              icon: const Icon(Icons.auto_awesome_outlined),
              label: const Text('Ask this specialist'),
            ),
            if (widget.module == 'wellness')
              TextButton(
                onPressed: () => context.push('/habits'),
                child: const Text('Daily habits'),
              ),
            if (widget.module == 'learning')
              TextButton(
                onPressed: () => context.push('/knowledge-universe'),
                child: const Text('Knowledge Universe'),
              ),
            if (widget.module == 'travel')
              TextButton(
                onPressed: () => context.push('/vault'),
                child: const Text('Travel documents'),
              ),
            IconButton(
              tooltip: 'Refresh module',
              onPressed: refresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        if (widget.module == 'finance') ...[
          TextButton.icon(
            onPressed: () async {
              final chosen = await showDatePicker(
                context: context,
                initialDate: month ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
              );
              if (chosen != null) {
                setState(() => month = DateTime(chosen.year, chosen.month));
              }
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              month == null
                  ? 'Report: current month'
                  : 'Report: ${month!.year}-${month!.month.toString().padLeft(2, '0')}',
            ),
          ),
          TextButton(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const CurrencyDialog(),
            ),
            child: const Text('Convert with your own exchange rate'),
          ),
        ],
        const SizedBox(height: 16),
        ref
            .watch(moduleReportProvider(reportQuery))
            .when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => UniverseErrorState(
                message: e.toString(),
                onRetry: () =>
                    ref.invalidate(moduleReportProvider(reportQuery)),
              ),
              data: (report) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final metric in report.metrics)
                        SizedBox(
                          width: 230,
                          child: UniverseSurface(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(metric.label),
                                const SizedBox(height: 8),
                                Text(
                                  metric.value,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                if (metric.detail.isNotEmpty)
                                  Text(metric.detail),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (report.lines.isNotEmpty)
                    ExpansionTile(
                      title: const Text('Details from your records'),
                      children: [
                        for (final line in report.lines)
                          ListTile(
                            title: Text(line.label),
                            subtitle: Text(line.value),
                          ),
                      ],
                    ),
                  TextButton.icon(
                    onPressed: () => action(() async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: const JsonEncoder.withIndent(
                            '  ',
                          ).convert(report.toJson()),
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Report copied')),
                        );
                      }
                    }),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy report'),
                  ),
                ],
              ),
            ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in spec.kinds.entries)
              ChoiceChip(
                label: Text(entry.value),
                selected: kind == entry.key,
                onSelected: (_) => setState(() {
                  kind = entry.key;
                  offset = 0;
                  selected.clear();
                }),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy
              ? null
              : () => editModuleRecord(context, ref, widget.module, kind),
          icon: const Icon(Icons.add),
          label: Text('New ${kindNames[kind]}'),
        ),
        const SizedBox(height: 16),
        RecordSearch(
          onSearch: (value) => setState(() {
            search = value;
            offset = 0;
          }),
        ),
        if (widget.module == 'finance')
          const Text(
            'All saved records below. The report above uses the selected month.',
          ),
        if (widget.module == 'future')
          FilledButton.tonal(
            onPressed: busy || selected.length < 2
                ? null
                : () => action(() => scenarios(selected.toList())),
            child: Text('Compare ${selected.length} selected scenarios'),
          ),
        if (busy) const LinearProgressIndicator(),
        const SizedBox(height: 16),
        ref
            .watch(moduleRecordsProvider(query))
            .when(
              loading: () => const UniverseLoadingState(),
              error: (e, _) => UniverseErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(moduleRecordsProvider(query)),
              ),
              data: (page) => Column(
                children: [
                  if (page.items.isEmpty)
                    const UniverseEmptyState(
                      title: 'Only what you add',
                      message:
                          'Create your first record. This space uses your saved information.',
                    ),
                  for (final row in page.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: UniverseSurface(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (row.kind == 'scenario')
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(row.title),
                                value: selected.contains(row.id),
                                onChanged: (value) => setState(() {
                                  if (value == true && selected.length < 4) {
                                    selected.add(row.id);
                                  } else {
                                    selected.remove(row.id);
                                  }
                                }),
                              )
                            else
                              Text(
                                row.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            const SizedBox(height: 8),
                            for (final field
                                in row.data.entries
                                    .where(
                                      (e) =>
                                          e.key != 'title' &&
                                          e.key != 'notes' &&
                                          e.value != null,
                                    )
                                    .take(4))
                              Text(
                                '${field.key.replaceAll('_', ' ')}: ${field.value}',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            const SizedBox(height: 8),
                            Text(
                              row.allowAi
                                  ? 'Shared with AI when this scope is selected'
                                  : 'Private · not available to AI',
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton(
                                  onPressed: busy
                                      ? null
                                      : () => editModuleRecord(
                                          context,
                                          ref,
                                          widget.module,
                                          row.kind,
                                          item: row,
                                        ),
                                  child: const Text('View / edit'),
                                ),
                                if (row.kind == 'flashcard' ||
                                    row.kind == 'quiz')
                                  TextButton(
                                    onPressed: () => practice(row),
                                    child: const Text('Practice'),
                                  ),
                                if (row.kind == 'resume')
                                  TextButton(
                                    onPressed: busy
                                        ? null
                                        : () => action(() => showResume(row)),
                                    child: const Text(
                                      'Resume & keyword review',
                                    ),
                                  ),
                                if (row.kind == 'scenario')
                                  TextButton(
                                    onPressed: busy
                                        ? null
                                        : () =>
                                              action(() => scenarios([row.id])),
                                    child: const Text('View estimate'),
                                  ),
                                TextButton(
                                  onPressed: busy
                                      ? null
                                      : () => action(() async {
                                          final id = plannerIds.putIfAbsent(
                                            row.id,
                                            () => const Uuid().v4(),
                                          );
                                          await ref
                                              .read(moduleRepositoryProvider)
                                              .plan(row.id, id);
                                          ref.invalidate(tasksProvider);
                                          ref.invalidate(dashboardProvider);
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Task saved to Planner',
                                                ),
                                                action: SnackBarAction(
                                                  label: 'Open',
                                                  onPressed: () =>
                                                      context.push('/planner'),
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  child: const Text('Add task to Planner'),
                                ),
                                IconButton(
                                  tooltip: 'Delete record',
                                  onPressed: busy
                                      ? null
                                      : () async {
                                          if (!await confirmAction(
                                            context,
                                            title:
                                                'Delete this ${kindNames[row.kind]}?',
                                            message:
                                                row.kind == 'trip' ||
                                                    row.kind == 'course'
                                                ? 'This also deletes its linked child records. Existing Planner tasks remain.'
                                                : 'This permanently deletes the record. Existing Planner tasks remain.',
                                          )) {
                                            return;
                                          }
                                          await action(() async {
                                            await ref
                                                .read(moduleRepositoryProvider)
                                                .remove(row.id);
                                            selected.remove(row.id);
                                            refresh();
                                          });
                                        },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}

class FlashcardDialog extends StatefulWidget {
  const FlashcardDialog({required this.record, super.key});
  final ModuleRecord record;
  @override
  State<FlashcardDialog> createState() => _FlashcardState();
}

class _FlashcardState extends State<FlashcardDialog> {
  bool reveal = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.record.title),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.record.data['question'] as String),
          if (reveal) ...[
            const SizedBox(height: 24),
            SelectableText(widget.record.data['answer'] as String),
          ],
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      FilledButton(
        onPressed: () => setState(() => reveal = !reveal),
        child: Text(reveal ? 'Hide answer' : 'Reveal answer'),
      ),
    ],
  );
}

class QuizDialog extends ConsumerStatefulWidget {
  const QuizDialog({required this.id, super.key});
  final String id;
  @override
  ConsumerState<QuizDialog> createState() => _QuizState();
}

class _QuizState extends ConsumerState<QuizDialog> {
  late final Future<Map<String, dynamic>> question = ref
      .read(moduleRepositoryProvider)
      .practice(widget.id);
  String? chosen, error;
  Map<String, dynamic>? result;
  bool busy = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Practice question'),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: question,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text(snapshot.error.toString());
            if (!snapshot.hasData) return const LinearProgressIndicator();
            final data = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['question'] as String),
                const SizedBox(height: 16),
                for (final entry
                    in (data['options'] as Map<String, dynamic>).entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OutlinedButton(
                      onPressed: busy
                          ? null
                          : () => setState(() {
                              chosen = entry.key;
                              result = null;
                            }),
                      child: Row(
                        children: [
                          Icon(
                            chosen == entry.key
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text('${entry.key}. ${entry.value}')),
                        ],
                      ),
                    ),
                  ),
                if (result != null) ...[
                  Text(
                    result!['correct'] == true
                        ? 'Correct · 1 / 1'
                        : 'Keep exploring · 0 / 1',
                  ),
                  Text('Answer: ${result!['answer']}'),
                  Text(result!['explanation'] as String),
                ],
                if (error != null) Text(error!),
              ],
            );
          },
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      FilledButton(
        onPressed: chosen == null || busy
            ? null
            : () async {
                setState(() => busy = true);
                try {
                  final value = await ref
                      .read(moduleRepositoryProvider)
                      .answer(widget.id, chosen!);
                  if (mounted) setState(() => result = value);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: const Text('Check answer'),
      ),
    ],
  );
}

class CurrencyDialog extends ConsumerStatefulWidget {
  const CurrencyDialog({super.key});
  @override
  ConsumerState<CurrencyDialog> createState() => _CurrencyState();
}

class _CurrencyState extends ConsumerState<CurrencyDialog> {
  final amount = TextEditingController(), rate = TextEditingController();
  String from = 'USD', to = 'INR';
  DateTime date = DateTime.now();
  String? result, error;
  bool busy = false;
  static const currencies = [
    'INR',
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SGD',
    'AED',
  ];
  @override
  void dispose() {
    amount.dispose();
    rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Manual currency conversion'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: amount,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          DropdownButtonFormField<String>(
            initialValue: from,
            decoration: const InputDecoration(labelText: 'From'),
            items: [
              for (final c in currencies)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) => setState(() => from = v!),
          ),
          DropdownButtonFormField<String>(
            initialValue: to,
            decoration: const InputDecoration(labelText: 'To'),
            items: [
              for (final c in currencies)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) => setState(() => to = v!),
          ),
          TextField(
            controller: rate,
            decoration: const InputDecoration(
              labelText: 'Your exchange rate',
              helperText: 'One source unit in target currency. No live feed.',
            ),
            keyboardType: TextInputType.number,
          ),
          TextButton(
            onPressed: () async {
              final chosen = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(1900),
                lastDate: DateTime(2200),
              );
              if (chosen != null) setState(() => date = chosen);
            },
            child: Text(
              'Rate date: ${date.toIso8601String().substring(0, 10)}',
            ),
          ),
          if (result != null) SelectableText(result!),
          if (error != null) Text(error!),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
      FilledButton(
        onPressed: busy
            ? null
            : () async {
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  final value = await ref
                      .read(moduleRepositoryProvider)
                      .convert({
                        'amount': amount.text,
                        'from_currency': from,
                        'to_currency': to,
                        'rate': rate.text,
                        'rate_date': date.toIso8601String().substring(0, 10),
                      });
                  if (mounted) {
                    setState(
                      () => result =
                          '${value['currency']} ${value['amount']}\n${value['method']}',
                    );
                  }
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: const Text('Calculate'),
      ),
    ],
  );
}

class ProjectionPainter extends CustomPainter {
  ProjectionPainter(this.values, this.color);
  final List<double> values;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final low = values.reduce(math.min), high = values.reduce(math.max);
    final range = math.max(high - low, 1);
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width,
          y = size.height - (values[i] - low) / range * (size.height - 12) - 6;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(ProjectionPainter old) =>
      old.values != values || old.color != color;
}
