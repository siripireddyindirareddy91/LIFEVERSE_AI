import 'package:freezed_annotation/freezed_annotation.dart';
part 'agent_models.freezed.dart';
part 'agent_models.g.dart';

@freezed
abstract class AgentStatus with _$AgentStatus {
  const factory AgentStatus({
    required bool configured,
    required bool consentRequired,
    required bool workerOnline,
    required bool embeddingsConfigured,
    required int dailyLimit,
    required int historyDays,
    required int maxModelCalls,
    required int maxToolCalls,
  }) = _AgentStatus;
  factory AgentStatus.fromJson(Map<String, dynamic> json) =>
      _$AgentStatusFromJson(json);
}

@freezed
abstract class AgentRun with _$AgentRun {
  const AgentRun._();
  const factory AgentRun({
    required String id,
    required String prompt,
    required String status,
    @Default('') String summary,
    @Default('') String error,
    @Default('') String plan,
    @Default([]) List<String> scopes,
    @Default([]) List<String> agents,
    @Default(false) bool allowProposals,
    @Default(0) int modelCalls,
    @Default(0) int toolCalls,
    String? approvalDigest,
    String? reviewNonce,
    DateTime? reviewExpiresAt,
    required DateTime createdAt,
    required DateTime expiresAt,
    @Default([]) List<AgentSource> sources,
    @Default([]) List<AgentAction> actions,
    @Default([]) List<AgentStep> steps,
  }) = _AgentRun;
  bool get active => status == 'queued' || status == 'running';
  bool get reviewable => status == 'awaiting_approval';
  factory AgentRun.fromJson(Map<String, dynamic> json) =>
      _$AgentRunFromJson(json);
}

@freezed
abstract class AgentSource with _$AgentSource {
  const factory AgentSource({
    required String label,
    required String kind,
    required String sourceId,
    required String title,
    required String excerpt,
    required String mode,
  }) = _AgentSource;
  factory AgentSource.fromJson(Map<String, dynamic> json) =>
      _$AgentSourceFromJson(json);
}

@freezed
abstract class PreviewField with _$PreviewField {
  const factory PreviewField({
    required String name,
    String? before,
    required String after,
  }) = _PreviewField;
  factory PreviewField.fromJson(Map<String, dynamic> json) =>
      _$PreviewFieldFromJson(json);
}

@freezed
abstract class AgentAction with _$AgentAction {
  const factory AgentAction({
    required String id,
    required String label,
    required String agent,
    required String tool,
    required String status,
    required int position,
    required String recordId,
    @Default([]) List<String> dependencies,
    @Default([]) List<PreviewField> preview,
    Map<String, dynamic>? result,
  }) = _AgentAction;
  factory AgentAction.fromJson(Map<String, dynamic> json) =>
      _$AgentActionFromJson(json);
}

@freezed
abstract class AgentStep with _$AgentStep {
  const factory AgentStep({
    required String id,
    required int sequence,
    required String kind,
    required String agent,
    required String status,
    required String summary,
    required DateTime createdAt,
    String? tool,
    @Default({}) Map<String, dynamic> details,
  }) = _AgentStep;
  factory AgentStep.fromJson(Map<String, dynamic> json) =>
      _$AgentStepFromJson(json);
}

@freezed
abstract class KnowledgeItem with _$KnowledgeItem {
  const factory KnowledgeItem({
    required String id,
    required String title,
    required String content,
    required bool allowAi,
    DateTime? expiresAt,
    required DateTime createdAt,
    required int chunkCount,
    required int indexedChunks,
  }) = _KnowledgeItem;
  factory KnowledgeItem.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeItemFromJson(json);
}
