// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'life_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileData {
  String get userId;
  String get displayName;
  String get locale;
  String get timezone;
  bool get aiConsent;
  bool get memoryConsent;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileDataCopyWith<ProfileData> get copyWith =>
      _$ProfileDataCopyWithImpl<ProfileData>(this as ProfileData, _$identity);

  /// Serializes this ProfileData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileData &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.aiConsent, aiConsent) ||
                other.aiConsent == aiConsent) &&
            (identical(other.memoryConsent, memoryConsent) ||
                other.memoryConsent == memoryConsent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    displayName,
    locale,
    timezone,
    aiConsent,
    memoryConsent,
  );

  @override
  String toString() {
    return 'ProfileData(userId: $userId, displayName: $displayName, locale: $locale, timezone: $timezone, aiConsent: $aiConsent, memoryConsent: $memoryConsent)';
  }
}

/// @nodoc
abstract mixin class $ProfileDataCopyWith<$Res> {
  factory $ProfileDataCopyWith(
    ProfileData value,
    $Res Function(ProfileData) _then,
  ) = _$ProfileDataCopyWithImpl;
  @useResult
  $Res call({
    String userId,
    String displayName,
    String locale,
    String timezone,
    bool aiConsent,
    bool memoryConsent,
  });
}

/// @nodoc
class _$ProfileDataCopyWithImpl<$Res> implements $ProfileDataCopyWith<$Res> {
  _$ProfileDataCopyWithImpl(this._self, this._then);

  final ProfileData _self;
  final $Res Function(ProfileData) _then;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? locale = null,
    Object? timezone = null,
    Object? aiConsent = null,
    Object? memoryConsent = null,
  }) {
    return _then(
      _self.copyWith(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        locale: null == locale
            ? _self.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        aiConsent: null == aiConsent
            ? _self.aiConsent
            : aiConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
        memoryConsent: null == memoryConsent
            ? _self.memoryConsent
            : memoryConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ProfileData].
extension ProfileDataPatterns on ProfileData {
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
    TResult Function(_ProfileData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileData() when $default != null:
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
    TResult Function(_ProfileData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileData():
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
    TResult? Function(_ProfileData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileData() when $default != null:
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
      String userId,
      String displayName,
      String locale,
      String timezone,
      bool aiConsent,
      bool memoryConsent,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProfileData() when $default != null:
        return $default(
          _that.userId,
          _that.displayName,
          _that.locale,
          _that.timezone,
          _that.aiConsent,
          _that.memoryConsent,
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
      String userId,
      String displayName,
      String locale,
      String timezone,
      bool aiConsent,
      bool memoryConsent,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileData():
        return $default(
          _that.userId,
          _that.displayName,
          _that.locale,
          _that.timezone,
          _that.aiConsent,
          _that.memoryConsent,
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
      String userId,
      String displayName,
      String locale,
      String timezone,
      bool aiConsent,
      bool memoryConsent,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProfileData() when $default != null:
        return $default(
          _that.userId,
          _that.displayName,
          _that.locale,
          _that.timezone,
          _that.aiConsent,
          _that.memoryConsent,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProfileData implements ProfileData {
  const _ProfileData({
    required this.userId,
    required this.displayName,
    this.locale = 'en',
    this.timezone = 'UTC',
    this.aiConsent = false,
    this.memoryConsent = false,
  });
  factory _ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final String timezone;
  @override
  @JsonKey()
  final bool aiConsent;
  @override
  @JsonKey()
  final bool memoryConsent;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileDataCopyWith<_ProfileData> get copyWith =>
      __$ProfileDataCopyWithImpl<_ProfileData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileDataToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProfileData &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.aiConsent, aiConsent) ||
                other.aiConsent == aiConsent) &&
            (identical(other.memoryConsent, memoryConsent) ||
                other.memoryConsent == memoryConsent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    displayName,
    locale,
    timezone,
    aiConsent,
    memoryConsent,
  );

  @override
  String toString() {
    return 'ProfileData(userId: $userId, displayName: $displayName, locale: $locale, timezone: $timezone, aiConsent: $aiConsent, memoryConsent: $memoryConsent)';
  }
}

/// @nodoc
abstract mixin class _$ProfileDataCopyWith<$Res>
    implements $ProfileDataCopyWith<$Res> {
  factory _$ProfileDataCopyWith(
    _ProfileData value,
    $Res Function(_ProfileData) _then,
  ) = __$ProfileDataCopyWithImpl;
  @override
  @useResult
  $Res call({
    String userId,
    String displayName,
    String locale,
    String timezone,
    bool aiConsent,
    bool memoryConsent,
  });
}

/// @nodoc
class __$ProfileDataCopyWithImpl<$Res> implements _$ProfileDataCopyWith<$Res> {
  __$ProfileDataCopyWithImpl(this._self, this._then);

  final _ProfileData _self;
  final $Res Function(_ProfileData) _then;

  /// Create a copy of ProfileData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? locale = null,
    Object? timezone = null,
    Object? aiConsent = null,
    Object? memoryConsent = null,
  }) {
    return _then(
      _ProfileData(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        locale: null == locale
            ? _self.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as String,
        timezone: null == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        aiConsent: null == aiConsent
            ? _self.aiConsent
            : aiConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
        memoryConsent: null == memoryConsent
            ? _self.memoryConsent
            : memoryConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$TaskItem {
  String get id;
  String get title;
  String get notes;
  String get status;
  String get priority;
  DateTime? get dueAt;
  DateTime? get completedAt;
  String? get goalId;
  DateTime get createdAt;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskItemCopyWith<TaskItem> get copyWith =>
      _$TaskItemCopyWithImpl<TaskItem>(this as TaskItem, _$identity);

  /// Serializes this TaskItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    status,
    priority,
    dueAt,
    completedAt,
    goalId,
    createdAt,
  );

  @override
  String toString() {
    return 'TaskItem(id: $id, title: $title, notes: $notes, status: $status, priority: $priority, dueAt: $dueAt, completedAt: $completedAt, goalId: $goalId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $TaskItemCopyWith<$Res> {
  factory $TaskItemCopyWith(TaskItem value, $Res Function(TaskItem) _then) =
      _$TaskItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    String status,
    String priority,
    DateTime? dueAt,
    DateTime? completedAt,
    String? goalId,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TaskItemCopyWithImpl<$Res> implements $TaskItemCopyWith<$Res> {
  _$TaskItemCopyWithImpl(this._self, this._then);

  final TaskItem _self;
  final $Res Function(TaskItem) _then;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? status = null,
    Object? priority = null,
    Object? dueAt = freezed,
    Object? completedAt = freezed,
    Object? goalId = freezed,
    Object? createdAt = null,
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
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _self.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        dueAt: freezed == dueAt
            ? _self.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _self.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        goalId: freezed == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [TaskItem].
extension TaskItemPatterns on TaskItem {
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
    TResult Function(_TaskItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskItem() when $default != null:
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
    TResult Function(_TaskItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskItem():
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
    TResult? Function(_TaskItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskItem() when $default != null:
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
      String notes,
      String status,
      String priority,
      DateTime? dueAt,
      DateTime? completedAt,
      String? goalId,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.status,
          _that.priority,
          _that.dueAt,
          _that.completedAt,
          _that.goalId,
          _that.createdAt,
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
      String notes,
      String status,
      String priority,
      DateTime? dueAt,
      DateTime? completedAt,
      String? goalId,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskItem():
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.status,
          _that.priority,
          _that.dueAt,
          _that.completedAt,
          _that.goalId,
          _that.createdAt,
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
      String notes,
      String status,
      String priority,
      DateTime? dueAt,
      DateTime? completedAt,
      String? goalId,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.status,
          _that.priority,
          _that.dueAt,
          _that.completedAt,
          _that.goalId,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TaskItem implements TaskItem {
  const _TaskItem({
    required this.id,
    required this.title,
    this.notes = '',
    this.status = 'todo',
    this.priority = 'normal',
    this.dueAt,
    this.completedAt,
    this.goalId,
    required this.createdAt,
  });
  factory _TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String priority;
  @override
  final DateTime? dueAt;
  @override
  final DateTime? completedAt;
  @override
  final String? goalId;
  @override
  final DateTime createdAt;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskItemCopyWith<_TaskItem> get copyWith =>
      __$TaskItemCopyWithImpl<_TaskItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TaskItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    status,
    priority,
    dueAt,
    completedAt,
    goalId,
    createdAt,
  );

  @override
  String toString() {
    return 'TaskItem(id: $id, title: $title, notes: $notes, status: $status, priority: $priority, dueAt: $dueAt, completedAt: $completedAt, goalId: $goalId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$TaskItemCopyWith<$Res>
    implements $TaskItemCopyWith<$Res> {
  factory _$TaskItemCopyWith(_TaskItem value, $Res Function(_TaskItem) _then) =
      __$TaskItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    String status,
    String priority,
    DateTime? dueAt,
    DateTime? completedAt,
    String? goalId,
    DateTime createdAt,
  });
}

/// @nodoc
class __$TaskItemCopyWithImpl<$Res> implements _$TaskItemCopyWith<$Res> {
  __$TaskItemCopyWithImpl(this._self, this._then);

  final _TaskItem _self;
  final $Res Function(_TaskItem) _then;

  /// Create a copy of TaskItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? status = null,
    Object? priority = null,
    Object? dueAt = freezed,
    Object? completedAt = freezed,
    Object? goalId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _TaskItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _self.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
        dueAt: freezed == dueAt
            ? _self.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _self.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        goalId: freezed == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$GoalItem {
  String get id;
  String get title;
  String get notes;
  int get progress;
  String? get targetDate;
  DateTime get createdAt;

  /// Create a copy of GoalItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalItemCopyWith<GoalItem> get copyWith =>
      _$GoalItemCopyWithImpl<GoalItem>(this as GoalItem, _$identity);

  /// Serializes this GoalItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    progress,
    targetDate,
    createdAt,
  );

  @override
  String toString() {
    return 'GoalItem(id: $id, title: $title, notes: $notes, progress: $progress, targetDate: $targetDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $GoalItemCopyWith<$Res> {
  factory $GoalItemCopyWith(GoalItem value, $Res Function(GoalItem) _then) =
      _$GoalItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    int progress,
    String? targetDate,
    DateTime createdAt,
  });
}

/// @nodoc
class _$GoalItemCopyWithImpl<$Res> implements $GoalItemCopyWith<$Res> {
  _$GoalItemCopyWithImpl(this._self, this._then);

  final GoalItem _self;
  final $Res Function(GoalItem) _then;

  /// Create a copy of GoalItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? progress = null,
    Object? targetDate = freezed,
    Object? createdAt = null,
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
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _self.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
        targetDate: freezed == targetDate
            ? _self.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [GoalItem].
extension GoalItemPatterns on GoalItem {
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
    TResult Function(_GoalItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalItem() when $default != null:
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
    TResult Function(_GoalItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalItem():
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
    TResult? Function(_GoalItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalItem() when $default != null:
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
      String notes,
      int progress,
      String? targetDate,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.progress,
          _that.targetDate,
          _that.createdAt,
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
      String notes,
      int progress,
      String? targetDate,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalItem():
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.progress,
          _that.targetDate,
          _that.createdAt,
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
      String notes,
      int progress,
      String? targetDate,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.progress,
          _that.targetDate,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalItem implements GoalItem {
  const _GoalItem({
    required this.id,
    required this.title,
    this.notes = '',
    this.progress = 0,
    this.targetDate,
    required this.createdAt,
  });
  factory _GoalItem.fromJson(Map<String, dynamic> json) =>
      _$GoalItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final int progress;
  @override
  final String? targetDate;
  @override
  final DateTime createdAt;

  /// Create a copy of GoalItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalItemCopyWith<_GoalItem> get copyWith =>
      __$GoalItemCopyWithImpl<_GoalItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    progress,
    targetDate,
    createdAt,
  );

  @override
  String toString() {
    return 'GoalItem(id: $id, title: $title, notes: $notes, progress: $progress, targetDate: $targetDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$GoalItemCopyWith<$Res>
    implements $GoalItemCopyWith<$Res> {
  factory _$GoalItemCopyWith(_GoalItem value, $Res Function(_GoalItem) _then) =
      __$GoalItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    int progress,
    String? targetDate,
    DateTime createdAt,
  });
}

/// @nodoc
class __$GoalItemCopyWithImpl<$Res> implements _$GoalItemCopyWith<$Res> {
  __$GoalItemCopyWithImpl(this._self, this._then);

  final _GoalItem _self;
  final $Res Function(_GoalItem) _then;

  /// Create a copy of GoalItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? progress = null,
    Object? targetDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _GoalItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _self.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
        targetDate: freezed == targetDate
            ? _self.targetDate
            : targetDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$HabitItem {
  String get id;
  String get title;
  String get notes;
  bool get active;
  bool get checkedToday;
  int get currentStreak;
  String get today;
  DateTime get createdAt;

  /// Create a copy of HabitItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HabitItemCopyWith<HabitItem> get copyWith =>
      _$HabitItemCopyWithImpl<HabitItem>(this as HabitItem, _$identity);

  /// Serializes this HabitItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HabitItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.checkedToday, checkedToday) ||
                other.checkedToday == checkedToday) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    active,
    checkedToday,
    currentStreak,
    today,
    createdAt,
  );

  @override
  String toString() {
    return 'HabitItem(id: $id, title: $title, notes: $notes, active: $active, checkedToday: $checkedToday, currentStreak: $currentStreak, today: $today, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $HabitItemCopyWith<$Res> {
  factory $HabitItemCopyWith(HabitItem value, $Res Function(HabitItem) _then) =
      _$HabitItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    bool active,
    bool checkedToday,
    int currentStreak,
    String today,
    DateTime createdAt,
  });
}

/// @nodoc
class _$HabitItemCopyWithImpl<$Res> implements $HabitItemCopyWith<$Res> {
  _$HabitItemCopyWithImpl(this._self, this._then);

  final HabitItem _self;
  final $Res Function(HabitItem) _then;

  /// Create a copy of HabitItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? active = null,
    Object? checkedToday = null,
    Object? currentStreak = null,
    Object? today = null,
    Object? createdAt = null,
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
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        checkedToday: null == checkedToday
            ? _self.checkedToday
            : checkedToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentStreak: null == currentStreak
            ? _self.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [HabitItem].
extension HabitItemPatterns on HabitItem {
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
    TResult Function(_HabitItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HabitItem() when $default != null:
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
    TResult Function(_HabitItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HabitItem():
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
    TResult? Function(_HabitItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HabitItem() when $default != null:
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
      String notes,
      bool active,
      bool checkedToday,
      int currentStreak,
      String today,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HabitItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.active,
          _that.checkedToday,
          _that.currentStreak,
          _that.today,
          _that.createdAt,
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
      String notes,
      bool active,
      bool checkedToday,
      int currentStreak,
      String today,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HabitItem():
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.active,
          _that.checkedToday,
          _that.currentStreak,
          _that.today,
          _that.createdAt,
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
      String notes,
      bool active,
      bool checkedToday,
      int currentStreak,
      String today,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HabitItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.active,
          _that.checkedToday,
          _that.currentStreak,
          _that.today,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HabitItem implements HabitItem {
  const _HabitItem({
    required this.id,
    required this.title,
    this.notes = '',
    this.active = true,
    required this.checkedToday,
    required this.currentStreak,
    required this.today,
    required this.createdAt,
  });
  factory _HabitItem.fromJson(Map<String, dynamic> json) =>
      _$HabitItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool active;
  @override
  final bool checkedToday;
  @override
  final int currentStreak;
  @override
  final String today;
  @override
  final DateTime createdAt;

  /// Create a copy of HabitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HabitItemCopyWith<_HabitItem> get copyWith =>
      __$HabitItemCopyWithImpl<_HabitItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HabitItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HabitItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.checkedToday, checkedToday) ||
                other.checkedToday == checkedToday) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    notes,
    active,
    checkedToday,
    currentStreak,
    today,
    createdAt,
  );

  @override
  String toString() {
    return 'HabitItem(id: $id, title: $title, notes: $notes, active: $active, checkedToday: $checkedToday, currentStreak: $currentStreak, today: $today, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$HabitItemCopyWith<$Res>
    implements $HabitItemCopyWith<$Res> {
  factory _$HabitItemCopyWith(
    _HabitItem value,
    $Res Function(_HabitItem) _then,
  ) = __$HabitItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    bool active,
    bool checkedToday,
    int currentStreak,
    String today,
    DateTime createdAt,
  });
}

/// @nodoc
class __$HabitItemCopyWithImpl<$Res> implements _$HabitItemCopyWith<$Res> {
  __$HabitItemCopyWithImpl(this._self, this._then);

  final _HabitItem _self;
  final $Res Function(_HabitItem) _then;

  /// Create a copy of HabitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? active = null,
    Object? checkedToday = null,
    Object? currentStreak = null,
    Object? today = null,
    Object? createdAt = null,
  }) {
    return _then(
      _HabitItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        checkedToday: null == checkedToday
            ? _self.checkedToday
            : checkedToday // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentStreak: null == currentStreak
            ? _self.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$MemoryItem {
  String get id;
  String get title;
  String get content;
  bool get allowAi;
  DateTime? get expiresAt;
  DateTime get createdAt;

  /// Create a copy of MemoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemoryItemCopyWith<MemoryItem> get copyWith =>
      _$MemoryItemCopyWithImpl<MemoryItem>(this as MemoryItem, _$identity);

  /// Serializes this MemoryItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemoryItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
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
  );

  @override
  String toString() {
    return 'MemoryItem(id: $id, title: $title, content: $content, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $MemoryItemCopyWith<$Res> {
  factory $MemoryItemCopyWith(
    MemoryItem value,
    $Res Function(MemoryItem) _then,
  ) = _$MemoryItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MemoryItemCopyWithImpl<$Res> implements $MemoryItemCopyWith<$Res> {
  _$MemoryItemCopyWithImpl(this._self, this._then);

  final MemoryItem _self;
  final $Res Function(MemoryItem) _then;

  /// Create a copy of MemoryItem
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MemoryItem].
extension MemoryItemPatterns on MemoryItem {
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
    TResult Function(_MemoryItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemoryItem() when $default != null:
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
    TResult Function(_MemoryItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemoryItem():
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
    TResult? Function(_MemoryItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemoryItem() when $default != null:
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
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MemoryItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
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
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemoryItem():
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
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
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MemoryItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.content,
          _that.allowAi,
          _that.expiresAt,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MemoryItem implements MemoryItem {
  const _MemoryItem({
    required this.id,
    required this.title,
    required this.content,
    this.allowAi = false,
    this.expiresAt,
    required this.createdAt,
  });
  factory _MemoryItem.fromJson(Map<String, dynamic> json) =>
      _$MemoryItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey()
  final bool allowAi;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;

  /// Create a copy of MemoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MemoryItemCopyWith<_MemoryItem> get copyWith =>
      __$MemoryItemCopyWithImpl<_MemoryItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MemoryItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MemoryItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
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
  );

  @override
  String toString() {
    return 'MemoryItem(id: $id, title: $title, content: $content, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$MemoryItemCopyWith<$Res>
    implements $MemoryItemCopyWith<$Res> {
  factory _$MemoryItemCopyWith(
    _MemoryItem value,
    $Res Function(_MemoryItem) _then,
  ) = __$MemoryItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$MemoryItemCopyWithImpl<$Res> implements _$MemoryItemCopyWith<$Res> {
  __$MemoryItemCopyWithImpl(this._self, this._then);

  final _MemoryItem _self;
  final $Res Function(_MemoryItem) _then;

  /// Create a copy of MemoryItem
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
  }) {
    return _then(
      _MemoryItem(
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
      ),
    );
  }
}

/// @nodoc
mixin _$CalendarItem {
  String get id;
  String get title;
  String get notes;
  DateTime get startsAt;
  DateTime get endsAt;
  DateTime get createdAt;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarItemCopyWith<CalendarItem> get copyWith =>
      _$CalendarItemCopyWithImpl<CalendarItem>(
        this as CalendarItem,
        _$identity,
      );

  /// Serializes this CalendarItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, notes, startsAt, endsAt, createdAt);

  @override
  String toString() {
    return 'CalendarItem(id: $id, title: $title, notes: $notes, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CalendarItemCopyWith<$Res> {
  factory $CalendarItemCopyWith(
    CalendarItem value,
    $Res Function(CalendarItem) _then,
  ) = _$CalendarItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    DateTime startsAt,
    DateTime endsAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CalendarItemCopyWithImpl<$Res> implements $CalendarItemCopyWith<$Res> {
  _$CalendarItemCopyWithImpl(this._self, this._then);

  final CalendarItem _self;
  final $Res Function(CalendarItem) _then;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? createdAt = null,
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
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        startsAt: null == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endsAt: null == endsAt
            ? _self.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CalendarItem].
extension CalendarItemPatterns on CalendarItem {
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
    TResult Function(_CalendarItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarItem() when $default != null:
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
    TResult Function(_CalendarItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarItem():
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
    TResult? Function(_CalendarItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarItem() when $default != null:
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
      String notes,
      DateTime startsAt,
      DateTime endsAt,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.startsAt,
          _that.endsAt,
          _that.createdAt,
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
      String notes,
      DateTime startsAt,
      DateTime endsAt,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarItem():
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.startsAt,
          _that.endsAt,
          _that.createdAt,
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
      String notes,
      DateTime startsAt,
      DateTime endsAt,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.notes,
          _that.startsAt,
          _that.endsAt,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CalendarItem implements CalendarItem {
  const _CalendarItem({
    required this.id,
    required this.title,
    this.notes = '',
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
  });
  factory _CalendarItem.fromJson(Map<String, dynamic> json) =>
      _$CalendarItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String notes;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final DateTime createdAt;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarItemCopyWith<_CalendarItem> get copyWith =>
      __$CalendarItemCopyWithImpl<_CalendarItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CalendarItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, notes, startsAt, endsAt, createdAt);

  @override
  String toString() {
    return 'CalendarItem(id: $id, title: $title, notes: $notes, startsAt: $startsAt, endsAt: $endsAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CalendarItemCopyWith<$Res>
    implements $CalendarItemCopyWith<$Res> {
  factory _$CalendarItemCopyWith(
    _CalendarItem value,
    $Res Function(_CalendarItem) _then,
  ) = __$CalendarItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String notes,
    DateTime startsAt,
    DateTime endsAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$CalendarItemCopyWithImpl<$Res>
    implements _$CalendarItemCopyWith<$Res> {
  __$CalendarItemCopyWithImpl(this._self, this._then);

  final _CalendarItem _self;
  final $Res Function(_CalendarItem) _then;

  /// Create a copy of CalendarItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? notes = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _CalendarItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        startsAt: null == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endsAt: null == endsAt
            ? _self.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$ActivityDay {
  String get day;
  int get tasksCompleted;
  int get habitCheckins;

  /// Create a copy of ActivityDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityDayCopyWith<ActivityDay> get copyWith =>
      _$ActivityDayCopyWithImpl<ActivityDay>(this as ActivityDay, _$identity);

  /// Serializes this ActivityDay to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityDay &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.habitCheckins, habitCheckins) ||
                other.habitCheckins == habitCheckins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, day, tasksCompleted, habitCheckins);

  @override
  String toString() {
    return 'ActivityDay(day: $day, tasksCompleted: $tasksCompleted, habitCheckins: $habitCheckins)';
  }
}

/// @nodoc
abstract mixin class $ActivityDayCopyWith<$Res> {
  factory $ActivityDayCopyWith(
    ActivityDay value,
    $Res Function(ActivityDay) _then,
  ) = _$ActivityDayCopyWithImpl;
  @useResult
  $Res call({String day, int tasksCompleted, int habitCheckins});
}

/// @nodoc
class _$ActivityDayCopyWithImpl<$Res> implements $ActivityDayCopyWith<$Res> {
  _$ActivityDayCopyWithImpl(this._self, this._then);

  final ActivityDay _self;
  final $Res Function(ActivityDay) _then;

  /// Create a copy of ActivityDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? tasksCompleted = null,
    Object? habitCheckins = null,
  }) {
    return _then(
      _self.copyWith(
        day: null == day
            ? _self.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        tasksCompleted: null == tasksCompleted
            ? _self.tasksCompleted
            : tasksCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        habitCheckins: null == habitCheckins
            ? _self.habitCheckins
            : habitCheckins // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ActivityDay].
extension ActivityDayPatterns on ActivityDay {
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
    TResult Function(_ActivityDay value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityDay() when $default != null:
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
    TResult Function(_ActivityDay value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityDay():
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
    TResult? Function(_ActivityDay value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityDay() when $default != null:
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
    TResult Function(String day, int tasksCompleted, int habitCheckins)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityDay() when $default != null:
        return $default(_that.day, _that.tasksCompleted, _that.habitCheckins);
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
    TResult Function(String day, int tasksCompleted, int habitCheckins)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityDay():
        return $default(_that.day, _that.tasksCompleted, _that.habitCheckins);
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
    TResult? Function(String day, int tasksCompleted, int habitCheckins)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityDay() when $default != null:
        return $default(_that.day, _that.tasksCompleted, _that.habitCheckins);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityDay implements ActivityDay {
  const _ActivityDay({
    required this.day,
    required this.tasksCompleted,
    required this.habitCheckins,
  });
  factory _ActivityDay.fromJson(Map<String, dynamic> json) =>
      _$ActivityDayFromJson(json);

  @override
  final String day;
  @override
  final int tasksCompleted;
  @override
  final int habitCheckins;

  /// Create a copy of ActivityDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityDayCopyWith<_ActivityDay> get copyWith =>
      __$ActivityDayCopyWithImpl<_ActivityDay>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityDayToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityDay &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.habitCheckins, habitCheckins) ||
                other.habitCheckins == habitCheckins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, day, tasksCompleted, habitCheckins);

  @override
  String toString() {
    return 'ActivityDay(day: $day, tasksCompleted: $tasksCompleted, habitCheckins: $habitCheckins)';
  }
}

/// @nodoc
abstract mixin class _$ActivityDayCopyWith<$Res>
    implements $ActivityDayCopyWith<$Res> {
  factory _$ActivityDayCopyWith(
    _ActivityDay value,
    $Res Function(_ActivityDay) _then,
  ) = __$ActivityDayCopyWithImpl;
  @override
  @useResult
  $Res call({String day, int tasksCompleted, int habitCheckins});
}

/// @nodoc
class __$ActivityDayCopyWithImpl<$Res> implements _$ActivityDayCopyWith<$Res> {
  __$ActivityDayCopyWithImpl(this._self, this._then);

  final _ActivityDay _self;
  final $Res Function(_ActivityDay) _then;

  /// Create a copy of ActivityDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? day = null,
    Object? tasksCompleted = null,
    Object? habitCheckins = null,
  }) {
    return _then(
      _ActivityDay(
        day: null == day
            ? _self.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        tasksCompleted: null == tasksCompleted
            ? _self.tasksCompleted
            : tasksCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        habitCheckins: null == habitCheckins
            ? _self.habitCheckins
            : habitCheckins // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$DashboardData {
  String get timezone;
  String get today;
  int get tasksOpen;
  int get tasksCompleted;
  int get tasksDueToday;
  int get tasksOverdue;
  int get goalsActive;
  int get goalsCompleted;
  int get habitCount;
  int get habitsCompletedToday;
  int get memoriesActive;
  List<ActivityDay> get weeklyActivity;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      _$DashboardDataCopyWithImpl<DashboardData>(
        this as DashboardData,
        _$identity,
      );

  /// Serializes this DashboardData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardData &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.tasksOpen, tasksOpen) ||
                other.tasksOpen == tasksOpen) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.tasksDueToday, tasksDueToday) ||
                other.tasksDueToday == tasksDueToday) &&
            (identical(other.tasksOverdue, tasksOverdue) ||
                other.tasksOverdue == tasksOverdue) &&
            (identical(other.goalsActive, goalsActive) ||
                other.goalsActive == goalsActive) &&
            (identical(other.goalsCompleted, goalsCompleted) ||
                other.goalsCompleted == goalsCompleted) &&
            (identical(other.habitCount, habitCount) ||
                other.habitCount == habitCount) &&
            (identical(other.habitsCompletedToday, habitsCompletedToday) ||
                other.habitsCompletedToday == habitsCompletedToday) &&
            (identical(other.memoriesActive, memoriesActive) ||
                other.memoriesActive == memoriesActive) &&
            const DeepCollectionEquality().equals(
              other.weeklyActivity,
              weeklyActivity,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timezone,
    today,
    tasksOpen,
    tasksCompleted,
    tasksDueToday,
    tasksOverdue,
    goalsActive,
    goalsCompleted,
    habitCount,
    habitsCompletedToday,
    memoriesActive,
    const DeepCollectionEquality().hash(weeklyActivity),
  );

  @override
  String toString() {
    return 'DashboardData(timezone: $timezone, today: $today, tasksOpen: $tasksOpen, tasksCompleted: $tasksCompleted, tasksDueToday: $tasksDueToday, tasksOverdue: $tasksOverdue, goalsActive: $goalsActive, goalsCompleted: $goalsCompleted, habitCount: $habitCount, habitsCompletedToday: $habitsCompletedToday, memoriesActive: $memoriesActive, weeklyActivity: $weeklyActivity)';
  }
}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
    DashboardData value,
    $Res Function(DashboardData) _then,
  ) = _$DashboardDataCopyWithImpl;
  @useResult
  $Res call({
    String timezone,
    String today,
    int tasksOpen,
    int tasksCompleted,
    int tasksDueToday,
    int tasksOverdue,
    int goalsActive,
    int goalsCompleted,
    int habitCount,
    int habitsCompletedToday,
    int memoriesActive,
    List<ActivityDay> weeklyActivity,
  });
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timezone = null,
    Object? today = null,
    Object? tasksOpen = null,
    Object? tasksCompleted = null,
    Object? tasksDueToday = null,
    Object? tasksOverdue = null,
    Object? goalsActive = null,
    Object? goalsCompleted = null,
    Object? habitCount = null,
    Object? habitsCompletedToday = null,
    Object? memoriesActive = null,
    Object? weeklyActivity = null,
  }) {
    return _then(
      _self.copyWith(
        timezone: null == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        tasksOpen: null == tasksOpen
            ? _self.tasksOpen
            : tasksOpen // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksCompleted: null == tasksCompleted
            ? _self.tasksCompleted
            : tasksCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksDueToday: null == tasksDueToday
            ? _self.tasksDueToday
            : tasksDueToday // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksOverdue: null == tasksOverdue
            ? _self.tasksOverdue
            : tasksOverdue // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsActive: null == goalsActive
            ? _self.goalsActive
            : goalsActive // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsCompleted: null == goalsCompleted
            ? _self.goalsCompleted
            : goalsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        habitCount: null == habitCount
            ? _self.habitCount
            : habitCount // ignore: cast_nullable_to_non_nullable
                  as int,
        habitsCompletedToday: null == habitsCompletedToday
            ? _self.habitsCompletedToday
            : habitsCompletedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        memoriesActive: null == memoriesActive
            ? _self.memoriesActive
            : memoriesActive // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyActivity: null == weeklyActivity
            ? _self.weeklyActivity
            : weeklyActivity // ignore: cast_nullable_to_non_nullable
                  as List<ActivityDay>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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
    TResult Function(_DashboardData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
    TResult Function(_DashboardData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
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
    TResult? Function(_DashboardData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
      String timezone,
      String today,
      int tasksOpen,
      int tasksCompleted,
      int tasksDueToday,
      int tasksOverdue,
      int goalsActive,
      int goalsCompleted,
      int habitCount,
      int habitsCompletedToday,
      int memoriesActive,
      List<ActivityDay> weeklyActivity,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(
          _that.timezone,
          _that.today,
          _that.tasksOpen,
          _that.tasksCompleted,
          _that.tasksDueToday,
          _that.tasksOverdue,
          _that.goalsActive,
          _that.goalsCompleted,
          _that.habitCount,
          _that.habitsCompletedToday,
          _that.memoriesActive,
          _that.weeklyActivity,
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
      String timezone,
      String today,
      int tasksOpen,
      int tasksCompleted,
      int tasksDueToday,
      int tasksOverdue,
      int goalsActive,
      int goalsCompleted,
      int habitCount,
      int habitsCompletedToday,
      int memoriesActive,
      List<ActivityDay> weeklyActivity,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
        return $default(
          _that.timezone,
          _that.today,
          _that.tasksOpen,
          _that.tasksCompleted,
          _that.tasksDueToday,
          _that.tasksOverdue,
          _that.goalsActive,
          _that.goalsCompleted,
          _that.habitCount,
          _that.habitsCompletedToday,
          _that.memoriesActive,
          _that.weeklyActivity,
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
      String timezone,
      String today,
      int tasksOpen,
      int tasksCompleted,
      int tasksDueToday,
      int tasksOverdue,
      int goalsActive,
      int goalsCompleted,
      int habitCount,
      int habitsCompletedToday,
      int memoriesActive,
      List<ActivityDay> weeklyActivity,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(
          _that.timezone,
          _that.today,
          _that.tasksOpen,
          _that.tasksCompleted,
          _that.tasksDueToday,
          _that.tasksOverdue,
          _that.goalsActive,
          _that.goalsCompleted,
          _that.habitCount,
          _that.habitsCompletedToday,
          _that.memoriesActive,
          _that.weeklyActivity,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DashboardData implements DashboardData {
  const _DashboardData({
    required this.timezone,
    required this.today,
    required this.tasksOpen,
    required this.tasksCompleted,
    required this.tasksDueToday,
    required this.tasksOverdue,
    required this.goalsActive,
    required this.goalsCompleted,
    required this.habitCount,
    required this.habitsCompletedToday,
    required this.memoriesActive,
    required final List<ActivityDay> weeklyActivity,
  }) : _weeklyActivity = weeklyActivity;
  factory _DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  @override
  final String timezone;
  @override
  final String today;
  @override
  final int tasksOpen;
  @override
  final int tasksCompleted;
  @override
  final int tasksDueToday;
  @override
  final int tasksOverdue;
  @override
  final int goalsActive;
  @override
  final int goalsCompleted;
  @override
  final int habitCount;
  @override
  final int habitsCompletedToday;
  @override
  final int memoriesActive;
  final List<ActivityDay> _weeklyActivity;
  @override
  List<ActivityDay> get weeklyActivity {
    if (_weeklyActivity is EqualUnmodifiableListView) return _weeklyActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyActivity);
  }

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardDataCopyWith<_DashboardData> get copyWith =>
      __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DashboardDataToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardData &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.tasksOpen, tasksOpen) ||
                other.tasksOpen == tasksOpen) &&
            (identical(other.tasksCompleted, tasksCompleted) ||
                other.tasksCompleted == tasksCompleted) &&
            (identical(other.tasksDueToday, tasksDueToday) ||
                other.tasksDueToday == tasksDueToday) &&
            (identical(other.tasksOverdue, tasksOverdue) ||
                other.tasksOverdue == tasksOverdue) &&
            (identical(other.goalsActive, goalsActive) ||
                other.goalsActive == goalsActive) &&
            (identical(other.goalsCompleted, goalsCompleted) ||
                other.goalsCompleted == goalsCompleted) &&
            (identical(other.habitCount, habitCount) ||
                other.habitCount == habitCount) &&
            (identical(other.habitsCompletedToday, habitsCompletedToday) ||
                other.habitsCompletedToday == habitsCompletedToday) &&
            (identical(other.memoriesActive, memoriesActive) ||
                other.memoriesActive == memoriesActive) &&
            const DeepCollectionEquality().equals(
              other._weeklyActivity,
              _weeklyActivity,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timezone,
    today,
    tasksOpen,
    tasksCompleted,
    tasksDueToday,
    tasksOverdue,
    goalsActive,
    goalsCompleted,
    habitCount,
    habitsCompletedToday,
    memoriesActive,
    const DeepCollectionEquality().hash(_weeklyActivity),
  );

  @override
  String toString() {
    return 'DashboardData(timezone: $timezone, today: $today, tasksOpen: $tasksOpen, tasksCompleted: $tasksCompleted, tasksDueToday: $tasksDueToday, tasksOverdue: $tasksOverdue, goalsActive: $goalsActive, goalsCompleted: $goalsCompleted, habitCount: $habitCount, habitsCompletedToday: $habitsCompletedToday, memoriesActive: $memoriesActive, weeklyActivity: $weeklyActivity)';
  }
}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(
    _DashboardData value,
    $Res Function(_DashboardData) _then,
  ) = __$DashboardDataCopyWithImpl;
  @override
  @useResult
  $Res call({
    String timezone,
    String today,
    int tasksOpen,
    int tasksCompleted,
    int tasksDueToday,
    int tasksOverdue,
    int goalsActive,
    int goalsCompleted,
    int habitCount,
    int habitsCompletedToday,
    int memoriesActive,
    List<ActivityDay> weeklyActivity,
  });
}

/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? timezone = null,
    Object? today = null,
    Object? tasksOpen = null,
    Object? tasksCompleted = null,
    Object? tasksDueToday = null,
    Object? tasksOverdue = null,
    Object? goalsActive = null,
    Object? goalsCompleted = null,
    Object? habitCount = null,
    Object? habitsCompletedToday = null,
    Object? memoriesActive = null,
    Object? weeklyActivity = null,
  }) {
    return _then(
      _DashboardData(
        timezone: null == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        tasksOpen: null == tasksOpen
            ? _self.tasksOpen
            : tasksOpen // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksCompleted: null == tasksCompleted
            ? _self.tasksCompleted
            : tasksCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksDueToday: null == tasksDueToday
            ? _self.tasksDueToday
            : tasksDueToday // ignore: cast_nullable_to_non_nullable
                  as int,
        tasksOverdue: null == tasksOverdue
            ? _self.tasksOverdue
            : tasksOverdue // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsActive: null == goalsActive
            ? _self.goalsActive
            : goalsActive // ignore: cast_nullable_to_non_nullable
                  as int,
        goalsCompleted: null == goalsCompleted
            ? _self.goalsCompleted
            : goalsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        habitCount: null == habitCount
            ? _self.habitCount
            : habitCount // ignore: cast_nullable_to_non_nullable
                  as int,
        habitsCompletedToday: null == habitsCompletedToday
            ? _self.habitsCompletedToday
            : habitsCompletedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        memoriesActive: null == memoriesActive
            ? _self.memoriesActive
            : memoriesActive // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyActivity: null == weeklyActivity
            ? _self._weeklyActivity
            : weeklyActivity // ignore: cast_nullable_to_non_nullable
                  as List<ActivityDay>,
      ),
    );
  }
}

/// @nodoc
mixin _$ConversationItem {
  String get id;
  String get title;
  DateTime get createdAt;
  DateTime get expiresAt;

  /// Create a copy of ConversationItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationItemCopyWith<ConversationItem> get copyWith =>
      _$ConversationItemCopyWithImpl<ConversationItem>(
        this as ConversationItem,
        _$identity,
      );

  /// Serializes this ConversationItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConversationItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, expiresAt);

  @override
  String toString() {
    return 'ConversationItem(id: $id, title: $title, createdAt: $createdAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $ConversationItemCopyWith<$Res> {
  factory $ConversationItemCopyWith(
    ConversationItem value,
    $Res Function(ConversationItem) _then,
  ) = _$ConversationItemCopyWithImpl;
  @useResult
  $Res call({String id, String title, DateTime createdAt, DateTime expiresAt});
}

/// @nodoc
class _$ConversationItemCopyWithImpl<$Res>
    implements $ConversationItemCopyWith<$Res> {
  _$ConversationItemCopyWithImpl(this._self, this._then);

  final ConversationItem _self;
  final $Res Function(ConversationItem) _then;

  /// Create a copy of ConversationItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
    Object? expiresAt = null,
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ConversationItem].
extension ConversationItemPatterns on ConversationItem {
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
    TResult Function(_ConversationItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationItem() when $default != null:
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
    TResult Function(_ConversationItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationItem():
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
    TResult? Function(_ConversationItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationItem() when $default != null:
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
      DateTime createdAt,
      DateTime expiresAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConversationItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.createdAt,
          _that.expiresAt,
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
      DateTime createdAt,
      DateTime expiresAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationItem():
        return $default(
          _that.id,
          _that.title,
          _that.createdAt,
          _that.expiresAt,
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
      DateTime createdAt,
      DateTime expiresAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConversationItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.createdAt,
          _that.expiresAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ConversationItem implements ConversationItem {
  const _ConversationItem({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.expiresAt,
  });
  factory _ConversationItem.fromJson(Map<String, dynamic> json) =>
      _$ConversationItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;

  /// Create a copy of ConversationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationItemCopyWith<_ConversationItem> get copyWith =>
      __$ConversationItemCopyWithImpl<_ConversationItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConversationItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConversationItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, createdAt, expiresAt);

  @override
  String toString() {
    return 'ConversationItem(id: $id, title: $title, createdAt: $createdAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$ConversationItemCopyWith<$Res>
    implements $ConversationItemCopyWith<$Res> {
  factory _$ConversationItemCopyWith(
    _ConversationItem value,
    $Res Function(_ConversationItem) _then,
  ) = __$ConversationItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, DateTime createdAt, DateTime expiresAt});
}

/// @nodoc
class __$ConversationItemCopyWithImpl<$Res>
    implements _$ConversationItemCopyWith<$Res> {
  __$ConversationItemCopyWithImpl(this._self, this._then);

  final _ConversationItem _self;
  final $Res Function(_ConversationItem) _then;

  /// Create a copy of ConversationItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? createdAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _ConversationItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageItem {
  String get id;
  String get role;
  String get content;
  DateTime get createdAt;
  int get memoryCount;
  int get planCount;
  String get model;

  /// Create a copy of MessageItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageItemCopyWith<MessageItem> get copyWith =>
      _$MessageItemCopyWithImpl<MessageItem>(this as MessageItem, _$identity);

  /// Serializes this MessageItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.memoryCount, memoryCount) ||
                other.memoryCount == memoryCount) &&
            (identical(other.planCount, planCount) ||
                other.planCount == planCount) &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    content,
    createdAt,
    memoryCount,
    planCount,
    model,
  );

  @override
  String toString() {
    return 'MessageItem(id: $id, role: $role, content: $content, createdAt: $createdAt, memoryCount: $memoryCount, planCount: $planCount, model: $model)';
  }
}

/// @nodoc
abstract mixin class $MessageItemCopyWith<$Res> {
  factory $MessageItemCopyWith(
    MessageItem value,
    $Res Function(MessageItem) _then,
  ) = _$MessageItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String role,
    String content,
    DateTime createdAt,
    int memoryCount,
    int planCount,
    String model,
  });
}

/// @nodoc
class _$MessageItemCopyWithImpl<$Res> implements $MessageItemCopyWith<$Res> {
  _$MessageItemCopyWithImpl(this._self, this._then);

  final MessageItem _self;
  final $Res Function(MessageItem) _then;

  /// Create a copy of MessageItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
    Object? memoryCount = null,
    Object? planCount = null,
    Object? model = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _self.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memoryCount: null == memoryCount
            ? _self.memoryCount
            : memoryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        planCount: null == planCount
            ? _self.planCount
            : planCount // ignore: cast_nullable_to_non_nullable
                  as int,
        model: null == model
            ? _self.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [MessageItem].
extension MessageItemPatterns on MessageItem {
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
    TResult Function(_MessageItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessageItem() when $default != null:
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
    TResult Function(_MessageItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageItem():
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
    TResult? Function(_MessageItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageItem() when $default != null:
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
      String role,
      String content,
      DateTime createdAt,
      int memoryCount,
      int planCount,
      String model,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MessageItem() when $default != null:
        return $default(
          _that.id,
          _that.role,
          _that.content,
          _that.createdAt,
          _that.memoryCount,
          _that.planCount,
          _that.model,
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
      String role,
      String content,
      DateTime createdAt,
      int memoryCount,
      int planCount,
      String model,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageItem():
        return $default(
          _that.id,
          _that.role,
          _that.content,
          _that.createdAt,
          _that.memoryCount,
          _that.planCount,
          _that.model,
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
      String role,
      String content,
      DateTime createdAt,
      int memoryCount,
      int planCount,
      String model,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MessageItem() when $default != null:
        return $default(
          _that.id,
          _that.role,
          _that.content,
          _that.createdAt,
          _that.memoryCount,
          _that.planCount,
          _that.model,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MessageItem implements MessageItem {
  const _MessageItem({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.memoryCount = 0,
    this.planCount = 0,
    this.model = '',
  });
  factory _MessageItem.fromJson(Map<String, dynamic> json) =>
      _$MessageItemFromJson(json);

  @override
  final String id;
  @override
  final String role;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int memoryCount;
  @override
  @JsonKey()
  final int planCount;
  @override
  @JsonKey()
  final String model;

  /// Create a copy of MessageItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageItemCopyWith<_MessageItem> get copyWith =>
      __$MessageItemCopyWithImpl<_MessageItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessageItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.memoryCount, memoryCount) ||
                other.memoryCount == memoryCount) &&
            (identical(other.planCount, planCount) ||
                other.planCount == planCount) &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    role,
    content,
    createdAt,
    memoryCount,
    planCount,
    model,
  );

  @override
  String toString() {
    return 'MessageItem(id: $id, role: $role, content: $content, createdAt: $createdAt, memoryCount: $memoryCount, planCount: $planCount, model: $model)';
  }
}

/// @nodoc
abstract mixin class _$MessageItemCopyWith<$Res>
    implements $MessageItemCopyWith<$Res> {
  factory _$MessageItemCopyWith(
    _MessageItem value,
    $Res Function(_MessageItem) _then,
  ) = __$MessageItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String role,
    String content,
    DateTime createdAt,
    int memoryCount,
    int planCount,
    String model,
  });
}

/// @nodoc
class __$MessageItemCopyWithImpl<$Res> implements _$MessageItemCopyWith<$Res> {
  __$MessageItemCopyWithImpl(this._self, this._then);

  final _MessageItem _self;
  final $Res Function(_MessageItem) _then;

  /// Create a copy of MessageItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? createdAt = null,
    Object? memoryCount = null,
    Object? planCount = null,
    Object? model = null,
  }) {
    return _then(
      _MessageItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _self.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _self.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        memoryCount: null == memoryCount
            ? _self.memoryCount
            : memoryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        planCount: null == planCount
            ? _self.planCount
            : planCount // ignore: cast_nullable_to_non_nullable
                  as int,
        model: null == model
            ? _self.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ChatResult {
  String get conversationId;
  MessageItem get reply;
  bool get cached;

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatResultCopyWith<ChatResult> get copyWith =>
      _$ChatResultCopyWithImpl<ChatResult>(this as ChatResult, _$identity);

  /// Serializes this ChatResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatResult &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.cached, cached) || other.cached == cached));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversationId, reply, cached);

  @override
  String toString() {
    return 'ChatResult(conversationId: $conversationId, reply: $reply, cached: $cached)';
  }
}

/// @nodoc
abstract mixin class $ChatResultCopyWith<$Res> {
  factory $ChatResultCopyWith(
    ChatResult value,
    $Res Function(ChatResult) _then,
  ) = _$ChatResultCopyWithImpl;
  @useResult
  $Res call({String conversationId, MessageItem reply, bool cached});

  $MessageItemCopyWith<$Res> get reply;
}

/// @nodoc
class _$ChatResultCopyWithImpl<$Res> implements $ChatResultCopyWith<$Res> {
  _$ChatResultCopyWithImpl(this._self, this._then);

  final ChatResult _self;
  final $Res Function(ChatResult) _then;

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? conversationId = null,
    Object? reply = null,
    Object? cached = null,
  }) {
    return _then(
      _self.copyWith(
        conversationId: null == conversationId
            ? _self.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        reply: null == reply
            ? _self.reply
            : reply // ignore: cast_nullable_to_non_nullable
                  as MessageItem,
        cached: null == cached
            ? _self.cached
            : cached // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageItemCopyWith<$Res> get reply {
    return $MessageItemCopyWith<$Res>(_self.reply, (value) {
      return _then(_self.copyWith(reply: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ChatResult].
extension ChatResultPatterns on ChatResult {
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
    TResult Function(_ChatResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatResult() when $default != null:
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
    TResult Function(_ChatResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResult():
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
    TResult? Function(_ChatResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResult() when $default != null:
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
    TResult Function(String conversationId, MessageItem reply, bool cached)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatResult() when $default != null:
        return $default(_that.conversationId, _that.reply, _that.cached);
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
    TResult Function(String conversationId, MessageItem reply, bool cached)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResult():
        return $default(_that.conversationId, _that.reply, _that.cached);
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
    TResult? Function(String conversationId, MessageItem reply, bool cached)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatResult() when $default != null:
        return $default(_that.conversationId, _that.reply, _that.cached);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatResult implements ChatResult {
  const _ChatResult({
    required this.conversationId,
    required this.reply,
    this.cached = false,
  });
  factory _ChatResult.fromJson(Map<String, dynamic> json) =>
      _$ChatResultFromJson(json);

  @override
  final String conversationId;
  @override
  final MessageItem reply;
  @override
  @JsonKey()
  final bool cached;

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatResultCopyWith<_ChatResult> get copyWith =>
      __$ChatResultCopyWithImpl<_ChatResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatResultToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatResult &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.cached, cached) || other.cached == cached));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, conversationId, reply, cached);

  @override
  String toString() {
    return 'ChatResult(conversationId: $conversationId, reply: $reply, cached: $cached)';
  }
}

/// @nodoc
abstract mixin class _$ChatResultCopyWith<$Res>
    implements $ChatResultCopyWith<$Res> {
  factory _$ChatResultCopyWith(
    _ChatResult value,
    $Res Function(_ChatResult) _then,
  ) = __$ChatResultCopyWithImpl;
  @override
  @useResult
  $Res call({String conversationId, MessageItem reply, bool cached});

  @override
  $MessageItemCopyWith<$Res> get reply;
}

/// @nodoc
class __$ChatResultCopyWithImpl<$Res> implements _$ChatResultCopyWith<$Res> {
  __$ChatResultCopyWithImpl(this._self, this._then);

  final _ChatResult _self;
  final $Res Function(_ChatResult) _then;

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? conversationId = null,
    Object? reply = null,
    Object? cached = null,
  }) {
    return _then(
      _ChatResult(
        conversationId: null == conversationId
            ? _self.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String,
        reply: null == reply
            ? _self.reply
            : reply // ignore: cast_nullable_to_non_nullable
                  as MessageItem,
        cached: null == cached
            ? _self.cached
            : cached // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }

  /// Create a copy of ChatResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageItemCopyWith<$Res> get reply {
    return $MessageItemCopyWith<$Res>(_self.reply, (value) {
      return _then(_self.copyWith(reply: value));
    });
  }
}

/// @nodoc
mixin _$AssistantStatus {
  bool get configured;
  bool get consentRequired;
  int get retentionDays;
  int get dailyLimit;

  /// Create a copy of AssistantStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssistantStatusCopyWith<AssistantStatus> get copyWith =>
      _$AssistantStatusCopyWithImpl<AssistantStatus>(
        this as AssistantStatus,
        _$identity,
      );

  /// Serializes this AssistantStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssistantStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.consentRequired, consentRequired) ||
                other.consentRequired == consentRequired) &&
            (identical(other.retentionDays, retentionDays) ||
                other.retentionDays == retentionDays) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    consentRequired,
    retentionDays,
    dailyLimit,
  );

  @override
  String toString() {
    return 'AssistantStatus(configured: $configured, consentRequired: $consentRequired, retentionDays: $retentionDays, dailyLimit: $dailyLimit)';
  }
}

/// @nodoc
abstract mixin class $AssistantStatusCopyWith<$Res> {
  factory $AssistantStatusCopyWith(
    AssistantStatus value,
    $Res Function(AssistantStatus) _then,
  ) = _$AssistantStatusCopyWithImpl;
  @useResult
  $Res call({
    bool configured,
    bool consentRequired,
    int retentionDays,
    int dailyLimit,
  });
}

/// @nodoc
class _$AssistantStatusCopyWithImpl<$Res>
    implements $AssistantStatusCopyWith<$Res> {
  _$AssistantStatusCopyWithImpl(this._self, this._then);

  final AssistantStatus _self;
  final $Res Function(AssistantStatus) _then;

  /// Create a copy of AssistantStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configured = null,
    Object? consentRequired = null,
    Object? retentionDays = null,
    Object? dailyLimit = null,
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
        retentionDays: null == retentionDays
            ? _self.retentionDays
            : retentionDays // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyLimit: null == dailyLimit
            ? _self.dailyLimit
            : dailyLimit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AssistantStatus].
extension AssistantStatusPatterns on AssistantStatus {
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
    TResult Function(_AssistantStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus() when $default != null:
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
    TResult Function(_AssistantStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus():
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
    TResult? Function(_AssistantStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus() when $default != null:
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
      int retentionDays,
      int dailyLimit,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus() when $default != null:
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.retentionDays,
          _that.dailyLimit,
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
      int retentionDays,
      int dailyLimit,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus():
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.retentionDays,
          _that.dailyLimit,
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
      int retentionDays,
      int dailyLimit,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssistantStatus() when $default != null:
        return $default(
          _that.configured,
          _that.consentRequired,
          _that.retentionDays,
          _that.dailyLimit,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssistantStatus implements AssistantStatus {
  const _AssistantStatus({
    required this.configured,
    required this.consentRequired,
    required this.retentionDays,
    required this.dailyLimit,
  });
  factory _AssistantStatus.fromJson(Map<String, dynamic> json) =>
      _$AssistantStatusFromJson(json);

  @override
  final bool configured;
  @override
  final bool consentRequired;
  @override
  final int retentionDays;
  @override
  final int dailyLimit;

  /// Create a copy of AssistantStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssistantStatusCopyWith<_AssistantStatus> get copyWith =>
      __$AssistantStatusCopyWithImpl<_AssistantStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssistantStatusToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssistantStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.consentRequired, consentRequired) ||
                other.consentRequired == consentRequired) &&
            (identical(other.retentionDays, retentionDays) ||
                other.retentionDays == retentionDays) &&
            (identical(other.dailyLimit, dailyLimit) ||
                other.dailyLimit == dailyLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    consentRequired,
    retentionDays,
    dailyLimit,
  );

  @override
  String toString() {
    return 'AssistantStatus(configured: $configured, consentRequired: $consentRequired, retentionDays: $retentionDays, dailyLimit: $dailyLimit)';
  }
}

/// @nodoc
abstract mixin class _$AssistantStatusCopyWith<$Res>
    implements $AssistantStatusCopyWith<$Res> {
  factory _$AssistantStatusCopyWith(
    _AssistantStatus value,
    $Res Function(_AssistantStatus) _then,
  ) = __$AssistantStatusCopyWithImpl;
  @override
  @useResult
  $Res call({
    bool configured,
    bool consentRequired,
    int retentionDays,
    int dailyLimit,
  });
}

/// @nodoc
class __$AssistantStatusCopyWithImpl<$Res>
    implements _$AssistantStatusCopyWith<$Res> {
  __$AssistantStatusCopyWithImpl(this._self, this._then);

  final _AssistantStatus _self;
  final $Res Function(_AssistantStatus) _then;

  /// Create a copy of AssistantStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? configured = null,
    Object? consentRequired = null,
    Object? retentionDays = null,
    Object? dailyLimit = null,
  }) {
    return _then(
      _AssistantStatus(
        configured: null == configured
            ? _self.configured
            : configured // ignore: cast_nullable_to_non_nullable
                  as bool,
        consentRequired: null == consentRequired
            ? _self.consentRequired
            : consentRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        retentionDays: null == retentionDays
            ? _self.retentionDays
            : retentionDays // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyLimit: null == dailyLimit
            ? _self.dailyLimit
            : dailyLimit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$LifeQuery {
  int get offset;
  String get search;
  String? get status;
  String? get goalId;
  DateTime? get startsAfter;
  DateTime? get endsBefore;

  /// Create a copy of LifeQuery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LifeQueryCopyWith<LifeQuery> get copyWith =>
      _$LifeQueryCopyWithImpl<LifeQuery>(this as LifeQuery, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LifeQuery &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.startsAfter, startsAfter) ||
                other.startsAfter == startsAfter) &&
            (identical(other.endsBefore, endsBefore) ||
                other.endsBefore == endsBefore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    offset,
    search,
    status,
    goalId,
    startsAfter,
    endsBefore,
  );

  @override
  String toString() {
    return 'LifeQuery(offset: $offset, search: $search, status: $status, goalId: $goalId, startsAfter: $startsAfter, endsBefore: $endsBefore)';
  }
}

/// @nodoc
abstract mixin class $LifeQueryCopyWith<$Res> {
  factory $LifeQueryCopyWith(LifeQuery value, $Res Function(LifeQuery) _then) =
      _$LifeQueryCopyWithImpl;
  @useResult
  $Res call({
    int offset,
    String search,
    String? status,
    String? goalId,
    DateTime? startsAfter,
    DateTime? endsBefore,
  });
}

/// @nodoc
class _$LifeQueryCopyWithImpl<$Res> implements $LifeQueryCopyWith<$Res> {
  _$LifeQueryCopyWithImpl(this._self, this._then);

  final LifeQuery _self;
  final $Res Function(LifeQuery) _then;

  /// Create a copy of LifeQuery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? offset = null,
    Object? search = null,
    Object? status = freezed,
    Object? goalId = freezed,
    Object? startsAfter = freezed,
    Object? endsBefore = freezed,
  }) {
    return _then(
      _self.copyWith(
        offset: null == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int,
        search: null == search
            ? _self.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        goalId: freezed == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startsAfter: freezed == startsAfter
            ? _self.startsAfter
            : startsAfter // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endsBefore: freezed == endsBefore
            ? _self.endsBefore
            : endsBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [LifeQuery].
extension LifeQueryPatterns on LifeQuery {
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
    TResult Function(_LifeQuery value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LifeQuery() when $default != null:
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
    TResult Function(_LifeQuery value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LifeQuery():
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
    TResult? Function(_LifeQuery value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LifeQuery() when $default != null:
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
      int offset,
      String search,
      String? status,
      String? goalId,
      DateTime? startsAfter,
      DateTime? endsBefore,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LifeQuery() when $default != null:
        return $default(
          _that.offset,
          _that.search,
          _that.status,
          _that.goalId,
          _that.startsAfter,
          _that.endsBefore,
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
      int offset,
      String search,
      String? status,
      String? goalId,
      DateTime? startsAfter,
      DateTime? endsBefore,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LifeQuery():
        return $default(
          _that.offset,
          _that.search,
          _that.status,
          _that.goalId,
          _that.startsAfter,
          _that.endsBefore,
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
      int offset,
      String search,
      String? status,
      String? goalId,
      DateTime? startsAfter,
      DateTime? endsBefore,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LifeQuery() when $default != null:
        return $default(
          _that.offset,
          _that.search,
          _that.status,
          _that.goalId,
          _that.startsAfter,
          _that.endsBefore,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LifeQuery implements LifeQuery {
  const _LifeQuery({
    this.offset = 0,
    this.search = '',
    this.status,
    this.goalId,
    this.startsAfter,
    this.endsBefore,
  });

  @override
  @JsonKey()
  final int offset;
  @override
  @JsonKey()
  final String search;
  @override
  final String? status;
  @override
  final String? goalId;
  @override
  final DateTime? startsAfter;
  @override
  final DateTime? endsBefore;

  /// Create a copy of LifeQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LifeQueryCopyWith<_LifeQuery> get copyWith =>
      __$LifeQueryCopyWithImpl<_LifeQuery>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LifeQuery &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.startsAfter, startsAfter) ||
                other.startsAfter == startsAfter) &&
            (identical(other.endsBefore, endsBefore) ||
                other.endsBefore == endsBefore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    offset,
    search,
    status,
    goalId,
    startsAfter,
    endsBefore,
  );

  @override
  String toString() {
    return 'LifeQuery(offset: $offset, search: $search, status: $status, goalId: $goalId, startsAfter: $startsAfter, endsBefore: $endsBefore)';
  }
}

/// @nodoc
abstract mixin class _$LifeQueryCopyWith<$Res>
    implements $LifeQueryCopyWith<$Res> {
  factory _$LifeQueryCopyWith(
    _LifeQuery value,
    $Res Function(_LifeQuery) _then,
  ) = __$LifeQueryCopyWithImpl;
  @override
  @useResult
  $Res call({
    int offset,
    String search,
    String? status,
    String? goalId,
    DateTime? startsAfter,
    DateTime? endsBefore,
  });
}

/// @nodoc
class __$LifeQueryCopyWithImpl<$Res> implements _$LifeQueryCopyWith<$Res> {
  __$LifeQueryCopyWithImpl(this._self, this._then);

  final _LifeQuery _self;
  final $Res Function(_LifeQuery) _then;

  /// Create a copy of LifeQuery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? offset = null,
    Object? search = null,
    Object? status = freezed,
    Object? goalId = freezed,
    Object? startsAfter = freezed,
    Object? endsBefore = freezed,
  }) {
    return _then(
      _LifeQuery(
        offset: null == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int,
        search: null == search
            ? _self.search
            : search // ignore: cast_nullable_to_non_nullable
                  as String,
        status: freezed == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        goalId: freezed == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        startsAfter: freezed == startsAfter
            ? _self.startsAfter
            : startsAfter // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endsBefore: freezed == endsBefore
            ? _self.endsBefore
            : endsBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
