import '../../../core/models/module_models.dart';
import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';

class ModuleRepository {
  ModuleRepository(this.api);
  final ApiClient api;
  Future<Map<String, dynamic>> call(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async => Map<String, dynamic>.from(
    await api.request('/api/v1/$path', method: method, data: data, query: query)
        as Map,
  );
  Future<ModuleCatalog> catalog() async =>
      ModuleCatalog.fromJson(await call('modules/catalog'));
  Future<ModuleReport> overview(String module, String? month) async =>
      ModuleReport.fromJson(
        await call('modules/$module/overview', query: {'month': ?month}),
      );
  Future<DataPage<ModuleRecord>> records(
    String module, {
    String? kind,
    String? parentId,
    int offset = 0,
    int limit = 30,
    String search = '',
  }) async => DataPage.fromJson(
    await call(
      'modules/$module/records',
      query: {
        'offset': offset,
        'limit': limit,
        'q': search,
        'kind': ?kind,
        'parent_id': ?parentId,
      },
    ),
    ModuleRecord.fromJson,
  );
  Future<ModuleRecord> save(
    String kind,
    Map<String, dynamic> payload, {
    String? id,
  }) async => ModuleRecord.fromJson(
    await call(
      id == null ? 'modules/records/$kind' : 'modules/record/$id',
      method: id == null ? 'POST' : 'PUT',
      data: payload,
    ),
  );
  Future<void> remove(String id) async {
    await api.request('/api/v1/modules/record/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> plan(String id, String requestId) => call(
    'modules/record/$id/planner',
    method: 'POST',
    data: {'request_id': requestId},
  );
  Future<Map<String, dynamic>> practice(String id) =>
      call('learning/practice/$id');
  Future<Map<String, dynamic>> answer(String id, String answer) =>
      call('learning/practice/$id', method: 'POST', data: {'answer': answer});
  Future<Map<String, dynamic>> resume(String id) => call('career/resume/$id');
  Future<Map<String, dynamic>> projection(String id) =>
      call('future/scenarios/$id');
  Future<Map<String, dynamic>> convert(Map<String, dynamic> payload) =>
      call('finance/convert', method: 'POST', data: payload);
  Future<KnowledgeGraph> graph(String search) async => KnowledgeGraph.fromJson(
    await call('knowledge-universe/graph', query: {'q': search}),
  );
  Future<void> connect(String source, String target, String label) async {
    await call(
      'knowledge-universe/links',
      method: 'POST',
      data: {'source_id': source, 'target_id': target, 'label': label},
    );
  }

  Future<void> disconnect(String id) async {
    await api.request('/api/v1/knowledge-universe/links/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> searchKnowledge(String query, bool semantic) =>
      call(
        'knowledge-universe/search',
        method: 'POST',
        data: {'query': query, 'semantic': semantic},
      );
  Future<VaultStatus> vaultStatus() async =>
      VaultStatus.fromJson(await call('vault/status'));
  Future<DataPage<VaultItem>> files(int offset, String query) async =>
      DataPage.fromJson(
        await call(
          'vault/files',
          query: {'offset': offset, 'q': query, 'limit': 30},
        ),
        VaultItem.fromJson,
      );
  Future<void> upload(Map<String, dynamic> payload) async {
    await call('vault/files', method: 'POST', data: payload);
  }

  Future<void> editFile(String id, Map<String, dynamic> payload) async {
    await call('vault/files/$id', method: 'PUT', data: payload);
  }

  Future<void> removeFile(String id) async {
    await api.request('/api/v1/vault/files/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> download(String id) =>
      call('vault/files/$id/download');
}
