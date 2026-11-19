import '../../../core/models/agent_models.dart';
import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';

class AgentRepository {
  AgentRepository(this.api);
  final ApiClient api;
  Future<Map<String, dynamic>> _get(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
  }) async => Map<String, dynamic>.from(
    await api.request('/api/v1/$path', method: method, data: data) as Map,
  );
  Future<AgentStatus> status() async =>
      AgentStatus.fromJson(await _get('agents/status'));
  Future<DataPage<AgentRun>> runs(int offset) async => DataPage.fromJson(
    Map<String, dynamic>.from(
      await api.request(
            '/api/v1/agents/runs',
            query: {'offset': offset, 'limit': 30},
          )
          as Map,
    ),
    AgentRun.fromJson,
  );
  Future<AgentRun> run(String id) async =>
      AgentRun.fromJson(await _get('agents/runs/$id'));
  Future<AgentRun> create(Map<String, dynamic> payload) async =>
      AgentRun.fromJson(
        await _get('agents/runs', method: 'POST', data: payload),
      );
  Future<AgentRun> decide(String id, Map<String, dynamic> payload) async =>
      AgentRun.fromJson(
        await _get('agents/runs/$id/decision', method: 'POST', data: payload),
      );
  Future<AgentRun> cancel(String id) async =>
      AgentRun.fromJson(await _get('agents/runs/$id/cancel', method: 'POST'));
  Future<void> remove(String id) async {
    await api.request('/api/v1/agents/runs/$id', method: 'DELETE');
  }

  Future<DataPage<KnowledgeItem>> knowledge(int offset) async =>
      DataPage.fromJson(
        Map<String, dynamic>.from(
          await api.request(
                '/api/v1/knowledge',
                query: {'offset': offset, 'limit': 30},
              )
              as Map,
        ),
        KnowledgeItem.fromJson,
      );
  Future<void> saveKnowledge(Map<String, dynamic> payload, {String? id}) async {
    await _get(
      'knowledge${id == null ? '' : '/$id'}',
      method: id == null ? 'POST' : 'PUT',
      data: payload,
    );
  }

  Future<void> deleteKnowledge(String id) async {
    await api.request('/api/v1/knowledge/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> index(String kind, String id) =>
      _get('retrieval/$kind/$id/index', method: 'POST');
  Future<Map<String, dynamic>> source(String kind, String id) =>
      _get('${kind == 'memory' ? 'memories' : 'knowledge'}/$id');
}
