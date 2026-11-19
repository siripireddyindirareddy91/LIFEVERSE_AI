import 'package:freezed_annotation/freezed_annotation.dart';
part 'module_models.freezed.dart';
part 'module_models.g.dart';

@freezed
abstract class ModuleRecord with _$ModuleRecord {
  const factory ModuleRecord({
    required String id,
    required String kind,
    required String title,
    required Map<String, dynamic> data,
    String? parentId,
    required bool allowAi,
    required String revision,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ModuleRecord;
  factory ModuleRecord.fromJson(Map<String, dynamic> json) =>
      _$ModuleRecordFromJson(json);
}

@freezed
abstract class ReportMetric with _$ReportMetric {
  const factory ReportMetric({
    required String label,
    required String value,
    @Default('') String detail,
  }) = _ReportMetric;
  factory ReportMetric.fromJson(Map<String, dynamic> json) =>
      _$ReportMetricFromJson(json);
}

@freezed
abstract class ModuleReport with _$ModuleReport {
  const factory ModuleReport({
    required String module,
    required String today,
    required String month,
    required int recordCount,
    @Default([]) List<ReportMetric> metrics,
    @Default([]) List<ReportMetric> lines,
  }) = _ModuleReport;
  factory ModuleReport.fromJson(Map<String, dynamic> json) =>
      _$ModuleReportFromJson(json);
}

@freezed
abstract class VaultStatus with _$VaultStatus {
  const factory VaultStatus({
    required bool configured,
    required int maxFileBytes,
    required int quotaBytes,
    required int usedBytes,
    required String encryption,
  }) = _VaultStatus;
  factory VaultStatus.fromJson(Map<String, dynamic> json) =>
      _$VaultStatusFromJson(json);
}

@freezed
abstract class VaultItem with _$VaultItem {
  const factory VaultItem({
    required String id,
    required String title,
    required String category,
    required String filename,
    required String mime,
    required int size,
    required String sha256,
    required bool allowAi,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) = _VaultItem;
  factory VaultItem.fromJson(Map<String, dynamic> json) =>
      _$VaultItemFromJson(json);
}

@freezed
abstract class KnowledgeNode with _$KnowledgeNode {
  const factory KnowledgeNode({
    required String id,
    required String title,
    required bool allowAi,
  }) = _KnowledgeNode;
  factory KnowledgeNode.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeNodeFromJson(json);
}

@freezed
abstract class KnowledgeEdge with _$KnowledgeEdge {
  const factory KnowledgeEdge({
    required String id,
    required String sourceId,
    required String targetId,
    required String label,
  }) = _KnowledgeEdge;
  factory KnowledgeEdge.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeEdgeFromJson(json);
}

@freezed
abstract class KnowledgeGraph with _$KnowledgeGraph {
  const factory KnowledgeGraph({
    required List<KnowledgeNode> nodes,
    required List<KnowledgeEdge> edges,
    required int total,
    required int limit,
  }) = _KnowledgeGraph;
  factory KnowledgeGraph.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeGraphFromJson(json);
}

// Structured input fields are derived from the server's validated domain schemas.
class ModuleField {
  ModuleField(this.name, Map<String, dynamic> spec, this.required)
    : schema = spec;
  final String name;
  final Map<String, dynamic> schema;
  final bool required;
  String get label => schema['title'] as String? ?? name.replaceAll('_', ' ');
  List<Map<String, dynamic>> get variants => [
    schema,
    ...((schema['anyOf'] as List?) ?? []).cast<Map<String, dynamic>>(),
  ];
  bool get nullable => variants.any((v) => v['type'] == 'null');
  String get type => variants
      .map((v) => v['type'])
      .whereType<String>()
      .firstWhere((v) => v != 'null', orElse: () => 'string');
  String? get format =>
      variants.map((v) => v['format']).whereType<String>().firstOrNull;
  List<String> get choices => ((schema['enum'] as List?) ?? []).cast<String>();
  Object? get initial => schema['default'];
  int? get maxLength => schema['maxLength'] as int?;
  bool get multiline => (maxLength ?? 0) > 1000;
}

class ModuleCatalog {
  ModuleCatalog(this.schemas);
  final Map<String, List<ModuleField>> schemas;
  factory ModuleCatalog.fromJson(Map<String, dynamic> json) => ModuleCatalog({
    for (final entry in (json['schemas'] as Map<String, dynamic>).entries)
      entry.key: [
        for (final field
            in ((entry.value as Map)['properties'] as Map<String, dynamic>)
                .entries)
          ModuleField(
            field.key,
            Map<String, dynamic>.from(field.value as Map),
            ((entry.value as Map)['required'] as List? ?? []).contains(
              field.key,
            ),
          ),
      ],
  });
}
