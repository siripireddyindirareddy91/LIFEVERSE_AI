// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => _ProfileData(
  userId: json['user_id'] as String,
  displayName: json['display_name'] as String,
  locale: json['locale'] as String? ?? 'en',
  timezone: json['timezone'] as String? ?? 'UTC',
  aiConsent: json['ai_consent'] as bool? ?? false,
  memoryConsent: json['memory_consent'] as bool? ?? false,
  knowledgeConsent: json['knowledge_consent'] as bool? ?? false,
);

Map<String, dynamic> _$ProfileDataToJson(_ProfileData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'display_name': instance.displayName,
      'locale': instance.locale,
      'timezone': instance.timezone,
      'ai_consent': instance.aiConsent,
      'memory_consent': instance.memoryConsent,
      'knowledge_consent': instance.knowledgeConsent,
    };

_TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => _TaskItem(
  id: json['id'] as String,
  title: json['title'] as String,
  notes: json['notes'] as String? ?? '',
  status: json['status'] as String? ?? 'todo',
  priority: json['priority'] as String? ?? 'normal',
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  goalId: json['goal_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$TaskItemToJson(_TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'notes': instance.notes,
  'status': instance.status,
  'priority': instance.priority,
  'due_at': instance.dueAt?.toIso8601String(),
  'completed_at': instance.completedAt?.toIso8601String(),
  'goal_id': instance.goalId,
  'created_at': instance.createdAt.toIso8601String(),
};

_GoalItem _$GoalItemFromJson(Map<String, dynamic> json) => _GoalItem(
  id: json['id'] as String,
  title: json['title'] as String,
  notes: json['notes'] as String? ?? '',
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  targetDate: json['target_date'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$GoalItemToJson(_GoalItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'notes': instance.notes,
  'progress': instance.progress,
  'target_date': instance.targetDate,
  'created_at': instance.createdAt.toIso8601String(),
};

_HabitItem _$HabitItemFromJson(Map<String, dynamic> json) => _HabitItem(
  id: json['id'] as String,
  title: json['title'] as String,
  notes: json['notes'] as String? ?? '',
  active: json['active'] as bool? ?? true,
  checkedToday: json['checked_today'] as bool,
  currentStreak: (json['current_streak'] as num).toInt(),
  today: json['today'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$HabitItemToJson(_HabitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'notes': instance.notes,
      'active': instance.active,
      'checked_today': instance.checkedToday,
      'current_streak': instance.currentStreak,
      'today': instance.today,
      'created_at': instance.createdAt.toIso8601String(),
    };

_MemoryItem _$MemoryItemFromJson(Map<String, dynamic> json) => _MemoryItem(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  allowAi: json['allow_ai'] as bool? ?? false,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MemoryItemToJson(_MemoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'allow_ai': instance.allowAi,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_CalendarItem _$CalendarItemFromJson(Map<String, dynamic> json) =>
    _CalendarItem(
      id: json['id'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String? ?? '',
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CalendarItemToJson(_CalendarItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'notes': instance.notes,
      'starts_at': instance.startsAt.toIso8601String(),
      'ends_at': instance.endsAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_ActivityDay _$ActivityDayFromJson(Map<String, dynamic> json) => _ActivityDay(
  day: json['day'] as String,
  tasksCompleted: (json['tasks_completed'] as num).toInt(),
  habitCheckins: (json['habit_checkins'] as num).toInt(),
);

Map<String, dynamic> _$ActivityDayToJson(_ActivityDay instance) =>
    <String, dynamic>{
      'day': instance.day,
      'tasks_completed': instance.tasksCompleted,
      'habit_checkins': instance.habitCheckins,
    };

_DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    _DashboardData(
      timezone: json['timezone'] as String,
      today: json['today'] as String,
      tasksOpen: (json['tasks_open'] as num).toInt(),
      tasksCompleted: (json['tasks_completed'] as num).toInt(),
      tasksDueToday: (json['tasks_due_today'] as num).toInt(),
      tasksOverdue: (json['tasks_overdue'] as num).toInt(),
      goalsActive: (json['goals_active'] as num).toInt(),
      goalsCompleted: (json['goals_completed'] as num).toInt(),
      habitCount: (json['habit_count'] as num).toInt(),
      habitsCompletedToday: (json['habits_completed_today'] as num).toInt(),
      memoriesActive: (json['memories_active'] as num).toInt(),
      weeklyActivity: (json['weekly_activity'] as List<dynamic>)
          .map((e) => ActivityDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardDataToJson(_DashboardData instance) =>
    <String, dynamic>{
      'timezone': instance.timezone,
      'today': instance.today,
      'tasks_open': instance.tasksOpen,
      'tasks_completed': instance.tasksCompleted,
      'tasks_due_today': instance.tasksDueToday,
      'tasks_overdue': instance.tasksOverdue,
      'goals_active': instance.goalsActive,
      'goals_completed': instance.goalsCompleted,
      'habit_count': instance.habitCount,
      'habits_completed_today': instance.habitsCompletedToday,
      'memories_active': instance.memoriesActive,
      'weekly_activity': instance.weeklyActivity,
    };

_ConversationItem _$ConversationItemFromJson(Map<String, dynamic> json) =>
    _ConversationItem(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$ConversationItemToJson(_ConversationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_MessageItem _$MessageItemFromJson(Map<String, dynamic> json) => _MessageItem(
  id: json['id'] as String,
  role: json['role'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  memoryCount: (json['memory_count'] as num?)?.toInt() ?? 0,
  planCount: (json['plan_count'] as num?)?.toInt() ?? 0,
  model: json['model'] as String? ?? '',
);

Map<String, dynamic> _$MessageItemToJson(_MessageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'memory_count': instance.memoryCount,
      'plan_count': instance.planCount,
      'model': instance.model,
    };

_ChatResult _$ChatResultFromJson(Map<String, dynamic> json) => _ChatResult(
  conversationId: json['conversation_id'] as String,
  reply: MessageItem.fromJson(json['reply'] as Map<String, dynamic>),
  cached: json['cached'] as bool? ?? false,
);

Map<String, dynamic> _$ChatResultToJson(_ChatResult instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'reply': instance.reply,
      'cached': instance.cached,
    };

_AssistantStatus _$AssistantStatusFromJson(Map<String, dynamic> json) =>
    _AssistantStatus(
      configured: json['configured'] as bool,
      consentRequired: json['consent_required'] as bool,
      retentionDays: (json['retention_days'] as num).toInt(),
      dailyLimit: (json['daily_limit'] as num).toInt(),
    );

Map<String, dynamic> _$AssistantStatusToJson(_AssistantStatus instance) =>
    <String, dynamic>{
      'configured': instance.configured,
      'consent_required': instance.consentRequired,
      'retention_days': instance.retentionDays,
      'daily_limit': instance.dailyLimit,
    };
