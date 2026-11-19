// Test-only adapter. Never registered by the production bootstrap.
import 'package:lifeverse_ai/core/models/life_models.dart';
import 'package:lifeverse_ai/core/network/api_client.dart';
import 'package:lifeverse_ai/features/life/data/life_repository.dart';

class FakeLifeRepository extends LifeRepository {
  FakeLifeRepository() : super(ApiClient('https://test.invalid', null));
  ProfileData? savedProfile = const ProfileData(
    userId: 'test-user',
    displayName: 'Test user',
    aiConsent: true,
    memoryConsent: true,
  );
  final List<TaskItem> taskItems = [];
  final List<GoalItem> goalItems = [];
  final List<HabitItem> habitItems = [];
  final List<MemoryItem> memoryItems = [];
  final List<CalendarItem> eventItems = [];
  final List<MessageItem> messageItems = [];
  bool failTasks = false;
  bool failChat = false;
  int sends = 0;
  final List<String> requestIds = [];
  int _next = 0;
  static final timestamp = DateTime.utc(2026, 11, 19);

  DataPage<T> page<T>(Iterable<T> items, LifeQuery query) {
    final values = items.toList();
    return DataPage(
      items: values.skip(query.offset).take(30),
      total: values.length,
      offset: query.offset,
      limit: 30,
    );
  }

  @override
  Future<ProfileData?> profile() async => savedProfile;
  @override
  Future<void> saveProfile(Map<String, dynamic> payload) async {
    savedProfile = ProfileData.fromJson({'user_id': 'test-user', ...payload});
  }

  @override
  Future<DataPage<TaskItem>> tasks(LifeQuery query) async {
    if (failTasks) throw const ApiFailure('Test connection failure');
    return page(
      taskItems.where(
        (item) =>
            item.title.contains(query.search) &&
            (query.status == null || query.status == item.status) &&
            (query.goalId == null || query.goalId == item.goalId),
      ),
      query,
    );
  }

  @override
  Future<DataPage<GoalItem>> goals(LifeQuery query) async =>
      page(goalItems.where((item) => item.title.contains(query.search)), query);
  @override
  Future<GoalItem> goal(String id) async =>
      goalItems.singleWhere((item) => item.id == id);
  @override
  Future<DataPage<HabitItem>> habits(LifeQuery query) async => page(
    habitItems.where((item) => item.title.contains(query.search)),
    query,
  );
  @override
  Future<DataPage<MemoryItem>> memories(LifeQuery query) async => page(
    memoryItems.where((item) => item.title.contains(query.search)),
    query,
  );
  @override
  Future<DataPage<CalendarItem>> events(LifeQuery query) async => page(
    eventItems.where((item) => item.title.contains(query.search)),
    query,
  );
  @override
  Future<void> save(
    RecordKind kind,
    Map<String, dynamic> payload, {
    String? id,
  }) async {
    final json = {
      'id': id ?? 'record-${_next++}',
      'created_at': timestamp.toIso8601String(),
      ...payload,
    };
    switch (kind) {
      case RecordKind.tasks:
        taskItems.removeWhere((item) => item.id == id);
        taskItems.add(TaskItem.fromJson(json));
      case RecordKind.goals:
        goalItems.removeWhere((item) => item.id == id);
        goalItems.add(GoalItem.fromJson(json));
      case RecordKind.memories:
        memoryItems.removeWhere((item) => item.id == id);
        memoryItems.add(MemoryItem.fromJson(json));
      case RecordKind.events:
        eventItems.removeWhere((item) => item.id == id);
        eventItems.add(CalendarItem.fromJson(json));
      case RecordKind.habits:
        habitItems.removeWhere((item) => item.id == id);
        habitItems.add(
          HabitItem.fromJson({
            ...json,
            'checked_today': false,
            'current_streak': 0,
            'today': '2026-11-19',
          }),
        );
    }
  }

  @override
  Future<void> remove(RecordKind kind, String id) async {
    switch (kind) {
      case RecordKind.tasks:
        taskItems.removeWhere((item) => item.id == id);
      case RecordKind.goals:
        goalItems.removeWhere((item) => item.id == id);
      case RecordKind.habits:
        habitItems.removeWhere((item) => item.id == id);
      case RecordKind.memories:
        memoryItems.removeWhere((item) => item.id == id);
      case RecordKind.events:
        eventItems.removeWhere((item) => item.id == id);
    }
  }

  @override
  Future<void> taskStatus(TaskItem task) async {
    final index = taskItems.indexWhere((item) => item.id == task.id);
    taskItems[index] = task.copyWith(
      status: task.status == 'done' ? 'todo' : 'done',
    );
  }

  @override
  Future<void> checkHabit(HabitItem habit) async {
    final index = habitItems.indexWhere((item) => item.id == habit.id);
    habitItems[index] = habit.copyWith(
      checkedToday: !habit.checkedToday,
      currentStreak: habit.checkedToday ? 0 : 1,
    );
  }

  @override
  Future<List<MemoryItem>> exportMemories() async => List.of(memoryItems);
  @override
  Future<void> eraseMemories() async => memoryItems.clear();
  @override
  Future<DashboardData> dashboard() async => DashboardData(
    timezone: 'UTC',
    today: '2026-11-19',
    tasksOpen: taskItems.where((task) => task.status == 'todo').length,
    tasksCompleted: taskItems.where((task) => task.status == 'done').length,
    tasksDueToday: 0,
    tasksOverdue: 0,
    goalsActive: goalItems.where((goal) => goal.progress < 100).length,
    goalsCompleted: goalItems.where((goal) => goal.progress == 100).length,
    habitCount: habitItems.length,
    habitsCompletedToday: habitItems
        .where((habit) => habit.checkedToday)
        .length,
    memoriesActive: memoryItems.length,
    weeklyActivity: List.generate(
      7,
      (index) => ActivityDay(
        day: '2026-11-${13 + index}',
        tasksCompleted: 0,
        habitCheckins: 0,
      ),
    ),
  );
  @override
  Future<AssistantStatus> assistantStatus() async => AssistantStatus(
    configured: true,
    consentRequired: !(savedProfile?.aiConsent ?? false),
    retentionDays: 7,
    dailyLimit: 50,
  );
  @override
  Future<DataPage<ConversationItem>> conversations(LifeQuery query) async =>
      page(
        messageItems.isEmpty
            ? []
            : [
                ConversationItem(
                  id: 'conversation',
                  title: 'Test conversation',
                  createdAt: timestamp,
                  expiresAt: timestamp.add(const Duration(days: 7)),
                ),
              ],
        query,
      );
  @override
  Future<DataPage<MessageItem>> messages(
    String conversationId,
    LifeQuery query,
  ) async => page(messageItems, query);
  @override
  Future<void> deleteConversation(String id) async => messageItems.clear();
  @override
  Future<ChatResult> sendMessage({
    required String requestId,
    required String message,
    String? conversationId,
    required bool includeMemory,
    required bool includePlans,
  }) async {
    sends++;
    requestIds.add(requestId);
    if (failChat) {
      throw const ApiFailure('Test provider unavailable', statusCode: 503);
    }
    final reply = MessageItem(
      id: 'reply-$sends',
      role: 'assistant',
      content: 'Test-only assistant response.',
      createdAt: timestamp,
    );
    messageItems.add(
      MessageItem(
        id: 'user-$sends',
        role: 'user',
        content: message,
        createdAt: timestamp,
      ),
    );
    messageItems.add(reply);
    return ChatResult(conversationId: 'conversation', reply: reply);
  }
}
