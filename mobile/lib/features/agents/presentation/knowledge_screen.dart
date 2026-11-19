import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/agent_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/agent_providers.dart';

class KnowledgeScreen extends ConsumerStatefulWidget {
  const KnowledgeScreen({super.key});
  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeState();
}

class _KnowledgeState extends ConsumerState<KnowledgeScreen> {
  int offset = 0;
  bool busy = false;
  Future<void> action(
    Future<void> Function() callback, {
    String? success,
  }) async {
    setState(() => busy = true);
    try {
      await callback();
      ref.invalidate(knowledgeProvider);
      if (mounted && success != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(success)));
      }
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

  Future<void> edit([KnowledgeItem? item]) async {
    final payload = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => KnowledgeEditor(item: item),
    );
    if (payload == null || !mounted) return;
    await action(
      () => ref
          .read(agentRepositoryProvider)
          .saveKnowledge(payload, id: item?.id),
    );
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(
        'Knowledge, on your terms.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Keep reference text privately, or share individual sources with your agents. Indexing sends shared text to the configured embedding provider and also requires knowledge permission in your profile.',
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: busy ? null : edit,
        icon: const Icon(Icons.add),
        label: const Text('Add knowledge source'),
      ),
      if (busy) const LinearProgressIndicator(),
      const SizedBox(height: 24),
      ref
          .watch(knowledgeProvider(offset))
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(knowledgeProvider),
            ),
            data: (page) => Column(
              children: [
                if (page.items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Add notes or reference text you want to keep close. Sources start private.',
                    ),
                  ),
                for (final item in page.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: UniverseSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.content,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item.allowAi ? 'Shared with AI' : 'Private'} · ${item.indexedChunks}/${item.chunkCount} chunks indexed',
                          ),
                          if (item.expiresAt != null)
                            Text('Expires ${deviceDate(item.expiresAt!)}'),
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: busy ? null : () => edit(item),
                                child: const Text('View / edit'),
                              ),
                              if (item.allowAi)
                                TextButton(
                                  onPressed: busy
                                      ? null
                                      : () async {
                                          if (!await confirmAction(
                                            context,
                                            title: 'Index this shared source?',
                                            message:
                                                'Its text will be sent to the configured embedding provider. Editing or unsharing it clears its index.',
                                            action: 'Index source',
                                          )) {
                                            return;
                                          }
                                          await action(() async {
                                            await ref
                                                .read(agentRepositoryProvider)
                                                .index('knowledge', item.id);
                                          }, success: 'Source indexed');
                                        },
                                  child: const Text('Index source'),
                                ),
                              TextButton(
                                onPressed: busy
                                    ? null
                                    : () async {
                                        if (!await confirmAction(
                                          context,
                                          title: 'Delete this source?',
                                          message:
                                              'Its text and retrieval index will be deleted. Past run excerpts remain until you delete their history.',
                                        )) {
                                          return;
                                        }
                                        await action(
                                          () => ref
                                              .read(agentRepositoryProvider)
                                              .deleteKnowledge(item.id),
                                        );
                                      },
                                child: const Text('Delete'),
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
                  onOffset: (v) => setState(() => offset = v),
                ),
              ],
            ),
          ),
    ],
  );
}

class KnowledgeEditor extends StatefulWidget {
  const KnowledgeEditor({this.item, super.key});
  final KnowledgeItem? item;
  @override
  State<KnowledgeEditor> createState() => _EditorState();
}

class _EditorState extends State<KnowledgeEditor> {
  final form = GlobalKey<FormState>();
  late final title = TextEditingController(text: widget.item?.title ?? '');
  late final content = TextEditingController(text: widget.item?.content ?? '');
  late bool shared = widget.item?.allowAi ?? false;
  late DateTime? expiry = widget.item?.expiresAt;
  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.item == null ? 'Add knowledge source' : 'Edit knowledge source',
    ),
    content: SizedBox(
      width: 620,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
                maxLength: 120,
                validator: requiredTitle,
              ),
              TextFormField(
                controller: content,
                decoration: const InputDecoration(labelText: 'Reference text'),
                minLines: 5,
                maxLines: 12,
                maxLength: 30000,
                validator: (v) => v?.trim().isNotEmpty == true
                    ? null
                    : 'Enter some reference text',
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Share this source with AI'),
                value: shared,
                onChanged: (v) => setState(() => shared = v),
              ),
              Text(
                expiry == null ? 'No expiry' : 'Expires ${deviceDate(expiry!)}',
              ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: () async {
                      final today = DateUtils.dateOnly(DateTime.now());
                      final chosen = await showDatePicker(
                        context: context,
                        initialDate: expiry?.isAfter(today) == true
                            ? expiry
                            : today.add(const Duration(days: 30)),
                        firstDate: today,
                        lastDate: today.add(const Duration(days: 3650)),
                      );
                      if (chosen != null && mounted) {
                        setState(
                          () => expiry = chosen.add(
                            const Duration(hours: 23, minutes: 59),
                          ),
                        );
                      }
                    },
                    child: const Text('Choose expiry'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => expiry = null),
                    child: const Text('Clear expiry'),
                  ),
                ],
              ),
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
      FilledButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          Navigator.pop(context, {
            'title': title.text.trim(),
            'content': content.text.trim(),
            'allow_ai': shared,
            'expires_at': expiry?.toUtc().toIso8601String(),
          });
        },
        child: const Text('Save source'),
      ),
    ],
  );
}
