import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/models/automation_models.dart';
import '../../../core/models/life_models.dart';
import '../../profile/application/account_providers.dart';
import '../data/automation_repository.dart';

final automationRepositoryProvider = Provider<AutomationRepository>((ref) {
  ref.watch(currentSessionProvider.select((s) => s?.user.id));
  return AutomationRepository(ref.watch(apiProvider));
});
final automationStatusProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>(
      (ref) => ref.watch(automationRepositoryProvider).status(),
    );
final workflowListProvider = FutureProvider.autoDispose
    .family<DataPage<WorkflowItem>, int>(
      (ref, offset) =>
          ref.watch(automationRepositoryProvider).workflows(offset),
    );
final workflowProvider = FutureProvider.autoDispose
    .family<WorkflowItem, String>(
      (ref, id) => ref.watch(automationRepositoryProvider).workflow(id),
    );
final workflowHistoryProvider = FutureProvider.autoDispose
    .family<DataPage<WorkflowRun>, int>(
      (ref, offset) => ref.watch(automationRepositoryProvider).history(offset),
    );
final workflowRunProvider = FutureProvider.autoDispose
    .family<WorkflowRun, String>(
      (ref, id) => ref.watch(automationRepositoryProvider).detail(id),
    );
final inboxProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, int>(
      (ref, offset) =>
          ref.watch(automationRepositoryProvider).inbox(offset: offset),
    );
final integrationsStatusProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>(
      (ref) => ref.watch(automationRepositoryProvider).integrationsStatus(),
    );
final calendarConnectionsProvider =
    FutureProvider.autoDispose<List<CalendarConnection>>(
      (ref) => ref.watch(automationRepositoryProvider).connections(),
    );
final calendarEventsProvider = FutureProvider.autoDispose
    .family<DataPage<CalendarMirror>, ({String id, int offset})>(
      (ref, q) =>
          ref.watch(automationRepositoryProvider).events(q.id, q.offset),
    );
final calendarExportsProvider = FutureProvider.autoDispose
    .family<DataPage<CalendarExport>, int>(
      (ref, offset) => ref.watch(automationRepositoryProvider).exports(offset),
    );
