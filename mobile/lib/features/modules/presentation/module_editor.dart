import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/module_models.dart';
import '../application/module_providers.dart';
import '../domain/module_spec.dart';

Future<void> editModuleRecord(
  BuildContext context,
  WidgetRef ref,
  String module,
  String kind, {
  ModuleRecord? item,
}) async {
  try {
    final catalog = await ref.read(moduleCatalogProvider.future);
    final parentKind = parentKinds[kind];
    final parents = parentKind == null
        ? <ModuleRecord>[]
        : (await ref
                  .read(moduleRepositoryProvider)
                  .records(module, kind: parentKind, limit: 100))
              .items
              .toList();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .88,
        child: ModuleEditor(
          module: module,
          kind: kind,
          fields: catalog.schemas[kind]!,
          parents: parents,
          item: item,
        ),
      ),
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

class ModuleEditor extends ConsumerStatefulWidget {
  const ModuleEditor({
    required this.module,
    required this.kind,
    required this.fields,
    required this.parents,
    this.item,
    super.key,
  });
  final String module, kind;
  final List<ModuleField> fields;
  final List<ModuleRecord> parents;
  final ModuleRecord? item;
  @override
  ConsumerState<ModuleEditor> createState() => _EditorState();
}

class _EditorState extends ConsumerState<ModuleEditor> {
  final form = GlobalKey<FormState>();
  final controllers = <String, TextEditingController>{};
  final booleans = <String, bool>{};
  late bool share = widget.item?.allowAi ?? false;
  late String? parent = widget.item?.parentId;
  bool busy = false;
  String? error, requestId, fingerprint;
  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      final initial = widget.item?.data[field.name] ?? field.initial;
      if (field.type == 'boolean') {
        booleans[field.name] = initial == true;
      } else {
        controllers[field.name] = TextEditingController(
          text:
              initial?.toString() ??
              (field.format == 'date' && !field.nullable
                  ? DateTime.now().toIso8601String().substring(0, 10)
                  : ''),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    final data = <String, dynamic>{};
    for (final field in widget.fields) {
      final value = controllers[field.name]?.text.trim();
      data[field.name] = field.type == 'boolean'
          ? booleans[field.name]
          : value == '' && field.nullable
          ? null
          : field.type == 'integer'
          ? int.parse(value!)
          : value;
    }
    final content = jsonEncode([data, parent, share]);
    if (content != fingerprint) {
      fingerprint = content;
      requestId = const Uuid().v4();
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await ref.read(moduleRepositoryProvider).save(widget.kind, {
        'request_id': requestId,
        'revision': widget.item?.revision,
        'parent_id': parent,
        'allow_ai': share,
        'data': data,
      }, id: widget.item?.id);
      ref.invalidate(moduleRecordsProvider);
      ref.invalidate(moduleReportProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget input(ModuleField field) {
    if (field.type == 'boolean') {
      return SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(field.label),
        value: booleans[field.name]!,
        onChanged: busy
            ? null
            : (v) => setState(() => booleans[field.name] = v),
      );
    }
    final controller = controllers[field.name]!;
    if (field.choices.isNotEmpty) {
      if (controller.text.isEmpty && !field.nullable) {
        controller.text = field.choices.first;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: DropdownButtonFormField<String>(
          key: ValueKey('field-${field.name}'),
          initialValue: controller.text.isEmpty ? null : controller.text,
          isExpanded: true,
          decoration: InputDecoration(labelText: field.label),
          items: [
            for (final value in field.choices)
              DropdownMenuItem(value: value, child: Text(value)),
          ],
          onChanged: busy ? null : (v) => controller.text = v ?? '',
          validator: (v) => v == null && !field.nullable
              ? 'Choose ${field.label.toLowerCase()}'
              : null,
        ),
      );
    }
    final numeric = field.type == 'integer' || field.type == 'number';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        key: ValueKey('field-${field.name}'),
        controller: controller,
        enabled: !busy,
        decoration: InputDecoration(
          labelText: field.label,
          helperText: field.format == 'date'
              ? 'YYYY-MM-DD'
              : field.name == 'annual_rate'
              ? 'Your assumed annual percentage; not a forecast'
              : field.name == 'time'
              ? 'HH:MM (24-hour)'
              : null,
          suffixIcon: field.format == 'date'
              ? IconButton(
                  tooltip: 'Choose ${field.label.toLowerCase()}',
                  onPressed: busy
                      ? null
                      : () async {
                          final value = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.tryParse(controller.text) ??
                                DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2200),
                          );
                          if (value != null) {
                            controller.text = value.toIso8601String().substring(
                              0,
                              10,
                            );
                          }
                        },
                  icon: const Icon(Icons.calendar_month_outlined),
                )
              : null,
        ),
        minLines: field.multiline ? 3 : 1,
        maxLines: field.multiline ? 6 : 1,
        maxLength: field.maxLength,
        keyboardType: numeric
            ? const TextInputType.numberWithOptions(decimal: true, signed: true)
            : field.multiline
            ? TextInputType.multiline
            : TextInputType.text,
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) {
            return field.nullable || field.initial == ''
                ? null
                : 'Enter ${field.label.toLowerCase()}';
          }
          if (field.type == 'integer' && int.tryParse(text) == null) {
            return 'Enter a whole number';
          }
          if (field.type == 'number' &&
              (num.tryParse(text) == null || !num.parse(text).isFinite)) {
            return 'Enter a finite number';
          }
          if (field.format == 'date' &&
              (DateTime.tryParse(text) == null ||
                  !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(text))) {
            return 'Use YYYY-MM-DD';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: 24,
      right: 24,
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Form(
      key: form,
      child: ListView(
        children: [
          Text(
            '${widget.item == null ? 'New' : 'Edit'} ${kindNames[widget.kind]}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          if (parentKinds.containsKey(widget.kind)) ...[
            DropdownButtonFormField<String>(
              initialValue: parent,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: parentKinds[widget.kind] == 'trip'
                    ? 'Trip'
                    : 'Course (optional)',
              ),
              items: [
                if (widget.kind != 'itinerary' && widget.kind != 'packing')
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('No course'),
                  ),
                if (parent != null &&
                    !widget.parents.any((r) => r.id == parent))
                  DropdownMenuItem(
                    value: parent,
                    child: const Text('Current parent'),
                  ),
                for (final row in widget.parents)
                  DropdownMenuItem(
                    value: row.id,
                    child: Text(row.title, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: busy ? null : (v) => setState(() => parent = v),
              validator: (v) =>
                  (widget.kind == 'itinerary' || widget.kind == 'packing') &&
                      v == null
                  ? 'Create and choose a trip first'
                  : null,
            ),
            if (widget.parents.length == 100)
              const Text('Showing the first 100 parent records.'),
            const SizedBox(height: 16),
          ],
          for (final field in widget.fields) input(field),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Share this record with AI'),
            subtitle: const Text(
              'Off by default. Agents also need your profile permission and this module selected for their run.',
            ),
            value: share,
            onChanged: busy ? null : (v) => setState(() => share = v),
          ),
          if (error != null) Semantics(liveRegion: true, child: Text(error!)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: busy ? null : save,
            child: Text(busy ? 'Saving…' : 'Save ${kindNames[widget.kind]}'),
          ),
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
