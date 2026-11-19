import '../../../core/models/automation_models.dart';
import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';

class AutomationRepository {
  AutomationRepository(this.api);
  final ApiClient api;
  Future<Map<String, dynamic>> call(
    String path, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async => Map<String, dynamic>.from(
    await api.request(
          '/api/v1/$path',
          method: method,
          data: data,
          query: query,
          ai: path.endsWith('/sync') || path.endsWith('/read'),
        )
        as Map,
  );
  Future<Map<String, dynamic>> status() => call('automation/status');
  Future<List<Map<String, dynamic>>> templates() async => (await call(
    'automation/templates',
  ))['items'].cast<Map<String, dynamic>>();
  Future<DataPage<WorkflowItem>> workflows(int offset) async =>
      DataPage.fromJson(
        await call('automation/workflows', query: {'offset': offset}),
        WorkflowItem.fromJson,
      );
  Future<WorkflowItem> workflow(String id) async =>
      WorkflowItem.fromJson(await call('automation/workflows/$id'));
  Future<WorkflowItem> save(Map<String, dynamic> data, {String? id}) async =>
      WorkflowItem.fromJson(
        await call(
          'automation/workflows${id == null ? '' : '/$id'}',
          method: id == null ? 'POST' : 'PUT',
          data: data,
        ),
      );
  Future<WorkflowItem> activate(WorkflowItem item) async =>
      WorkflowItem.fromJson(
        await call(
          'automation/workflows/${item.id}/activate',
          method: 'POST',
          data: {'revision': item.revision, 'digest': item.digest},
        ),
      );
  Future<void> pause(String id) async {
    await call('automation/workflows/$id/pause', method: 'POST');
  }

  Future<void> removeWorkflow(String id) async {
    await api.request('/api/v1/automation/workflows/$id', method: 'DELETE');
  }

  Future<WorkflowRun> run(String id, String requestId) async =>
      WorkflowRun.fromJson(
        await call(
          'automation/workflows/$id/run',
          method: 'POST',
          data: {'request_id': requestId},
        ),
      );
  Future<DataPage<WorkflowRun>> history(int offset) async => DataPage.fromJson(
    await call('automation/runs', query: {'offset': offset}),
    WorkflowRun.fromJson,
  );
  Future<WorkflowRun> detail(String id) async =>
      WorkflowRun.fromJson(await call('automation/runs/$id'));
  Future<void> cancel(String id) async {
    await call('automation/runs/$id/cancel', method: 'POST');
  }

  Future<void> retry(String id) async {
    await call('automation/runs/$id/retry', method: 'POST');
  }

  Future<void> removeRun(String id) async {
    await api.request('/api/v1/automation/runs/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> inbox({int offset = 0, bool pending = false}) =>
      call(
        'notifications',
        query: {
          'offset': offset,
          'limit': pending ? 50 : 30,
          'pending': pending,
        },
      );
  Future<void> reminder(Map<String, dynamic> data) async {
    await call('notifications', method: 'POST', data: data);
  }

  Future<void> read(String id) async {
    await call('notifications/$id/read', method: 'POST');
  }

  Future<void> dismiss(String id) async {
    await api.request('/api/v1/notifications/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> integrationsStatus() =>
      call('integrations/status');
  Future<String> startOAuth(String provider, bool writable) async =>
      (await call(
            'integrations/oauth/$provider/start',
            method: 'POST',
            data: {'writable': writable},
          ))['authorization_url']
          as String;
  Future<List<CalendarConnection>> connections() async =>
      ((await call('integrations/calendars'))['items'] as List)
          .map(
            (e) => CalendarConnection.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
  Future<void> disconnect(String id) async {
    await api.request('/api/v1/integrations/calendars/$id', method: 'DELETE');
  }

  Future<Map<String, dynamic>> sync(String id) =>
      call('integrations/calendars/$id/sync', method: 'POST');
  Future<DataPage<CalendarMirror>> events(String id, int offset) async =>
      DataPage.fromJson(
        await call(
          'integrations/calendars/$id/events',
          query: {'offset': offset},
        ),
        CalendarMirror.fromJson,
      );
  Future<void> importEvent(String id, {bool overlap = false}) async {
    await call(
      'integrations/events/$id/import',
      method: 'POST',
      query: {'allow_overlap': overlap},
    );
  }

  Future<CalendarExport> prepareExport(
    String connection,
    String eventId,
    String requestId,
  ) async => CalendarExport.fromJson(
    await call(
      'integrations/calendars/$connection/exports',
      method: 'POST',
      data: {'local_event_id': eventId, 'request_id': requestId},
    ),
  );
  Future<DataPage<CalendarExport>> exports(int offset) async =>
      DataPage.fromJson(
        await call('integrations/exports', query: {'offset': offset}),
        CalendarExport.fromJson,
      );
  Future<void> decideExport(CalendarExport op, bool approve) async {
    await call(
      'integrations/exports/${op.id}/decision',
      method: 'POST',
      data: {'digest': op.digest, 'nonce': op.nonce, 'approve': approve},
    );
  }

  Future<Map<String, dynamic>> external(Map<String, dynamic> data) =>
      call('integrations/external/read', method: 'POST', data: data);
}
