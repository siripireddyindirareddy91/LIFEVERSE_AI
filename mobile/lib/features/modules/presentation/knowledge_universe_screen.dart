import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/module_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/module_providers.dart';

class KnowledgeUniverseScreen extends ConsumerStatefulWidget {
  const KnowledgeUniverseScreen({super.key});
  @override
  ConsumerState<KnowledgeUniverseScreen> createState() => _KnowledgeState();
}

class _KnowledgeState extends ConsumerState<KnowledgeUniverseScreen> {
  String query = '';
  String? focus;
  bool busy = false, semantic = false;
  final search = TextEditingController();
  Map<String, dynamic>? results;
  String? error;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> connect(KnowledgeGraph graph) async {
    final value =
        await showDialog<({String source, String target, String label})>(
          context: context,
          builder: (_) => ConnectionEditor(nodes: graph.nodes),
        );
    if (value == null) return;
    try {
      await ref
          .read(moduleRepositoryProvider)
          .connect(value.source, value.target, value.label);
      ref.invalidate(knowledgeGraphProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Icon(
        Icons.hub_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 12),
      Text(
        'Let your ideas connect.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Build connections between your own notes and reference sources. Your graph is private. AI retrieval uses only sources you explicitly share.',
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        children: [
          FilledButton.icon(
            onPressed: () => context.push('/knowledge'),
            icon: const Icon(Icons.library_books_outlined),
            label: const Text('Manage sources'),
          ),
          TextButton(
            onPressed: () => context.push('/agents/new?scope=knowledge'),
            child: const Text('Ask over shared knowledge'),
          ),
        ],
      ),
      const SizedBox(height: 24),
      RecordSearch(
        onSearch: (v) => setState(() {
          query = v;
          focus = null;
        }),
      ),
      ref
          .watch(knowledgeGraphProvider(query))
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(knowledgeGraphProvider),
            ),
            data: (graph) {
              final current =
                  graph.nodes.where((n) => n.id == focus).firstOrNull ??
                  graph.nodes.firstOrNull;
              final edges = current == null
                  ? <KnowledgeEdge>[]
                  : graph.edges
                        .where(
                          (e) =>
                              e.sourceId == current.id ||
                              e.targetId == current.id,
                        )
                        .toList();
              final ids = {
                for (final e in edges)
                  e.sourceId == current?.id ? e.targetId : e.sourceId,
              };
              final neighbors = graph.nodes
                  .where((n) => ids.contains(n.id))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  if (graph.nodes.isEmpty)
                    const UniverseEmptyState(
                      title: 'Start with one idea',
                      message:
                          'Add sources, then link concepts to build your knowledge universe.',
                    ),
                  if (current != null) ...[
                    DropdownButtonFormField<String>(
                      key: ValueKey(current.id),
                      initialValue: current.id,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Explore a source',
                      ),
                      items: [
                        for (final n in graph.nodes)
                          DropdownMenuItem(
                            value: n.id,
                            child: Text(
                              n.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (v) => setState(() => focus = v),
                    ),
                    const SizedBox(height: 16),
                    UniverseSurface(
                      child: KnowledgeConstellation(
                        center: current,
                        neighbors: neighbors.take(8).toList(),
                        onSelect: (id) => setState(() => focus = id),
                      ),
                    ),
                    if (neighbors.length > 8)
                      const Text(
                        'Eight neighboring sources shown in the graph; all loaded connections appear below.',
                      ),
                    if (graph.total > graph.limit)
                      Text(
                        'Showing ${graph.limit} of ${graph.total} sources. Search titles to narrow this view.',
                      ),
                    const SizedBox(height: 16),
                    FilledButton.tonalIcon(
                      onPressed: graph.nodes.length < 2
                          ? null
                          : () => connect(graph),
                      icon: const Icon(Icons.add_link),
                      label: const Text('Connect two sources'),
                    ),
                    for (final edge in edges)
                      ListTile(
                        title: Text(
                          '${graph.nodes.firstWhere((n) => n.id == edge.sourceId).title} → ${graph.nodes.firstWhere((n) => n.id == edge.targetId).title}',
                        ),
                        subtitle: Text(edge.label),
                        trailing: IconButton(
                          tooltip: 'Remove connection',
                          icon: const Icon(Icons.link_off),
                          onPressed: () async {
                            if (!await confirmAction(
                              context,
                              title: 'Remove this connection?',
                              message: 'The source notes remain.',
                              action: 'Remove connection',
                            )) {
                              return;
                            }
                            try {
                              await ref
                                  .read(moduleRepositoryProvider)
                                  .disconnect(edge.id);
                              ref.invalidate(knowledgeGraphProvider);
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
                  ],
                ],
              );
            },
          ),
      const SizedBox(height: 32),
      Text(
        'Find a shared reference',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const Text(
        'Search the sources shared with AI. Knowledge and AI permissions in Profile are required. Semantic search sends the query to your embedding provider.',
      ),
      const SizedBox(height: 16),
      TextField(
        controller: search,
        minLines: 1,
        maxLines: 3,
        maxLength: 2000,
        decoration: const InputDecoration(labelText: 'Search shared content'),
      ),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Include semantic retrieval'),
        value: semantic,
        onChanged: busy ? null : (v) => setState(() => semantic = v),
      ),
      FilledButton.tonal(
        onPressed: busy
            ? null
            : () async {
                if (search.text.trim().isEmpty) return;
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  final value = await ref
                      .read(moduleRepositoryProvider)
                      .searchKnowledge(search.text.trim(), semantic);
                  if (mounted) setState(() => results = value);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: Text(busy ? 'Searching…' : 'Search references'),
      ),
      if (error != null) Text(error!),
      if (results != null) ...[
        Text('Retrieval mode: ${results!['mode']}'),
        if (results!['warning'] != null) Text(results!['warning'] as String),
        if ((results!['sources'] as List).isEmpty)
          const Text(
            'No shared sources matched. Try different words or index a source for semantic search.',
          ),
        for (final source in results!['sources'] as List)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: UniverseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (source as Map)['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(source['excerpt'] as String),
                ],
              ),
            ),
          ),
      ],
    ],
  );
}

class KnowledgeConstellation extends StatelessWidget {
  const KnowledgeConstellation({
    required this.center,
    required this.neighbors,
    required this.onSelect,
    super.key,
  });
  final KnowledgeNode center;
  final List<KnowledgeNode> neighbors;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = box.maxWidth,
          height = 340.0,
          c = Offset(width / 2, height / 2),
          radius = math.min(width / 2 - 40, 115.0);
      final positions = [
        for (var i = 0; i < neighbors.length; i++)
          c +
              Offset(
                math.cos(
                      i * 2 * math.pi / math.max(neighbors.length, 1) -
                          math.pi / 2,
                    ) *
                    radius,
                math.sin(
                      i * 2 * math.pi / math.max(neighbors.length, 1) -
                          math.pi / 2,
                    ) *
                    radius,
              ),
      ];
      Widget node(KnowledgeNode value, Offset position, bool primary) =>
          Positioned(
            left: position.dx - 38,
            top: position.dy - 32,
            width: 76,
            height: 64,
            child: Semantics(
              button: true,
              label: 'Explore ${value.title}',
              child: Tooltip(
                message: value.title,
                child: Material(
                  color: primary
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onSelect(value.id),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Center(
                        child: Text(
                          value.title,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
      return SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _ConnectionPainter(
                  c,
                  positions,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            node(center, c, true),
            for (var i = 0; i < neighbors.length; i++)
              node(neighbors[i], positions[i], false),
          ],
        ),
      );
    },
  );
}

class _ConnectionPainter extends CustomPainter {
  _ConnectionPainter(this.center, this.positions, this.color);
  final Offset center;
  final List<Offset> positions;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in positions) {
      canvas.drawLine(
        center,
        p,
        Paint()
          ..color = color.withValues(alpha: .5)
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_ConnectionPainter old) =>
      old.center != center || old.positions != positions || old.color != color;
}

class ConnectionEditor extends StatefulWidget {
  const ConnectionEditor({required this.nodes, super.key});
  final List<KnowledgeNode> nodes;
  @override
  State<ConnectionEditor> createState() => _ConnectionState();
}

class _ConnectionState extends State<ConnectionEditor> {
  late String source = widget.nodes.first.id, target = widget.nodes[1].id;
  final label = TextEditingController(text: 'related');
  @override
  void dispose() {
    label.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Connect concepts'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: source,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'From source'),
            items: [
              for (final n in widget.nodes)
                DropdownMenuItem(
                  value: n.id,
                  child: Text(n.title, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (v) => setState(() => source = v!),
          ),
          DropdownButtonFormField<String>(
            initialValue: target,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'To source'),
            items: [
              for (final n in widget.nodes)
                DropdownMenuItem(
                  value: n.id,
                  child: Text(n.title, overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: (v) => setState(() => target = v!),
          ),
          TextField(
            controller: label,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Relationship'),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: source == target
            ? null
            : () => Navigator.pop(context, (
                source: source,
                target: target,
                label: label.text.trim().isEmpty
                    ? 'related'
                    : label.text.trim(),
              )),
        child: const Text('Connect'),
      ),
    ],
  );
}
