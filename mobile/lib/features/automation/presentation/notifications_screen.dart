import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../app/providers.dart';
import '../../../core/models/automation_models.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/automation_providers.dart';
import '../application/notification_coordinator.dart';
import '../data/device_gateway.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsState();
}

class _NotificationsState extends ConsumerState<NotificationsScreen> {
  int offset = 0;
  bool busy = false;
  String? error;
  Future<void> act(Future<void> Function() fn) async {
    setState(() => busy = true);
    try {
      await fn();
      ref.invalidate(inboxProvider);
      ref.invalidate(notificationCoordinatorProvider);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled =
        ref.watch(preferencesProvider).getBool('notification_enabled') == true;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'A gentle nudge, when you choose.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        const Text(
          'Your private inbox keeps workflow updates, approval requests and reminders. Device alerts are optional and use a generic lock-screen preview.',
        ),
        const SizedBox(height: 16),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Allow device notifications'),
          subtitle: const Text(
            'Upcoming reminders sync while this app is open. Synced local reminders can fire while closed. Remote push is not configured.',
          ),
          value: enabled,
          onChanged: busy
              ? null
              : (value) => act(() async {
                  if (value &&
                      !await ref
                          .read(deviceGatewayProvider)
                          .requestPermission()) {
                    throw StateError(
                      'Device notification permission was not granted. The inbox remains available.',
                    );
                  }
                  await ref
                      .read(preferencesProvider)
                      .setBool('notification_enabled', value);
                  if (!value) await ref.read(deviceGatewayProvider).clear();
                  if (mounted) setState(() {});
                }),
        ),
        ref
            .watch(notificationCoordinatorProvider)
            .when(
              data: (_) => const SizedBox.shrink(),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Device sync: $e'),
            ),
        const Text(
          'Up to 50 upcoming/unread items sync to this device. OS battery settings and permissions can delay local delivery; the inbox remains the source of truth.',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: busy
              ? null
              : () => showDialog<void>(
                  context: context,
                  builder: (_) => const ReminderEditor(),
                ),
          icon: const Icon(Icons.add_alarm),
          label: const Text('Create a reminder'),
        ),
        if (error != null) Text(error!),
        const SizedBox(height: 24),
        ref
            .watch(inboxProvider(offset))
            .when(
              loading: () => const UniverseLoadingState(),
              error: (e, _) => UniverseErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(inboxProvider),
              ),
              data: (page) {
                final rows = (page['items'] as List)
                    .map(
                      (e) => InboxItem.fromJson(
                        Map<String, dynamic>.from(e as Map),
                      ),
                    )
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${page['unread']} unread updates',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (rows.isEmpty)
                      const UniverseEmptyState(
                        title: 'A little quiet',
                        message:
                            'Your reminders and workflow updates will appear here.',
                      ),
                    for (final row in rows)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: UniverseSurface(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '${row.dueAt.isAfter(DateTime.now()) ? 'Upcoming' : 'Due'} · ${deviceDate(row.dueAt)}',
                              ),
                              const SizedBox(height: 8),
                              SelectableText(row.body),
                              Wrap(
                                spacing: 8,
                                children: [
                                  if (row.route != '/notifications' &&
                                      safeNotificationRoute(row.route))
                                    TextButton(
                                      onPressed: () => context.push(row.route),
                                      child: const Text('Open details'),
                                    ),
                                  if (row.readAt == null)
                                    TextButton(
                                      onPressed: busy
                                          ? null
                                          : () => act(
                                              () => ref
                                                  .read(
                                                    automationRepositoryProvider,
                                                  )
                                                  .read(row.id),
                                            ),
                                      child: const Text('Mark read'),
                                    ),
                                  TextButton(
                                    onPressed: busy
                                        ? null
                                        : () => act(
                                            () => ref
                                                .read(
                                                  automationRepositoryProvider,
                                                )
                                                .dismiss(row.id),
                                          ),
                                    child: Text(
                                      row.dueAt.isAfter(DateTime.now())
                                          ? 'Cancel reminder'
                                          : 'Dismiss',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    PageControls(
                      total: page['total'] as int,
                      offset: offset,
                      limit: page['limit'] as int,
                      onOffset: (v) => setState(() => offset = v),
                    ),
                  ],
                );
              },
            ),
        TextButton.icon(
          onPressed: () => act(() async {}),
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh inbox & device sync'),
        ),
      ],
    );
  }
}

class ReminderEditor extends ConsumerStatefulWidget {
  const ReminderEditor({super.key});
  @override
  ConsumerState<ReminderEditor> createState() => _ReminderState();
}

class _ReminderState extends ConsumerState<ReminderEditor> {
  final title = TextEditingController(), body = TextEditingController();
  DateTime due = DateTime.now().add(const Duration(hours: 1));
  bool busy = false;
  String? error;
  final requestId = const Uuid().v4();
  @override
  void dispose() {
    title.dispose();
    body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Create a reminder'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            maxLength: 120,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: body,
            maxLength: 2000,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
          Text('Device time: ${deviceDate(due)}'),
          TextButton(
            onPressed: busy
                ? null
                : () async {
                    final day = await showDatePicker(
                      context: context,
                      initialDate: due,
                      firstDate: DateUtils.dateOnly(DateTime.now()),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (day == null || !context.mounted) return;
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(due),
                    );
                    if (time != null) {
                      setState(
                        () => due = DateTime(
                          day.year,
                          day.month,
                          day.day,
                          time.hour,
                          time.minute,
                        ),
                      );
                    }
                  },
            child: const Text('Choose date & time'),
          ),
          if (error != null) Text(error!),
        ],
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
                if (title.text.trim().isEmpty) {
                  setState(() => error = 'Enter a title.');
                  return;
                }
                setState(() => busy = true);
                try {
                  await ref.read(automationRepositoryProvider).reminder({
                    'request_id': requestId,
                    'title': title.text.trim(),
                    'body': body.text.trim(),
                    'due_at': due.toUtc().toIso8601String(),
                  });
                  ref.invalidate(inboxProvider);
                  ref.invalidate(notificationCoordinatorProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: Text(busy ? 'Saving…' : 'Save reminder'),
      ),
    ],
  );
}
