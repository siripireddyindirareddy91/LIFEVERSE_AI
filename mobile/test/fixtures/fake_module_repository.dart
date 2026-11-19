// Explicit test adapter; never imported by production code.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:lifeverse_ai/core/models/module_models.dart';
import 'package:lifeverse_ai/core/models/life_models.dart';
import 'package:lifeverse_ai/core/network/api_client.dart';
import 'package:lifeverse_ai/features/modules/data/module_repository.dart';
import 'package:lifeverse_ai/features/modules/data/vault_file_gateway.dart';

class FakeModuleRepository extends ModuleRepository {
  FakeModuleRepository() : super(ApiClient('https://test.invalid', null));
  static final time = DateTime.utc(2026, 11, 19);
  final items = <ModuleRecord>[];
  final uploads = <Map<String, dynamic>>[];
  final saves = <Map<String, dynamic>>[];
  final documents = <VaultItem>[];
  bool failSave = false, failUpload = false;
  int count = 0;
  KnowledgeGraph connections = const KnowledgeGraph(
    nodes: [
      KnowledgeNode(id: 'one', title: 'Flutter', allowAi: false),
      KnowledgeNode(id: 'two', title: 'Dart', allowAi: true),
    ],
    edges: [
      KnowledgeEdge(
        id: 'link',
        sourceId: 'one',
        targetId: 'two',
        label: 'built with',
      ),
    ],
    total: 2,
    limit: 100,
  );
  @override
  Future<ModuleCatalog> catalog() async => ModuleCatalog.fromJson(
    jsonDecode(File('test/fixtures/module_catalog.json').readAsStringSync())
        as Map<String, dynamic>,
  );
  @override
  Future<ModuleReport> overview(String module, String? month) async =>
      ModuleReport(
        module: module,
        today: '2026-11-19',
        month: month ?? '2026-11-01',
        recordCount: items.length,
        metrics: [
          ReportMetric(
            label: 'Your saved records',
            value: items.length.toString(),
            detail: 'Test-only repository',
          ),
        ],
      );
  @override
  Future<DataPage<ModuleRecord>> records(
    String module, {
    String? kind,
    String? parentId,
    int offset = 0,
    int limit = 30,
    String search = '',
  }) async {
    final rows = items
        .where(
          (r) =>
              (kind == null || r.kind == kind) &&
              (parentId == null || r.parentId == parentId) &&
              r.title.contains(search),
        )
        .toList();
    return DataPage(
      items: rows.skip(offset).take(limit),
      total: rows.length,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<ModuleRecord> save(
    String kind,
    Map<String, dynamic> payload, {
    String? id,
  }) async {
    saves.add(payload);
    if (failSave) throw const ApiFailure('Test-only save failure');
    final row = ModuleRecord(
      id: id ?? 'test-${++count}',
      kind: kind,
      title: (payload['data'] as Map)['title'] as String,
      data: Map<String, dynamic>.from(payload['data'] as Map),
      parentId: payload['parent_id'] as String?,
      allowAi: payload['allow_ai'] as bool,
      revision: 'revision-$count',
      createdAt: time,
      updatedAt: time,
    );
    items.removeWhere((r) => r.id == id);
    items.add(row);
    return row;
  }

  @override
  Future<void> remove(String id) async {
    items.removeWhere((r) => r.id == id);
  }

  @override
  Future<Map<String, dynamic>> plan(String id, String requestId) async => {
    'task_id': 'test-task',
    'cached': false,
  };
  @override
  Future<Map<String, dynamic>> practice(String id) async => {
    'question': 'Which language does Flutter use?',
    'options': {'A': 'Dart', 'B': 'Other'},
  };
  @override
  Future<Map<String, dynamic>> answer(String id, String answer) async => {
    'correct': answer == 'A',
    'answer': 'A',
    'explanation': 'Flutter uses Dart.',
    'score': answer == 'A' ? 1 : 0,
    'total': 1,
  };
  @override
  Future<Map<String, dynamic>> resume(String id) async => {
    'text': 'Test resume\nFlutter developer',
    'missing_sections': ['Education'],
    'matched_terms': ['dart'],
    'review_terms': ['sql'],
    'method': 'Literal test comparison',
  };
  @override
  Future<Map<String, dynamic>> projection(String id) async => {
    'type': 'savings',
    'currency': 'INR',
    'projected_balance': '220.00',
    'contributed': '220.00',
    'estimated_hours': '104.0',
    'target_hours': 100,
    'points': [
      {'month': 0, 'balance': '100.00'},
      {'month': 12, 'balance': '220.00'},
    ],
    'assumptions': 'Test assumptions only',
    'risks': 'Unknown outcomes',
    'method': 'Estimate from test inputs',
  };
  @override
  Future<KnowledgeGraph> graph(String search) async => connections;
  @override
  Future<void> connect(String source, String target, String label) async {
    connections = connections.copyWith(
      edges: [
        ...connections.edges,
        KnowledgeEdge(
          id: 'new-link',
          sourceId: source,
          targetId: target,
          label: label,
        ),
      ],
    );
  }

  @override
  Future<void> disconnect(String id) async {
    connections = connections.copyWith(
      edges: connections.edges.where((e) => e.id != id).toList(),
    );
  }

  @override
  Future<VaultStatus> vaultStatus() async => const VaultStatus(
    configured: true,
    maxFileBytes: 5242880,
    quotaBytes: 104857600,
    usedBytes: 0,
    encryption: 'Test-only configuration',
  );
  @override
  Future<DataPage<VaultItem>> files(int offset, String query) async => DataPage(
    items: documents,
    total: documents.length,
    offset: offset,
    limit: 30,
  );
  @override
  Future<void> upload(Map<String, dynamic> payload) async {
    uploads.add(payload);
    if (failUpload) throw const ApiFailure('Test upload failure');
    documents.add(
      VaultItem(
        id: 'test-file',
        title: payload['title'] as String,
        category: payload['category'] as String,
        filename: payload['filename'] as String,
        mime: 'text/plain',
        size: 12,
        sha256: 'test-hash',
        allowAi: payload['allow_ai'] as bool,
        createdAt: time,
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> download(String id) async => {
    'filename': 'test.txt',
    'content_base64': base64Encode(utf8.encode('Test-only document')),
  };
}

class FakeVaultGateway extends VaultFileGateway {
  int downloads = 0;
  @override
  Future<PickedVaultFile?> pick() async => PickedVaultFile(
    'test.txt',
    Uint8List.fromList(utf8.encode('Test-only document')),
  );
  @override
  Future<bool> save(String name, Uint8List bytes) async {
    downloads++;
    return true;
  }
}
