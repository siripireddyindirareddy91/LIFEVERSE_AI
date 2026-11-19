import 'package:freezed_annotation/freezed_annotation.dart';
part 'life_models.freezed.dart';
part 'life_models.g.dart';

@freezed
abstract class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String userId,
    required String displayName,
    @Default('en') String locale,
    @Default('UTC') String timezone,
    @Default(false) bool aiConsent,
    @Default(false) bool memoryConsent,
  }) = _ProfileData;
  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
}

@freezed
abstract class TaskItem with _$TaskItem {
  const factory TaskItem({
    required String id,
    required String title,
    @Default('') String notes,
    @Default('todo') String status,
    @Default('normal') String priority,
    DateTime? dueAt,
    DateTime? completedAt,
    String? goalId,
    required DateTime createdAt,
  }) = _TaskItem;
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);
}

@freezed
abstract class GoalItem with _$GoalItem {
  const factory GoalItem({
    required String id,
    required String title,
    @Default('') String notes,
    @Default(0) int progress,
    String? targetDate,
    required DateTime createdAt,
  }) = _GoalItem;
  factory GoalItem.fromJson(Map<String, dynamic> json) =>
      _$GoalItemFromJson(json);
}

@freezed
abstract class HabitItem with _$HabitItem {
  const factory HabitItem({
    required String id,
    required String title,
    @Default('') String notes,
    @Default(true) bool active,
    required bool checkedToday,
    required int currentStreak,
    required String today,
    required DateTime createdAt,
  }) = _HabitItem;
  factory HabitItem.fromJson(Map<String, dynamic> json) =>
      _$HabitItemFromJson(json);
}

@freezed
abstract class MemoryItem with _$MemoryItem {
  const factory MemoryItem({
    required String id,
    required String title,
    required String content,
    @Default(false) bool allowAi,
    DateTime? expiresAt,
    required DateTime createdAt,
  }) = _MemoryItem;
  factory MemoryItem.fromJson(Map<String, dynamic> json) =>
      _$MemoryItemFromJson(json);
}

@freezed
abstract class CalendarItem with _$CalendarItem {
  const factory CalendarItem({
    required String id,
    required String title,
    @Default('') String notes,
    required DateTime startsAt,
    required DateTime endsAt,
    required DateTime createdAt,
  }) = _CalendarItem;
  factory CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);
}

@freezed
abstract class ActivityDay with _$ActivityDay {
  const factory ActivityDay({
    required String day,
    required int tasksCompleted,
    required int habitCheckins,
  }) = _ActivityDay;
  factory ActivityDay.fromJson(Map<String, dynamic> json) =>
      _$ActivityDayFromJson(json);
}

@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    required String timezone,
    required String today,
    required int tasksOpen,
    required int tasksCompleted,
    required int tasksDueToday,
    required int tasksOverdue,
    required int goalsActive,
    required int goalsCompleted,
    required int habitCount,
    required int habitsCompletedToday,
    required int memoriesActive,
    required List<ActivityDay> weeklyActivity,
  }) = _DashboardData;
  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
abstract class ConversationItem with _$ConversationItem {
  const factory ConversationItem({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _ConversationItem;
  factory ConversationItem.fromJson(Map<String, dynamic> json) =>
      _$ConversationItemFromJson(json);
}

@freezed
abstract class MessageItem with _$MessageItem {
  const factory MessageItem({
    required String id,
    required String role,
    required String content,
    required DateTime createdAt,
    @Default(0) int memoryCount,
    @Default(0) int planCount,
    @Default('') String model,
  }) = _MessageItem;
  factory MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);
}

@freezed
abstract class ChatResult with _$ChatResult {
  const factory ChatResult({
    required String conversationId,
    required MessageItem reply,
    @Default(false) bool cached,
  }) = _ChatResult;
  factory ChatResult.fromJson(Map<String, dynamic> json) =>
      _$ChatResultFromJson(json);
}

@freezed
abstract class AssistantStatus with _$AssistantStatus {
  const factory AssistantStatus({
    required bool configured,
    required bool consentRequired,
    required int retentionDays,
    required int dailyLimit,
  }) = _AssistantStatus;
  factory AssistantStatus.fromJson(Map<String, dynamic> json) =>
      _$AssistantStatusFromJson(json);
}

@freezed
abstract class LifeQuery with _$LifeQuery {
  const factory LifeQuery({
    @Default(0) int offset,
    @Default('') String search,
    String? status,
    String? goalId,
    DateTime? startsAfter,
    DateTime? endsBefore,
  }) = _LifeQuery;
}

class DataPage<T> {
  DataPage({
    required Iterable<T> items,
    required this.total,
    required this.offset,
    required this.limit,
  }) : items = List.unmodifiable(items);
  final List<T> items;
  final int total;
  final int offset;
  final int limit;
  bool get hasNext => offset + items.length < total;
  factory DataPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) decode,
  ) => DataPage(
    items: (json['items'] as List).map(
      (item) => decode(Map<String, dynamic>.from(item as Map)),
    ),
    total: json['total'] as int,
    offset: json['offset'] as int,
    limit: json['limit'] as int,
  );
}
