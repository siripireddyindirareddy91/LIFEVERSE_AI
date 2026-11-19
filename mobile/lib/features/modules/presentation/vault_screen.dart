import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/module_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/module_providers.dart';
import '../data/vault_file_gateway.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});
  @override
  ConsumerState<VaultScreen> createState() => _VaultState();
}

class _VaultState extends ConsumerState<VaultScreen> {
  bool busy = false;
  int offset = 0;
  String search = '';
  void refresh() {
    ref.invalidate(vaultFilesProvider);
    ref.invalidate(vaultStatusProvider);
  }

  Future<void> action(Future<void> Function() callback) async {
    setState(() => busy = true);
    try {
      await callback();
      refresh();
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

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Icon(
        Icons.shield_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 12),
      Text(
        'A private place for life’s paperwork.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Store certificates, receipts, warranties and personal documents. Files are encrypted on the server and accessible through your account. AI sharing covers metadata only, never file contents.',
      ),
      const SizedBox(height: 24),
      ref
          .watch(vaultStatusProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(vaultStatusProvider),
            ),
            data: (status) => UniverseSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status.configured
                        ? 'Your vault is ready'
                        : 'Server encryption key required',
                  ),
                  Text(
                    '${(status.usedBytes / 1024 / 1024).toStringAsFixed(1)} / ${(status.quotaBytes / 1024 / 1024).round()} MiB used · 5 MiB per file',
                  ),
                  const Text(
                    'PDF, PNG, JPEG and UTF-8 text. Downloads use your device’s save dialog.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: busy || !status.configured
                        ? null
                        : () => action(() async {
                            final file = await ref
                                .read(vaultFileGatewayProvider)
                                .pick();
                            if (file == null || !context.mounted) return;
                            setState(() => busy = false);
                            await showDialog<void>(
                              context: context,
                              builder: (_) => VaultEditor(file: file),
                            );
                          }),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload document'),
                  ),
                ],
              ),
            ),
          ),
      TextButton.icon(
        onPressed: () => context.push('/agents/new?scope=vault'),
        icon: const Icon(Icons.auto_awesome_outlined),
        label: const Text('Ask about shared document metadata'),
      ),
      if (busy) const LinearProgressIndicator(),
      const SizedBox(height: 16),
      RecordSearch(
        onSearch: (value) => setState(() {
          search = value;
          offset = 0;
        }),
      ),
      const SizedBox(height: 16),
      ref
          .watch(vaultFilesProvider((offset: offset, search: search)))
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) =>
                UniverseErrorState(message: e.toString(), onRetry: refresh),
            data: (page) => Column(
              children: [
                if (page.items.isEmpty)
                  const UniverseEmptyState(
                    title: 'Room for your important things',
                    message:
                        'Upload your first document. No files are collected automatically.',
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
                          Text(
                            '${item.category} · ${item.filename} · ${(item.size / 1024).toStringAsFixed(1)} KiB',
                          ),
                          Text(
                            item.allowAi
                                ? 'Metadata shared with AI when selected'
                                : 'Private · metadata not shared with AI',
                          ),
                          if (item.expiresAt != null)
                            Text('Expires ${deviceDate(item.expiresAt!)}'),
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton.icon(
                                onPressed: busy
                                    ? null
                                    : () => action(() async {
                                        final result = await ref
                                            .read(moduleRepositoryProvider)
                                            .download(item.id);
                                        final saved = await ref
                                            .read(vaultFileGatewayProvider)
                                            .save(
                                              result['filename'] as String,
                                              base64Decode(
                                                result['content_base64']
                                                    as String,
                                              ),
                                            );
                                        if (saved && context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Document saved to your chosen location',
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                icon: const Icon(Icons.download_outlined),
                                label: const Text('Download'),
                              ),
                              TextButton(
                                onPressed: busy
                                    ? null
                                    : () async {
                                        setState(() => busy = false);
                                        await showDialog<void>(
                                          context: context,
                                          builder: (_) =>
                                              VaultEditor(item: item),
                                        );
                                        refresh();
                                      },
                                child: const Text('Edit details'),
                              ),
                              TextButton(
                                onPressed: busy
                                    ? null
                                    : () async {
                                        if (!await confirmAction(
                                          context,
                                          title: 'Delete this document?',
                                          message:
                                              'The stored encrypted file and its metadata will be permanently deleted. Copies you downloaded are separate.',
                                        )) {
                                          return;
                                        }
                                        await action(
                                          () => ref
                                              .read(moduleRepositoryProvider)
                                              .removeFile(item.id),
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
                  onOffset: (value) => setState(() => offset = value),
                ),
              ],
            ),
          ),
    ],
  );
}

class VaultEditor extends ConsumerStatefulWidget {
  const VaultEditor({this.file, this.item, super.key});
  final PickedVaultFile? file;
  final VaultItem? item;
  @override
  ConsumerState<VaultEditor> createState() => _VaultEditorState();
}

class _VaultEditorState extends ConsumerState<VaultEditor> {
  final form = GlobalKey<FormState>();
  late final title = TextEditingController(
    text: widget.item?.title ?? widget.file?.name ?? '',
  );
  late final category = TextEditingController(
    text: widget.item?.category ?? 'Document',
  );
  late bool shared = widget.item?.allowAi ?? false;
  late DateTime? expiry = widget.item?.expiresAt;
  String? error;
  bool busy = false;
  final requestId = const Uuid().v4();
  @override
  void dispose() {
    title.dispose();
    category.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.item == null ? 'Upload document' : 'Document details'),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.file?.name ?? widget.item!.filename),
              TextFormField(
                controller: title,
                maxLength: 120,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: requiredTitle,
              ),
              TextFormField(
                controller: category,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: requiredTitle,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Share metadata with AI'),
                subtitle: const Text(
                  'Title, category, filename and expiry only. File contents remain unavailable to agents.',
                ),
                value: shared,
                onChanged: busy ? null : (v) => setState(() => shared = v),
              ),
              Text(
                expiry == null ? 'No expiry' : 'Expires ${deviceDate(expiry!)}',
              ),
              Wrap(
                children: [
                  TextButton(
                    onPressed: busy
                        ? null
                        : () async {
                            final today = DateUtils.dateOnly(DateTime.now());
                            final value = await showDatePicker(
                              context: context,
                              initialDate: expiry?.isAfter(today) == true
                                  ? expiry
                                  : today.add(const Duration(days: 365)),
                              firstDate: today,
                              lastDate: today.add(const Duration(days: 3650)),
                            );
                            if (value != null) {
                              setState(
                                () => expiry = value.add(
                                  const Duration(hours: 23, minutes: 59),
                                ),
                              );
                            }
                          },
                    child: const Text('Choose expiry'),
                  ),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => setState(() => expiry = null),
                    child: const Text('Clear expiry'),
                  ),
                ],
              ),
              if (error != null) Text(error!),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: busy
            ? null
            : () async {
                if (!form.currentState!.validate()) return;
                setState(() {
                  busy = true;
                  error = null;
                });
                final payload = {
                  'title': title.text.trim(),
                  'category': category.text.trim(),
                  'allow_ai': shared,
                  'expires_at': expiry?.toUtc().toIso8601String(),
                };
                try {
                  if (widget.item == null) {
                    await ref.read(moduleRepositoryProvider).upload({
                      ...payload,
                      'request_id': requestId,
                      'filename': widget.file!.name,
                      'content_base64': base64Encode(widget.file!.bytes),
                    });
                  } else {
                    await ref
                        .read(moduleRepositoryProvider)
                        .editFile(widget.item!.id, payload);
                  }
                  ref.invalidate(vaultFilesProvider);
                  ref.invalidate(vaultStatusProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: Text(
          busy
              ? 'Saving…'
              : widget.item == null
              ? 'Upload securely'
              : 'Save details',
        ),
      ),
    ],
  );
}
