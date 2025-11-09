// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LinksType _$LinksTypeFromJson(Map<String, dynamic> json) {
  return _LinksType.fromJson(json);
}

/// @nodoc
mixin _$LinksType {
  int? get first => throw _privateConstructorUsedError;
  int? get last => throw _privateConstructorUsedError;
  int? get prev => throw _privateConstructorUsedError;
  int? get next => throw _privateConstructorUsedError;

  /// Serializes this LinksType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LinksType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinksTypeCopyWith<LinksType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinksTypeCopyWith<$Res> {
  factory $LinksTypeCopyWith(LinksType value, $Res Function(LinksType) then) =
      _$LinksTypeCopyWithImpl<$Res, LinksType>;
  @useResult
  $Res call({int? first, int? last, int? prev, int? next});
}

/// @nodoc
class _$LinksTypeCopyWithImpl<$Res, $Val extends LinksType>
    implements $LinksTypeCopyWith<$Res> {
  _$LinksTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinksType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? first = freezed,
    Object? last = freezed,
    Object? prev = freezed,
    Object? next = freezed,
  }) {
    return _then(
      _value.copyWith(
            first: freezed == first
                ? _value.first
                : first // ignore: cast_nullable_to_non_nullable
                      as int?,
            last: freezed == last
                ? _value.last
                : last // ignore: cast_nullable_to_non_nullable
                      as int?,
            prev: freezed == prev
                ? _value.prev
                : prev // ignore: cast_nullable_to_non_nullable
                      as int?,
            next: freezed == next
                ? _value.next
                : next // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LinksTypeImplCopyWith<$Res>
    implements $LinksTypeCopyWith<$Res> {
  factory _$$LinksTypeImplCopyWith(
    _$LinksTypeImpl value,
    $Res Function(_$LinksTypeImpl) then,
  ) = __$$LinksTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? first, int? last, int? prev, int? next});
}

/// @nodoc
class __$$LinksTypeImplCopyWithImpl<$Res>
    extends _$LinksTypeCopyWithImpl<$Res, _$LinksTypeImpl>
    implements _$$LinksTypeImplCopyWith<$Res> {
  __$$LinksTypeImplCopyWithImpl(
    _$LinksTypeImpl _value,
    $Res Function(_$LinksTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinksType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? first = freezed,
    Object? last = freezed,
    Object? prev = freezed,
    Object? next = freezed,
  }) {
    return _then(
      _$LinksTypeImpl(
        first: freezed == first
            ? _value.first
            : first // ignore: cast_nullable_to_non_nullable
                  as int?,
        last: freezed == last
            ? _value.last
            : last // ignore: cast_nullable_to_non_nullable
                  as int?,
        prev: freezed == prev
            ? _value.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as int?,
        next: freezed == next
            ? _value.next
            : next // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LinksTypeImpl implements _LinksType {
  const _$LinksTypeImpl({this.first, this.last, this.prev, this.next});

  factory _$LinksTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$LinksTypeImplFromJson(json);

  @override
  final int? first;
  @override
  final int? last;
  @override
  final int? prev;
  @override
  final int? next;

  @override
  String toString() {
    return 'LinksType(first: $first, last: $last, prev: $prev, next: $next)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinksTypeImpl &&
            (identical(other.first, first) || other.first == first) &&
            (identical(other.last, last) || other.last == last) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            (identical(other.next, next) || other.next == next));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, first, last, prev, next);

  /// Create a copy of LinksType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinksTypeImplCopyWith<_$LinksTypeImpl> get copyWith =>
      __$$LinksTypeImplCopyWithImpl<_$LinksTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LinksTypeImplToJson(this);
  }
}

abstract class _LinksType implements LinksType {
  const factory _LinksType({
    final int? first,
    final int? last,
    final int? prev,
    final int? next,
  }) = _$LinksTypeImpl;

  factory _LinksType.fromJson(Map<String, dynamic> json) =
      _$LinksTypeImpl.fromJson;

  @override
  int? get first;
  @override
  int? get last;
  @override
  int? get prev;
  @override
  int? get next;

  /// Create a copy of LinksType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinksTypeImplCopyWith<_$LinksTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetaType _$MetaTypeFromJson(Map<String, dynamic> json) {
  return _MetaType.fromJson(json);
}

/// @nodoc
mixin _$MetaType {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this MetaType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetaType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaTypeCopyWith<MetaType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaTypeCopyWith<$Res> {
  factory $MetaTypeCopyWith(MetaType value, $Res Function(MetaType) then) =
      _$MetaTypeCopyWithImpl<$Res, MetaType>;
  @useResult
  $Res call({
    @JsonKey(name: 'current_page') int currentPage,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'per_page') int perPage,
    int total,
  });
}

/// @nodoc
class _$MetaTypeCopyWithImpl<$Res, $Val extends MetaType>
    implements $MetaTypeCopyWith<$Res> {
  _$MetaTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetaType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            perPage: null == perPage
                ? _value.perPage
                : perPage // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetaTypeImplCopyWith<$Res>
    implements $MetaTypeCopyWith<$Res> {
  factory _$$MetaTypeImplCopyWith(
    _$MetaTypeImpl value,
    $Res Function(_$MetaTypeImpl) then,
  ) = __$$MetaTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'current_page') int currentPage,
    @JsonKey(name: 'total_pages') int totalPages,
    @JsonKey(name: 'per_page') int perPage,
    int total,
  });
}

/// @nodoc
class __$$MetaTypeImplCopyWithImpl<$Res>
    extends _$MetaTypeCopyWithImpl<$Res, _$MetaTypeImpl>
    implements _$$MetaTypeImplCopyWith<$Res> {
  __$$MetaTypeImplCopyWithImpl(
    _$MetaTypeImpl _value,
    $Res Function(_$MetaTypeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetaType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? totalPages = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(
      _$MetaTypeImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        perPage: null == perPage
            ? _value.perPage
            : perPage // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaTypeImpl implements _MetaType {
  const _$MetaTypeImpl({
    @JsonKey(name: 'current_page') required this.currentPage,
    @JsonKey(name: 'total_pages') required this.totalPages,
    @JsonKey(name: 'per_page') required this.perPage,
    required this.total,
  });

  factory _$MetaTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaTypeImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  final int total;

  @override
  String toString() {
    return 'MetaType(currentPage: $currentPage, totalPages: $totalPages, perPage: $perPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaTypeImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentPage, totalPages, perPage, total);

  /// Create a copy of MetaType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaTypeImplCopyWith<_$MetaTypeImpl> get copyWith =>
      __$$MetaTypeImplCopyWithImpl<_$MetaTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaTypeImplToJson(this);
  }
}

abstract class _MetaType implements MetaType {
  const factory _MetaType({
    @JsonKey(name: 'current_page') required final int currentPage,
    @JsonKey(name: 'total_pages') required final int totalPages,
    @JsonKey(name: 'per_page') required final int perPage,
    required final int total,
  }) = _$MetaTypeImpl;

  factory _MetaType.fromJson(Map<String, dynamic> json) =
      _$MetaTypeImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  int get total;

  /// Create a copy of MetaType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaTypeImplCopyWith<_$MetaTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DataType<T> _$DataTypeFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object?) fromJsonT,
) {
  return _DataType<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$DataType<T> {
  List<T> get data => throw _privateConstructorUsedError;
  LinksType get links => throw _privateConstructorUsedError;
  MetaType get meta => throw _privateConstructorUsedError;

  /// Serializes this DataType to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataTypeCopyWith<T, DataType<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataTypeCopyWith<T, $Res> {
  factory $DataTypeCopyWith(
    DataType<T> value,
    $Res Function(DataType<T>) then,
  ) = _$DataTypeCopyWithImpl<T, $Res, DataType<T>>;
  @useResult
  $Res call({List<T> data, LinksType links, MetaType meta});

  $LinksTypeCopyWith<$Res> get links;
  $MetaTypeCopyWith<$Res> get meta;
}

/// @nodoc
class _$DataTypeCopyWithImpl<T, $Res, $Val extends DataType<T>>
    implements $DataTypeCopyWith<T, $Res> {
  _$DataTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? links = null, Object? meta = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<T>,
            links: null == links
                ? _value.links
                : links // ignore: cast_nullable_to_non_nullable
                      as LinksType,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as MetaType,
          )
          as $Val,
    );
  }

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LinksTypeCopyWith<$Res> get links {
    return $LinksTypeCopyWith<$Res>(_value.links, (value) {
      return _then(_value.copyWith(links: value) as $Val);
    });
  }

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaTypeCopyWith<$Res> get meta {
    return $MetaTypeCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DataTypeImplCopyWith<T, $Res>
    implements $DataTypeCopyWith<T, $Res> {
  factory _$$DataTypeImplCopyWith(
    _$DataTypeImpl<T> value,
    $Res Function(_$DataTypeImpl<T>) then,
  ) = __$$DataTypeImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({List<T> data, LinksType links, MetaType meta});

  @override
  $LinksTypeCopyWith<$Res> get links;
  @override
  $MetaTypeCopyWith<$Res> get meta;
}

/// @nodoc
class __$$DataTypeImplCopyWithImpl<T, $Res>
    extends _$DataTypeCopyWithImpl<T, $Res, _$DataTypeImpl<T>>
    implements _$$DataTypeImplCopyWith<T, $Res> {
  __$$DataTypeImplCopyWithImpl(
    _$DataTypeImpl<T> _value,
    $Res Function(_$DataTypeImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? links = null, Object? meta = null}) {
    return _then(
      _$DataTypeImpl<T>(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<T>,
        links: null == links
            ? _value.links
            : links // ignore: cast_nullable_to_non_nullable
                  as LinksType,
        meta: null == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as MetaType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$DataTypeImpl<T> implements _DataType<T> {
  const _$DataTypeImpl({
    required final List<T> data,
    required this.links,
    required this.meta,
  }) : _data = data;

  factory _$DataTypeImpl.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$$DataTypeImplFromJson(json, fromJsonT);

  final List<T> _data;
  @override
  List<T> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final LinksType links;
  @override
  final MetaType meta;

  @override
  String toString() {
    return 'DataType<$T>(data: $data, links: $links, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataTypeImpl<T> &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.links, links) || other.links == links) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    links,
    meta,
  );

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataTypeImplCopyWith<T, _$DataTypeImpl<T>> get copyWith =>
      __$$DataTypeImplCopyWithImpl<T, _$DataTypeImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$DataTypeImplToJson<T>(this, toJsonT);
  }
}

abstract class _DataType<T> implements DataType<T> {
  const factory _DataType({
    required final List<T> data,
    required final LinksType links,
    required final MetaType meta,
  }) = _$DataTypeImpl<T>;

  factory _DataType.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) = _$DataTypeImpl<T>.fromJson;

  @override
  List<T> get data;
  @override
  LinksType get links;
  @override
  MetaType get meta;

  /// Create a copy of DataType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataTypeImplCopyWith<T, _$DataTypeImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
