// Explicit test-only service/native adapters. Never registered by production bootstrap.
import 'package:lifeverse_ai/core/models/automation_models.dart';
import 'package:lifeverse_ai/core/models/life_models.dart';
import 'package:lifeverse_ai/core/network/api_client.dart';
import 'package:lifeverse_ai/features/automation/data/automation_repository.dart';
import 'package:lifeverse_ai/features/automation/data/device_gateway.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAutomationRepository extends AutomationRepository {
  FakeAutomationRepository() : super(ApiClient('https://test.invalid', null));
  static final time = DateTime.utc(2026, 11, 19);
  WorkflowItem item = WorkflowItem(
    id: 'test-workflow',
    title: 'A gentler morning (test)',
    definition: const {
      'nodes': [
        {'type': 'trigger', 'mode': 'manual'},
        {'type': 'report', 'module': 'life'},
        {
          'type': 'notify',
          'title': 'Morning report',
          'body': 'Your report is ready.',
        },
        {'type': 'output'},
      ],
    },
    revision: 'test-revision',
    enabled: false,
    digest: 'test-digest',
    permissions: const [
      'Read your own saved records',
      'Automatic in-app notification',
    ],
    createdAt: time,
  );
  final saves = <Map<String, dynamic>>[];
  final activations = <WorkflowItem>[];
  final reminders = <Map<String, dynamic>>[];
  final oauth = <bool>[];
  final exportDecisions = <bool>[];
  bool failSave = false;
  int imports = 0;
  final notifications = <InboxItem>[
    InboxItem(
      id: 'test-notification',
      title: 'A little room for what matters',
      body:
          'Your workflow report is ready. Open the run to review each completed step.',
      route: '/automation/runs/test-run',
      dueAt: time,
      readAt: null,
      cancelled: false,
      createdAt: time,
      expiresAt: DateTime.utc(2099),
    ),
  ];
  late WorkflowRun execution = WorkflowRun(
    id: 'test-run',
    workflowId: item.id,
    revision: item.revision,
    status: 'waiting_approval',
    cursor: 2,
    steps: [
      WorkflowStep(
        index: 0,
        type: 'trigger',
        status: 'completed',
        summary: 'Trigger received',
        at: time,
      ),
      WorkflowStep(
        index: 1,
        type: 'action',
        status: 'prepared',
        summary: 'Prepared for your approval; no life records changed',
        at: time,
      ),
    ],
    proposalRunId: 'test-agent-run',
    createdAt: time,
    expiresAt: DateTime.utc(2099),
  );
  late CalendarConnection connection = CalendarConnection(
    id: 'test-calendar',
    title: 'Google default calendar (test)',
    provider: 'google',
    writable: true,
    active: true,
    revision: 'test-revision',
    lastSyncAt: time,
    createdAt: time,
  );
  late CalendarExport operation = CalendarExport(
    id: 'test-export',
    connectionId: connection.id,
    localEventId: 'test-event',
    payload: const {
      'title': 'A focused hour',
      'notes': 'Time for the important things.',
      'starts_at': '2026-11-20T09:00:00Z',
      'ends_at': '2026-11-20T10:00:00Z',
    },
    digest: 'test-digest',
    nonce: 'test-nonce',
    status: 'awaiting_approval',
    expiresAt: DateTime.utc(2099),
    createdAt: time,
  );
  @override
  Future<Map<String, dynamic>> status() async => {
    'worker_online': true,
    'daily_limit': 40,
    'history_days': 30,
    'max_nodes': 12,
    'external_apis_enabled': true,
  };
  @override
  Future<List<Map<String, dynamic>>> templates() async => [
    for (var i = 0; i < 3; i++)
      {'title': item.title, 'definition': item.definition},
  ];
  @override
  Future<DataPage<WorkflowItem>> workflows(int offset) async =>
      DataPage(items: [item], total: 1, limit: 30, offset: offset);
  @override
  Future<WorkflowItem> workflow(String id) async => item;
  @override
  Future<WorkflowItem> save(Map<String, dynamic> data, {String? id}) async {
    saves.add(data);
    if (failSave) throw const ApiFailure('Test save failure');
    item = item.copyWith(
      title: data['title'] as String,
      definition: Map<String, dynamic>.from(data['definition'] as Map),
      enabled: false,
    );
    return item;
  }

  @override
  Future<WorkflowItem> activate(WorkflowItem value) async {
    activations.add(value);
    item = item.copyWith(enabled: true);
    return item;
  }

  @override
  Future<void> pause(String id) async {
    item = item.copyWith(enabled: false);
  }

  @override
  Future<WorkflowRun> run(String id, String requestId) async => execution;
  @override
  Future<DataPage<WorkflowRun>> history(int offset) async =>
      DataPage(items: [execution], total: 1, limit: 30, offset: offset);
  @override
  Future<WorkflowRun> detail(String id) async => execution;
  @override
  Future<void> cancel(String id) async {
    execution = execution.copyWith(status: 'cancelled');
  }

  @override
  Future<Map<String, dynamic>> inbox({
    int offset = 0,
    bool pending = false,
  }) async => {
    'items': notifications
        .where((n) => !n.cancelled && (!pending || n.readAt == null))
        .map((n) => n.toJson())
        .toList(),
    'total': notifications.length,
    'unread': notifications
        .where((n) => n.readAt == null && !n.cancelled)
        .length,
    'offset': offset,
    'limit': 30,
  };
  @override
  Future<void> reminder(Map<String, dynamic> data) async {
    reminders.add(data);
  }

  @override
  Future<void> read(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    notifications[index] = notifications[index].copyWith(readAt: time);
  }

  @override
  Future<void> dismiss(String id) async {
    final index = notifications.indexWhere((n) => n.id == id);
    notifications[index] = notifications[index].copyWith(cancelled: true);
  }

  @override
  Future<Map<String, dynamic>> integrationsStatus() async => {
    'providers': [
      {'provider': 'google', 'configured': true},
      {'provider': 'microsoft', 'configured': false},
    ],
    'external_apis_enabled': true,
  };
  @override
  Future<String> startOAuth(String provider, bool writable) async {
    oauth.add(writable);
    return 'https://accounts.google.com/o/oauth2/v2/auth?test-only=true';
  }

  @override
  Future<List<CalendarConnection>> connections() async => [connection];
  @override
  Future<DataPage<CalendarMirror>> events(String id, int offset) async =>
      DataPage(
        items: [
          CalendarMirror(
            id: 'test-mirror',
            title: 'A real fixture event',
            startsAt: time.add(const Duration(days: 1)),
            endsAt: time.add(const Duration(days: 1, hours: 1)),
            allDay: false,
          ),
        ],
        total: 1,
        limit: 30,
        offset: offset,
      );
  @override
  Future<void> importEvent(String id, {bool overlap = false}) async {
    imports++;
  }

  @override
  Future<DataPage<CalendarExport>> exports(int offset) async =>
      DataPage(items: [operation], total: 1, limit: 30, offset: offset);
  @override
  Future<void> decideExport(CalendarExport op, bool approve) async {
    exportDecisions.add(approve);
    operation = operation.copyWith(status: approve ? 'approved' : 'rejected');
  }
}

class FakeDeviceGateway extends DeviceGateway {
  int permissions = 0, clears = 0, syncs = 0, opens = 0;
  @override
  Future<bool> requestPermission() async {
    permissions++;
    return true;
  }

  @override
  Future<void> clear() async {
    clears++;
  }

  @override
  Future<void> synchronize(
    List<InboxItem> items,
    SharedPreferences prefs,
    bool Function() current,
    void Function(String) onOpen,
  ) async {
    if (current()) syncs++;
  }

  @override
  Future<void> openOAuth(String url) async {
    opens++;
  }
}
