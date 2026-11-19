import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/data/life_repository.dart';
import '../../life/presentation/life_widgets.dart';
import '../../life/presentation/record_editor.dart';

class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen({super.key});
  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  LifeQuery _query = const LifeQuery();
  bool _exporting = false;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Space.lg),
    children: [
      Text(
        'Remember, on your terms.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: Space.md),
      const Text(
        'Choose what to save, what can be shared with AI and when it should expire. Chats never become memories automatically.',
      ),
      const SizedBox(height: Space.lg),
      LifeverseButton(
        label: 'New memory',
        icon: Icons.add,
        onPressed: () => openRecordEditor(context, RecordKind.memories),
      ),
      const SizedBox(height: Space.sm),
      Wrap(
        spacing: 8,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.copy_all_outlined),
            label: Text(_exporting ? 'Exporting…' : 'Copy JSON export'),
            onPressed: _exporting
                ? null
                : () async {
                    setState(() => _exporting = true);
                    try {
                      final items = await ref
                          .read(lifeRepositoryProvider)
                          .exportMemories();
                      await Clipboard.setData(
                        ClipboardData(
                          text: const JsonEncoder.withIndent('  ').convert(
                            items.map((item) => item.toJson()).toList(),
                          ),
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Memory export copied to clipboard'),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _exporting = false);
                    }
                  },
          ),
          TextButton.icon(
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Erase all memories'),
            onPressed: () async {
              if (!await confirmAction(
                context,
                title: 'Erase all memories?',
                message:
                    'All saved memories will be permanently deleted. Chats are separate and can be deleted in Assistant.',
                action: 'Erase all',
              )) {
                return;
              }
              if (context.mounted) {
                await runLifeAction(
                  context,
                  ref,
                  (repo) => repo.eraseMemories(),
                  success: 'All saved memories erased',
                );
              }
            },
          ),
        ],
      ),
      const SizedBox(height: Space.md),
      RecordSearch(
        onSearch: (value) => setState(() => _query = LifeQuery(search: value)),
      ),
      const SizedBox(height: Space.lg),
      RecordsView<MemoryItem>(
        data: ref.watch(memoriesProvider(_query)),
        onRetry: () => ref.invalidate(memoriesProvider(_query)),
        onOffset: (value) =>
            setState(() => _query = _query.copyWith(offset: value)),
        emptyTitle: 'Only what you choose',
        emptyMessage:
            'Save a preference or useful piece of context. Nothing is collected here automatically.',
        itemBuilder: (memory) => UniverseSurface(
          accent: Aurora.orchid,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(memory.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Space.md),
              SelectableText(memory.content),
              const SizedBox(height: Space.md),
              StatusPill(
                memory.allowAi
                    ? 'AI sharing allowed with consent'
                    : 'Not shared with AI',
              ),
              if (memory.expiresAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Expires: ${deviceDate(memory.expiresAt!)}'),
                ),
              RecordActions(
                onEdit: () => openRecordEditor(
                  context,
                  RecordKind.memories,
                  initial: memory,
                ),
                onDelete: () =>
                    removeRecord(context, ref, RecordKind.memories, memory.id),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
