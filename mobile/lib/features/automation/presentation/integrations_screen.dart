import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/automation_models.dart';
import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/widgets/universe_components.dart';
import '../../life/application/life_providers.dart';
import '../../life/presentation/life_widgets.dart';
import '../application/automation_providers.dart';
import '../data/device_gateway.dart';
import 'automation_screen.dart' show ReportResult;

class IntegrationsScreen extends ConsumerStatefulWidget {
  const IntegrationsScreen({super.key});
  @override
  ConsumerState<IntegrationsScreen> createState() => _IntegrationState();
}

class _IntegrationState extends ConsumerState<IntegrationsScreen> {
  bool busy = false;
  String? error;
  int offset = 0;
  void refresh() {
    ref.invalidate(calendarConnectionsProvider);
    ref.invalidate(calendarExportsProvider);
    ref.invalidate(integrationsStatusProvider);
  }

  Future<void> act(Future<void> Function() fn) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await fn();
      refresh();
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> connect(String provider) async {
    final writable = await showDialog<bool>(
      context: context,
      builder: (_) => CalendarConsentDialog(provider: provider),
    );
    if (writable == null) return;
    await act(() async {
      final url = await ref
          .read(automationRepositoryProvider)
          .startOAuth(provider, writable);
      await ref.read(deviceGatewayProvider).openOAuth(url);
    });
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(
        'Connect with a clear purpose.',
        style: Theme.of(context).textTheme.displaySmall,
      ),
      const SizedBox(height: 12),
      const Text(
        'Calendar connections begin with read access. Import events deliberately, and approve an exact preview before an event is exported. No attendees or invitations are added.',
      ),
      const SizedBox(height: 24),
      ref
          .watch(integrationsStatusProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => UniverseErrorState(
              message: e.toString(),
              onRetry: () => ref.invalidate(integrationsStatusProvider),
            ),
            data: (status) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final provider in status['providers'] as List)
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: Text(
                      (provider as Map)['provider'] == 'google'
                          ? 'Google Calendar'
                          : 'Microsoft Calendar',
                    ),
                    subtitle: Text(
                      provider['configured'] == true
                          ? 'Default calendar · OAuth consent required'
                          : 'Server OAuth client / encryption setup required',
                    ),
                    trailing: TextButton(
                      onPressed: busy || provider['configured'] != true
                          ? null
                          : () => connect(provider['provider'] as String),
                      child: const Text('Connect'),
                    ),
                  ),
                const SizedBox(height: 16),
                FilledButton.tonalIcon(
                  onPressed: status['external_apis_enabled'] == true
                      ? () => showDialog<void>(
                          context: context,
                          builder: (_) => const ExternalReadDialog(),
                        )
                      : null,
                  icon: const Icon(Icons.cloud_outlined),
                  label: const Text('Read weather or reference rates'),
                ),
                if (status['external_apis_enabled'] != true)
                  const Text(
                    'Public API reads are disabled in server configuration.',
                  ),
              ],
            ),
          ),
      const SizedBox(height: 24),
      Text('Your calendars', style: Theme.of(context).textTheme.titleLarge),
      ref
          .watch(calendarConnectionsProvider)
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) =>
                UniverseErrorState(message: e.toString(), onRetry: refresh),
            data: (connections) => Column(
              children: [
                if (connections.isEmpty)
                  const UniverseEmptyState(
                    title: 'Only the services you choose',
                    message:
                        'Connect a calendar after server OAuth registration. No provider account is connected automatically.',
                  ),
                for (final connection in connections)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: UniverseSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            connection.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            connection.active
                                ? (connection.writable
                                      ? 'Read + approved export access'
                                      : 'Read access')
                                : 'Disconnected',
                          ),
                          if (connection.lastSyncAt != null)
                            Text(
                              'Last sync: ${deviceDate(connection.lastSyncAt!)}',
                            ),
                          if (connection.error.isNotEmpty)
                            Text(connection.error),
                          if (connection.active)
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton.icon(
                                  onPressed: busy
                                      ? null
                                      : () => act(() async {
                                          final result = await ref
                                              .read(
                                                automationRepositoryProvider,
                                              )
                                              .sync(connection.id);
                                          ref.invalidate(
                                            calendarEventsProvider,
                                          );
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${result['events']} events mirrored${result['truncated'] == true ? ' (provider window limit reached)' : ''}. Import explicitly to Planner.',
                                                ),
                                              ),
                                            );
                                          }
                                        }),
                                  icon: const Icon(Icons.sync),
                                  label: const Text('Sync now'),
                                ),
                                TextButton(
                                  onPressed: () => showDialog<void>(
                                    context: context,
                                    builder: (_) => CalendarEventsDialog(
                                      connection: connection,
                                    ),
                                  ),
                                  child: const Text('Review & import events'),
                                ),
                                if (connection.writable)
                                  TextButton(
                                    onPressed: () => showDialog<void>(
                                      context: context,
                                      builder: (_) => CalendarExportEditor(
                                        connection: connection,
                                      ),
                                    ),
                                    child: const Text('Prepare event export'),
                                  ),
                                TextButton(
                                  onPressed: busy
                                      ? null
                                      : () async {
                                          if (!await confirmAction(
                                            context,
                                            title: 'Disconnect this calendar?',
                                            message:
                                                'Removes stored access tokens and stops future exports. Imported Planner events remain. Manage the provider account to revoke its original app grant.',
                                            action: 'Disconnect',
                                          )) {
                                            return;
                                          }
                                          await act(
                                            () => ref
                                                .read(
                                                  automationRepositoryProvider,
                                                )
                                                .disconnect(connection.id),
                                          );
                                        },
                                  child: const Text('Disconnect'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
      if (busy) const LinearProgressIndicator(),
      if (error != null) Text(error!),
      const SizedBox(height: 24),
      Text(
        'Calendar export history',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      ref
          .watch(calendarExportsProvider(offset))
          .when(
            loading: () => const UniverseLoadingState(),
            error: (e, _) =>
                UniverseErrorState(message: e.toString(), onRetry: refresh),
            data: (page) => Column(
              children: [
                for (final op in page.items)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: UniverseSurface(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            op.payload['title'] as String,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(op.status.replaceAll('_', ' ')),
                          Text(
                            'Start: ${deviceDate(DateTime.parse(op.payload['starts_at'] as String))}',
                          ),
                          Text(
                            'End: ${deviceDate(DateTime.parse(op.payload['ends_at'] as String))}',
                          ),
                          if ((op.payload['notes'] as String).isNotEmpty)
                            SelectableText(op.payload['notes'] as String),
                          if (op.error.isNotEmpty) Text(op.error),
                          if (op.status == 'awaiting_approval' ||
                              op.status == 'uncertain') ...[
                            Text(
                              'Preview expires ${deviceDate(op.expiresAt)}. Destination: your connected default calendar. No attendees or invites.',
                            ),
                            Wrap(
                              spacing: 8,
                              children: [
                                FilledButton(
                                  onPressed:
                                      busy ||
                                          !op.expiresAt.isAfter(DateTime.now())
                                      ? null
                                      : () async {
                                          if (await confirmAction(
                                            context,
                                            title: op.status == 'uncertain'
                                                ? 'Retry this approved export?'
                                                : 'Approve this calendar export?',
                                            message:
                                                '${op.payload['title']}\n${op.payload['starts_at']} → ${op.payload['ends_at']}\nThe worker will publish this exact event to your own calendar. Retries use the same provider identifier.',
                                            action: op.status == 'uncertain'
                                                ? 'Retry same export'
                                                : 'Approve export',
                                          )) {
                                            await act(
                                              () => ref
                                                  .read(
                                                    automationRepositoryProvider,
                                                  )
                                                  .decideExport(op, true),
                                            );
                                          }
                                        },
                                  child: Text(
                                    op.status == 'uncertain'
                                        ? 'Retry same export'
                                        : 'Approve export',
                                  ),
                                ),
                                TextButton(
                                  onPressed: busy
                                      ? null
                                      : () => act(
                                          () => ref
                                              .read(
                                                automationRepositoryProvider,
                                              )
                                              .decideExport(op, false),
                                        ),
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                          if (op.status == 'published')
                            const Text('Provider confirmed publication.'),
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
      TextButton.icon(
        onPressed: refresh,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh connections & outcomes'),
      ),
    ],
  );
}

class CalendarConsentDialog extends StatefulWidget {
  const CalendarConsentDialog({required this.provider, super.key});
  final String provider;
  @override
  State<CalendarConsentDialog> createState() => _ConsentState();
}

class _ConsentState extends State<CalendarConsentDialog> {
  bool write = false;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Connect ${widget.provider} calendar'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Read your default calendar. Credentials stay encrypted on the server. Return to the app and refresh after provider consent.',
        ),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Also allow approved event exports'),
          subtitle: const Text(
            'Off by default. Every export still needs its own exact-preview approval.',
          ),
          value: write,
          onChanged: (v) => setState(() => write = v),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, write),
        child: const Text('Continue to provider'),
      ),
    ],
  );
}

class CalendarEventsDialog extends ConsumerStatefulWidget {
  const CalendarEventsDialog({required this.connection, super.key});
  final CalendarConnection connection;
  @override
  ConsumerState<CalendarEventsDialog> createState() => _EventsState();
}

class _EventsState extends ConsumerState<CalendarEventsDialog> {
  int offset = 0;
  String? error;
  bool busy = false;
  Future<void> importEvent(CalendarMirror row) async {
    if (!await confirmAction(
      context,
      title: 'Import this event to Planner?',
      message:
          '${row.title}\n${deviceDate(row.startsAt)} → ${deviceDate(row.endsAt)}\nFuture provider edits will not silently change Planner.',
      action: 'Import event',
    )) {
      return;
    }
    setState(() => busy = true);
    try {
      await ref.read(automationRepositoryProvider).importEvent(row.id);
    } on ApiFailure catch (e) {
      if (e.statusCode == 409 && mounted) {
        if (await confirmAction(
          context,
          title: 'Confirm an overlapping event?',
          message:
              'This may overlap an existing Planner event. Import it anyway?',
          action: 'Import with overlap',
        )) {
          try {
            await ref
                .read(automationRepositoryProvider)
                .importEvent(row.id, overlap: true);
          } catch (e) {
            if (mounted) setState(() => error = e.toString());
          }
        }
      } else {
        if (mounted) setState(() => error = e.toString());
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      ref.invalidate(calendarEventsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(dashboardProvider);
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.connection.title),
    content: SizedBox(
      width: 650,
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Mirror of the last sync: past 30 days through the next 90 days, at most 500 events. Sync now from Integrations to refresh.',
            ),
            if (error != null) Text(error!),
            ref
                .watch(
                  calendarEventsProvider((
                    id: widget.connection.id,
                    offset: offset,
                  )),
                )
                .when(
                  loading: () => const UniverseLoadingState(),
                  error: (e, _) => Text(e.toString()),
                  data: (page) => Column(
                    children: [
                      for (final row in page.items)
                        ListTile(
                          title: Text(row.title),
                          subtitle: Text(
                            '${row.allDay ? 'All-day · ' : ''}${deviceDate(row.startsAt)} → ${deviceDate(row.endsAt)}',
                          ),
                          trailing: TextButton(
                            onPressed: busy || row.localEventId != null
                                ? null
                                : () => importEvent(row),
                            child: Text(
                              row.localEventId == null ? 'Import' : 'Imported',
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
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Close'),
      ),
    ],
  );
}

class CalendarExportEditor extends ConsumerStatefulWidget {
  const CalendarExportEditor({required this.connection, super.key});
  final CalendarConnection connection;
  @override
  ConsumerState<CalendarExportEditor> createState() => _ExportEditorState();
}

class _ExportEditorState extends ConsumerState<CalendarExportEditor> {
  List<CalendarItem> events = [];
  String? selected, error;
  bool loading = true, busy = false;
  final search = TextEditingController();
  String? requestId, previous;
  @override
  void initState() {
    super.initState();
    Future.microtask(load);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final page = await ref
          .read(automationRepositoryProvider)
          .call('events', query: {'q': search.text.trim(), 'limit': 100});
      if (mounted) {
        setState(() {
          events = (page['items'] as List)
              .map(
                (e) =>
                    CalendarItem.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
          selected = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Prepare a calendar export'),
    content: SizedBox(
      width: 600,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose a saved Planner event. Preparing does not publish it; review and approve from export history.',
            ),
            TextField(
              controller: search,
              maxLength: 120,
              decoration: InputDecoration(
                labelText: 'Search Planner event titles',
                suffixIcon: IconButton(
                  onPressed: load,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            if (loading)
              const LinearProgressIndicator()
            else
              DropdownButtonFormField<String>(
                key: ValueKey(events.map((e) => e.id).join()),
                initialValue: selected,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Planner event'),
                items: [
                  for (final event in events)
                    DropdownMenuItem(
                      value: event.id,
                      child: Text(event.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: busy ? null : (v) => setState(() => selected = v),
              ),
            if (events.length == 100)
              const Text('Showing the first 100 matches. Narrow your search.'),
            if (error != null) Text(error!),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: busy || selected == null
            ? null
            : () async {
                if (previous != selected) {
                  previous = selected;
                  requestId = const Uuid().v4();
                }
                setState(() => busy = true);
                try {
                  await ref
                      .read(automationRepositoryProvider)
                      .prepareExport(
                        widget.connection.id,
                        selected!,
                        requestId!,
                      );
                  ref.invalidate(calendarExportsProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: const Text('Prepare preview'),
      ),
    ],
  );
}

class ExternalReadDialog extends ConsumerStatefulWidget {
  const ExternalReadDialog({super.key});
  @override
  ConsumerState<ExternalReadDialog> createState() => _ExternalState();
}

class _ExternalState extends ConsumerState<ExternalReadDialog> {
  String api = 'weather';
  final latitude = TextEditingController(text: '0'),
      longitude = TextEditingController(text: '0'),
      base = TextEditingController(text: 'USD'),
      quote = TextEditingController(text: 'INR');
  Map<String, dynamic>? result;
  String? error;
  bool busy = false;
  @override
  void dispose() {
    latitude.dispose();
    longitude.dispose();
    base.dispose();
    quote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Read from a connected public API'),
    content: SizedBox(
      width: 650,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: api,
              items: const [
                DropdownMenuItem(
                  value: 'weather',
                  child: Text('Open-Meteo weather'),
                ),
                DropdownMenuItem(
                  value: 'exchange',
                  child: Text('Frankfurter reference rate'),
                ),
              ],
              onChanged: busy
                  ? null
                  : (v) => setState(() {
                      api = v!;
                      result = null;
                    }),
            ),
            if (api == 'weather') ...[
              TextField(
                controller: latitude,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
              ),
              TextField(
                controller: longitude,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
              ),
              const Text(
                'These coordinates will be sent to Open-Meteo. No device location permission is requested.',
              ),
            ] else ...[
              TextField(
                controller: base,
                decoration: const InputDecoration(
                  labelText: 'Base currency code',
                ),
              ),
              TextField(
                controller: quote,
                decoration: const InputDecoration(
                  labelText: 'Quote currency code',
                ),
              ),
              const Text(
                'Reference rates are not live market quotes. No transaction is made.',
              ),
            ],
            if (result != null) ReportResult(value: result!),
            if (error != null) Text(error!),
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
        onPressed: busy
            ? null
            : () async {
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  final data = {
                    'api': api,
                    if (api == 'weather')
                      'latitude': double.parse(latitude.text),
                    if (api == 'weather')
                      'longitude': double.parse(longitude.text),
                    if (api == 'exchange')
                      'base': base.text.trim().toUpperCase(),
                    if (api == 'exchange')
                      'quote': quote.text.trim().toUpperCase(),
                  };
                  final value = await ref
                      .read(automationRepositoryProvider)
                      .external(data);
                  if (mounted) setState(() => result = value);
                } catch (e) {
                  if (mounted) setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        child: Text(busy ? 'Reading…' : 'Fetch from provider'),
      ),
    ],
  );
}
