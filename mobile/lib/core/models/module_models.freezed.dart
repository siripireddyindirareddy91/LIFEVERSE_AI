// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModuleRecord {
  String get id;
  String get kind;
  String get title;
  Map<String, dynamic> get data;
  String? get parentId;
  bool get allowAi;
  String get revision;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of ModuleRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModuleRecordCopyWith<ModuleRecord> get copyWith =>
      _$ModuleRecordCopyWithImpl<ModuleRecord>(
        this as ModuleRecord,
        _$identity,
      );

  /// Serializes this ModuleRecord to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModuleRecord &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    kind,
    title,
    const DeepCollectionEquality().hash(data),
    parentId,
    allowAi,
    revision,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'ModuleRecord(id: $id, kind: $kind, title: $title, data: $data, parentId: $parentId, allowAi: $allowAi, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ModuleRecordCopyWith<$Res> {
  factory $ModuleRecordCopyWith(
    ModuleRecord value,
    $Res Function(ModuleRecord) _then,
  ) = _$ModuleRecordCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String kind,
    String title,
    Map<String, dynamic> data,
    String? parentId,
    bool allowAi,
    String revision,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ModuleRecordCopyWithImpl<$Res> implements $ModuleRecordCopyWith<$Res> {
  _$ModuleRecordCopyWithImpl(this._self, this._then);

  final ModuleRecord _self;
  final $Res Function(ModuleRecord) _then;

  /// Create a copy of ModuleRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? title = null,
    Object? data = null,
    Object? parentId = freezed,
    Object? allowAi = null,
    Object? revision = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ModuleRecord].
extension ModuleRecordPatterns on ModuleRecord {
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
    TResult Function(_ModuleRecord value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord() when $default != null:
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
    TResult Function(_ModuleRecord value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord():
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
    TResult? Function(_ModuleRecord value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord() when $default != null:
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
      String kind,
      String title,
      Map<String, dynamic> data,
      String? parentId,
      bool allowAi,
      String revision,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord() when $default != null:
        return $default(
          _that.id,
          _that.kind,
          _that.title,
          _that.data,
          _that.parentId,
          _that.allowAi,
          _that.revision,
          _that.createdAt,
          _that.updatedAt,
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
      String kind,
      String title,
      Map<String, dynamic> data,
      String? parentId,
      bool allowAi,
      String revision,
      DateTime createdAt,
      DateTime updatedAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord():
        return $default(
          _that.id,
          _that.kind,
          _that.title,
          _that.data,
          _that.parentId,
          _that.allowAi,
          _that.revision,
          _that.createdAt,
          _that.updatedAt,
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
      String kind,
      String title,
      Map<String, dynamic> data,
      String? parentId,
      bool allowAi,
      String revision,
      DateTime createdAt,
      DateTime updatedAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleRecord() when $default != null:
        return $default(
          _that.id,
          _that.kind,
          _that.title,
          _that.data,
          _that.parentId,
          _that.allowAi,
          _that.revision,
          _that.createdAt,
          _that.updatedAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ModuleRecord implements ModuleRecord {
  const _ModuleRecord({
    required this.id,
    required this.kind,
    required this.title,
    required final Map<String, dynamic> data,
    this.parentId,
    required this.allowAi,
    required this.revision,
    required this.createdAt,
    required this.updatedAt,
  }) : _data = data;
  factory _ModuleRecord.fromJson(Map<String, dynamic> json) =>
      _$ModuleRecordFromJson(json);

  @override
  final String id;
  @override
  final String kind;
  @override
  final String title;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final String? parentId;
  @override
  final bool allowAi;
  @override
  final String revision;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of ModuleRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ModuleRecordCopyWith<_ModuleRecord> get copyWith =>
      __$ModuleRecordCopyWithImpl<_ModuleRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ModuleRecordToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ModuleRecord &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi) &&
            (identical(other.revision, revision) ||
                other.revision == revision) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    kind,
    title,
    const DeepCollectionEquality().hash(_data),
    parentId,
    allowAi,
    revision,
    createdAt,
    updatedAt,
  );

  @override
  String toString() {
    return 'ModuleRecord(id: $id, kind: $kind, title: $title, data: $data, parentId: $parentId, allowAi: $allowAi, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ModuleRecordCopyWith<$Res>
    implements $ModuleRecordCopyWith<$Res> {
  factory _$ModuleRecordCopyWith(
    _ModuleRecord value,
    $Res Function(_ModuleRecord) _then,
  ) = __$ModuleRecordCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String kind,
    String title,
    Map<String, dynamic> data,
    String? parentId,
    bool allowAi,
    String revision,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$ModuleRecordCopyWithImpl<$Res>
    implements _$ModuleRecordCopyWith<$Res> {
  __$ModuleRecordCopyWithImpl(this._self, this._then);

  final _ModuleRecord _self;
  final $Res Function(_ModuleRecord) _then;

  /// Create a copy of ModuleRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? title = null,
    Object? data = null,
    Object? parentId = freezed,
    Object? allowAi = null,
    Object? revision = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _ModuleRecord(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        data: null == data
            ? _self._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
        revision: null == revision
            ? _self.revision
            : revision // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
mixin _$ReportMetric {
  String get label;
  String get value;
  String get detail;

  /// Create a copy of ReportMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportMetricCopyWith<ReportMetric> get copyWith =>
      _$ReportMetricCopyWithImpl<ReportMetric>(
        this as ReportMetric,
        _$identity,
      );

  /// Serializes this ReportMetric to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportMetric &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, detail);

  @override
  String toString() {
    return 'ReportMetric(label: $label, value: $value, detail: $detail)';
  }
}

/// @nodoc
abstract mixin class $ReportMetricCopyWith<$Res> {
  factory $ReportMetricCopyWith(
    ReportMetric value,
    $Res Function(ReportMetric) _then,
  ) = _$ReportMetricCopyWithImpl;
  @useResult
  $Res call({String label, String value, String detail});
}

/// @nodoc
class _$ReportMetricCopyWithImpl<$Res> implements $ReportMetricCopyWith<$Res> {
  _$ReportMetricCopyWithImpl(this._self, this._then);

  final ReportMetric _self;
  final $Res Function(ReportMetric) _then;

  /// Create a copy of ReportMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? detail = null,
  }) {
    return _then(
      _self.copyWith(
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        detail: null == detail
            ? _self.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ReportMetric].
extension ReportMetricPatterns on ReportMetric {
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
    TResult Function(_ReportMetric value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportMetric() when $default != null:
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
    TResult Function(_ReportMetric value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportMetric():
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
    TResult? Function(_ReportMetric value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportMetric() when $default != null:
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
    TResult Function(String label, String value, String detail)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportMetric() when $default != null:
        return $default(_that.label, _that.value, _that.detail);
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
    TResult Function(String label, String value, String detail) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportMetric():
        return $default(_that.label, _that.value, _that.detail);
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
    TResult? Function(String label, String value, String detail)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportMetric() when $default != null:
        return $default(_that.label, _that.value, _that.detail);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReportMetric implements ReportMetric {
  const _ReportMetric({
    required this.label,
    required this.value,
    this.detail = '',
  });
  factory _ReportMetric.fromJson(Map<String, dynamic> json) =>
      _$ReportMetricFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  @JsonKey()
  final String detail;

  /// Create a copy of ReportMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReportMetricCopyWith<_ReportMetric> get copyWith =>
      __$ReportMetricCopyWithImpl<_ReportMetric>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReportMetricToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReportMetric &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, detail);

  @override
  String toString() {
    return 'ReportMetric(label: $label, value: $value, detail: $detail)';
  }
}

/// @nodoc
abstract mixin class _$ReportMetricCopyWith<$Res>
    implements $ReportMetricCopyWith<$Res> {
  factory _$ReportMetricCopyWith(
    _ReportMetric value,
    $Res Function(_ReportMetric) _then,
  ) = __$ReportMetricCopyWithImpl;
  @override
  @useResult
  $Res call({String label, String value, String detail});
}

/// @nodoc
class __$ReportMetricCopyWithImpl<$Res>
    implements _$ReportMetricCopyWith<$Res> {
  __$ReportMetricCopyWithImpl(this._self, this._then);

  final _ReportMetric _self;
  final $Res Function(_ReportMetric) _then;

  /// Create a copy of ReportMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? detail = null,
  }) {
    return _then(
      _ReportMetric(
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        detail: null == detail
            ? _self.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ModuleReport {
  String get module;
  String get today;
  String get month;
  int get recordCount;
  List<ReportMetric> get metrics;
  List<ReportMetric> get lines;

  /// Create a copy of ModuleReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModuleReportCopyWith<ModuleReport> get copyWith =>
      _$ModuleReportCopyWithImpl<ModuleReport>(
        this as ModuleReport,
        _$identity,
      );

  /// Serializes this ModuleReport to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModuleReport &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.recordCount, recordCount) ||
                other.recordCount == recordCount) &&
            const DeepCollectionEquality().equals(other.metrics, metrics) &&
            const DeepCollectionEquality().equals(other.lines, lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    module,
    today,
    month,
    recordCount,
    const DeepCollectionEquality().hash(metrics),
    const DeepCollectionEquality().hash(lines),
  );

  @override
  String toString() {
    return 'ModuleReport(module: $module, today: $today, month: $month, recordCount: $recordCount, metrics: $metrics, lines: $lines)';
  }
}

/// @nodoc
abstract mixin class $ModuleReportCopyWith<$Res> {
  factory $ModuleReportCopyWith(
    ModuleReport value,
    $Res Function(ModuleReport) _then,
  ) = _$ModuleReportCopyWithImpl;
  @useResult
  $Res call({
    String module,
    String today,
    String month,
    int recordCount,
    List<ReportMetric> metrics,
    List<ReportMetric> lines,
  });
}

/// @nodoc
class _$ModuleReportCopyWithImpl<$Res> implements $ModuleReportCopyWith<$Res> {
  _$ModuleReportCopyWithImpl(this._self, this._then);

  final ModuleReport _self;
  final $Res Function(ModuleReport) _then;

  /// Create a copy of ModuleReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? module = null,
    Object? today = null,
    Object? month = null,
    Object? recordCount = null,
    Object? metrics = null,
    Object? lines = null,
  }) {
    return _then(
      _self.copyWith(
        module: null == module
            ? _self.module
            : module // ignore: cast_nullable_to_non_nullable
                  as String,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        month: null == month
            ? _self.month
            : month // ignore: cast_nullable_to_non_nullable
                  as String,
        recordCount: null == recordCount
            ? _self.recordCount
            : recordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        metrics: null == metrics
            ? _self.metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<ReportMetric>,
        lines: null == lines
            ? _self.lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<ReportMetric>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ModuleReport].
extension ModuleReportPatterns on ModuleReport {
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
    TResult Function(_ModuleReport value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModuleReport() when $default != null:
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
    TResult Function(_ModuleReport value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleReport():
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
    TResult? Function(_ModuleReport value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleReport() when $default != null:
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
      String module,
      String today,
      String month,
      int recordCount,
      List<ReportMetric> metrics,
      List<ReportMetric> lines,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModuleReport() when $default != null:
        return $default(
          _that.module,
          _that.today,
          _that.month,
          _that.recordCount,
          _that.metrics,
          _that.lines,
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
      String module,
      String today,
      String month,
      int recordCount,
      List<ReportMetric> metrics,
      List<ReportMetric> lines,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleReport():
        return $default(
          _that.module,
          _that.today,
          _that.month,
          _that.recordCount,
          _that.metrics,
          _that.lines,
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
      String module,
      String today,
      String month,
      int recordCount,
      List<ReportMetric> metrics,
      List<ReportMetric> lines,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModuleReport() when $default != null:
        return $default(
          _that.module,
          _that.today,
          _that.month,
          _that.recordCount,
          _that.metrics,
          _that.lines,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ModuleReport implements ModuleReport {
  const _ModuleReport({
    required this.module,
    required this.today,
    required this.month,
    required this.recordCount,
    final List<ReportMetric> metrics = const [],
    final List<ReportMetric> lines = const [],
  }) : _metrics = metrics,
       _lines = lines;
  factory _ModuleReport.fromJson(Map<String, dynamic> json) =>
      _$ModuleReportFromJson(json);

  @override
  final String module;
  @override
  final String today;
  @override
  final String month;
  @override
  final int recordCount;
  final List<ReportMetric> _metrics;
  @override
  @JsonKey()
  List<ReportMetric> get metrics {
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_metrics);
  }

  final List<ReportMetric> _lines;
  @override
  @JsonKey()
  List<ReportMetric> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  /// Create a copy of ModuleReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ModuleReportCopyWith<_ModuleReport> get copyWith =>
      __$ModuleReportCopyWithImpl<_ModuleReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ModuleReportToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ModuleReport &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.recordCount, recordCount) ||
                other.recordCount == recordCount) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    module,
    today,
    month,
    recordCount,
    const DeepCollectionEquality().hash(_metrics),
    const DeepCollectionEquality().hash(_lines),
  );

  @override
  String toString() {
    return 'ModuleReport(module: $module, today: $today, month: $month, recordCount: $recordCount, metrics: $metrics, lines: $lines)';
  }
}

/// @nodoc
abstract mixin class _$ModuleReportCopyWith<$Res>
    implements $ModuleReportCopyWith<$Res> {
  factory _$ModuleReportCopyWith(
    _ModuleReport value,
    $Res Function(_ModuleReport) _then,
  ) = __$ModuleReportCopyWithImpl;
  @override
  @useResult
  $Res call({
    String module,
    String today,
    String month,
    int recordCount,
    List<ReportMetric> metrics,
    List<ReportMetric> lines,
  });
}

/// @nodoc
class __$ModuleReportCopyWithImpl<$Res>
    implements _$ModuleReportCopyWith<$Res> {
  __$ModuleReportCopyWithImpl(this._self, this._then);

  final _ModuleReport _self;
  final $Res Function(_ModuleReport) _then;

  /// Create a copy of ModuleReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? module = null,
    Object? today = null,
    Object? month = null,
    Object? recordCount = null,
    Object? metrics = null,
    Object? lines = null,
  }) {
    return _then(
      _ModuleReport(
        module: null == module
            ? _self.module
            : module // ignore: cast_nullable_to_non_nullable
                  as String,
        today: null == today
            ? _self.today
            : today // ignore: cast_nullable_to_non_nullable
                  as String,
        month: null == month
            ? _self.month
            : month // ignore: cast_nullable_to_non_nullable
                  as String,
        recordCount: null == recordCount
            ? _self.recordCount
            : recordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        metrics: null == metrics
            ? _self._metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<ReportMetric>,
        lines: null == lines
            ? _self._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<ReportMetric>,
      ),
    );
  }
}

/// @nodoc
mixin _$VaultStatus {
  bool get configured;
  int get maxFileBytes;
  int get quotaBytes;
  int get usedBytes;
  String get encryption;

  /// Create a copy of VaultStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VaultStatusCopyWith<VaultStatus> get copyWith =>
      _$VaultStatusCopyWithImpl<VaultStatus>(this as VaultStatus, _$identity);

  /// Serializes this VaultStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VaultStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.maxFileBytes, maxFileBytes) ||
                other.maxFileBytes == maxFileBytes) &&
            (identical(other.quotaBytes, quotaBytes) ||
                other.quotaBytes == quotaBytes) &&
            (identical(other.usedBytes, usedBytes) ||
                other.usedBytes == usedBytes) &&
            (identical(other.encryption, encryption) ||
                other.encryption == encryption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    maxFileBytes,
    quotaBytes,
    usedBytes,
    encryption,
  );

  @override
  String toString() {
    return 'VaultStatus(configured: $configured, maxFileBytes: $maxFileBytes, quotaBytes: $quotaBytes, usedBytes: $usedBytes, encryption: $encryption)';
  }
}

/// @nodoc
abstract mixin class $VaultStatusCopyWith<$Res> {
  factory $VaultStatusCopyWith(
    VaultStatus value,
    $Res Function(VaultStatus) _then,
  ) = _$VaultStatusCopyWithImpl;
  @useResult
  $Res call({
    bool configured,
    int maxFileBytes,
    int quotaBytes,
    int usedBytes,
    String encryption,
  });
}

/// @nodoc
class _$VaultStatusCopyWithImpl<$Res> implements $VaultStatusCopyWith<$Res> {
  _$VaultStatusCopyWithImpl(this._self, this._then);

  final VaultStatus _self;
  final $Res Function(VaultStatus) _then;

  /// Create a copy of VaultStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configured = null,
    Object? maxFileBytes = null,
    Object? quotaBytes = null,
    Object? usedBytes = null,
    Object? encryption = null,
  }) {
    return _then(
      _self.copyWith(
        configured: null == configured
            ? _self.configured
            : configured // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxFileBytes: null == maxFileBytes
            ? _self.maxFileBytes
            : maxFileBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        quotaBytes: null == quotaBytes
            ? _self.quotaBytes
            : quotaBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        usedBytes: null == usedBytes
            ? _self.usedBytes
            : usedBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        encryption: null == encryption
            ? _self.encryption
            : encryption // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [VaultStatus].
extension VaultStatusPatterns on VaultStatus {
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
    TResult Function(_VaultStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VaultStatus() when $default != null:
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
    TResult Function(_VaultStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultStatus():
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
    TResult? Function(_VaultStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultStatus() when $default != null:
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
      int maxFileBytes,
      int quotaBytes,
      int usedBytes,
      String encryption,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VaultStatus() when $default != null:
        return $default(
          _that.configured,
          _that.maxFileBytes,
          _that.quotaBytes,
          _that.usedBytes,
          _that.encryption,
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
      int maxFileBytes,
      int quotaBytes,
      int usedBytes,
      String encryption,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultStatus():
        return $default(
          _that.configured,
          _that.maxFileBytes,
          _that.quotaBytes,
          _that.usedBytes,
          _that.encryption,
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
      int maxFileBytes,
      int quotaBytes,
      int usedBytes,
      String encryption,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultStatus() when $default != null:
        return $default(
          _that.configured,
          _that.maxFileBytes,
          _that.quotaBytes,
          _that.usedBytes,
          _that.encryption,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VaultStatus implements VaultStatus {
  const _VaultStatus({
    required this.configured,
    required this.maxFileBytes,
    required this.quotaBytes,
    required this.usedBytes,
    required this.encryption,
  });
  factory _VaultStatus.fromJson(Map<String, dynamic> json) =>
      _$VaultStatusFromJson(json);

  @override
  final bool configured;
  @override
  final int maxFileBytes;
  @override
  final int quotaBytes;
  @override
  final int usedBytes;
  @override
  final String encryption;

  /// Create a copy of VaultStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VaultStatusCopyWith<_VaultStatus> get copyWith =>
      __$VaultStatusCopyWithImpl<_VaultStatus>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VaultStatusToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VaultStatus &&
            (identical(other.configured, configured) ||
                other.configured == configured) &&
            (identical(other.maxFileBytes, maxFileBytes) ||
                other.maxFileBytes == maxFileBytes) &&
            (identical(other.quotaBytes, quotaBytes) ||
                other.quotaBytes == quotaBytes) &&
            (identical(other.usedBytes, usedBytes) ||
                other.usedBytes == usedBytes) &&
            (identical(other.encryption, encryption) ||
                other.encryption == encryption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    configured,
    maxFileBytes,
    quotaBytes,
    usedBytes,
    encryption,
  );

  @override
  String toString() {
    return 'VaultStatus(configured: $configured, maxFileBytes: $maxFileBytes, quotaBytes: $quotaBytes, usedBytes: $usedBytes, encryption: $encryption)';
  }
}

/// @nodoc
abstract mixin class _$VaultStatusCopyWith<$Res>
    implements $VaultStatusCopyWith<$Res> {
  factory _$VaultStatusCopyWith(
    _VaultStatus value,
    $Res Function(_VaultStatus) _then,
  ) = __$VaultStatusCopyWithImpl;
  @override
  @useResult
  $Res call({
    bool configured,
    int maxFileBytes,
    int quotaBytes,
    int usedBytes,
    String encryption,
  });
}

/// @nodoc
class __$VaultStatusCopyWithImpl<$Res> implements _$VaultStatusCopyWith<$Res> {
  __$VaultStatusCopyWithImpl(this._self, this._then);

  final _VaultStatus _self;
  final $Res Function(_VaultStatus) _then;

  /// Create a copy of VaultStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? configured = null,
    Object? maxFileBytes = null,
    Object? quotaBytes = null,
    Object? usedBytes = null,
    Object? encryption = null,
  }) {
    return _then(
      _VaultStatus(
        configured: null == configured
            ? _self.configured
            : configured // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxFileBytes: null == maxFileBytes
            ? _self.maxFileBytes
            : maxFileBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        quotaBytes: null == quotaBytes
            ? _self.quotaBytes
            : quotaBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        usedBytes: null == usedBytes
            ? _self.usedBytes
            : usedBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        encryption: null == encryption
            ? _self.encryption
            : encryption // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$VaultItem {
  String get id;
  String get title;
  String get category;
  String get filename;
  String get mime;
  int get size;
  String get sha256;
  bool get allowAi;
  DateTime? get expiresAt;
  DateTime get createdAt;

  /// Create a copy of VaultItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VaultItemCopyWith<VaultItem> get copyWith =>
      _$VaultItemCopyWithImpl<VaultItem>(this as VaultItem, _$identity);

  /// Serializes this VaultItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VaultItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.mime, mime) || other.mime == mime) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.sha256, sha256) || other.sha256 == sha256) &&
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
    category,
    filename,
    mime,
    size,
    sha256,
    allowAi,
    expiresAt,
    createdAt,
  );

  @override
  String toString() {
    return 'VaultItem(id: $id, title: $title, category: $category, filename: $filename, mime: $mime, size: $size, sha256: $sha256, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $VaultItemCopyWith<$Res> {
  factory $VaultItemCopyWith(VaultItem value, $Res Function(VaultItem) _then) =
      _$VaultItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    String filename,
    String mime,
    int size,
    String sha256,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$VaultItemCopyWithImpl<$Res> implements $VaultItemCopyWith<$Res> {
  _$VaultItemCopyWithImpl(this._self, this._then);

  final VaultItem _self;
  final $Res Function(VaultItem) _then;

  /// Create a copy of VaultItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? filename = null,
    Object? mime = null,
    Object? size = null,
    Object? sha256 = null,
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
        category: null == category
            ? _self.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        filename: null == filename
            ? _self.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String,
        mime: null == mime
            ? _self.mime
            : mime // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _self.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        sha256: null == sha256
            ? _self.sha256
            : sha256 // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [VaultItem].
extension VaultItemPatterns on VaultItem {
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
    TResult Function(_VaultItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VaultItem() when $default != null:
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
    TResult Function(_VaultItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultItem():
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
    TResult? Function(_VaultItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultItem() when $default != null:
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
      String category,
      String filename,
      String mime,
      int size,
      String sha256,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VaultItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.category,
          _that.filename,
          _that.mime,
          _that.size,
          _that.sha256,
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
      String category,
      String filename,
      String mime,
      int size,
      String sha256,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultItem():
        return $default(
          _that.id,
          _that.title,
          _that.category,
          _that.filename,
          _that.mime,
          _that.size,
          _that.sha256,
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
      String category,
      String filename,
      String mime,
      int size,
      String sha256,
      bool allowAi,
      DateTime? expiresAt,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VaultItem() when $default != null:
        return $default(
          _that.id,
          _that.title,
          _that.category,
          _that.filename,
          _that.mime,
          _that.size,
          _that.sha256,
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
class _VaultItem implements VaultItem {
  const _VaultItem({
    required this.id,
    required this.title,
    required this.category,
    required this.filename,
    required this.mime,
    required this.size,
    required this.sha256,
    required this.allowAi,
    this.expiresAt,
    required this.createdAt,
  });
  factory _VaultItem.fromJson(Map<String, dynamic> json) =>
      _$VaultItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  @override
  final String filename;
  @override
  final String mime;
  @override
  final int size;
  @override
  final String sha256;
  @override
  final bool allowAi;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime createdAt;

  /// Create a copy of VaultItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VaultItemCopyWith<_VaultItem> get copyWith =>
      __$VaultItemCopyWithImpl<_VaultItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VaultItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VaultItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.mime, mime) || other.mime == mime) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.sha256, sha256) || other.sha256 == sha256) &&
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
    category,
    filename,
    mime,
    size,
    sha256,
    allowAi,
    expiresAt,
    createdAt,
  );

  @override
  String toString() {
    return 'VaultItem(id: $id, title: $title, category: $category, filename: $filename, mime: $mime, size: $size, sha256: $sha256, allowAi: $allowAi, expiresAt: $expiresAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$VaultItemCopyWith<$Res>
    implements $VaultItemCopyWith<$Res> {
  factory _$VaultItemCopyWith(
    _VaultItem value,
    $Res Function(_VaultItem) _then,
  ) = __$VaultItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    String filename,
    String mime,
    int size,
    String sha256,
    bool allowAi,
    DateTime? expiresAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$VaultItemCopyWithImpl<$Res> implements _$VaultItemCopyWith<$Res> {
  __$VaultItemCopyWithImpl(this._self, this._then);

  final _VaultItem _self;
  final $Res Function(_VaultItem) _then;

  /// Create a copy of VaultItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? filename = null,
    Object? mime = null,
    Object? size = null,
    Object? sha256 = null,
    Object? allowAi = null,
    Object? expiresAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _VaultItem(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _self.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        filename: null == filename
            ? _self.filename
            : filename // ignore: cast_nullable_to_non_nullable
                  as String,
        mime: null == mime
            ? _self.mime
            : mime // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _self.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        sha256: null == sha256
            ? _self.sha256
            : sha256 // ignore: cast_nullable_to_non_nullable
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
mixin _$KnowledgeNode {
  String get id;
  String get title;
  bool get allowAi;

  /// Create a copy of KnowledgeNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KnowledgeNodeCopyWith<KnowledgeNode> get copyWith =>
      _$KnowledgeNodeCopyWithImpl<KnowledgeNode>(
        this as KnowledgeNode,
        _$identity,
      );

  /// Serializes this KnowledgeNode to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KnowledgeNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, allowAi);

  @override
  String toString() {
    return 'KnowledgeNode(id: $id, title: $title, allowAi: $allowAi)';
  }
}

/// @nodoc
abstract mixin class $KnowledgeNodeCopyWith<$Res> {
  factory $KnowledgeNodeCopyWith(
    KnowledgeNode value,
    $Res Function(KnowledgeNode) _then,
  ) = _$KnowledgeNodeCopyWithImpl;
  @useResult
  $Res call({String id, String title, bool allowAi});
}

/// @nodoc
class _$KnowledgeNodeCopyWithImpl<$Res>
    implements $KnowledgeNodeCopyWith<$Res> {
  _$KnowledgeNodeCopyWithImpl(this._self, this._then);

  final KnowledgeNode _self;
  final $Res Function(KnowledgeNode) _then;

  /// Create a copy of KnowledgeNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? title = null, Object? allowAi = null}) {
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
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [KnowledgeNode].
extension KnowledgeNodePatterns on KnowledgeNode {
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
    TResult Function(_KnowledgeNode value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode() when $default != null:
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
    TResult Function(_KnowledgeNode value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode():
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
    TResult? Function(_KnowledgeNode value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode() when $default != null:
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
    TResult Function(String id, String title, bool allowAi)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode() when $default != null:
        return $default(_that.id, _that.title, _that.allowAi);
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
    TResult Function(String id, String title, bool allowAi) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode():
        return $default(_that.id, _that.title, _that.allowAi);
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
    TResult? Function(String id, String title, bool allowAi)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeNode() when $default != null:
        return $default(_that.id, _that.title, _that.allowAi);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KnowledgeNode implements KnowledgeNode {
  const _KnowledgeNode({
    required this.id,
    required this.title,
    required this.allowAi,
  });
  factory _KnowledgeNode.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeNodeFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final bool allowAi;

  /// Create a copy of KnowledgeNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KnowledgeNodeCopyWith<_KnowledgeNode> get copyWith =>
      __$KnowledgeNodeCopyWithImpl<_KnowledgeNode>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KnowledgeNodeToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KnowledgeNode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.allowAi, allowAi) || other.allowAi == allowAi));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, allowAi);

  @override
  String toString() {
    return 'KnowledgeNode(id: $id, title: $title, allowAi: $allowAi)';
  }
}

/// @nodoc
abstract mixin class _$KnowledgeNodeCopyWith<$Res>
    implements $KnowledgeNodeCopyWith<$Res> {
  factory _$KnowledgeNodeCopyWith(
    _KnowledgeNode value,
    $Res Function(_KnowledgeNode) _then,
  ) = __$KnowledgeNodeCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, bool allowAi});
}

/// @nodoc
class __$KnowledgeNodeCopyWithImpl<$Res>
    implements _$KnowledgeNodeCopyWith<$Res> {
  __$KnowledgeNodeCopyWithImpl(this._self, this._then);

  final _KnowledgeNode _self;
  final $Res Function(_KnowledgeNode) _then;

  /// Create a copy of KnowledgeNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? id = null, Object? title = null, Object? allowAi = null}) {
    return _then(
      _KnowledgeNode(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        allowAi: null == allowAi
            ? _self.allowAi
            : allowAi // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$KnowledgeEdge {
  String get id;
  String get sourceId;
  String get targetId;
  String get label;

  /// Create a copy of KnowledgeEdge
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KnowledgeEdgeCopyWith<KnowledgeEdge> get copyWith =>
      _$KnowledgeEdgeCopyWithImpl<KnowledgeEdge>(
        this as KnowledgeEdge,
        _$identity,
      );

  /// Serializes this KnowledgeEdge to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KnowledgeEdge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sourceId, targetId, label);

  @override
  String toString() {
    return 'KnowledgeEdge(id: $id, sourceId: $sourceId, targetId: $targetId, label: $label)';
  }
}

/// @nodoc
abstract mixin class $KnowledgeEdgeCopyWith<$Res> {
  factory $KnowledgeEdgeCopyWith(
    KnowledgeEdge value,
    $Res Function(KnowledgeEdge) _then,
  ) = _$KnowledgeEdgeCopyWithImpl;
  @useResult
  $Res call({String id, String sourceId, String targetId, String label});
}

/// @nodoc
class _$KnowledgeEdgeCopyWithImpl<$Res>
    implements $KnowledgeEdgeCopyWith<$Res> {
  _$KnowledgeEdgeCopyWithImpl(this._self, this._then);

  final KnowledgeEdge _self;
  final $Res Function(KnowledgeEdge) _then;

  /// Create a copy of KnowledgeEdge
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? label = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _self.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _self.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [KnowledgeEdge].
extension KnowledgeEdgePatterns on KnowledgeEdge {
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
    TResult Function(_KnowledgeEdge value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge() when $default != null:
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
    TResult Function(_KnowledgeEdge value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge():
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
    TResult? Function(_KnowledgeEdge value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge() when $default != null:
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
    TResult Function(String id, String sourceId, String targetId, String label)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge() when $default != null:
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label);
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
    TResult Function(String id, String sourceId, String targetId, String label)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge():
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label);
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
      String sourceId,
      String targetId,
      String label,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeEdge() when $default != null:
        return $default(_that.id, _that.sourceId, _that.targetId, _that.label);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KnowledgeEdge implements KnowledgeEdge {
  const _KnowledgeEdge({
    required this.id,
    required this.sourceId,
    required this.targetId,
    required this.label,
  });
  factory _KnowledgeEdge.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeEdgeFromJson(json);

  @override
  final String id;
  @override
  final String sourceId;
  @override
  final String targetId;
  @override
  final String label;

  /// Create a copy of KnowledgeEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KnowledgeEdgeCopyWith<_KnowledgeEdge> get copyWith =>
      __$KnowledgeEdgeCopyWithImpl<_KnowledgeEdge>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KnowledgeEdgeToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KnowledgeEdge &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sourceId, sourceId) ||
                other.sourceId == sourceId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sourceId, targetId, label);

  @override
  String toString() {
    return 'KnowledgeEdge(id: $id, sourceId: $sourceId, targetId: $targetId, label: $label)';
  }
}

/// @nodoc
abstract mixin class _$KnowledgeEdgeCopyWith<$Res>
    implements $KnowledgeEdgeCopyWith<$Res> {
  factory _$KnowledgeEdgeCopyWith(
    _KnowledgeEdge value,
    $Res Function(_KnowledgeEdge) _then,
  ) = __$KnowledgeEdgeCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String sourceId, String targetId, String label});
}

/// @nodoc
class __$KnowledgeEdgeCopyWithImpl<$Res>
    implements _$KnowledgeEdgeCopyWith<$Res> {
  __$KnowledgeEdgeCopyWithImpl(this._self, this._then);

  final _KnowledgeEdge _self;
  final $Res Function(_KnowledgeEdge) _then;

  /// Create a copy of KnowledgeEdge
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sourceId = null,
    Object? targetId = null,
    Object? label = null,
  }) {
    return _then(
      _KnowledgeEdge(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceId: null == sourceId
            ? _self.sourceId
            : sourceId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetId: null == targetId
            ? _self.targetId
            : targetId // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _self.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$KnowledgeGraph {
  List<KnowledgeNode> get nodes;
  List<KnowledgeEdge> get edges;
  int get total;
  int get limit;

  /// Create a copy of KnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KnowledgeGraphCopyWith<KnowledgeGraph> get copyWith =>
      _$KnowledgeGraphCopyWithImpl<KnowledgeGraph>(
        this as KnowledgeGraph,
        _$identity,
      );

  /// Serializes this KnowledgeGraph to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KnowledgeGraph &&
            const DeepCollectionEquality().equals(other.nodes, nodes) &&
            const DeepCollectionEquality().equals(other.edges, edges) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(nodes),
    const DeepCollectionEquality().hash(edges),
    total,
    limit,
  );

  @override
  String toString() {
    return 'KnowledgeGraph(nodes: $nodes, edges: $edges, total: $total, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $KnowledgeGraphCopyWith<$Res> {
  factory $KnowledgeGraphCopyWith(
    KnowledgeGraph value,
    $Res Function(KnowledgeGraph) _then,
  ) = _$KnowledgeGraphCopyWithImpl;
  @useResult
  $Res call({
    List<KnowledgeNode> nodes,
    List<KnowledgeEdge> edges,
    int total,
    int limit,
  });
}

/// @nodoc
class _$KnowledgeGraphCopyWithImpl<$Res>
    implements $KnowledgeGraphCopyWith<$Res> {
  _$KnowledgeGraphCopyWithImpl(this._self, this._then);

  final KnowledgeGraph _self;
  final $Res Function(KnowledgeGraph) _then;

  /// Create a copy of KnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? total = null,
    Object? limit = null,
  }) {
    return _then(
      _self.copyWith(
        nodes: null == nodes
            ? _self.nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<KnowledgeNode>,
        edges: null == edges
            ? _self.edges
            : edges // ignore: cast_nullable_to_non_nullable
                  as List<KnowledgeEdge>,
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [KnowledgeGraph].
extension KnowledgeGraphPatterns on KnowledgeGraph {
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
    TResult Function(_KnowledgeGraph value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph() when $default != null:
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
    TResult Function(_KnowledgeGraph value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph():
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
    TResult? Function(_KnowledgeGraph value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph() when $default != null:
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
      List<KnowledgeNode> nodes,
      List<KnowledgeEdge> edges,
      int total,
      int limit,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph() when $default != null:
        return $default(_that.nodes, _that.edges, _that.total, _that.limit);
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
      List<KnowledgeNode> nodes,
      List<KnowledgeEdge> edges,
      int total,
      int limit,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph():
        return $default(_that.nodes, _that.edges, _that.total, _that.limit);
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
      List<KnowledgeNode> nodes,
      List<KnowledgeEdge> edges,
      int total,
      int limit,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KnowledgeGraph() when $default != null:
        return $default(_that.nodes, _that.edges, _that.total, _that.limit);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KnowledgeGraph implements KnowledgeGraph {
  const _KnowledgeGraph({
    required final List<KnowledgeNode> nodes,
    required final List<KnowledgeEdge> edges,
    required this.total,
    required this.limit,
  }) : _nodes = nodes,
       _edges = edges;
  factory _KnowledgeGraph.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeGraphFromJson(json);

  final List<KnowledgeNode> _nodes;
  @override
  List<KnowledgeNode> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<KnowledgeEdge> _edges;
  @override
  List<KnowledgeEdge> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  final int total;
  @override
  final int limit;

  /// Create a copy of KnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KnowledgeGraphCopyWith<_KnowledgeGraph> get copyWith =>
      __$KnowledgeGraphCopyWithImpl<_KnowledgeGraph>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KnowledgeGraphToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KnowledgeGraph &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_nodes),
    const DeepCollectionEquality().hash(_edges),
    total,
    limit,
  );

  @override
  String toString() {
    return 'KnowledgeGraph(nodes: $nodes, edges: $edges, total: $total, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class _$KnowledgeGraphCopyWith<$Res>
    implements $KnowledgeGraphCopyWith<$Res> {
  factory _$KnowledgeGraphCopyWith(
    _KnowledgeGraph value,
    $Res Function(_KnowledgeGraph) _then,
  ) = __$KnowledgeGraphCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<KnowledgeNode> nodes,
    List<KnowledgeEdge> edges,
    int total,
    int limit,
  });
}

/// @nodoc
class __$KnowledgeGraphCopyWithImpl<$Res>
    implements _$KnowledgeGraphCopyWith<$Res> {
  __$KnowledgeGraphCopyWithImpl(this._self, this._then);

  final _KnowledgeGraph _self;
  final $Res Function(_KnowledgeGraph) _then;

  /// Create a copy of KnowledgeGraph
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? nodes = null,
    Object? edges = null,
    Object? total = null,
    Object? limit = null,
  }) {
    return _then(
      _KnowledgeGraph(
        nodes: null == nodes
            ? _self._nodes
            : nodes // ignore: cast_nullable_to_non_nullable
                  as List<KnowledgeNode>,
        edges: null == edges
            ? _self._edges
            : edges // ignore: cast_nullable_to_non_nullable
                  as List<KnowledgeEdge>,
        total: null == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
