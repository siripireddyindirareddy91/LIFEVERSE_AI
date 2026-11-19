// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentStatus {
  bool get configured;
  bool get consentRequired;
  bool get workerOnline;
  bool get embeddingsConfigured;
  int get dailyLimit;
  int get historyDays;
  int get maxModelCalls;
  int get maxToolCalls;

  /// Create a copy of AgentStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentStatusCopyWith<AgentStatus> get copyWith =>
      _$AgentStatusCopyWithImpl<AgentStatus>(this as AgentStatus, _$identity);

  /// Serializes this AgentStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.consentRequired, consentRequired) ||
                other.consentRequired == consentRequired) &&
            (identical(other.workerOnline, workerOnline) ||
                other.workerOnline == workerOnline) &&
            (identical(other.embeddingsConfigured, embeddingsConfigured) ||
                other.embeddingsConfigured == embeddingsConfigured) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit) &&
            (identical(other.historyDays, historyDays) ||
                other.historyDays == historyDays) &&
            (identical(other.maxModelCalls, maxModelCalls) ||
                other.maxModelCalls == maxModelCalls) &&
            (identical(other.maxToolCalls, maxToolCalls) ||
                other.maxToolCalls == maxToolCalls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    consentRequired,
    workerOnline,
    embeddingsConfigured,
    dailyLimit,
    historyDays,
    maxModelCalls,
    maxToolCalls,
  );

  @override
  String toString() {
    return 'AgentStatus(configured: $configured, consentRequired: $consentRequired, workerOnline: $workerOnline, embeddingsConfigured: $embeddingsConfigured, dailyLimit: $dailyLimit, historyDays: $historyDays, maxModelCalls: $maxModelCalls, maxToolCalls: $maxToolCalls)';
  }
}

/// @nodoc
abstract mixin class $AgentStatusCopyWith<$Res> {
  factory $AgentStatusCopyWith(
    AgentStatus value,
    $Res Function(AgentStatus) _then,
  ) = _$AgentStatusCopyWithImpl;
  @useResult
  $Res call({
    bool configured,
    bool consentRequired,
    bool workerOnline,
    bool embeddingsConfigured,
    int dailyLimit,
    int historyDays,
    int maxModelCalls,
    int maxToolCalls,
  });
}

/// @nodoc
class _$AgentStatusCopyWithImpl<$Res> implements $AgentStatusCopyWith<$Res> {
  _$AgentStatusCopyWithImpl(this._self, this._then);

  final AgentStatus _self;
  final $Res Function(AgentStatus) _then;

  /// Create a copy of AgentStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configured = null,
    Object? consentRequired = null,
    Object? workerOnline = null,
    Object? embeddingsConfigured = null,
    Object? dailyLimit = null,
    Object? historyDays = null,
    Object? maxModelCalls = null,
    Object? maxToolCalls = null,
  }) {
    return _then(
      _self.copyWith(
        configured: null == configured
            ? _self.configured
            : configured // ignore: cast_nullable_to_non_nullable
                  as bool,
        consentRequired: null == consentRequired
            ? _self.consentRequired
            : consentRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        workerOnline: null == workerOnline
            ? _self.workerOnline
            : workerOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        embeddingsConfigured: null == embeddingsConfigured
            ? _self.embeddingsConfigured
            : embeddingsConfigured // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyLimit: null == dailyLimit
            ? _self.dailyLimit
            : dailyLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        historyDays: null == historyDays
            ? _self.historyDays
            : historyDays // ignore: cast_nullable_to_non_nullable
                  as int,
        maxModelCalls: null == maxModelCalls
            ? _self.maxModelCalls
            : maxModelCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        maxToolCalls: null == maxToolCalls
            ? _self.maxToolCalls
            : maxToolCalls // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AgentStatus].
extension AgentStatusPatterns on AgentStatus {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AgentStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentStatus() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AgentStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStatus():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AgentStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStatus() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      bool configured,
      bool consentRequired,
      bool workerOnline,
      bool embeddingsConfigured,
      int dailyLimit,
      int historyDays,
      int maxModelCalls,
      int maxToolCalls,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentStatus() when $default != null:
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.workerOnline,
          _that.embeddingsConfigured,
          _that.dailyLimit,
          _that.historyDays,
          _that.maxModelCalls,
          _that.maxToolCalls,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      bool configured,
      bool consentRequired,
      bool workerOnline,
      bool embeddingsConfigured,
      int dailyLimit,
      int historyDays,
      int maxModelCalls,
      int maxToolCalls,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStatus():
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.workerOnline,
          _that.embeddingsConfigured,
          _that.dailyLimit,
          _that.historyDays,
          _that.maxModelCalls,
          _that.maxToolCalls,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      bool configured,
      bool consentRequired,
      bool workerOnline,
      bool embeddingsConfigured,
      int dailyLimit,
      int historyDays,
      int maxModelCalls,
      int maxToolCalls,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStatus() when $default != null:
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.workerOnline,
          _that.embeddingsConfigured,
          _that.dailyLimit,
          _that.historyDays,
          _that.maxModelCalls,
          _that.maxToolCalls,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgentStatus implements AgentStatus {
  const _AgentStatus({
    required this.configured,
    required this.consentRequired,
    required this.workerOnline,
    required this.embeddingsConfigured,
    required this.dailyLimit,
    required this.historyDays,
    required this.maxModelCalls,
    required this.maxToolCalls,
  });
  factory _AgentStatus.fromJson(Map<String, dynamic> json) =>
      _$AgentStatusFromJson(json);

  @override
  final bool configured;
  @override
  final bool consentRequired;
  @override
  final bool workerOnline;
  @override
  final bool embeddingsConfigured;
  @override
  final int dailyLimit;
  @override
  final int historyDays;
  @override
  final int maxModelCalls;
  @override
  final int maxToolCalls;

  /// Create a copy of AgentStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentStatusCopyWith<_AgentStatus> get copyWith =>
      __$AgentStatusCopyWithImpl<_AgentStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgentStatusToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.consentRequired, consentRequired) ||
                other.consentRequired == consentRequired) &&
            (identical(other.workerOnline, workerOnline) ||
                other.workerOnline == workerOnline) &&
            (identical(other.embeddingsConfigured, embeddingsConfigured) ||
                other.embeddingsConfigured == embeddingsConfigured) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit) &&
            (identical(other.historyDays, historyDays) ||
                other.historyDays == historyDays) &&
            (identical(other.maxModelCalls, maxModelCalls) ||
                other.maxModelCalls == maxModelCalls) &&
            (identical(other.maxToolCalls, maxToolCalls) ||
                other.maxToolCalls == maxToolCalls));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    consentRequired,
    workerOnline,
    embeddingsConfigured,
    dailyLimit,
    historyDays,
    maxModelCalls,
    maxToolCalls,
  );

  @override
  String toString() {
    return 'AgentStatus(configured: $configured, consentRequired: $consentRequired, workerOnline: $workerOnline, embeddingsConfigured: $embeddingsConfigured, dailyLimit: $dailyLimit, historyDays: $historyDays, maxModelCalls: $maxModelCalls, maxToolCalls: $maxToolCalls)';
  }
}

/// @nodoc
abstract mixin class _$AgentStatusCopyWith<$Res>
    implements $AgentStatusCopyWith<$Res> {
  factory _$AgentStatusCopyWith(
    _AgentStatus value,
    $Res Function(_AgentStatus) _then,
  ) = __$AgentStatusCopyWithImpl;
  @override
  @useResult
  $Res call({
    bool configured,
    bool consentRequired,
    bool workerOnline,
    bool embeddingsConfigured,
    int dailyLimit,
    int historyDays,
    int maxModelCalls,
    int maxToolCalls,
  });
}

/// @nodoc
class __$AgentStatusCopyWithImpl<$Res> implements _$AgentStatusCopyWith<$Res> {
  __$AgentStatusCopyWithImpl(this._self, this._then);

  final _AgentStatus _self;
  final $Res Function(_AgentStatus) _then;

  /// Create a copy of AgentStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? configured = null,
    Object? consentRequired = null,
    Object? workerOnline = null,
    Object? embeddingsConfigured = null,
    Object? dailyLimit = null,
    Object? historyDays = null,
    Object? maxModelCalls = null,
    Object? maxToolCalls = null,
  }) {
    return _then(
      _AgentStatus(
        configured: null == configured
            ? _self.configured
            : configured // ignore: cast_nullable_to_non_nullable
                  as bool,
        consentRequired: null == consentRequired
            ? _self.consentRequired
            : consentRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        workerOnline: null == workerOnline
            ? _self.workerOnline
            : workerOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        embeddingsConfigured: null == embeddingsConfigured
            ? _self.embeddingsConfigured
            : embeddingsConfigured // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyLimit: null == dailyLimit
            ? _self.dailyLimit
            : dailyLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        historyDays: null == historyDays
            ? _self.historyDays
            : historyDays // ignore: cast_nullable_to_non_nullable
                  as int,
        maxModelCalls: null == maxModelCalls
            ? _self.maxModelCalls
            : maxModelCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        maxToolCalls: null == maxToolCalls
            ? _self.maxToolCalls
            : maxToolCalls // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$AgentRun {
  String get id;
  String get prompt;
  String get status;
  String get summary;
  String get error;
  String get plan;
  List<String> get scopes;
  List<String> get agents;
  bool get allowProposals;
  int get modelCalls;
  int get toolCalls;
  String? get approvalDigest;
  String? get reviewNonce;
  DateTime? get reviewExpiresAt;
  DateTime get createdAt;
  DateTime get expiresAt;
  List<AgentSource> get sources;
  List<AgentAction> get actions;
  List<AgentStep> get steps;

  /// Create a copy of AgentRun
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentRunCopyWith<AgentRun> get copyWith =>
      _$AgentRunCopyWithImpl<AgentRun>(this as AgentRun, _$identity);

  /// Serializes this AgentRun to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentRun &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            const DeepCollectionEquality().equals(other.scopes, scopes) &&
            const DeepCollectionEquality().equals(other.agents, agents) &&
            (identical(other.allowProposals, allowProposals) ||
                other.allowProposals == allowProposals) &&
            (identical(other.modelCalls, modelCalls) ||
                other.modelCalls == modelCalls) &&
            (identical(other.toolCalls, toolCalls) ||
                other.toolCalls == toolCalls) &&
            (identical(other.approvalDigest, approvalDigest) ||
                other.approvalDigest == approvalDigest) &&
            (identical(other.reviewNonce, reviewNonce) ||
                other.reviewNonce == reviewNonce) &&
            (identical(other.reviewExpiresAt, reviewExpiresAt) ||
                other.reviewExpiresAt == reviewExpiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other.sources, sources) &&
            const DeepCollectionEquality().equals(other.actions, actions) &&
            const DeepCollectionEquality().equals(other.steps, steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    prompt,
    status,
    summary,
    error,
    plan,
    const DeepCollectionEquality().hash(scopes),
    const DeepCollectionEquality().hash(agents),
    allowProposals,
    modelCalls,
    toolCalls,
    approvalDigest,
    reviewNonce,
    reviewExpiresAt,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(sources),
    const DeepCollectionEquality().hash(actions),
    const DeepCollectionEquality().hash(steps),
  ]);

  @override
  String toString() {
    return 'AgentRun(id: $id, prompt: $prompt, status: $status, summary: $summary, error: $error, plan: $plan, scopes: $scopes, agents: $agents, allowProposals: $allowProposals, modelCalls: $modelCalls, toolCalls: $toolCalls, approvalDigest: $approvalDigest, reviewNonce: $reviewNonce, reviewExpiresAt: $reviewExpiresAt, createdAt: $createdAt, expiresAt: $expiresAt, sources: $sources, actions: $actions, steps: $steps)';
  }
}

/// @nodoc
abstract mixin class $AgentRunCopyWith<$Res> {
  factory $AgentRunCopyWith(AgentRun value, $Res Function(AgentRun) _then) =
      _$AgentRunCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String prompt,
    String status,
    String summary,
    String error,
    String plan,
    List<String> scopes,
    List<String> agents,
    bool allowProposals,
    int modelCalls,
    int toolCalls,
    String? approvalDigest,
    String? reviewNonce,
    DateTime? reviewExpiresAt,
    DateTime createdAt,
    DateTime expiresAt,
    List<AgentSource> sources,
    List<AgentAction> actions,
    List<AgentStep> steps,
  });
}

/// @nodoc
class _$AgentRunCopyWithImpl<$Res> implements $AgentRunCopyWith<$Res> {
  _$AgentRunCopyWithImpl(this._self, this._then);

  final AgentRun _self;
  final $Res Function(AgentRun) _then;

  /// Create a copy of AgentRun
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? prompt = null,
    Object? status = null,
    Object? summary = null,
    Object? error = null,
    Object? plan = null,
    Object? scopes = null,
    Object? agents = null,
    Object? allowProposals = null,
    Object? modelCalls = null,
    Object? toolCalls = null,
    Object? approvalDigest = freezed,
    Object? reviewNonce = freezed,
    Object? reviewExpiresAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? sources = null,
    Object? actions = null,
    Object? steps = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        prompt: null == prompt
            ? _self.prompt
            : prompt // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        plan: null == plan
            ? _self.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as String,
        scopes: null == scopes
            ? _self.scopes
            : scopes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        agents: null == agents
            ? _self.agents
            : agents // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        allowProposals: null == allowProposals
            ? _self.allowProposals
            : allowProposals // ignore: cast_nullable_to_non_nullable
                  as bool,
        modelCalls: null == modelCalls
            ? _self.modelCalls
            : modelCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        toolCalls: null == toolCalls
            ? _self.toolCalls
            : toolCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        approvalDigest: freezed == approvalDigest
            ? _self.approvalDigest
            : approvalDigest // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewNonce: freezed == reviewNonce
            ? _self.reviewNonce
            : reviewNonce // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewExpiresAt: freezed == reviewExpiresAt
            ? _self.reviewExpiresAt
            : reviewExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sources: null == sources
            ? _self.sources
            : sources // ignore: cast_nullable_to_non_nullable
                  as List<AgentSource>,
        actions: null == actions
            ? _self.actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<AgentAction>,
        steps: null == steps
            ? _self.steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<AgentStep>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AgentRun].
extension AgentRunPatterns on AgentRun {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AgentRun value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentRun() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AgentRun value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentRun():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AgentRun value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentRun() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String prompt,
      String status,
      String summary,
      String error,
      String plan,
      List<String> scopes,
      List<String> agents,
      bool allowProposals,
      int modelCalls,
      int toolCalls,
      String? approvalDigest,
      String? reviewNonce,
      DateTime? reviewExpiresAt,
      DateTime createdAt,
      DateTime expiresAt,
      List<AgentSource> sources,
      List<AgentAction> actions,
      List<AgentStep> steps,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentRun() when $default != null:
        return $default(
          _that.id,
          _that.prompt,
          _that.status,
          _that.summary,
          _that.error,
          _that.plan,
          _that.scopes,
          _that.agents,
          _that.allowProposals,
          _that.modelCalls,
          _that.toolCalls,
          _that.approvalDigest,
          _that.reviewNonce,
          _that.reviewExpiresAt,
          _that.createdAt,
          _that.expiresAt,
          _that.sources,
          _that.actions,
          _that.steps,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String prompt,
      String status,
      String summary,
      String error,
      String plan,
      List<String> scopes,
      List<String> agents,
      bool allowProposals,
      int modelCalls,
      int toolCalls,
      String? approvalDigest,
      String? reviewNonce,
      DateTime? reviewExpiresAt,
      DateTime createdAt,
      DateTime expiresAt,
      List<AgentSource> sources,
      List<AgentAction> actions,
      List<AgentStep> steps,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentRun():
        return $default(
          _that.id,
          _that.prompt,
          _that.status,
          _that.summary,
          _that.error,
          _that.plan,
          _that.scopes,
          _that.agents,
          _that.allowProposals,
          _that.modelCalls,
          _that.toolCalls,
          _that.approvalDigest,
          _that.reviewNonce,
          _that.reviewExpiresAt,
          _that.createdAt,
          _that.expiresAt,
          _that.sources,
          _that.actions,
          _that.steps,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String prompt,
      String status,
      String summary,
      String error,
      String plan,
      List<String> scopes,
      List<String> agents,
      bool allowProposals,
      int modelCalls,
      int toolCalls,
      String? approvalDigest,
      String? reviewNonce,
      DateTime? reviewExpiresAt,
      DateTime createdAt,
      DateTime expiresAt,
      List<AgentSource> sources,
      List<AgentAction> actions,
      List<AgentStep> steps,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentRun() when $default != null:
        return $default(
          _that.id,
          _that.prompt,
          _that.status,
          _that.summary,
          _that.error,
          _that.plan,
          _that.scopes,
          _that.agents,
          _that.allowProposals,
          _that.modelCalls,
          _that.toolCalls,
          _that.approvalDigest,
          _that.reviewNonce,
          _that.reviewExpiresAt,
          _that.createdAt,
          _that.expiresAt,
          _that.sources,
          _that.actions,
          _that.steps,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgentRun extends AgentRun {
  const _AgentRun({
    required this.id,
    required this.prompt,
    required this.status,
    this.summary = '',
    this.error = '',
    this.plan = '',
    final List<String> scopes = const [],
    final List<String> agents = const [],
    this.allowProposals = false,
    this.modelCalls = 0,
    this.toolCalls = 0,
    this.approvalDigest,
    this.reviewNonce,
    this.reviewExpiresAt,
    required this.createdAt,
    required this.expiresAt,
    final List<AgentSource> sources = const [],
    final List<AgentAction> actions = const [],
    final List<AgentStep> steps = const [],
  }) : _scopes = scopes,
       _agents = agents,
       _sources = sources,
       _actions = actions,
       _steps = steps,
       super._();
  factory _AgentRun.fromJson(Map<String, dynamic> json) =>
      _$AgentRunFromJson(json);

  @override
  final String id;
  @override
  final String prompt;
  @override
  final String status;
  @override
  @JsonKey()
  final String summary;
  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final String plan;
  final List<String> _scopes;
  @override
  @JsonKey()
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  final List<String> _agents;
  @override
  @JsonKey()
  List<String> get agents {
    if (_agents is EqualUnmodifiableListView) return _agents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agents);
  }

  @override
  @JsonKey()
  final bool allowProposals;
  @override
  @JsonKey()
  final int modelCalls;
  @override
  @JsonKey()
  final int toolCalls;
  @override
  final String? approvalDigest;
  @override
  final String? reviewNonce;
  @override
  final DateTime? reviewExpiresAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  final List<AgentSource> _sources;
  @override
  @JsonKey()
  List<AgentSource> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  final List<AgentAction> _actions;
  @override
  @JsonKey()
  List<AgentAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  final List<AgentStep> _steps;
  @override
  @JsonKey()
  List<AgentStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  /// Create a copy of AgentRun
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentRunCopyWith<_AgentRun> get copyWith =>
      __$AgentRunCopyWithImpl<_AgentRun>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgentRunToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentRun &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.plan, plan) || other.plan == plan) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes) &&
            const DeepCollectionEquality().equals(other._agents, _agents) &&
            (identical(other.allowProposals, allowProposals) ||
                other.allowProposals == allowProposals) &&
            (identical(other.modelCalls, modelCalls) ||
                other.modelCalls == modelCalls) &&
            (identical(other.toolCalls, toolCalls) ||
                other.toolCalls == toolCalls) &&
            (identical(other.approvalDigest, approvalDigest) ||
                other.approvalDigest == approvalDigest) &&
            (identical(other.reviewNonce, reviewNonce) ||
                other.reviewNonce == reviewNonce) &&
            (identical(other.reviewExpiresAt, reviewExpiresAt) ||
                other.reviewExpiresAt == reviewExpiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            const DeepCollectionEquality().equals(other._actions, _actions) &&
            const DeepCollectionEquality().equals(other._steps, _steps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    prompt,
    status,
    summary,
    error,
    plan,
    const DeepCollectionEquality().hash(_scopes),
    const DeepCollectionEquality().hash(_agents),
    allowProposals,
    modelCalls,
    toolCalls,
    approvalDigest,
    reviewNonce,
    reviewExpiresAt,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_sources),
    const DeepCollectionEquality().hash(_actions),
    const DeepCollectionEquality().hash(_steps),
  ]);

  @override
  String toString() {
    return 'AgentRun(id: $id, prompt: $prompt, status: $status, summary: $summary, error: $error, plan: $plan, scopes: $scopes, agents: $agents, allowProposals: $allowProposals, modelCalls: $modelCalls, toolCalls: $toolCalls, approvalDigest: $approvalDigest, reviewNonce: $reviewNonce, reviewExpiresAt: $reviewExpiresAt, createdAt: $createdAt, expiresAt: $expiresAt, sources: $sources, actions: $actions, steps: $steps)';
  }
}

/// @nodoc
abstract mixin class _$AgentRunCopyWith<$Res>
    implements $AgentRunCopyWith<$Res> {
  factory _$AgentRunCopyWith(_AgentRun value, $Res Function(_AgentRun) _then) =
      __$AgentRunCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String prompt,
    String status,
    String summary,
    String error,
    String plan,
    List<String> scopes,
    List<String> agents,
    bool allowProposals,
    int modelCalls,
    int toolCalls,
    String? approvalDigest,
    String? reviewNonce,
    DateTime? reviewExpiresAt,
    DateTime createdAt,
    DateTime expiresAt,
    List<AgentSource> sources,
    List<AgentAction> actions,
    List<AgentStep> steps,
  });
}

/// @nodoc
class __$AgentRunCopyWithImpl<$Res> implements _$AgentRunCopyWith<$Res> {
  __$AgentRunCopyWithImpl(this._self, this._then);

  final _AgentRun _self;
  final $Res Function(_AgentRun) _then;

  /// Create a copy of AgentRun
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? prompt = null,
    Object? status = null,
    Object? summary = null,
    Object? error = null,
    Object? plan = null,
    Object? scopes = null,
    Object? agents = null,
    Object? allowProposals = null,
    Object? modelCalls = null,
    Object? toolCalls = null,
    Object? approvalDigest = freezed,
    Object? reviewNonce = freezed,
    Object? reviewExpiresAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? sources = null,
    Object? actions = null,
    Object? steps = null,
  }) {
    return _then(
      _AgentRun(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        prompt: null == prompt
            ? _self.prompt
            : prompt // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        plan: null == plan
            ? _self.plan
            : plan // ignore: cast_nullable_to_non_nullable
                  as String,
        scopes: null == scopes
            ? _self._scopes
            : scopes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        agents: null == agents
            ? _self._agents
            : agents // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        allowProposals: null == allowProposals
            ? _self.allowProposals
            : allowProposals // ignore: cast_nullable_to_non_nullable
                  as bool,
        modelCalls: null == modelCalls
            ? _self.modelCalls
            : modelCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        toolCalls: null == toolCalls
            ? _self.toolCalls
            : toolCalls // ignore: cast_nullable_to_non_nullable
                  as int,
        approvalDigest: freezed == approvalDigest
            ? _self.approvalDigest
            : approvalDigest // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewNonce: freezed == reviewNonce
            ? _self.reviewNonce
            : reviewNonce // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewExpiresAt: freezed == reviewExpiresAt
            ? _self.reviewExpiresAt
            : reviewExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sources: null == sources
            ? _self._sources
            : sources // ignore: cast_nullable_to_non_nullable
                  as List<AgentSource>,
        actions: null == actions
            ? _self._actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<AgentAction>,
        steps: null == steps
            ? _self._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<AgentStep>,
      ),
    );
  }
}

/// @nodoc
mixin _$AgentSource {
  String get label;
  String get kind;
  String get sourceId;
  String get title;
  String get excerpt;
  String get mode;

  /// Create a copy of AgentSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentSourceCopyWith<AgentSource> get copyWith =>
      _$AgentSourceCopyWithImpl<AgentSource>(this as AgentSource, _$identity);

  /// Serializes this AgentSource to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentSource &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, kind, sourceId, title, excerpt, mode);

  @override
  String toString() {
    return 'AgentSource(label: $label, kind: $kind, sourceId: $sourceId, title: $title, excerpt: $excerpt, mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $AgentSourceCopyWith<$Res> {
  factory $AgentSourceCopyWith(
    AgentSource value,
    $Res Function(AgentSource) _then,
  ) = _$AgentSourceCopyWithImpl;
  @useResult
  $Res call({
    String label,
    String kind,
    String sourceId,
    String title,
    String excerpt,
    String mode,
  });
}

/// @nodoc
class _$AgentSourceCopyWithImpl<$Res> implements $AgentSourceCopyWith<$Res> {
  _$AgentSourceCopyWithImpl(this._self, this._then);

  final AgentSource _self;
  final $Res Function(AgentSource) _then;

  /// Create a copy of AgentSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? kind = null,
    Object? sourceId = null,
    Object? title = null,
    Object? excerpt = null,
    Object? mode = null,
  }) {
    return _then(
      _self.copyWith(
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _self.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        excerpt: null == excerpt
            ? _self.excerpt
            : excerpt // ignore: cast_nullable_to_non_nullable
                  as String,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AgentSource].
extension AgentSourcePatterns on AgentSource {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AgentSource value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentSource() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AgentSource value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentSource():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AgentSource value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentSource() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String label,
      String kind,
      String sourceId,
      String title,
      String excerpt,
      String mode,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentSource() when $default != null:
        return $default(
          _that.label,
          _that.kind,
          _that.sourceId,
          _that.title,
          _that.excerpt,
          _that.mode,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String label,
      String kind,
      String sourceId,
      String title,
      String excerpt,
      String mode,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentSource():
        return $default(
          _that.label,
          _that.kind,
          _that.sourceId,
          _that.title,
          _that.excerpt,
          _that.mode,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String label,
      String kind,
      String sourceId,
      String title,
      String excerpt,
      String mode,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentSource() when $default != null:
        return $default(
          _that.label,
          _that.kind,
          _that.sourceId,
          _that.title,
          _that.excerpt,
          _that.mode,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgentSource implements AgentSource {
  const _AgentSource({
    required this.label,
    required this.kind,
    required this.sourceId,
    required this.title,
    required this.excerpt,
    required this.mode,
  });
  factory _AgentSource.fromJson(Map<String, dynamic> json) =>
      _$AgentSourceFromJson(json);

  @override
  final String label;
  @override
  final String kind;
  @override
  final String sourceId;
  @override
  final String title;
  @override
  final String excerpt;
  @override
  final String mode;

  /// Create a copy of AgentSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentSourceCopyWith<_AgentSource> get copyWith =>
      __$AgentSourceCopyWithImpl<_AgentSource>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgentSourceToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentSource &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, kind, sourceId, title, excerpt, mode);

  @override
  String toString() {
    return 'AgentSource(label: $label, kind: $kind, sourceId: $sourceId, title: $title, excerpt: $excerpt, mode: $mode)';
  }
}

/// @nodoc
abstract mixin class _$AgentSourceCopyWith<$Res>
    implements $AgentSourceCopyWith<$Res> {
  factory _$AgentSourceCopyWith(
    _AgentSource value,
    $Res Function(_AgentSource) _then,
  ) = __$AgentSourceCopyWithImpl;
  @override
  @useResult
  $Res call({
    String label,
    String kind,
    String sourceId,
    String title,
    String excerpt,
    String mode,
  });
}

/// @nodoc
class __$AgentSourceCopyWithImpl<$Res> implements _$AgentSourceCopyWith<$Res> {
  __$AgentSourceCopyWithImpl(this._self, this._then);

  final _AgentSource _self;
  final $Res Function(_AgentSource) _then;

  /// Create a copy of AgentSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? kind = null,
    Object? sourceId = null,
    Object? title = null,
    Object? excerpt = null,
    Object? mode = null,
  }) {
    return _then(
      _AgentSource(
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _self.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        excerpt: null == excerpt
            ? _self.excerpt
            : excerpt // ignore: cast_nullable_to_non_nullable
                  as String,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PreviewField {
  String get name;
  String? get before;
  String get after;

  /// Create a copy of PreviewField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PreviewFieldCopyWith<PreviewField> get copyWith =>
      _$PreviewFieldCopyWithImpl<PreviewField>(
        this as PreviewField,
        _$identity,
      );

  /// Serializes this PreviewField to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PreviewField &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.before, before) || other.before == before) &&
            (identical(other.after, after) || other.after == after));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, before, after);

  @override
  String toString() {
    return 'PreviewField(name: $name, before: $before, after: $after)';
  }
}

/// @nodoc
abstract mixin class $PreviewFieldCopyWith<$Res> {
  factory $PreviewFieldCopyWith(
    PreviewField value,
    $Res Function(PreviewField) _then,
  ) = _$PreviewFieldCopyWithImpl;
  @useResult
  $Res call({String name, String? before, String after});
}

/// @nodoc
class _$PreviewFieldCopyWithImpl<$Res> implements $PreviewFieldCopyWith<$Res> {
  _$PreviewFieldCopyWithImpl(this._self, this._then);

  final PreviewField _self;
  final $Res Function(PreviewField) _then;

  /// Create a copy of PreviewField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? before = freezed,
    Object? after = null,
  }) {
    return _then(
      _self.copyWith(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        before: freezed == before
            ? _self.before
            : before // ignore: cast_nullable_to_non_nullable
                  as String?,
        after: null == after
            ? _self.after
            : after // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [PreviewField].
extension PreviewFieldPatterns on PreviewField {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PreviewField value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PreviewField() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PreviewField value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PreviewField():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PreviewField value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PreviewField() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, String? before, String after)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PreviewField() when $default != null:
        return $default(_that.name, _that.before, _that.after);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, String? before, String after) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PreviewField():
        return $default(_that.name, _that.before, _that.after);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, String? before, String after)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PreviewField() when $default != null:
        return $default(_that.name, _that.before, _that.after);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PreviewField implements PreviewField {
  const _PreviewField({required this.name, this.before, required this.after});
  factory _PreviewField.fromJson(Map<String, dynamic> json) =>
      _$PreviewFieldFromJson(json);

  @override
  final String name;
  @override
  final String? before;
  @override
  final String after;

  /// Create a copy of PreviewField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PreviewFieldCopyWith<_PreviewField> get copyWith =>
      __$PreviewFieldCopyWithImpl<_PreviewField>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PreviewFieldToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PreviewField &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.before, before) || other.before == before) &&
            (identical(other.after, after) || other.after == after));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, before, after);

  @override
  String toString() {
    return 'PreviewField(name: $name, before: $before, after: $after)';
  }
}

/// @nodoc
abstract mixin class _$PreviewFieldCopyWith<$Res>
    implements $PreviewFieldCopyWith<$Res> {
  factory _$PreviewFieldCopyWith(
    _PreviewField value,
    $Res Function(_PreviewField) _then,
  ) = __$PreviewFieldCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String? before, String after});
}

/// @nodoc
class __$PreviewFieldCopyWithImpl<$Res>
    implements _$PreviewFieldCopyWith<$Res> {
  __$PreviewFieldCopyWithImpl(this._self, this._then);

  final _PreviewField _self;
  final $Res Function(_PreviewField) _then;

  /// Create a copy of PreviewField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? before = freezed,
    Object? after = null,
  }) {
    return _then(
      _PreviewField(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        before: freezed == before
            ? _self.before
            : before // ignore: cast_nullable_to_non_nullable
                  as String?,
        after: null == after
            ? _self.after
            : after // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$AgentAction {
  String get id;
  String get label;
  String get agent;
  String get tool;
  String get status;
  int get position;
  String get recordId;
  List<String> get dependencies;
  List<PreviewField> get preview;
  Map<String, dynamic>? get result;

  /// Create a copy of AgentAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentActionCopyWith<AgentAction> get copyWith =>
      _$AgentActionCopyWithImpl<AgentAction>(this as AgentAction, _$identity);

  /// Serializes this AgentAction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentAction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            const DeepCollectionEquality().equals(
              other.dependencies,
              dependencies,
            ) &&
            const DeepCollectionEquality().equals(other.preview, preview) &&
            const DeepCollectionEquality().equals(other.result, result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    agent,
    tool,
    status,
    position,
    recordId,
    const DeepCollectionEquality().hash(dependencies),
    const DeepCollectionEquality().hash(preview),
    const DeepCollectionEquality().hash(result),
  );

  @override
  String toString() {
    return 'AgentAction(id: $id, label: $label, agent: $agent, tool: $tool, status: $status, position: $position, recordId: $recordId, dependencies: $dependencies, preview: $preview, result: $result)';
  }
}

/// @nodoc
abstract mixin class $AgentActionCopyWith<$Res> {
  factory $AgentActionCopyWith(
    AgentAction value,
    $Res Function(AgentAction) _then,
  ) = _$AgentActionCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String label,
    String agent,
    String tool,
    String status,
    int position,
    String recordId,
    List<String> dependencies,
    List<PreviewField> preview,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class _$AgentActionCopyWithImpl<$Res> implements $AgentActionCopyWith<$Res> {
  _$AgentActionCopyWithImpl(this._self, this._then);

  final AgentAction _self;
  final $Res Function(AgentAction) _then;

  /// Create a copy of AgentAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? agent = null,
    Object? tool = null,
    Object? status = null,
    Object? position = null,
    Object? recordId = null,
    Object? dependencies = null,
    Object? preview = null,
    Object? result = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        agent: null == agent
            ? _self.agent
            : agent // ignore: cast_nullable_to_non_nullable
                  as String,
        tool: null == tool
            ? _self.tool
            : tool // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _self.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        recordId: null == recordId
            ? _self.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        dependencies: null == dependencies
            ? _self.dependencies
            : dependencies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        preview: null == preview
            ? _self.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as List<PreviewField>,
        result: freezed == result
            ? _self.result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AgentAction].
extension AgentActionPatterns on AgentAction {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AgentAction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentAction() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AgentAction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentAction():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AgentAction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentAction() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String label,
      String agent,
      String tool,
      String status,
      int position,
      String recordId,
      List<String> dependencies,
      List<PreviewField> preview,
      Map<String, dynamic>? result,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentAction() when $default != null:
        return $default(
          _that.id,
          _that.label,
          _that.agent,
          _that.tool,
          _that.status,
          _that.position,
          _that.recordId,
          _that.dependencies,
          _that.preview,
          _that.result,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String label,
      String agent,
      String tool,
      String status,
      int position,
      String recordId,
      List<String> dependencies,
      List<PreviewField> preview,
      Map<String, dynamic>? result,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentAction():
        return $default(
          _that.id,
          _that.label,
          _that.agent,
          _that.tool,
          _that.status,
          _that.position,
          _that.recordId,
          _that.dependencies,
          _that.preview,
          _that.result,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String label,
      String agent,
      String tool,
      String status,
      int position,
      String recordId,
      List<String> dependencies,
      List<PreviewField> preview,
      Map<String, dynamic>? result,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentAction() when $default != null:
        return $default(
          _that.id,
          _that.label,
          _that.agent,
          _that.tool,
          _that.status,
          _that.position,
          _that.recordId,
          _that.dependencies,
          _that.preview,
          _that.result,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgentAction implements AgentAction {
  const _AgentAction({
    required this.id,
    required this.label,
    required this.agent,
    required this.tool,
    required this.status,
    required this.position,
    required this.recordId,
    final List<String> dependencies = const [],
    final List<PreviewField> preview = const [],
    final Map<String, dynamic>? result,
  }) : _dependencies = dependencies,
       _preview = preview,
       _result = result;
  factory _AgentAction.fromJson(Map<String, dynamic> json) =>
      _$AgentActionFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String agent;
  @override
  final String tool;
  @override
  final String status;
  @override
  final int position;
  @override
  final String recordId;
  final List<String> _dependencies;
  @override
  @JsonKey()
  List<String> get dependencies {
    if (_dependencies is EqualUnmodifiableListView) return _dependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependencies);
  }

  final List<PreviewField> _preview;
  @override
  @JsonKey()
  List<PreviewField> get preview {
    if (_preview is EqualUnmodifiableListView) return _preview;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_preview);
  }

  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of AgentAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentActionCopyWith<_AgentAction> get copyWith =>
      __$AgentActionCopyWithImpl<_AgentAction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgentActionToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentAction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            const DeepCollectionEquality().equals(
              other._dependencies,
              _dependencies,
            ) &&
            const DeepCollectionEquality().equals(other._preview, _preview) &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    agent,
    tool,
    status,
    position,
    recordId,
    const DeepCollectionEquality().hash(_dependencies),
    const DeepCollectionEquality().hash(_preview),
    const DeepCollectionEquality().hash(_result),
  );

  @override
  String toString() {
    return 'AgentAction(id: $id, label: $label, agent: $agent, tool: $tool, status: $status, position: $position, recordId: $recordId, dependencies: $dependencies, preview: $preview, result: $result)';
  }
}

/// @nodoc
abstract mixin class _$AgentActionCopyWith<$Res>
    implements $AgentActionCopyWith<$Res> {
  factory _$AgentActionCopyWith(
    _AgentAction value,
    $Res Function(_AgentAction) _then,
  ) = __$AgentActionCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    String agent,
    String tool,
    String status,
    int position,
    String recordId,
    List<String> dependencies,
    List<PreviewField> preview,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class __$AgentActionCopyWithImpl<$Res> implements _$AgentActionCopyWith<$Res> {
  __$AgentActionCopyWithImpl(this._self, this._then);

  final _AgentAction _self;
  final $Res Function(_AgentAction) _then;

  /// Create a copy of AgentAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? agent = null,
    Object? tool = null,
    Object? status = null,
    Object? position = null,
    Object? recordId = null,
    Object? dependencies = null,
    Object? preview = null,
    Object? result = freezed,
  }) {
    return _then(
      _AgentAction(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        agent: null == agent
            ? _self.agent
            : agent // ignore: cast_nullable_to_non_nullable
                  as String,
        tool: null == tool
            ? _self.tool
            : tool // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _self.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        recordId: null == recordId
            ? _self.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        dependencies: null == dependencies
            ? _self._dependencies
            : dependencies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        preview: null == preview
            ? _self._preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as List<PreviewField>,
        result: freezed == result
            ? _self._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
mixin _$AgentStep {
  String get id;
  int get sequence;
  String get kind;
  String get agent;
  String get status;
  String get summary;
  DateTime get createdAt;
  String? get tool;
  Map<String, dynamic> get details;

  /// Create a copy of AgentStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentStepCopyWith<AgentStep> get copyWith =>
      _$AgentStepCopyWithImpl<AgentStep>(this as AgentStep, _$identity);

  /// Serializes this AgentStep to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentStep &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            const DeepCollectionEquality().equals(other.details, details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sequence,
    kind,
    agent,
    status,
    summary,
    createdAt,
    tool,
    const DeepCollectionEquality().hash(details),
  );

  @override
  String toString() {
    return 'AgentStep(id: $id, sequence: $sequence, kind: $kind, agent: $agent, status: $status, summary: $summary, createdAt: $createdAt, tool: $tool, details: $details)';
  }
}

/// @nodoc
abstract mixin class $AgentStepCopyWith<$Res> {
  factory $AgentStepCopyWith(AgentStep value, $Res Function(AgentStep) _then) =
      _$AgentStepCopyWithImpl;
  @useResult
  $Res call({
    String id,
    int sequence,
    String kind,
    String agent,
    String status,
    String summary,
    DateTime createdAt,
    String? tool,
    Map<String, dynamic> details,
  });
}

/// @nodoc
class _$AgentStepCopyWithImpl<$Res> implements $AgentStepCopyWith<$Res> {
  _$AgentStepCopyWithImpl(this._self, this._then);

  final AgentStep _self;
  final $Res Function(AgentStep) _then;

  /// Create a copy of AgentStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sequence = null,
    Object? kind = null,
    Object? agent = null,
    Object? status = null,
    Object? summary = null,
    Object? createdAt = null,
    Object? tool = freezed,
    Object? details = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sequence: null == sequence
            ? _self.sequence
            : sequence // ignore: cast_nullable_to_non_nullable
                  as int,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        agent: null == agent
            ? _self.agent
            : agent // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tool: freezed == tool
            ? _self.tool
            : tool // ignore: cast_nullable_to_non_nullable
                  as String?,
        details: null == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AgentStep].
extension AgentStepPatterns on AgentStep {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AgentStep value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentStep() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AgentStep value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStep():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AgentStep value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStep() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      int sequence,
      String kind,
      String agent,
      String status,
      String summary,
      DateTime createdAt,
      String? tool,
      Map<String, dynamic> details,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentStep() when $default != null:
        return $default(
          _that.id,
          _that.sequence,
          _that.kind,
          _that.agent,
          _that.status,
          _that.summary,
          _that.createdAt,
          _that.tool,
          _that.details,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      int sequence,
      String kind,
      String agent,
      String status,
      String summary,
      DateTime createdAt,
      String? tool,
      Map<String, dynamic> details,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStep():
        return $default(
          _that.id,
          _that.sequence,
          _that.kind,
          _that.agent,
          _that.status,
          _that.summary,
          _that.createdAt,
          _that.tool,
          _that.details,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      int sequence,
      String kind,
      String agent,
      String status,
      String summary,
      DateTime createdAt,
      String? tool,
      Map<String, dynamic> details,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentStep() when $default != null:
        return $default(
          _that.id,
          _that.sequence,
          _that.kind,
          _that.agent,
          _that.status,
          _that.summary,
          _that.createdAt,
          _that.tool,
          _that.details,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgentStep implements AgentStep {
  const _AgentStep({
    required this.id,
    required this.sequence,
    required this.kind,
    required this.agent,
    required this.status,
    required this.summary,
    required this.createdAt,
    this.tool,
    final Map<String, dynamic> details = const {},
  }) : _details = details;
  factory _AgentStep.fromJson(Map<String, dynamic> json) =>
      _$AgentStepFromJson(json);

  @override
  final String id;
  @override
  final int sequence;
  @override
  final String kind;
  @override
  final String agent;
  @override
  final String status;
  @override
  final String summary;
  @override
  final DateTime createdAt;
  @override
  final String? tool;
  final Map<String, dynamic> _details;
  @override
  @JsonKey()
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  /// Create a copy of AgentStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentStepCopyWith<_AgentStep> get copyWith =>
      __$AgentStepCopyWithImpl<_AgentStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgentStepToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentStep &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sequence, sequence) ||
                other.sequence == sequence) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.tool, tool) || other.tool == tool) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sequence,
    kind,
    agent,
    status,
    summary,
    createdAt,
    tool,
    const DeepCollectionEquality().hash(_details),
  );

  @override
  String toString() {
    return 'AgentStep(id: $id, sequence: $sequence, kind: $kind, agent: $agent, status: $status, summary: $summary, createdAt: $createdAt, tool: $tool, details: $details)';
  }
}

/// @nodoc
abstract mixin class _$AgentStepCopyWith<$Res>
    implements $AgentStepCopyWith<$Res> {
  factory _$AgentStepCopyWith(
    _AgentStep value,
    $Res Function(_AgentStep) _then,
  ) = __$AgentStepCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    int sequence,
    String kind,
    String agent,
    String status,
    String summary,
    DateTime createdAt,
    String? tool,
    Map<String, dynamic> details,
  });
}

/// @nodoc
class __$AgentStepCopyWithImpl<$Res> implements _$AgentStepCopyWith<$Res> {
  __$AgentStepCopyWithImpl(this._self, this._then);

  final _AgentStep _self;
  final $Res Function(_AgentStep) _then;

  /// Create a copy of AgentStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sequence = null,
    Object? kind = null,
    Object? agent = null,
    Object? status = null,
    Object? summary = null,
    Object? createdAt = null,
    Object? tool = freezed,
    Object? details = null,
  }) {
    return _then(
      _AgentStep(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sequence: null == sequence
            ? _self.sequence
            : sequence // ignore: cast_nullable_to_non_nullable
                  as int,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        agent: null == agent
            ? _self.agent
            : agent // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tool: freezed == tool
            ? _self.tool
            : tool // ignore: cast_nullable_to_non_nullable
                  as String?,
        details: null == details
            ? _self._details
            : details // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
mixin _$KnowledgeItem {
  String get id;
  String get title;
  String get content;
  bool get allowAi;
  DateTime? get expiresAt;
  DateTime get createdAt;
  int get chunkCount;
  int get indexedChunks;

  /// Create a copy of KnowledgeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KnowledgeItemCopyWith<KnowledgeItem> get copyWith =>
      _$KnowledgeItemCopyWithImpl<KnowledgeItem>(
        this as KnowledgeItem,
        _$identity,
      );

  /// Serializes this KnowledgeItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KnowledgeItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.chunkCount, chunkCount) ||
                other.chunkCount == chunkCount) &&
            (identical(other.indexedChunks, indexedChunks) ||
                other.indexedChunks == indexedChunks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    allowAi,
    expiresAt,
    createdAt,
    chunkCount,
    indexedChunks,
  );

  @override
  String toString() {
    return 'KnowledgeItem(id: $id, title: $title, content: $content, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt, chunkCount: $chunkCount, indexedChunks: $indexedChunks)';
  }
}

/// @nodoc
abstract mixin class $KnowledgeItemCopyWith<$Res> {
  factory $KnowledgeItemCopyWith(
    KnowledgeItem value,
    $Res Function(KnowledgeItem) _then,
  ) = _$KnowledgeItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
    int chunkCount,
    int indexedChunks,
  });
}

/// @nodoc
class _$KnowledgeItemCopyWithImpl<$Res>
    implements $KnowledgeItemCopyWith<$Res> {
  _$KnowledgeItemCopyWithImpl(this._self, this._then);

  final KnowledgeItem _self;
  final $Res Function(KnowledgeItem) _then;

  /// Create a copy of KnowledgeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? allowAi = null,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? chunkCount = null,
    Object? indexedChunks = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _self.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        expiresAt: freezed == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        chunkCount: null == chunkCount
            ? _self.chunkCount
            : chunkCount // ignore: cast_nullable_to_non_nullable
                  as int,
        indexedChunks: null == indexedChunks
            ? _self.indexedChunks
            : indexedChunks // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [KnowledgeItem].
extension KnowledgeItemPatterns on KnowledgeItem {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_KnowledgeItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_KnowledgeItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_KnowledgeItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String title,
      String content,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
      int chunkCount,
      int indexedChunks,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
          _that.chunkCount,
          _that.indexedChunks,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String title,
      String content,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
      int chunkCount,
      int indexedChunks,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem():
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
          _that.chunkCount,
          _that.indexedChunks,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String title,
      String content,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
      int chunkCount,
      int indexedChunks,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
          _that.chunkCount,
          _that.indexedChunks,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KnowledgeItem implements KnowledgeItem {
  const _KnowledgeItem({
    required this.id,
    required this.title,
    required this.content,
    required this.allowAi,
    this.expiresAt,
    required this.createdAt,
    required this.chunkCount,
    required this.indexedChunks,
  });
  factory _KnowledgeItem.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final bool allowAi;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;
  @override
  final int chunkCount;
  @override
  final int indexedChunks;

  /// Create a copy of KnowledgeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KnowledgeItemCopyWith<_KnowledgeItem> get copyWith =>
      __$KnowledgeItemCopyWithImpl<_KnowledgeItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KnowledgeItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KnowledgeItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.chunkCount, chunkCount) ||
                other.chunkCount == chunkCount) &&
            (identical(other.indexedChunks, indexedChunks) ||
                other.indexedChunks == indexedChunks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    allowAi,
    expiresAt,
    createdAt,
    chunkCount,
    indexedChunks,
  );

  @override
  String toString() {
    return 'KnowledgeItem(id: $id, title: $title, content: $content, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt, chunkCount: $chunkCount, indexedChunks: $indexedChunks)';
  }
}

/// @nodoc
abstract mixin class _$KnowledgeItemCopyWith<$Res>
    implements $KnowledgeItemCopyWith<$Res> {
  factory _$KnowledgeItemCopyWith(
    _KnowledgeItem value,
    $Res Function(_KnowledgeItem) _then,
  ) = __$KnowledgeItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
    int chunkCount,
    int indexedChunks,
  });
}

/// @nodoc
class __$KnowledgeItemCopyWithImpl<$Res>
    implements _$KnowledgeItemCopyWith<$Res> {
  __$KnowledgeItemCopyWithImpl(this._self, this._then);

  final _KnowledgeItem _self;
  final $Res Function(_KnowledgeItem) _then;

  /// Create a copy of KnowledgeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? allowAi = null,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? chunkCount = null,
    Object? indexedChunks = null,
  }) {
    return _then(
      _KnowledgeItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _self.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        expiresAt: freezed == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        chunkCount: null == chunkCount
            ? _self.chunkCount
            : chunkCount // ignore: cast_nullable_to_non_nullable
                  as int,
        indexedChunks: null == indexedChunks
            ? _self.indexedChunks
            : indexedChunks // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
