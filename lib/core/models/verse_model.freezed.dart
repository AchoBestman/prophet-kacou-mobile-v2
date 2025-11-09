// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VerseLink _$VerseLinkFromJson(Map<String, dynamic> json) {
  return _VerseLink.fromJson(json);
}

/// @nodoc
mixin _$VerseLink {
  String get url => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String? get fileName => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;

  /// Serializes this VerseLink to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerseLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerseLinkCopyWith<VerseLink> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerseLinkCopyWith<$Res> {
  factory $VerseLinkCopyWith(VerseLink value, $Res Function(VerseLink) then) =
      _$VerseLinkCopyWithImpl<$Res, VerseLink>;
  @useResult
  $Res call({
    String url,
    String type,
    @JsonKey(name: 'file_name') String? fileName,
    String? content,
  });
}

/// @nodoc
class _$VerseLinkCopyWithImpl<$Res, $Val extends VerseLink>
    implements $VerseLinkCopyWith<$Res> {
  _$VerseLinkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerseLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = null,
    Object? fileName = freezed,
    Object? content = freezed,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: freezed == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VerseLinkImplCopyWith<$Res>
    implements $VerseLinkCopyWith<$Res> {
  factory _$$VerseLinkImplCopyWith(
    _$VerseLinkImpl value,
    $Res Function(_$VerseLinkImpl) then,
  ) = __$$VerseLinkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String url,
    String type,
    @JsonKey(name: 'file_name') String? fileName,
    String? content,
  });
}

/// @nodoc
class __$$VerseLinkImplCopyWithImpl<$Res>
    extends _$VerseLinkCopyWithImpl<$Res, _$VerseLinkImpl>
    implements _$$VerseLinkImplCopyWith<$Res> {
  __$$VerseLinkImplCopyWithImpl(
    _$VerseLinkImpl _value,
    $Res Function(_$VerseLinkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VerseLink
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? type = null,
    Object? fileName = freezed,
    Object? content = freezed,
  }) {
    return _then(
      _$VerseLinkImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: freezed == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerseLinkImpl implements _VerseLink {
  const _$VerseLinkImpl({
    required this.url,
    required this.type,
    @JsonKey(name: 'file_name') this.fileName,
    this.content,
  });

  factory _$VerseLinkImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerseLinkImplFromJson(json);

  @override
  final String url;
  @override
  final String type;
  @override
  @JsonKey(name: 'file_name')
  final String? fileName;
  @override
  final String? content;

  @override
  String toString() {
    return 'VerseLink(url: $url, type: $type, fileName: $fileName, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerseLinkImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, type, fileName, content);

  /// Create a copy of VerseLink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerseLinkImplCopyWith<_$VerseLinkImpl> get copyWith =>
      __$$VerseLinkImplCopyWithImpl<_$VerseLinkImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerseLinkImplToJson(this);
  }
}

abstract class _VerseLink implements VerseLink {
  const factory _VerseLink({
    required final String url,
    required final String type,
    @JsonKey(name: 'file_name') final String? fileName,
    final String? content,
  }) = _$VerseLinkImpl;

  factory _VerseLink.fromJson(Map<String, dynamic> json) =
      _$VerseLinkImpl.fromJson;

  @override
  String get url;
  @override
  String get type;
  @override
  @JsonKey(name: 'file_name')
  String? get fileName;
  @override
  String? get content;

  /// Create a copy of VerseLink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerseLinkImplCopyWith<_$VerseLinkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return _Verse.fromJson(json);
}

/// @nodoc
mixin _$Verse {
  int get id => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get info => throw _privateConstructorUsedError;
  @JsonKey(name: 'link_at_content')
  String? get linkAtContent => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_content')
  String? get urlContent => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'sermon_id')
  int get sermonId => throw _privateConstructorUsedError;
  Concordance? get concordances => throw _privateConstructorUsedError;
  String? get concordance => throw _privateConstructorUsedError;
  @JsonKey(name: 'verse_links')
  List<VerseLink>? get verseLinks => throw _privateConstructorUsedError;

  /// Serializes this Verse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerseCopyWith<Verse> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerseCopyWith<$Res> {
  factory $VerseCopyWith(Verse value, $Res Function(Verse) then) =
      _$VerseCopyWithImpl<$Res, Verse>;
  @useResult
  $Res call({
    int id,
    int number,
    String content,
    String? info,
    @JsonKey(name: 'link_at_content') String? linkAtContent,
    @JsonKey(name: 'url_content') String? urlContent,
    String? title,
    @JsonKey(name: 'sermon_id') int sermonId,
    Concordance? concordances,
    String? concordance,
    @JsonKey(name: 'verse_links') List<VerseLink>? verseLinks,
  });

  $ConcordanceCopyWith<$Res>? get concordances;
}

/// @nodoc
class _$VerseCopyWithImpl<$Res, $Val extends Verse>
    implements $VerseCopyWith<$Res> {
  _$VerseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? content = null,
    Object? info = freezed,
    Object? linkAtContent = freezed,
    Object? urlContent = freezed,
    Object? title = freezed,
    Object? sermonId = null,
    Object? concordances = freezed,
    Object? concordance = freezed,
    Object? verseLinks = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            info: freezed == info
                ? _value.info
                : info // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkAtContent: freezed == linkAtContent
                ? _value.linkAtContent
                : linkAtContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            urlContent: freezed == urlContent
                ? _value.urlContent
                : urlContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            sermonId: null == sermonId
                ? _value.sermonId
                : sermonId // ignore: cast_nullable_to_non_nullable
                      as int,
            concordances: freezed == concordances
                ? _value.concordances
                : concordances // ignore: cast_nullable_to_non_nullable
                      as Concordance?,
            concordance: freezed == concordance
                ? _value.concordance
                : concordance // ignore: cast_nullable_to_non_nullable
                      as String?,
            verseLinks: freezed == verseLinks
                ? _value.verseLinks
                : verseLinks // ignore: cast_nullable_to_non_nullable
                      as List<VerseLink>?,
          )
          as $Val,
    );
  }

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConcordanceCopyWith<$Res>? get concordances {
    if (_value.concordances == null) {
      return null;
    }

    return $ConcordanceCopyWith<$Res>(_value.concordances!, (value) {
      return _then(_value.copyWith(concordances: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerseImplCopyWith<$Res> implements $VerseCopyWith<$Res> {
  factory _$$VerseImplCopyWith(
    _$VerseImpl value,
    $Res Function(_$VerseImpl) then,
  ) = __$$VerseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int number,
    String content,
    String? info,
    @JsonKey(name: 'link_at_content') String? linkAtContent,
    @JsonKey(name: 'url_content') String? urlContent,
    String? title,
    @JsonKey(name: 'sermon_id') int sermonId,
    Concordance? concordances,
    String? concordance,
    @JsonKey(name: 'verse_links') List<VerseLink>? verseLinks,
  });

  @override
  $ConcordanceCopyWith<$Res>? get concordances;
}

/// @nodoc
class __$$VerseImplCopyWithImpl<$Res>
    extends _$VerseCopyWithImpl<$Res, _$VerseImpl>
    implements _$$VerseImplCopyWith<$Res> {
  __$$VerseImplCopyWithImpl(
    _$VerseImpl _value,
    $Res Function(_$VerseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? content = null,
    Object? info = freezed,
    Object? linkAtContent = freezed,
    Object? urlContent = freezed,
    Object? title = freezed,
    Object? sermonId = null,
    Object? concordances = freezed,
    Object? concordance = freezed,
    Object? verseLinks = freezed,
  }) {
    return _then(
      _$VerseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        info: freezed == info
            ? _value.info
            : info // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkAtContent: freezed == linkAtContent
            ? _value.linkAtContent
            : linkAtContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        urlContent: freezed == urlContent
            ? _value.urlContent
            : urlContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        sermonId: null == sermonId
            ? _value.sermonId
            : sermonId // ignore: cast_nullable_to_non_nullable
                  as int,
        concordances: freezed == concordances
            ? _value.concordances
            : concordances // ignore: cast_nullable_to_non_nullable
                  as Concordance?,
        concordance: freezed == concordance
            ? _value.concordance
            : concordance // ignore: cast_nullable_to_non_nullable
                  as String?,
        verseLinks: freezed == verseLinks
            ? _value._verseLinks
            : verseLinks // ignore: cast_nullable_to_non_nullable
                  as List<VerseLink>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VerseImpl implements _Verse {
  const _$VerseImpl({
    required this.id,
    required this.number,
    required this.content,
    this.info,
    @JsonKey(name: 'link_at_content') this.linkAtContent,
    @JsonKey(name: 'url_content') this.urlContent,
    this.title,
    @JsonKey(name: 'sermon_id') required this.sermonId,
    this.concordances,
    this.concordance,
    @JsonKey(name: 'verse_links') final List<VerseLink>? verseLinks,
  }) : _verseLinks = verseLinks;

  factory _$VerseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerseImplFromJson(json);

  @override
  final int id;
  @override
  final int number;
  @override
  final String content;
  @override
  final String? info;
  @override
  @JsonKey(name: 'link_at_content')
  final String? linkAtContent;
  @override
  @JsonKey(name: 'url_content')
  final String? urlContent;
  @override
  final String? title;
  @override
  @JsonKey(name: 'sermon_id')
  final int sermonId;
  @override
  final Concordance? concordances;
  @override
  final String? concordance;
  final List<VerseLink>? _verseLinks;
  @override
  @JsonKey(name: 'verse_links')
  List<VerseLink>? get verseLinks {
    final value = _verseLinks;
    if (value == null) return null;
    if (_verseLinks is EqualUnmodifiableListView) return _verseLinks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Verse(id: $id, number: $number, content: $content, info: $info, linkAtContent: $linkAtContent, urlContent: $urlContent, title: $title, sermonId: $sermonId, concordances: $concordances, concordance: $concordance, verseLinks: $verseLinks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.linkAtContent, linkAtContent) ||
                other.linkAtContent == linkAtContent) &&
            (identical(other.urlContent, urlContent) ||
                other.urlContent == urlContent) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sermonId, sermonId) ||
                other.sermonId == sermonId) &&
            (identical(other.concordances, concordances) ||
                other.concordances == concordances) &&
            (identical(other.concordance, concordance) ||
                other.concordance == concordance) &&
            const DeepCollectionEquality().equals(
              other._verseLinks,
              _verseLinks,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    number,
    content,
    info,
    linkAtContent,
    urlContent,
    title,
    sermonId,
    concordances,
    concordance,
    const DeepCollectionEquality().hash(_verseLinks),
  );

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerseImplCopyWith<_$VerseImpl> get copyWith =>
      __$$VerseImplCopyWithImpl<_$VerseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerseImplToJson(this);
  }
}

abstract class _Verse implements Verse {
  const factory _Verse({
    required final int id,
    required final int number,
    required final String content,
    final String? info,
    @JsonKey(name: 'link_at_content') final String? linkAtContent,
    @JsonKey(name: 'url_content') final String? urlContent,
    final String? title,
    @JsonKey(name: 'sermon_id') required final int sermonId,
    final Concordance? concordances,
    final String? concordance,
    @JsonKey(name: 'verse_links') final List<VerseLink>? verseLinks,
  }) = _$VerseImpl;

  factory _Verse.fromJson(Map<String, dynamic> json) = _$VerseImpl.fromJson;

  @override
  int get id;
  @override
  int get number;
  @override
  String get content;
  @override
  String? get info;
  @override
  @JsonKey(name: 'link_at_content')
  String? get linkAtContent;
  @override
  @JsonKey(name: 'url_content')
  String? get urlContent;
  @override
  String? get title;
  @override
  @JsonKey(name: 'sermon_id')
  int get sermonId;
  @override
  Concordance? get concordances;
  @override
  String? get concordance;
  @override
  @JsonKey(name: 'verse_links')
  List<VerseLink>? get verseLinks;

  /// Create a copy of Verse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerseImplCopyWith<_$VerseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
