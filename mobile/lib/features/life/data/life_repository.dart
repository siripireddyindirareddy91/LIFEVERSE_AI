import '../../../core/models/life_models.dart';
import '../../../core/network/api_client.dart';

enum RecordKind { tasks, goals, habits, memories, events }

class LifeRepository {
  LifeRepository(this.api);
  final ApiClient api;

  Map<String, dynamic> _query(LifeQuery query) => {
    'limit': 30,
    'offset': query.offset,
    'q': query.search,
    if (query.status != null) 'status': query.status,
    if (query.goalId != null) 'goal_id': query.goalId,
    if (query.startsAfter != null)
      'starts_after': query.startsAfter!.toUtc().toIso8601String(),
    if (query.endsBefore != null)
      'ends_before': query.endsBefore!.toUtc().toIso8601String(),
  };
  Future<DataPage<T>> _page<T>(
    String path,
    LifeQuery query,
    T Function(Map<String, dynamic>) decode,
  ) async => DataPage.fromJson(
    Map<String, dynamic>.from(
      await api.request('/api/v1/$path', query: _query(query)) as Map,
    ),
    decode,
  );
  Future<ProfileData?> profile() async {
    try {
      return ProfileData.fromJson(
        Map<String, dynamic>.from(await api.request('/api/v1/profile') as Map),
      );
    } on ApiFailure catch (error) {
      if (error.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> saveProfile(Map<String, dynamic> payload) async {
    await api.request('/api/v1/profile', method: 'PUT', data: payload);
  }

  Future<DataPage<TaskItem>> tasks(LifeQuery query) =>
      _page('tasks', query, TaskItem.fromJson);
  Future<DataPage<GoalItem>> goals(LifeQuery query) =>
      _page('goals', query, GoalItem.fromJson);
  Future<GoalItem> goal(String id) async => GoalItem.fromJson(
    Map<String, dynamic>.from(await api.request('/api/v1/goals/$id') as Map),
  );
  Future<DataPage<HabitItem>> habits(LifeQuery query) =>
      _page('habits', query, HabitItem.fromJson);
  Future<DataPage<MemoryItem>> memories(LifeQuery query) =>
      _page('memories', query, MemoryItem.fromJson);
  Future<DataPage<CalendarItem>> events(LifeQuery query) =>
      _page('events', query, CalendarItem.fromJson);
  Future<void> save(
    RecordKind kind,
    Map<String, dynamic> payload, {
    String? id,
  }) async {
    await api.request(
      '/api/v1/${kind.name}${id == null ? '' : '/$id'}',
      method: id == null ? 'POST' : 'PUT',
      data: payload,
    );
  }

  Future<void> remove(RecordKind kind, String id) async {
    await api.request('/api/v1/${kind.name}/$id', method: 'DELETE');
  }

  Future<void> taskStatus(TaskItem task) async {
    await api.request(
      '/api/v1/tasks/${task.id}/status',
      method: 'PATCH',
      data: {'status': task.status == 'done' ? 'todo' : 'done'},
    );
  }

  Future<void> checkHabit(HabitItem habit) async {
    await api.request(
      '/api/v1/habits/${habit.id}/checkins',
      method: habit.checkedToday ? 'DELETE' : 'POST',
      data: habit.checkedToday ? null : <String, dynamic>{},
    );
  }

  Future<List<MemoryItem>> exportMemories() async =>
      (await api.request('/api/v1/memories/export') as List)
          .map(
            (item) =>
                MemoryItem.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
  Future<void> eraseMemories() async {
    await api.request(
      '/api/v1/memories',
      method: 'DELETE',
      data: {'confirmation': 'DELETE ALL MEMORIES'},
    );
  }

  Future<DashboardData> dashboard() async => DashboardData.fromJson(
    Map<String, dynamic>.from(await api.request('/api/v1/dashboard') as Map),
  );
  Future<AssistantStatus> assistantStatus() async => AssistantStatus.fromJson(
    Map<String, dynamic>.from(
      await api.request('/api/v1/assistant/status') as Map,
    ),
  );
  Future<DataPage<ConversationItem>> conversations(LifeQuery query) =>
      _page('assistant/conversations', query, ConversationItem.fromJson);
  Future<DataPage<MessageItem>> messages(
    String conversationId,
    LifeQuery query,
  ) => _page(
    'assistant/conversations/$conversationId/messages',
    query,
    MessageItem.fromJson,
  );
  Future<void> deleteConversation(String id) async {
    await api.request('/api/v1/assistant/conversations/$id', method: 'DELETE');
  }

  Future<ChatResult> sendMessage({
    required String requestId,
    required String message,
    String? conversationId,
    required bool includeMemory,
    required bool includePlans,
  }) async => ChatResult.fromJson(
    Map<String, dynamic>.from(
      await api.request(
            '/api/v1/assistant/chat',
            method: 'POST',
            ai: true,
            data: {
              'request_id': requestId,
              'message': message,
              'conversation_id': conversationId,
              'include_memory': includeMemory,
              'include_plans': includePlans,
            },
          )
          as Map,
    ),
  );
}
