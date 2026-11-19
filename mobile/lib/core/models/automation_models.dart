import 'package:freezed_annotation/freezed_annotation.dart';
part 'automation_models.freezed.dart';
part 'automation_models.g.dart';

@freezed
abstract class WorkflowItem with _$WorkflowItem {
  const factory WorkflowItem({
    required String id,
    required String title,
    required Map<String, dynamic> definition,
    required String revision,
    required bool enabled,
    required String digest,
    required List<String> permissions,
    required DateTime createdAt,
  }) = _WorkflowItem;
  factory WorkflowItem.fromJson(Map<String, dynamic> json) =>
      _$WorkflowItemFromJson(json);
}

@freezed
abstract class WorkflowStep with _$WorkflowStep {
  const factory WorkflowStep({
    required int index,
    required String type,
    required String status,
    required String summary,
    required DateTime at,
    Map<String, dynamic>? result,
  }) = _WorkflowStep;
  factory WorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStepFromJson(json);
}

@freezed
abstract class WorkflowRun with _$WorkflowRun {
  const WorkflowRun._();
  const factory WorkflowRun({
    required String id,
    required String workflowId,
    required String revision,
    required String status,
    required int cursor,
    @Default([]) List<WorkflowStep> steps,
    @Default('') String summary,
    @Default('') String error,
    @Default(0) int attempts,
    String? agentRunId,
    String? proposalRunId,
    required DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    required DateTime expiresAt,
  }) = _WorkflowRun;
  bool get active => [
    'queued',
    'running',
    'waiting_agent',
    'waiting_approval',
  ].contains(status);
  factory WorkflowRun.fromJson(Map<String, dynamic> json) =>
      _$WorkflowRunFromJson(json);
}

@freezed
abstract class InboxItem with _$InboxItem {
  const factory InboxItem({
    required String id,
    required String title,
    required String body,
    required String route,
    required DateTime dueAt,
    DateTime? readAt,
    required bool cancelled,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _InboxItem;
  factory InboxItem.fromJson(Map<String, dynamic> json) =>
      _$InboxItemFromJson(json);
}

@freezed
abstract class CalendarConnection with _$CalendarConnection {
  const factory CalendarConnection({
    required String id,
    required String title,
    required String provider,
    required bool writable,
    required bool active,
    required String revision,
    DateTime? lastSyncAt,
    @Default('') String error,
    required DateTime createdAt,
  }) = _CalendarConnection;
  factory CalendarConnection.fromJson(Map<String, dynamic> json) =>
      _$CalendarConnectionFromJson(json);
}

@freezed
abstract class CalendarMirror with _$CalendarMirror {
  const factory CalendarMirror({
    required String id,
    required String title,
    required DateTime startsAt,
    required DateTime endsAt,
    required bool allDay,
    String? localEventId,
  }) = _CalendarMirror;
  factory CalendarMirror.fromJson(Map<String, dynamic> json) =>
      _$CalendarMirrorFromJson(json);
}

@freezed
abstract class CalendarExport with _$CalendarExport {
  const factory CalendarExport({
    required String id,
    required String connectionId,
    required String localEventId,
    required Map<String, dynamic> payload,
    required String digest,
    required String nonce,
    required String status,
    String? remoteId,
    @Default('') String error,
    required DateTime expiresAt,
    required DateTime createdAt,
  }) = _CalendarExport;
  factory CalendarExport.fromJson(Map<String, dynamic> json) =>
      _$CalendarExportFromJson(json);
}
