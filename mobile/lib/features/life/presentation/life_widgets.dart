import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/life_models.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/universe_components.dart';
import '../application/life_providers.dart';
import '../data/life_repository.dart';

String deviceDate(DateTime value) =>
    DateFormat.yMMMd().add_jm().format(value.toLocal());
String plainDate(String value) =>
    DateFormat.yMMMd().format(DateTime.parse(value));
String? requiredTitle(String? value) =>
    (value?.trim().isEmpty ?? true) ? 'Enter a title' : null;

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  String action = 'Delete',
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    ) ??
    false;

Future<void> runLifeAction(
  BuildContext context,
  WidgetRef ref,
  Future<void> Function(LifeRepository repository) action, {
  String? success,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref.read(mutationProvider.notifier).run(action);
    if (success != null) {
      messenger.showSnackBar(SnackBar(content: Text(success)));
    }
  } catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

Future<void> removeRecord(
  BuildContext context,
  WidgetRef ref,
  RecordKind kind,
  String id,
) async {
  if (!await confirmAction(
    context,
    title: 'Delete this record?',
    message: kind == RecordKind.goals
        ? 'This goal will be deleted. Linked tasks will remain without a goal link.'
        : 'This will permanently delete the record${kind == RecordKind.habits ? ' and its check-ins' : ''}.',
  )) {
    return;
  }
  if (context.mounted) {
    await runLifeAction(
      context,
      ref,
      (repository) => repository.remove(kind, id),
      success: 'Record deleted',
    );
  }
}

class PageControls extends StatelessWidget {
  const PageControls({
    required this.total,
    required this.offset,
    required this.limit,
    required this.onOffset,
    super.key,
  });
  final int total;
  final int offset;
  final int limit;
  final ValueChanged<int> onOffset;
  @override
  Widget build(BuildContext context) => Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 8,
    children: [
      Text(
        total == 0
            ? 'No records'
            : '${offset + 1}–${(offset + limit).clamp(0, total)} of $total',
      ),
      IconButton(
        tooltip: 'Previous page',
        onPressed: offset == 0
            ? null
            : () => onOffset((offset - limit).clamp(0, total)),
        icon: const Icon(Icons.chevron_left),
      ),
      IconButton(
        tooltip: 'Next page',
        onPressed: offset + limit >= total
            ? null
            : () => onOffset(offset + limit),
        icon: const Icon(Icons.chevron_right),
      ),
    ],
  );
}

class RecordsView<T> extends StatelessWidget {
  const RecordsView({
    required this.data,
    required this.onRetry,
    required this.itemBuilder,
    required this.onOffset,
    this.emptyTitle = 'A fresh start',
    this.emptyMessage = 'Add your first record when you’re ready.',
    super.key,
  });
  final AsyncValue<DataPage<T>> data;
  final VoidCallback onRetry;
  final Widget Function(T item) itemBuilder;
  final ValueChanged<int> onOffset;
  final String emptyTitle;
  final String emptyMessage;
  @override
  Widget build(BuildContext context) => data.when(
    skipLoadingOnRefresh: false,
    loading: () => const UniverseLoadingState(),
    error: (error, stack) =>
        UniverseErrorState(message: error.toString(), onRetry: onRetry),
    data: (page) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (page.items.isEmpty)
          UniverseEmptyState(title: emptyTitle, message: emptyMessage)
        else
          for (final item in page.items)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.md),
              child: itemBuilder(item),
            ),
        PageControls(
          total: page.total,
          offset: page.offset,
          limit: page.limit,
          onOffset: onOffset,
        ),
      ],
    ),
  );
}

class RecordSearch extends StatefulWidget {
  const RecordSearch({required this.onSearch, super.key});
  final ValueChanged<String> onSearch;
  @override
  State<RecordSearch> createState() => _RecordSearchState();
}

class _RecordSearchState extends State<RecordSearch> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLength: 120,
    decoration: InputDecoration(
      labelText: 'Search titles',
      counterText: '',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: IconButton(
        tooltip: 'Search',
        icon: const Icon(Icons.arrow_forward),
        onPressed: () => widget.onSearch(controller.text.trim()),
      ),
    ),
    textInputAction: TextInputAction.search,
    onSubmitted: (value) => widget.onSearch(value.trim()),
  );
}

class RecordActions extends StatelessWidget {
  const RecordActions({
    required this.onEdit,
    required this.onDelete,
    this.extra,
    super.key,
  });
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Widget? extra;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      ?extra,
      TextButton.icon(
        onPressed: onEdit,
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('Edit'),
      ),
      IconButton(
        tooltip: 'Delete record',
        onPressed: onDelete,
        icon: const Icon(Icons.delete_outline_rounded),
      ),
    ],
  );
}
