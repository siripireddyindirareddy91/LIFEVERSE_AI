// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentStatus _$AgentStatusFromJson(Map<String, dynamic> json) => _AgentStatus(
  configured: json['configured'] as bool,
  consentRequired: json['consent_required'] as bool,
  workerOnline: json['worker_online'] as bool,
  embeddingsConfigured: json['embeddings_configured'] as bool,
  dailyLimit: (json['daily_limit'] as num).toInt(),
  historyDays: (json['history_days'] as num).toInt(),
  maxModelCalls: (json['max_model_calls'] as num).toInt(),
  maxToolCalls: (json['max_tool_calls'] as num).toInt(),
);

Map<String, dynamic> _$AgentStatusToJson(_AgentStatus instance) =>
    <String, dynamic>{
      'configured': instance.configured,
      'consent_required': instance.consentRequired,
      'worker_online': instance.workerOnline,
      'embeddings_configured': instance.embeddingsConfigured,
      'daily_limit': instance.dailyLimit,
      'history_days': instance.historyDays,
      'max_model_calls': instance.maxModelCalls,
      'max_tool_calls': instance.maxToolCalls,
    };

_AgentRun _$AgentRunFromJson(Map<String, dynamic> json) => _AgentRun(
  id: json['id'] as String,
  prompt: json['prompt'] as String,
  status: json['status'] as String,
  summary: json['summary'] as String? ?? '',
  error: json['error'] as String? ?? '',
  plan: json['plan'] as String? ?? '',
  scopes:
      (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  agents:
      (json['agents'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  allowProposals: json['allow_proposals'] as bool? ?? false,
  modelCalls: (json['model_calls'] as num?)?.toInt() ?? 0,
  toolCalls: (json['tool_calls'] as num?)?.toInt() ?? 0,
  approvalDigest: json['approval_digest'] as String?,
  reviewNonce: json['review_nonce'] as String?,
  reviewExpiresAt: json['review_expires_at'] == null
      ? null
      : DateTime.parse(json['review_expires_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map((e) => AgentSource.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  actions:
      (json['actions'] as List<dynamic>?)
          ?.map((e) => AgentAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  steps:
      (json['steps'] as List<dynamic>?)
          ?.map((e) => AgentStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AgentRunToJson(_AgentRun instance) => <String, dynamic>{
  'id': instance.id,
  'prompt': instance.prompt,
  'status': instance.status,
  'summary': instance.summary,
  'error': instance.error,
  'plan': instance.plan,
  'scopes': instance.scopes,
  'agents': instance.agents,
  'allow_proposals': instance.allowProposals,
  'model_calls': instance.modelCalls,
  'tool_calls': instance.toolCalls,
  'approval_digest': instance.approvalDigest,
  'review_nonce': instance.reviewNonce,
  'review_expires_at': instance.reviewExpiresAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'expires_at': instance.expiresAt.toIso8601String(),
  'sources': instance.sources,
  'actions': instance.actions,
  'steps': instance.steps,
};

_AgentSource _$AgentSourceFromJson(Map<String, dynamic> json) => _AgentSource(
  label: json['label'] as String,
  kind: json['kind'] as String,
  sourceId: json['source_id'] as String,
  title: json['title'] as String,
  excerpt: json['excerpt'] as String,
  mode: json['mode'] as String,
);

Map<String, dynamic> _$AgentSourceToJson(_AgentSource instance) =>
    <String, dynamic>{
      'label': instance.label,
      'kind': instance.kind,
      'source_id': instance.sourceId,
      'title': instance.title,
      'excerpt': instance.excerpt,
      'mode': instance.mode,
    };

_PreviewField _$PreviewFieldFromJson(Map<String, dynamic> json) =>
    _PreviewField(
      name: json['name'] as String,
      before: json['before'] as String?,
      after: json['after'] as String,
    );

Map<String, dynamic> _$PreviewFieldToJson(_PreviewField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'before': instance.before,
      'after': instance.after,
    };

_AgentAction _$AgentActionFromJson(Map<String, dynamic> json) => _AgentAction(
  id: json['id'] as String,
  label: json['label'] as String,
  agent: json['agent'] as String,
  tool: json['tool'] as String,
  status: json['status'] as String,
  position: (json['position'] as num).toInt(),
  recordId: json['record_id'] as String,
  dependencies:
      (json['dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  preview:
      (json['preview'] as List<dynamic>?)
          ?.map((e) => PreviewField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  result: json['result'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AgentActionToJson(_AgentAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'agent': instance.agent,
      'tool': instance.tool,
      'status': instance.status,
      'position': instance.position,
      'record_id': instance.recordId,
      'dependencies': instance.dependencies,
      'preview': instance.preview,
      'result': instance.result,
    };

_AgentStep _$AgentStepFromJson(Map<String, dynamic> json) => _AgentStep(
  id: json['id'] as String,
  sequence: (json['sequence'] as num).toInt(),
  kind: json['kind'] as String,
  agent: json['agent'] as String,
  status: json['status'] as String,
  summary: json['summary'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  tool: json['tool'] as String?,
  details: json['details'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$AgentStepToJson(_AgentStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'kind': instance.kind,
      'agent': instance.agent,
      'status': instance.status,
      'summary': instance.summary,
      'created_at': instance.createdAt.toIso8601String(),
      'tool': instance.tool,
      'details': instance.details,
    };

_KnowledgeItem _$KnowledgeItemFromJson(Map<String, dynamic> json) =>
    _KnowledgeItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      allowAi: json['allow_ai'] as bool,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      chunkCount: (json['chunk_count'] as num).toInt(),
      indexedChunks: (json['indexed_chunks'] as num).toInt(),
    );

Map<String, dynamic> _$KnowledgeItemToJson(_KnowledgeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'allow_ai': instance.allowAi,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'chunk_count': instance.chunkCount,
      'indexed_chunks': instance.indexedChunks,
    };
