// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concordance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParsedReference _$ParsedReferenceFromJson(Map<String, dynamic> json) {
  return _ParsedReference.fromJson(json);
}

/// @nodoc
mixin _$ParsedReference {
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'sermon_number')
  int get sermonNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'verse_number')
  int get verseNumber => throw _privateConstructorUsedError;

  /// Serializes this ParsedReference to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParsedReference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParsedReferenceCopyWith<ParsedReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParsedReferenceCopyWith<$Res> {
  factory $ParsedReferenceCopyWith(
    ParsedReference value,
    $Res Function(ParsedReference) then,
  ) = _$ParsedReferenceCopyWithImpl<$Res, ParsedReference>;
  @useResult
  $Res call({
    String label,
    @JsonKey(name: 'sermon_number') int sermonNumber,
    @JsonKey(name: 'verse_number') int verseNumber,
  });
}

/// @nodoc
class _$ParsedReferenceCopyWithImpl<$Res, $Val extends ParsedReference>
    implements $ParsedReferenceCopyWith<$Res> {
  _$ParsedReferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParsedReference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? sermonNumber = null,
    Object? verseNumber = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            sermonNumber: null == sermonNumber
                ? _value.sermonNumber
                : sermonNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            verseNumber: null == verseNumber
                ? _value.verseNumber
                : verseNumber // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParsedReferenceImplCopyWith<$Res>
    implements $ParsedReferenceCopyWith<$Res> {
  factory _$$ParsedReferenceImplCopyWith(
    _$ParsedReferenceImpl value,
    $Res Function(_$ParsedReferenceImpl) then,
  ) = __$$ParsedReferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    @JsonKey(name: 'sermon_number') int sermonNumber,
    @JsonKey(name: 'verse_number') int verseNumber,
  });
}

/// @nodoc
class __$$ParsedReferenceImplCopyWithImpl<$Res>
    extends _$ParsedReferenceCopyWithImpl<$Res, _$ParsedReferenceImpl>
    implements _$$ParsedReferenceImplCopyWith<$Res> {
  __$$ParsedReferenceImplCopyWithImpl(
    _$ParsedReferenceImpl _value,
    $Res Function(_$ParsedReferenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParsedReference
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? sermonNumber = null,
    Object? verseNumber = null,
  }) {
    return _then(
      _$ParsedReferenceImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        sermonNumber: null == sermonNumber
            ? _value.sermonNumber
            : sermonNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        verseNumber: null == verseNumber
            ? _value.verseNumber
            : verseNumber // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParsedReferenceImpl implements _ParsedReference {
  const _$ParsedReferenceImpl({
    required this.label,
    @JsonKey(name: 'sermon_number') required this.sermonNumber,
    @JsonKey(name: 'verse_number') required this.verseNumber,
  });

  factory _$ParsedReferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParsedReferenceImplFromJson(json);

  @override
  final String label;
  @override
  @JsonKey(name: 'sermon_number')
  final int sermonNumber;
  @override
  @JsonKey(name: 'verse_number')
  final int verseNumber;

  @override
  String toString() {
    return 'ParsedReference(label: $label, sermonNumber: $sermonNumber, verseNumber: $verseNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsedReferenceImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.sermonNumber, sermonNumber) ||
                other.sermonNumber == sermonNumber) &&
            (identical(other.verseNumber, verseNumber) ||
                other.verseNumber == verseNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, sermonNumber, verseNumber);

  /// Create a copy of ParsedReference
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsedReferenceImplCopyWith<_$ParsedReferenceImpl> get copyWith =>
      __$$ParsedReferenceImplCopyWithImpl<_$ParsedReferenceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ParsedReferenceImplToJson(this);
  }
}

abstract class _ParsedReference implements ParsedReference {
  const factory _ParsedReference({
    required final String label,
    @JsonKey(name: 'sermon_number') required final int sermonNumber,
    @JsonKey(name: 'verse_number') required final int verseNumber,
  }) = _$ParsedReferenceImpl;

  factory _ParsedReference.fromJson(Map<String, dynamic> json) =
      _$ParsedReferenceImpl.fromJson;

  @override
  String get label;
  @override
  @JsonKey(name: 'sermon_number')
  int get sermonNumber;
  @override
  @JsonKey(name: 'verse_number')
  int get verseNumber;

  /// Create a copy of ParsedReference
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParsedReferenceImplCopyWith<_$ParsedReferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConcordanceItem _$ConcordanceItemFromJson(Map<String, dynamic> json) {
  return _ConcordanceItem.fromJson(json);
}

/// @nodoc
mixin _$ConcordanceItem {
  String get label => throw _privateConstructorUsedError;
  @JsonKey(name: 'sermon_number')
  int get sermonNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'verse_number')
  int get verseNumber => throw _privateConstructorUsedError;

  /// Serializes this ConcordanceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConcordanceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConcordanceItemCopyWith<ConcordanceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConcordanceItemCopyWith<$Res> {
  factory $ConcordanceItemCopyWith(
    ConcordanceItem value,
    $Res Function(ConcordanceItem) then,
  ) = _$ConcordanceItemCopyWithImpl<$Res, ConcordanceItem>;
  @useResult
  $Res call({
    String label,
    @JsonKey(name: 'sermon_number') int sermonNumber,
    @JsonKey(name: 'verse_number') int verseNumber,
  });
}

/// @nodoc
class _$ConcordanceItemCopyWithImpl<$Res, $Val extends ConcordanceItem>
    implements $ConcordanceItemCopyWith<$Res> {
  _$ConcordanceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConcordanceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? sermonNumber = null,
    Object? verseNumber = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            sermonNumber: null == sermonNumber
                ? _value.sermonNumber
                : sermonNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            verseNumber: null == verseNumber
                ? _value.verseNumber
                : verseNumber // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConcordanceItemImplCopyWith<$Res>
    implements $ConcordanceItemCopyWith<$Res> {
  factory _$$ConcordanceItemImplCopyWith(
    _$ConcordanceItemImpl value,
    $Res Function(_$ConcordanceItemImpl) then,
  ) = __$$ConcordanceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    @JsonKey(name: 'sermon_number') int sermonNumber,
    @JsonKey(name: 'verse_number') int verseNumber,
  });
}

/// @nodoc
class __$$ConcordanceItemImplCopyWithImpl<$Res>
    extends _$ConcordanceItemCopyWithImpl<$Res, _$ConcordanceItemImpl>
    implements _$$ConcordanceItemImplCopyWith<$Res> {
  __$$ConcordanceItemImplCopyWithImpl(
    _$ConcordanceItemImpl _value,
    $Res Function(_$ConcordanceItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConcordanceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? sermonNumber = null,
    Object? verseNumber = null,
  }) {
    return _then(
      _$ConcordanceItemImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        sermonNumber: null == sermonNumber
            ? _value.sermonNumber
            : sermonNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        verseNumber: null == verseNumber
            ? _value.verseNumber
            : verseNumber // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConcordanceItemImpl implements _ConcordanceItem {
  const _$ConcordanceItemImpl({
    required this.label,
    @JsonKey(name: 'sermon_number') required this.sermonNumber,
    @JsonKey(name: 'verse_number') required this.verseNumber,
  });

  factory _$ConcordanceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConcordanceItemImplFromJson(json);

  @override
  final String label;
  @override
  @JsonKey(name: 'sermon_number')
  final int sermonNumber;
  @override
  @JsonKey(name: 'verse_number')
  final int verseNumber;

  @override
  String toString() {
    return 'ConcordanceItem(label: $label, sermonNumber: $sermonNumber, verseNumber: $verseNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConcordanceItemImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.sermonNumber, sermonNumber) ||
                other.sermonNumber == sermonNumber) &&
            (identical(other.verseNumber, verseNumber) ||
                other.verseNumber == verseNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, sermonNumber, verseNumber);

  /// Create a copy of ConcordanceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConcordanceItemImplCopyWith<_$ConcordanceItemImpl> get copyWith =>
      __$$ConcordanceItemImplCopyWithImpl<_$ConcordanceItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConcordanceItemImplToJson(this);
  }
}

abstract class _ConcordanceItem implements ConcordanceItem {
  const factory _ConcordanceItem({
    required final String label,
    @JsonKey(name: 'sermon_number') required final int sermonNumber,
    @JsonKey(name: 'verse_number') required final int verseNumber,
  }) = _$ConcordanceItemImpl;

  factory _ConcordanceItem.fromJson(Map<String, dynamic> json) =
      _$ConcordanceItemImpl.fromJson;

  @override
  String get label;
  @override
  @JsonKey(name: 'sermon_number')
  int get sermonNumber;
  @override
  @JsonKey(name: 'verse_number')
  int get verseNumber;

  /// Create a copy of ConcordanceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConcordanceItemImplCopyWith<_$ConcordanceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Concordance _$ConcordanceFromJson(Map<String, dynamic> json) {
  return _Concordance.fromJson(json);
}

/// @nodoc
mixin _$Concordance {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'num_pred')
  int get numPred => throw _privateConstructorUsedError;
  @JsonKey(name: 'num_verset')
  int get numVerset => throw _privateConstructorUsedError;
  List<ConcordanceItem> get concordance => throw _privateConstructorUsedError;

  /// Serializes this Concordance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Concordance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConcordanceCopyWith<Concordance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConcordanceCopyWith<$Res> {
  factory $ConcordanceCopyWith(
    Concordance value,
    $Res Function(Concordance) then,
  ) = _$ConcordanceCopyWithImpl<$Res, Concordance>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'num_pred') int numPred,
    @JsonKey(name: 'num_verset') int numVerset,
    List<ConcordanceItem> concordance,
  });
}

/// @nodoc
class _$ConcordanceCopyWithImpl<$Res, $Val extends Concordance>
    implements $ConcordanceCopyWith<$Res> {
  _$ConcordanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Concordance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numPred = null,
    Object? numVerset = null,
    Object? concordance = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            numPred: null == numPred
                ? _value.numPred
                : numPred // ignore: cast_nullable_to_non_nullable
                      as int,
            numVerset: null == numVerset
                ? _value.numVerset
                : numVerset // ignore: cast_nullable_to_non_nullable
                      as int,
            concordance: null == concordance
                ? _value.concordance
                : concordance // ignore: cast_nullable_to_non_nullable
                      as List<ConcordanceItem>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConcordanceImplCopyWith<$Res>
    implements $ConcordanceCopyWith<$Res> {
  factory _$$ConcordanceImplCopyWith(
    _$ConcordanceImpl value,
    $Res Function(_$ConcordanceImpl) then,
  ) = __$$ConcordanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'num_pred') int numPred,
    @JsonKey(name: 'num_verset') int numVerset,
    List<ConcordanceItem> concordance,
  });
}

/// @nodoc
class __$$ConcordanceImplCopyWithImpl<$Res>
    extends _$ConcordanceCopyWithImpl<$Res, _$ConcordanceImpl>
    implements _$$ConcordanceImplCopyWith<$Res> {
  __$$ConcordanceImplCopyWithImpl(
    _$ConcordanceImpl _value,
    $Res Function(_$ConcordanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Concordance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numPred = null,
    Object? numVerset = null,
    Object? concordance = null,
  }) {
    return _then(
      _$ConcordanceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        numPred: null == numPred
            ? _value.numPred
            : numPred // ignore: cast_nullable_to_non_nullable
                  as int,
        numVerset: null == numVerset
            ? _value.numVerset
            : numVerset // ignore: cast_nullable_to_non_nullable
                  as int,
        concordance: null == concordance
            ? _value._concordance
            : concordance // ignore: cast_nullable_to_non_nullable
                  as List<ConcordanceItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConcordanceImpl implements _Concordance {
  const _$ConcordanceImpl({
    required this.id,
    @JsonKey(name: 'num_pred') required this.numPred,
    @JsonKey(name: 'num_verset') required this.numVerset,
    required final List<ConcordanceItem> concordance,
  }) : _concordance = concordance;

  factory _$ConcordanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConcordanceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'num_pred')
  final int numPred;
  @override
  @JsonKey(name: 'num_verset')
  final int numVerset;
  final List<ConcordanceItem> _concordance;
  @override
  List<ConcordanceItem> get concordance {
    if (_concordance is EqualUnmodifiableListView) return _concordance;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_concordance);
  }

  @override
  String toString() {
    return 'Concordance(id: $id, numPred: $numPred, numVerset: $numVerset, concordance: $concordance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConcordanceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.numPred, numPred) || other.numPred == numPred) &&
            (identical(other.numVerset, numVerset) ||
                other.numVerset == numVerset) &&
            const DeepCollectionEquality().equals(
              other._concordance,
              _concordance,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    numPred,
    numVerset,
    const DeepCollectionEquality().hash(_concordance),
  );

  /// Create a copy of Concordance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConcordanceImplCopyWith<_$ConcordanceImpl> get copyWith =>
      __$$ConcordanceImplCopyWithImpl<_$ConcordanceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConcordanceImplToJson(this);
  }
}

abstract class _Concordance implements Concordance {
  const factory _Concordance({
    required final int id,
    @JsonKey(name: 'num_pred') required final int numPred,
    @JsonKey(name: 'num_verset') required final int numVerset,
    required final List<ConcordanceItem> concordance,
  }) = _$ConcordanceImpl;

  factory _Concordance.fromJson(Map<String, dynamic> json) =
      _$ConcordanceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'num_pred')
  int get numPred;
  @override
  @JsonKey(name: 'num_verset')
  int get numVerset;
  @override
  List<ConcordanceItem> get concordance;

  /// Create a copy of Concordance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConcordanceImplCopyWith<_$ConcordanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
