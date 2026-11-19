// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModuleRecord _$ModuleRecordFromJson(Map<String, dynamic> json) =>
    _ModuleRecord(
      id: json['id'] as String,
      kind: json['kind'] as String,
      title: json['title'] as String,
      data: json['data'] as Map<String, dynamic>,
      parentId: json['parent_id'] as String?,
      allowAi: json['allow_ai'] as bool,
      revision: json['revision'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ModuleRecordToJson(_ModuleRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'title': instance.title,
      'data': instance.data,
      'parent_id': instance.parentId,
      'allow_ai': instance.allowAi,
      'revision': instance.revision,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_ReportMetric _$ReportMetricFromJson(Map<String, dynamic> json) =>
    _ReportMetric(
      label: json['label'] as String,
      value: json['value'] as String,
      detail: json['detail'] as String? ?? '',
    );

Map<String, dynamic> _$ReportMetricToJson(_ReportMetric instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'detail': instance.detail,
    };

_ModuleReport _$ModuleReportFromJson(Map<String, dynamic> json) =>
    _ModuleReport(
      module: json['module'] as String,
      today: json['today'] as String,
      month: json['month'] as String,
      recordCount: (json['record_count'] as num).toInt(),
      metrics:
          (json['metrics'] as List<dynamic>?)
              ?.map((e) => ReportMetric.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map((e) => ReportMetric.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ModuleReportToJson(_ModuleReport instance) =>
    <String, dynamic>{
      'module': instance.module,
      'today': instance.today,
      'month': instance.month,
      'record_count': instance.recordCount,
      'metrics': instance.metrics,
      'lines': instance.lines,
    };

_VaultStatus _$VaultStatusFromJson(Map<String, dynamic> json) => _VaultStatus(
  configured: json['configured'] as bool,
  maxFileBytes: (json['max_file_bytes'] as num).toInt(),
  quotaBytes: (json['quota_bytes'] as num).toInt(),
  usedBytes: (json['used_bytes'] as num).toInt(),
  encryption: json['encryption'] as String,
);

Map<String, dynamic> _$VaultStatusToJson(_VaultStatus instance) =>
    <String, dynamic>{
      'configured': instance.configured,
      'max_file_bytes': instance.maxFileBytes,
      'quota_bytes': instance.quotaBytes,
      'used_bytes': instance.usedBytes,
      'encryption': instance.encryption,
    };

_VaultItem _$VaultItemFromJson(Map<String, dynamic> json) => _VaultItem(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  filename: json['filename'] as String,
  mime: json['mime'] as String,
  size: (json['size'] as num).toInt(),
  sha256: json['sha256'] as String,
  allowAi: json['allow_ai'] as bool,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$VaultItemToJson(_VaultItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'filename': instance.filename,
      'mime': instance.mime,
      'size': instance.size,
      'sha256': instance.sha256,
      'allow_ai': instance.allowAi,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_KnowledgeNode _$KnowledgeNodeFromJson(Map<String, dynamic> json) =>
    _KnowledgeNode(
      id: json['id'] as String,
      title: json['title'] as String,
      allowAi: json['allow_ai'] as bool,
    );

Map<String, dynamic> _$KnowledgeNodeToJson(_KnowledgeNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'allow_ai': instance.allowAi,
    };

_KnowledgeEdge _$KnowledgeEdgeFromJson(Map<String, dynamic> json) =>
    _KnowledgeEdge(
      id: json['id'] as String,
      sourceId: json['source_id'] as String,
      targetId: json['target_id'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$KnowledgeEdgeToJson(_KnowledgeEdge instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source_id': instance.sourceId,
      'target_id': instance.targetId,
      'label': instance.label,
    };

_KnowledgeGraph _$KnowledgeGraphFromJson(Map<String, dynamic> json) =>
    _KnowledgeGraph(
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => KnowledgeNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>)
          .map((e) => KnowledgeEdge.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$KnowledgeGraphToJson(_KnowledgeGraph instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'edges': instance.edges,
      'total': instance.total,
      'limit': instance.limit,
    };
