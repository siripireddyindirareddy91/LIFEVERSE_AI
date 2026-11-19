// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowItem {
  String get id;
  String get title;
  Map<String, dynamic> get definition;
  String get revision;
  bool get enabled;
  String get digest;
  List<String> get permissions;
  DateTime get createdAt;

  /// Create a copy of WorkflowItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowItemCopyWith<WorkflowItem> get copyWith =>
      _$WorkflowItemCopyWithImpl<WorkflowItem>(
        this as WorkflowItem,
        _$identity,
      );

  /// Serializes this WorkflowItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(
              other.definition,
              definition,
            ) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.digest, digest) || other.digest == digest) &&
            const DeepCollectionEquality().equals(
              other.permissions,
              permissions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(definition),
    revision,
    enabled,
    digest,
    const DeepCollectionEquality().hash(permissions),
    createdAt,
  );

  @override
  String toString() {
    return 'WorkflowItem(id: $id, title: $title, definition: $definition, revision: $revision, enabled: $enabled, digest: $digest, permissions: $permissions, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $WorkflowItemCopyWith<$Res> {
  factory $WorkflowItemCopyWith(
    WorkflowItem value,
    $Res Function(WorkflowItem) _then,
  ) = _$WorkflowItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    Map<String, dynamic> definition,
    String revision,
    bool enabled,
    String digest,
    List<String> permissions,
    DateTime createdAt,
  });
}

/// @nodoc
class _$WorkflowItemCopyWithImpl<$Res> implements $WorkflowItemCopyWith<$Res> {
  _$WorkflowItemCopyWithImpl(this._self, this._then);

  final WorkflowItem _self;
  final $Res Function(WorkflowItem) _then;

  /// Create a copy of WorkflowItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? definition = null,
    Object? revision = null,
    Object? enabled = null,
    Object? digest = null,
    Object? permissions = null,
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
        definition: null == definition
            ? _self.definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        digest: null == digest
            ? _self.digest
            : digest // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _self.permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WorkflowItem].
extension WorkflowItemPatterns on WorkflowItem {
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
    TResult Function(_WorkflowItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem() when $default != null:
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
    TResult Function(_WorkflowItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem():
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
    TResult? Function(_WorkflowItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem() when $default != null:
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
      Map<String, dynamic> definition,
      String revision,
      bool enabled,
      String digest,
      List<String> permissions,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.definition,
          _that.revision,
          _that.enabled,
          _that.digest,
          _that.permissions,
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
      Map<String, dynamic> definition,
      String revision,
      bool enabled,
      String digest,
      List<String> permissions,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem():
        return $default(
          _that.id,
          _that.title,
          _that.definition,
          _that.revision,
          _that.enabled,
          _that.digest,
          _that.permissions,
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
      Map<String, dynamic> definition,
      String revision,
      bool enabled,
      String digest,
      List<String> permissions,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.definition,
          _that.revision,
          _that.enabled,
          _that.digest,
          _that.permissions,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowItem implements WorkflowItem {
  const _WorkflowItem({
    required this.id,
    required this.title,
    required final Map<String, dynamic> definition,
    required this.revision,
    required this.enabled,
    required this.digest,
    required final List<String> permissions,
    required this.createdAt,
  }) : _definition = definition,
       _permissions = permissions;
  factory _WorkflowItem.fromJson(Map<String, dynamic> json) =>
      _$WorkflowItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final Map<String, dynamic> _definition;
  @override
  Map<String, dynamic> get definition {
    if (_definition is EqualUnmodifiableMapView) return _definition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_definition);
  }

  @override
  final String revision;
  @override
  final bool enabled;
  @override
  final String digest;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final DateTime createdAt;

  /// Create a copy of WorkflowItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowItemCopyWith<_WorkflowItem> get copyWith =>
      __$WorkflowItemCopyWithImpl<_WorkflowItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(
              other._definition,
              _definition,
            ) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.digest, digest) || other.digest == digest) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_definition),
    revision,
    enabled,
    digest,
    const DeepCollectionEquality().hash(_permissions),
    createdAt,
  );

  @override
  String toString() {
    return 'WorkflowItem(id: $id, title: $title, definition: $definition, revision: $revision, enabled: $enabled, digest: $digest, permissions: $permissions, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowItemCopyWith<$Res>
    implements $WorkflowItemCopyWith<$Res> {
  factory _$WorkflowItemCopyWith(
    _WorkflowItem value,
    $Res Function(_WorkflowItem) _then,
  ) = __$WorkflowItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    Map<String, dynamic> definition,
    String revision,
    bool enabled,
    String digest,
    List<String> permissions,
    DateTime createdAt,
  });
}

/// @nodoc
class __$WorkflowItemCopyWithImpl<$Res>
    implements _$WorkflowItemCopyWith<$Res> {
  __$WorkflowItemCopyWithImpl(this._self, this._then);

  final _WorkflowItem _self;
  final $Res Function(_WorkflowItem) _then;

  /// Create a copy of WorkflowItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? definition = null,
    Object? revision = null,
    Object? enabled = null,
    Object? digest = null,
    Object? permissions = null,
    Object? createdAt = null,
  }) {
    return _then(
      _WorkflowItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        definition: null == definition
            ? _self._definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        digest: null == digest
            ? _self.digest
            : digest // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _self._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$WorkflowStep {
  int get index;
  String get type;
  String get status;
  String get summary;
  DateTime get at;
  Map<String, dynamic>? get result;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowStepCopyWith<WorkflowStep> get copyWith =>
      _$WorkflowStepCopyWithImpl<WorkflowStep>(
        this as WorkflowStep,
        _$identity,
      );

  /// Serializes this WorkflowStep to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowStep &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.at, at) || other.at == at) &&
            const DeepCollectionEquality().equals(other.result, result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    type,
    status,
    summary,
    at,
    const DeepCollectionEquality().hash(result),
  );

  @override
  String toString() {
    return 'WorkflowStep(index: $index, type: $type, status: $status, summary: $summary, at: $at, result: $result)';
  }
}

/// @nodoc
abstract mixin class $WorkflowStepCopyWith<$Res> {
  factory $WorkflowStepCopyWith(
    WorkflowStep value,
    $Res Function(WorkflowStep) _then,
  ) = _$WorkflowStepCopyWithImpl;
  @useResult
  $Res call({
    int index,
    String type,
    String status,
    String summary,
    DateTime at,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class _$WorkflowStepCopyWithImpl<$Res> implements $WorkflowStepCopyWith<$Res> {
  _$WorkflowStepCopyWithImpl(this._self, this._then);

  final WorkflowStep _self;
  final $Res Function(WorkflowStep) _then;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? type = null,
    Object? status = null,
    Object? summary = null,
    Object? at = null,
    Object? result = freezed,
  }) {
    return _then(
      _self.copyWith(
        index: null == index
            ? _self.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        at: null == at
            ? _self.at
            : at // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        result: freezed == result
            ? _self.result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WorkflowStep].
extension WorkflowStepPatterns on WorkflowStep {
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
    TResult Function(_WorkflowStep value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep() when $default != null:
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
    TResult Function(_WorkflowStep value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep():
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
    TResult? Function(_WorkflowStep value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep() when $default != null:
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
      int index,
      String type,
      String status,
      String summary,
      DateTime at,
      Map<String, dynamic>? result,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep() when $default != null:
        return $default(
          _that.index,
          _that.type,
          _that.status,
          _that.summary,
          _that.at,
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
      int index,
      String type,
      String status,
      String summary,
      DateTime at,
      Map<String, dynamic>? result,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep():
        return $default(
          _that.index,
          _that.type,
          _that.status,
          _that.summary,
          _that.at,
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
      int index,
      String type,
      String status,
      String summary,
      DateTime at,
      Map<String, dynamic>? result,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowStep() when $default != null:
        return $default(
          _that.index,
          _that.type,
          _that.status,
          _that.summary,
          _that.at,
          _that.result,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowStep implements WorkflowStep {
  const _WorkflowStep({
    required this.index,
    required this.type,
    required this.status,
    required this.summary,
    required this.at,
    final Map<String, dynamic>? result,
  }) : _result = result;
  factory _WorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStepFromJson(json);

  @override
  final int index;
  @override
  final String type;
  @override
  final String status;
  @override
  final String summary;
  @override
  final DateTime at;
  final Map<String, dynamic>? _result;
  @override
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowStepCopyWith<_WorkflowStep> get copyWith =>
      __$WorkflowStepCopyWithImpl<_WorkflowStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowStepToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowStep &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.at, at) || other.at == at) &&
            const DeepCollectionEquality().equals(other._result, _result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    index,
    type,
    status,
    summary,
    at,
    const DeepCollectionEquality().hash(_result),
  );

  @override
  String toString() {
    return 'WorkflowStep(index: $index, type: $type, status: $status, summary: $summary, at: $at, result: $result)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowStepCopyWith<$Res>
    implements $WorkflowStepCopyWith<$Res> {
  factory _$WorkflowStepCopyWith(
    _WorkflowStep value,
    $Res Function(_WorkflowStep) _then,
  ) = __$WorkflowStepCopyWithImpl;
  @override
  @useResult
  $Res call({
    int index,
    String type,
    String status,
    String summary,
    DateTime at,
    Map<String, dynamic>? result,
  });
}

/// @nodoc
class __$WorkflowStepCopyWithImpl<$Res>
    implements _$WorkflowStepCopyWith<$Res> {
  __$WorkflowStepCopyWithImpl(this._self, this._then);

  final _WorkflowStep _self;
  final $Res Function(_WorkflowStep) _then;

  /// Create a copy of WorkflowStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? index = null,
    Object? type = null,
    Object? status = null,
    Object? summary = null,
    Object? at = null,
    Object? result = freezed,
  }) {
    return _then(
      _WorkflowStep(
        index: null == index
            ? _self.index
            : index // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        at: null == at
            ? _self.at
            : at // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        result: freezed == result
            ? _self._result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
mixin _$WorkflowRun {
  String get id;
  String get workflowId;
  String get revision;
  String get status;
  int get cursor;
  List<WorkflowStep> get steps;
  String get summary;
  String get error;
  int get attempts;
  String? get agentRunId;
  String? get proposalRunId;
  DateTime get createdAt;
  DateTime? get startedAt;
  DateTime? get finishedAt;
  DateTime get expiresAt;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WorkflowRunCopyWith<WorkflowRun> get copyWith =>
      _$WorkflowRunCopyWithImpl<WorkflowRun>(this as WorkflowRun, _$identity);

  /// Serializes this WorkflowRun to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WorkflowRun &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            const DeepCollectionEquality().equals(other.steps, steps) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.agentRunId, agentRunId) ||
                other.agentRunId == agentRunId) &&
            (identical(other.proposalRunId, proposalRunId) ||
                other.proposalRunId == proposalRunId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workflowId,
    revision,
    status,
    cursor,
    const DeepCollectionEquality().hash(steps),
    summary,
    error,
    attempts,
    agentRunId,
    proposalRunId,
    createdAt,
    startedAt,
    finishedAt,
    expiresAt,
  );

  @override
  String toString() {
    return 'WorkflowRun(id: $id, workflowId: $workflowId, revision: $revision, status: $status, cursor: $cursor, steps: $steps, summary: $summary, error: $error, attempts: $attempts, agentRunId: $agentRunId, proposalRunId: $proposalRunId, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $WorkflowRunCopyWith<$Res> {
  factory $WorkflowRunCopyWith(
    WorkflowRun value,
    $Res Function(WorkflowRun) _then,
  ) = _$WorkflowRunCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String workflowId,
    String revision,
    String status,
    int cursor,
    List<WorkflowStep> steps,
    String summary,
    String error,
    int attempts,
    String? agentRunId,
    String? proposalRunId,
    DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$WorkflowRunCopyWithImpl<$Res> implements $WorkflowRunCopyWith<$Res> {
  _$WorkflowRunCopyWithImpl(this._self, this._then);

  final WorkflowRun _self;
  final $Res Function(WorkflowRun) _then;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? revision = null,
    Object? status = null,
    Object? cursor = null,
    Object? steps = null,
    Object? summary = null,
    Object? error = null,
    Object? attempts = null,
    Object? agentRunId = freezed,
    Object? proposalRunId = freezed,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? expiresAt = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workflowId: null == workflowId
            ? _self.workflowId
            : workflowId // ignore: cast_nullable_to_non_nullable
                  as String,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        cursor: null == cursor
            ? _self.cursor
            : cursor // ignore: cast_nullable_to_non_nullable
                  as int,
        steps: null == steps
            ? _self.steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<WorkflowStep>,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        attempts: null == attempts
            ? _self.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
        agentRunId: freezed == agentRunId
            ? _self.agentRunId
            : agentRunId // ignore: cast_nullable_to_non_nullable
                  as String?,
        proposalRunId: freezed == proposalRunId
            ? _self.proposalRunId
            : proposalRunId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startedAt: freezed == startedAt
            ? _self.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        finishedAt: freezed == finishedAt
            ? _self.finishedAt
            : finishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [WorkflowRun].
extension WorkflowRunPatterns on WorkflowRun {
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
    TResult Function(_WorkflowRun value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun() when $default != null:
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
    TResult Function(_WorkflowRun value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun():
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
    TResult? Function(_WorkflowRun value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun() when $default != null:
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
      String workflowId,
      String revision,
      String status,
      int cursor,
      List<WorkflowStep> steps,
      String summary,
      String error,
      int attempts,
      String? agentRunId,
      String? proposalRunId,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? finishedAt,
      DateTime expiresAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun() when $default != null:
        return $default(
          _that.id,
          _that.workflowId,
          _that.revision,
          _that.status,
          _that.cursor,
          _that.steps,
          _that.summary,
          _that.error,
          _that.attempts,
          _that.agentRunId,
          _that.proposalRunId,
          _that.createdAt,
          _that.startedAt,
          _that.finishedAt,
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
      String workflowId,
      String revision,
      String status,
      int cursor,
      List<WorkflowStep> steps,
      String summary,
      String error,
      int attempts,
      String? agentRunId,
      String? proposalRunId,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? finishedAt,
      DateTime expiresAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun():
        return $default(
          _that.id,
          _that.workflowId,
          _that.revision,
          _that.status,
          _that.cursor,
          _that.steps,
          _that.summary,
          _that.error,
          _that.attempts,
          _that.agentRunId,
          _that.proposalRunId,
          _that.createdAt,
          _that.startedAt,
          _that.finishedAt,
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
      String workflowId,
      String revision,
      String status,
      int cursor,
      List<WorkflowStep> steps,
      String summary,
      String error,
      int attempts,
      String? agentRunId,
      String? proposalRunId,
      DateTime createdAt,
      DateTime? startedAt,
      DateTime? finishedAt,
      DateTime expiresAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WorkflowRun() when $default != null:
        return $default(
          _that.id,
          _that.workflowId,
          _that.revision,
          _that.status,
          _that.cursor,
          _that.steps,
          _that.summary,
          _that.error,
          _that.attempts,
          _that.agentRunId,
          _that.proposalRunId,
          _that.createdAt,
          _that.startedAt,
          _that.finishedAt,
          _that.expiresAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _WorkflowRun extends WorkflowRun {
  const _WorkflowRun({
    required this.id,
    required this.workflowId,
    required this.revision,
    required this.status,
    required this.cursor,
    final List<WorkflowStep> steps = const [],
    this.summary = '',
    this.error = '',
    this.attempts = 0,
    this.agentRunId,
    this.proposalRunId,
    required this.createdAt,
    this.startedAt,
    this.finishedAt,
    required this.expiresAt,
  }) : _steps = steps,
       super._();
  factory _WorkflowRun.fromJson(Map<String, dynamic> json) =>
      _$WorkflowRunFromJson(json);

  @override
  final String id;
  @override
  final String workflowId;
  @override
  final String revision;
  @override
  final String status;
  @override
  final int cursor;
  final List<WorkflowStep> _steps;
  @override
  @JsonKey()
  List<WorkflowStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  @JsonKey()
  final String summary;
  @override
  @JsonKey()
  final String error;
  @override
  @JsonKey()
  final int attempts;
  @override
  final String? agentRunId;
  @override
  final String? proposalRunId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final DateTime expiresAt;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WorkflowRunCopyWith<_WorkflowRun> get copyWith =>
      __$WorkflowRunCopyWithImpl<_WorkflowRun>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WorkflowRunToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WorkflowRun &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workflowId, workflowId) ||
                other.workflowId == workflowId) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.agentRunId, agentRunId) ||
                other.agentRunId == agentRunId) &&
            (identical(other.proposalRunId, proposalRunId) ||
                other.proposalRunId == proposalRunId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workflowId,
    revision,
    status,
    cursor,
    const DeepCollectionEquality().hash(_steps),
    summary,
    error,
    attempts,
    agentRunId,
    proposalRunId,
    createdAt,
    startedAt,
    finishedAt,
    expiresAt,
  );

  @override
  String toString() {
    return 'WorkflowRun(id: $id, workflowId: $workflowId, revision: $revision, status: $status, cursor: $cursor, steps: $steps, summary: $summary, error: $error, attempts: $attempts, agentRunId: $agentRunId, proposalRunId: $proposalRunId, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$WorkflowRunCopyWith<$Res>
    implements $WorkflowRunCopyWith<$Res> {
  factory _$WorkflowRunCopyWith(
    _WorkflowRun value,
    $Res Function(_WorkflowRun) _then,
  ) = __$WorkflowRunCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String workflowId,
    String revision,
    String status,
    int cursor,
    List<WorkflowStep> steps,
    String summary,
    String error,
    int attempts,
    String? agentRunId,
    String? proposalRunId,
    DateTime createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$WorkflowRunCopyWithImpl<$Res> implements _$WorkflowRunCopyWith<$Res> {
  __$WorkflowRunCopyWithImpl(this._self, this._then);

  final _WorkflowRun _self;
  final $Res Function(_WorkflowRun) _then;

  /// Create a copy of WorkflowRun
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? workflowId = null,
    Object? revision = null,
    Object? status = null,
    Object? cursor = null,
    Object? steps = null,
    Object? summary = null,
    Object? error = null,
    Object? attempts = null,
    Object? agentRunId = freezed,
    Object? proposalRunId = freezed,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? expiresAt = null,
  }) {
    return _then(
      _WorkflowRun(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        workflowId: null == workflowId
            ? _self.workflowId
            : workflowId // ignore: cast_nullable_to_non_nullable
                  as String,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        cursor: null == cursor
            ? _self.cursor
            : cursor // ignore: cast_nullable_to_non_nullable
                  as int,
        steps: null == steps
            ? _self._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<WorkflowStep>,
        summary: null == summary
            ? _self.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        attempts: null == attempts
            ? _self.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
        agentRunId: freezed == agentRunId
            ? _self.agentRunId
            : agentRunId // ignore: cast_nullable_to_non_nullable
                  as String?,
        proposalRunId: freezed == proposalRunId
            ? _self.proposalRunId
            : proposalRunId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startedAt: freezed == startedAt
            ? _self.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        finishedAt: freezed == finishedAt
            ? _self.finishedAt
            : finishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$InboxItem {
  String get id;
  String get title;
  String get body;
  String get route;
  DateTime get dueAt;
  DateTime? get readAt;
  bool get cancelled;
  DateTime get createdAt;
  DateTime get expiresAt;

  /// Create a copy of InboxItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InboxItemCopyWith<InboxItem> get copyWith =>
      _$InboxItemCopyWithImpl<InboxItem>(this as InboxItem, _$identity);

  /// Serializes this InboxItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InboxItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    body,
    route,
    dueAt,
    readAt,
    cancelled,
    createdAt,
    expiresAt,
  );

  @override
  String toString() {
    return 'InboxItem(id: $id, title: $title, body: $body, route: $route, dueAt: $dueAt, readAt: $readAt, cancelled: $cancelled, createdAt: $createdAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class $InboxItemCopyWith<$Res> {
  factory $InboxItemCopyWith(InboxItem value, $Res Function(InboxItem) _then) =
      _$InboxItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    String route,
    DateTime dueAt,
    DateTime? readAt,
    bool cancelled,
    DateTime createdAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$InboxItemCopyWithImpl<$Res> implements $InboxItemCopyWith<$Res> {
  _$InboxItemCopyWithImpl(this._self, this._then);

  final InboxItem _self;
  final $Res Function(InboxItem) _then;

  /// Create a copy of InboxItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? route = null,
    Object? dueAt = null,
    Object? readAt = freezed,
    Object? cancelled = null,
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
        body: null == body
            ? _self.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _self.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        dueAt: null == dueAt
            ? _self.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        readAt: freezed == readAt
            ? _self.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelled: null == cancelled
            ? _self.cancelled
            : cancelled // ignore: cast_nullable_to_non_nullable
                  as bool,
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

/// Adds pattern-matching-related methods to [InboxItem].
extension InboxItemPatterns on InboxItem {
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
    TResult Function(_InboxItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InboxItem() when $default != null:
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
    TResult Function(_InboxItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InboxItem():
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
    TResult? Function(_InboxItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InboxItem() when $default != null:
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
      String body,
      String route,
      DateTime dueAt,
      DateTime? readAt,
      bool cancelled,
      DateTime createdAt,
      DateTime expiresAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InboxItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.body,
          _that.route,
          _that.dueAt,
          _that.readAt,
          _that.cancelled,
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
      String body,
      String route,
      DateTime dueAt,
      DateTime? readAt,
      bool cancelled,
      DateTime createdAt,
      DateTime expiresAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InboxItem():
        return $default(
          _that.id,
          _that.title,
          _that.body,
          _that.route,
          _that.dueAt,
          _that.readAt,
          _that.cancelled,
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
      String body,
      String route,
      DateTime dueAt,
      DateTime? readAt,
      bool cancelled,
      DateTime createdAt,
      DateTime expiresAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InboxItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.body,
          _that.route,
          _that.dueAt,
          _that.readAt,
          _that.cancelled,
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
class _InboxItem implements InboxItem {
  const _InboxItem({
    required this.id,
    required this.title,
    required this.body,
    required this.route,
    required this.dueAt,
    this.readAt,
    required this.cancelled,
    required this.createdAt,
    required this.expiresAt,
  });
  factory _InboxItem.fromJson(Map<String, dynamic> json) =>
      _$InboxItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String route;
  @override
  final DateTime dueAt;
  @override
  final DateTime? readAt;
  @override
  final bool cancelled;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;

  /// Create a copy of InboxItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InboxItemCopyWith<_InboxItem> get copyWith =>
      __$InboxItemCopyWithImpl<_InboxItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$InboxItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InboxItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    body,
    route,
    dueAt,
    readAt,
    cancelled,
    createdAt,
    expiresAt,
  );

  @override
  String toString() {
    return 'InboxItem(id: $id, title: $title, body: $body, route: $route, dueAt: $dueAt, readAt: $readAt, cancelled: $cancelled, createdAt: $createdAt, expiresAt: $expiresAt)';
  }
}

/// @nodoc
abstract mixin class _$InboxItemCopyWith<$Res>
    implements $InboxItemCopyWith<$Res> {
  factory _$InboxItemCopyWith(
    _InboxItem value,
    $Res Function(_InboxItem) _then,
  ) = __$InboxItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String body,
    String route,
    DateTime dueAt,
    DateTime? readAt,
    bool cancelled,
    DateTime createdAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$InboxItemCopyWithImpl<$Res> implements _$InboxItemCopyWith<$Res> {
  __$InboxItemCopyWithImpl(this._self, this._then);

  final _InboxItem _self;
  final $Res Function(_InboxItem) _then;

  /// Create a copy of InboxItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? route = null,
    Object? dueAt = null,
    Object? readAt = freezed,
    Object? cancelled = null,
    Object? createdAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _InboxItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _self.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _self.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        dueAt: null == dueAt
            ? _self.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        readAt: freezed == readAt
            ? _self.readAt
            : readAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelled: null == cancelled
            ? _self.cancelled
            : cancelled // ignore: cast_nullable_to_non_nullable
                  as bool,
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
mixin _$CalendarConnection {
  String get id;
  String get title;
  String get provider;
  bool get writable;
  bool get active;
  String get revision;
  DateTime? get lastSyncAt;
  String get error;
  DateTime get createdAt;

  /// Create a copy of CalendarConnection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarConnectionCopyWith<CalendarConnection> get copyWith =>
      _$CalendarConnectionCopyWithImpl<CalendarConnection>(
        this as CalendarConnection,
        _$identity,
      );

  /// Serializes this CalendarConnection to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.writable, writable) ||
                other.writable == writable) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    provider,
    writable,
    active,
    revision,
    lastSyncAt,
    error,
    createdAt,
  );

  @override
  String toString() {
    return 'CalendarConnection(id: $id, title: $title, provider: $provider, writable: $writable, active: $active, revision: $revision, lastSyncAt: $lastSyncAt, error: $error, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CalendarConnectionCopyWith<$Res> {
  factory $CalendarConnectionCopyWith(
    CalendarConnection value,
    $Res Function(CalendarConnection) _then,
  ) = _$CalendarConnectionCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String provider,
    bool writable,
    bool active,
    String revision,
    DateTime? lastSyncAt,
    String error,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CalendarConnectionCopyWithImpl<$Res>
    implements $CalendarConnectionCopyWith<$Res> {
  _$CalendarConnectionCopyWithImpl(this._self, this._then);

  final CalendarConnection _self;
  final $Res Function(CalendarConnection) _then;

  /// Create a copy of CalendarConnection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? provider = null,
    Object? writable = null,
    Object? active = null,
    Object? revision = null,
    Object? lastSyncAt = freezed,
    Object? error = null,
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
        provider: null == provider
            ? _self.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        writable: null == writable
            ? _self.writable
            : writable // ignore: cast_nullable_to_non_nullable
                  as bool,
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSyncAt: freezed == lastSyncAt
            ? _self.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CalendarConnection].
extension CalendarConnectionPatterns on CalendarConnection {
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
    TResult Function(_CalendarConnection value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection() when $default != null:
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
    TResult Function(_CalendarConnection value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection():
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
    TResult? Function(_CalendarConnection value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection() when $default != null:
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
      String provider,
      bool writable,
      bool active,
      String revision,
      DateTime? lastSyncAt,
      String error,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.provider,
          _that.writable,
          _that.active,
          _that.revision,
          _that.lastSyncAt,
          _that.error,
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
      String provider,
      bool writable,
      bool active,
      String revision,
      DateTime? lastSyncAt,
      String error,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection():
        return $default(
          _that.id,
          _that.title,
          _that.provider,
          _that.writable,
          _that.active,
          _that.revision,
          _that.lastSyncAt,
          _that.error,
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
      String provider,
      bool writable,
      bool active,
      String revision,
      DateTime? lastSyncAt,
      String error,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarConnection() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.provider,
          _that.writable,
          _that.active,
          _that.revision,
          _that.lastSyncAt,
          _that.error,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CalendarConnection implements CalendarConnection {
  const _CalendarConnection({
    required this.id,
    required this.title,
    required this.provider,
    required this.writable,
    required this.active,
    required this.revision,
    this.lastSyncAt,
    this.error = '',
    required this.createdAt,
  });
  factory _CalendarConnection.fromJson(Map<String, dynamic> json) =>
      _$CalendarConnectionFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String provider;
  @override
  final bool writable;
  @override
  final bool active;
  @override
  final String revision;
  @override
  final DateTime? lastSyncAt;
  @override
  @JsonKey()
  final String error;
  @override
  final DateTime createdAt;

  /// Create a copy of CalendarConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarConnectionCopyWith<_CalendarConnection> get copyWith =>
      __$CalendarConnectionCopyWithImpl<_CalendarConnection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CalendarConnectionToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarConnection &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.writable, writable) ||
                other.writable == writable) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    provider,
    writable,
    active,
    revision,
    lastSyncAt,
    error,
    createdAt,
  );

  @override
  String toString() {
    return 'CalendarConnection(id: $id, title: $title, provider: $provider, writable: $writable, active: $active, revision: $revision, lastSyncAt: $lastSyncAt, error: $error, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CalendarConnectionCopyWith<$Res>
    implements $CalendarConnectionCopyWith<$Res> {
  factory _$CalendarConnectionCopyWith(
    _CalendarConnection value,
    $Res Function(_CalendarConnection) _then,
  ) = __$CalendarConnectionCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String provider,
    bool writable,
    bool active,
    String revision,
    DateTime? lastSyncAt,
    String error,
    DateTime createdAt,
  });
}

/// @nodoc
class __$CalendarConnectionCopyWithImpl<$Res>
    implements _$CalendarConnectionCopyWith<$Res> {
  __$CalendarConnectionCopyWithImpl(this._self, this._then);

  final _CalendarConnection _self;
  final $Res Function(_CalendarConnection) _then;

  /// Create a copy of CalendarConnection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? provider = null,
    Object? writable = null,
    Object? active = null,
    Object? revision = null,
    Object? lastSyncAt = freezed,
    Object? error = null,
    Object? createdAt = null,
  }) {
    return _then(
      _CalendarConnection(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _self.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        writable: null == writable
            ? _self.writable
            : writable // ignore: cast_nullable_to_non_nullable
                  as bool,
        active: null == active
            ? _self.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        lastSyncAt: freezed == lastSyncAt
            ? _self.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
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
mixin _$CalendarMirror {
  String get id;
  String get title;
  DateTime get startsAt;
  DateTime get endsAt;
  bool get allDay;
  String? get localEventId;

  /// Create a copy of CalendarMirror
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarMirrorCopyWith<CalendarMirror> get copyWith =>
      _$CalendarMirrorCopyWithImpl<CalendarMirror>(
        this as CalendarMirror,
        _$identity,
      );

  /// Serializes this CalendarMirror to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarMirror &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.allDay, allDay) || other.allDay == allDay) &&
            (identical(other.localEventId, localEventId) ||
                other.localEventId == localEventId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    startsAt,
    endsAt,
    allDay,
    localEventId,
  );

  @override
  String toString() {
    return 'CalendarMirror(id: $id, title: $title, startsAt: $startsAt, endsAt: $endsAt, allDay: $allDay, localEventId: $localEventId)';
  }
}

/// @nodoc
abstract mixin class $CalendarMirrorCopyWith<$Res> {
  factory $CalendarMirrorCopyWith(
    CalendarMirror value,
    $Res Function(CalendarMirror) _then,
  ) = _$CalendarMirrorCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    DateTime startsAt,
    DateTime endsAt,
    bool allDay,
    String? localEventId,
  });
}

/// @nodoc
class _$CalendarMirrorCopyWithImpl<$Res>
    implements $CalendarMirrorCopyWith<$Res> {
  _$CalendarMirrorCopyWithImpl(this._self, this._then);

  final CalendarMirror _self;
  final $Res Function(CalendarMirror) _then;

  /// Create a copy of CalendarMirror
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? allDay = null,
    Object? localEventId = freezed,
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
        startsAt: null == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endsAt: null == endsAt
            ? _self.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        allDay: null == allDay
            ? _self.allDay
            : allDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        localEventId: freezed == localEventId
            ? _self.localEventId
            : localEventId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CalendarMirror].
extension CalendarMirrorPatterns on CalendarMirror {
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
    TResult Function(_CalendarMirror value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror() when $default != null:
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
    TResult Function(_CalendarMirror value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror():
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
    TResult? Function(_CalendarMirror value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror() when $default != null:
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
      DateTime startsAt,
      DateTime endsAt,
      bool allDay,
      String? localEventId,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.startsAt,
          _that.endsAt,
          _that.allDay,
          _that.localEventId,
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
      DateTime startsAt,
      DateTime endsAt,
      bool allDay,
      String? localEventId,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror():
        return $default(
          _that.id,
          _that.title,
          _that.startsAt,
          _that.endsAt,
          _that.allDay,
          _that.localEventId,
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
      DateTime startsAt,
      DateTime endsAt,
      bool allDay,
      String? localEventId,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarMirror() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.startsAt,
          _that.endsAt,
          _that.allDay,
          _that.localEventId,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CalendarMirror implements CalendarMirror {
  const _CalendarMirror({
    required this.id,
    required this.title,
    required this.startsAt,
    required this.endsAt,
    required this.allDay,
    this.localEventId,
  });
  factory _CalendarMirror.fromJson(Map<String, dynamic> json) =>
      _$CalendarMirrorFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final bool allDay;
  @override
  final String? localEventId;

  /// Create a copy of CalendarMirror
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarMirrorCopyWith<_CalendarMirror> get copyWith =>
      __$CalendarMirrorCopyWithImpl<_CalendarMirror>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CalendarMirrorToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarMirror &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startsAt, startsAt) ||
                other.startsAt == startsAt) &&
            (identical(other.endsAt, endsAt) || other.endsAt == endsAt) &&
            (identical(other.allDay, allDay) || other.allDay == allDay) &&
            (identical(other.localEventId, localEventId) ||
                other.localEventId == localEventId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    startsAt,
    endsAt,
    allDay,
    localEventId,
  );

  @override
  String toString() {
    return 'CalendarMirror(id: $id, title: $title, startsAt: $startsAt, endsAt: $endsAt, allDay: $allDay, localEventId: $localEventId)';
  }
}

/// @nodoc
abstract mixin class _$CalendarMirrorCopyWith<$Res>
    implements $CalendarMirrorCopyWith<$Res> {
  factory _$CalendarMirrorCopyWith(
    _CalendarMirror value,
    $Res Function(_CalendarMirror) _then,
  ) = __$CalendarMirrorCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    DateTime startsAt,
    DateTime endsAt,
    bool allDay,
    String? localEventId,
  });
}

/// @nodoc
class __$CalendarMirrorCopyWithImpl<$Res>
    implements _$CalendarMirrorCopyWith<$Res> {
  __$CalendarMirrorCopyWithImpl(this._self, this._then);

  final _CalendarMirror _self;
  final $Res Function(_CalendarMirror) _then;

  /// Create a copy of CalendarMirror
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? startsAt = null,
    Object? endsAt = null,
    Object? allDay = null,
    Object? localEventId = freezed,
  }) {
    return _then(
      _CalendarMirror(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        startsAt: null == startsAt
            ? _self.startsAt
            : startsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endsAt: null == endsAt
            ? _self.endsAt
            : endsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        allDay: null == allDay
            ? _self.allDay
            : allDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        localEventId: freezed == localEventId
            ? _self.localEventId
            : localEventId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
mixin _$CalendarExport {
  String get id;
  String get connectionId;
  String get localEventId;
  Map<String, dynamic> get payload;
  String get digest;
  String get nonce;
  String get status;
  String? get remoteId;
  String get error;
  DateTime get expiresAt;
  DateTime get createdAt;

  /// Create a copy of CalendarExport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarExportCopyWith<CalendarExport> get copyWith =>
      _$CalendarExportCopyWithImpl<CalendarExport>(
        this as CalendarExport,
        _$identity,
      );

  /// Serializes this CalendarExport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarExport &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.connectionId, connectionId) ||
                other.connectionId == connectionId) &&
            (identical(other.localEventId, localEventId) ||
                other.localEventId == localEventId) &&
            const DeepCollectionEquality().equals(other.payload, payload) &&
            (identical(other.digest, digest) || other.digest == digest) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.remoteId, remoteId) ||
                other.remoteId == remoteId) &&
            (identical(other.error, error) || other.error == error) &&
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
    connectionId,
    localEventId,
    const DeepCollectionEquality().hash(payload),
    digest,
    nonce,
    status,
    remoteId,
    error,
    expiresAt,
    createdAt,
  );

  @override
  String toString() {
    return 'CalendarExport(id: $id, connectionId: $connectionId, localEventId: $localEventId, payload: $payload, digest: $digest, nonce: $nonce, status: $status, remoteId: $remoteId, error: $error, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CalendarExportCopyWith<$Res> {
  factory $CalendarExportCopyWith(
    CalendarExport value,
    $Res Function(CalendarExport) _then,
  ) = _$CalendarExportCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String connectionId,
    String localEventId,
    Map<String, dynamic> payload,
    String digest,
    String nonce,
    String status,
    String? remoteId,
    String error,
    DateTime expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CalendarExportCopyWithImpl<$Res>
    implements $CalendarExportCopyWith<$Res> {
  _$CalendarExportCopyWithImpl(this._self, this._then);

  final CalendarExport _self;
  final $Res Function(CalendarExport) _then;

  /// Create a copy of CalendarExport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? connectionId = null,
    Object? localEventId = null,
    Object? payload = null,
    Object? digest = null,
    Object? nonce = null,
    Object? status = null,
    Object? remoteId = freezed,
    Object? error = null,
    Object? expiresAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        connectionId: null == connectionId
            ? _self.connectionId
            : connectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        localEventId: null == localEventId
            ? _self.localEventId
            : localEventId // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _self.payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        digest: null == digest
            ? _self.digest
            : digest // ignore: cast_nullable_to_non_nullable
                  as String,
        nonce: null == nonce
            ? _self.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        remoteId: freezed == remoteId
            ? _self.remoteId
            : remoteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [CalendarExport].
extension CalendarExportPatterns on CalendarExport {
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
    TResult Function(_CalendarExport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarExport() when $default != null:
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
    TResult Function(_CalendarExport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarExport():
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
    TResult? Function(_CalendarExport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarExport() when $default != null:
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
      String connectionId,
      String localEventId,
      Map<String, dynamic> payload,
      String digest,
      String nonce,
      String status,
      String? remoteId,
      String error,
      DateTime expiresAt,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CalendarExport() when $default != null:
        return $default(
          _that.id,
          _that.connectionId,
          _that.localEventId,
          _that.payload,
          _that.digest,
          _that.nonce,
          _that.status,
          _that.remoteId,
          _that.error,
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
      String connectionId,
      String localEventId,
      Map<String, dynamic> payload,
      String digest,
      String nonce,
      String status,
      String? remoteId,
      String error,
      DateTime expiresAt,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarExport():
        return $default(
          _that.id,
          _that.connectionId,
          _that.localEventId,
          _that.payload,
          _that.digest,
          _that.nonce,
          _that.status,
          _that.remoteId,
          _that.error,
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
      String connectionId,
      String localEventId,
      Map<String, dynamic> payload,
      String digest,
      String nonce,
      String status,
      String? remoteId,
      String error,
      DateTime expiresAt,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CalendarExport() when $default != null:
        return $default(
          _that.id,
          _that.connectionId,
          _that.localEventId,
          _that.payload,
          _that.digest,
          _that.nonce,
          _that.status,
          _that.remoteId,
          _that.error,
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
class _CalendarExport implements CalendarExport {
  const _CalendarExport({
    required this.id,
    required this.connectionId,
    required this.localEventId,
    required final Map<String, dynamic> payload,
    required this.digest,
    required this.nonce,
    required this.status,
    this.remoteId,
    this.error = '',
    required this.expiresAt,
    required this.createdAt,
  }) : _payload = payload;
  factory _CalendarExport.fromJson(Map<String, dynamic> json) =>
      _$CalendarExportFromJson(json);

  @override
  final String id;
  @override
  final String connectionId;
  @override
  final String localEventId;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final String digest;
  @override
  final String nonce;
  @override
  final String status;
  @override
  final String? remoteId;
  @override
  @JsonKey()
  final String error;
  @override
  final DateTime expiresAt;
  @override
  final DateTime createdAt;

  /// Create a copy of CalendarExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CalendarExportCopyWith<_CalendarExport> get copyWith =>
      __$CalendarExportCopyWithImpl<_CalendarExport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CalendarExportToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CalendarExport &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.connectionId, connectionId) ||
                other.connectionId == connectionId) &&
            (identical(other.localEventId, localEventId) ||
                other.localEventId == localEventId) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.digest, digest) || other.digest == digest) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.remoteId, remoteId) ||
                other.remoteId == remoteId) &&
            (identical(other.error, error) || other.error == error) &&
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
    connectionId,
    localEventId,
    const DeepCollectionEquality().hash(_payload),
    digest,
    nonce,
    status,
    remoteId,
    error,
    expiresAt,
    createdAt,
  );

  @override
  String toString() {
    return 'CalendarExport(id: $id, connectionId: $connectionId, localEventId: $localEventId, payload: $payload, digest: $digest, nonce: $nonce, status: $status, remoteId: $remoteId, error: $error, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CalendarExportCopyWith<$Res>
    implements $CalendarExportCopyWith<$Res> {
  factory _$CalendarExportCopyWith(
    _CalendarExport value,
    $Res Function(_CalendarExport) _then,
  ) = __$CalendarExportCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String connectionId,
    String localEventId,
    Map<String, dynamic> payload,
    String digest,
    String nonce,
    String status,
    String? remoteId,
    String error,
    DateTime expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$CalendarExportCopyWithImpl<$Res>
    implements _$CalendarExportCopyWith<$Res> {
  __$CalendarExportCopyWithImpl(this._self, this._then);

  final _CalendarExport _self;
  final $Res Function(_CalendarExport) _then;

  /// Create a copy of CalendarExport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? connectionId = null,
    Object? localEventId = null,
    Object? payload = null,
    Object? digest = null,
    Object? nonce = null,
    Object? status = null,
    Object? remoteId = freezed,
    Object? error = null,
    Object? expiresAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _CalendarExport(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        connectionId: null == connectionId
            ? _self.connectionId
            : connectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        localEventId: null == localEventId
            ? _self.localEventId
            : localEventId // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _self._payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        digest: null == digest
            ? _self.digest
            : digest // ignore: cast_nullable_to_non_nullable
                  as String,
        nonce: null == nonce
            ? _self.nonce
            : nonce // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        remoteId: freezed == remoteId
            ? _self.remoteId
            : remoteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
        expiresAt: null == expiresAt
            ? _self.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
