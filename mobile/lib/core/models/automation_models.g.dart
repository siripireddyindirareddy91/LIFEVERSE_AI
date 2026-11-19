// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkflowItem _$WorkflowItemFromJson(Map<String, dynamic> json) =>
    _WorkflowItem(
      id: json['id'] as String,
      title: json['title'] as String,
      definition: json['definition'] as Map<String, dynamic>,
      revision: json['revision'] as String,
      enabled: json['enabled'] as bool,
      digest: json['digest'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$WorkflowItemToJson(_WorkflowItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'definition': instance.definition,
      'revision': instance.revision,
      'enabled': instance.enabled,
      'digest': instance.digest,
      'permissions': instance.permissions,
      'created_at': instance.createdAt.toIso8601String(),
    };

_WorkflowStep _$WorkflowStepFromJson(Map<String, dynamic> json) =>
    _WorkflowStep(
      index: (json['index'] as num).toInt(),
      type: json['type'] as String,
      status: json['status'] as String,
      summary: json['summary'] as String,
      at: DateTime.parse(json['at'] as String),
      result: json['result'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WorkflowStepToJson(_WorkflowStep instance) =>
    <String, dynamic>{
      'index': instance.index,
      'type': instance.type,
      'status': instance.status,
      'summary': instance.summary,
      'at': instance.at.toIso8601String(),
      'result': instance.result,
    };

_WorkflowRun _$WorkflowRunFromJson(Map<String, dynamic> json) => _WorkflowRun(
  id: json['id'] as String,
  workflowId: json['workflow_id'] as String,
  revision: json['revision'] as String,
  status: json['status'] as String,
  cursor: (json['cursor'] as num).toInt(),
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  summary: json['summary'] as String? ?? '',
  error: json['error'] as String? ?? '',
  attempts: (json['attempts'] as num?)?.toInt() ?? 0,
  agentRunId: json['agent_run_id'] as String?,
  proposalRunId: json['proposal_run_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$WorkflowRunToJson(_WorkflowRun instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workflow_id': instance.workflowId,
      'revision': instance.revision,
      'status': instance.status,
      'cursor': instance.cursor,
      'steps': instance.steps,
      'summary': instance.summary,
      'error': instance.error,
      'attempts': instance.attempts,
      'agent_run_id': instance.agentRunId,
      'proposal_run_id': instance.proposalRunId,
      'created_at': instance.createdAt.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'finished_at': instance.finishedAt?.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_InboxItem _$InboxItemFromJson(Map<String, dynamic> json) => _InboxItem(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  route: json['route'] as String,
  dueAt: DateTime.parse(json['due_at'] as String),
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  cancelled: json['cancelled'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$InboxItemToJson(_InboxItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'route': instance.route,
      'due_at': instance.dueAt.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'cancelled': instance.cancelled,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_CalendarConnection _$CalendarConnectionFromJson(Map<String, dynamic> json) =>
    _CalendarConnection(
      id: json['id'] as String,
      title: json['title'] as String,
      provider: json['provider'] as String,
      writable: json['writable'] as bool,
      active: json['active'] as bool,
      revision: json['revision'] as String,
      lastSyncAt: json['last_sync_at'] == null
          ? null
          : DateTime.parse(json['last_sync_at'] as String),
      error: json['error'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CalendarConnectionToJson(_CalendarConnection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'provider': instance.provider,
      'writable': instance.writable,
      'active': instance.active,
      'revision': instance.revision,
      'last_sync_at': instance.lastSyncAt?.toIso8601String(),
      'error': instance.error,
      'created_at': instance.createdAt.toIso8601String(),
    };

_CalendarMirror _$CalendarMirrorFromJson(Map<String, dynamic> json) =>
    _CalendarMirror(
      id: json['id'] as String,
      title: json['title'] as String,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      allDay: json['all_day'] as bool,
      localEventId: json['local_event_id'] as String?,
    );

Map<String, dynamic> _$CalendarMirrorToJson(_CalendarMirror instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'all_day': instance.allDay,
      'local_event_id': instance.localEventId,
    };

_CalendarExport _$CalendarExportFromJson(Map<String, dynamic> json) =>
    _CalendarExport(
      id: json['id'] as String,
      connectionId: json['connection_id'] as String,
      localEventId: json['local_event_id'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      digest: json['digest'] as String,
      nonce: json['nonce'] as String,
      status: json['status'] as String,
      remoteId: json['remote_id'] as String?,
      error: json['error'] as String? ?? '',
      expiresAt: DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CalendarExportToJson(_CalendarExport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'connection_id': instance.connectionId,
      'local_event_id': instance.localEventId,
      'payload': instance.payload,
      'digest': instance.digest,
      'nonce': instance.nonce,
      'status': instance.status,
      'remote_id': instance.remoteId,
      'error': instance.error,
      'expires_at': instance.expiresAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
