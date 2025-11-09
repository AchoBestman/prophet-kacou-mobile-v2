// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sermon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Sermon _$SermonFromJson(Map<String, dynamic> json) {
  return _Sermon.fromJson(json);
}

/// @nodoc
mixin _$Sermon {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_title')
  String? get subTitle => throw _privateConstructorUsedError;
  int get number => throw _privateConstructorUsedError;
  @JsonKey(name: 'verse_number')
  dynamic get verseNumber => throw _privateConstructorUsedError; // peut être int ou String
  String? get audio => throw _privateConstructorUsedError;
  @JsonKey(name: 'audio_name')
  String? get audioName => throw _privateConstructorUsedError;
  String? get video => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String get chapter => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_picture')
  String? get coverPicture => throw _privateConstructorUsedError;
  String? get cover => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'similar_sermon')
  String? get similarSermon => throw _privateConstructorUsedError;
  @JsonKey(name: 'publication_date')
  String? get publicationDate => throw _privateConstructorUsedError;
  String? get pdf => throw _privateConstructorUsedError;
  String? get epub => throw _privateConstructorUsedError;
  String? get legende => throw _privateConstructorUsedError;
  List<Verse>? get verses => throw _privateConstructorUsedError;

  /// Serializes this Sermon to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sermon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SermonCopyWith<Sermon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SermonCopyWith<$Res> {
  factory $SermonCopyWith(Sermon value, $Res Function(Sermon) then) =
      _$SermonCopyWithImpl<$Res, Sermon>;
  @useResult
  $Res call({
    int id,
    String title,
    @JsonKey(name: 'sub_title') String? subTitle,
    int number,
    @JsonKey(name: 'verse_number') dynamic verseNumber,
    String? audio,
    @JsonKey(name: 'audio_name') String? audioName,
    String? video,
    String? time,
    String chapter,
    @JsonKey(name: 'cover_picture') String? coverPicture,
    String? cover,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'similar_sermon') String? similarSermon,
    @JsonKey(name: 'publication_date') String? publicationDate,
    String? pdf,
    String? epub,
    String? legende,
    List<Verse>? verses,
  });
}

/// @nodoc
class _$SermonCopyWithImpl<$Res, $Val extends Sermon>
    implements $SermonCopyWith<$Res> {
  _$SermonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sermon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subTitle = freezed,
    Object? number = null,
    Object? verseNumber = freezed,
    Object? audio = freezed,
    Object? audioName = freezed,
    Object? video = freezed,
    Object? time = freezed,
    Object? chapter = null,
    Object? coverPicture = freezed,
    Object? cover = freezed,
    Object? coverUrl = freezed,
    Object? similarSermon = freezed,
    Object? publicationDate = freezed,
    Object? pdf = freezed,
    Object? epub = freezed,
    Object? legende = freezed,
    Object? verses = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subTitle: freezed == subTitle
                ? _value.subTitle
                : subTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            verseNumber: freezed == verseNumber
                ? _value.verseNumber
                : verseNumber // ignore: cast_nullable_to_non_nullable
                      as dynamic,
            audio: freezed == audio
                ? _value.audio
                : audio // ignore: cast_nullable_to_non_nullable
                      as String?,
            audioName: freezed == audioName
                ? _value.audioName
                : audioName // ignore: cast_nullable_to_non_nullable
                      as String?,
            video: freezed == video
                ? _value.video
                : video // ignore: cast_nullable_to_non_nullable
                      as String?,
            time: freezed == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String?,
            chapter: null == chapter
                ? _value.chapter
                : chapter // ignore: cast_nullable_to_non_nullable
                      as String,
            coverPicture: freezed == coverPicture
                ? _value.coverPicture
                : coverPicture // ignore: cast_nullable_to_non_nullable
                      as String?,
            cover: freezed == cover
                ? _value.cover
                : cover // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            similarSermon: freezed == similarSermon
                ? _value.similarSermon
                : similarSermon // ignore: cast_nullable_to_non_nullable
                      as String?,
            publicationDate: freezed == publicationDate
                ? _value.publicationDate
                : publicationDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            pdf: freezed == pdf
                ? _value.pdf
                : pdf // ignore: cast_nullable_to_non_nullable
                      as String?,
            epub: freezed == epub
                ? _value.epub
                : epub // ignore: cast_nullable_to_non_nullable
                      as String?,
            legende: freezed == legende
                ? _value.legende
                : legende // ignore: cast_nullable_to_non_nullable
                      as String?,
            verses: freezed == verses
                ? _value.verses
                : verses // ignore: cast_nullable_to_non_nullable
                      as List<Verse>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SermonImplCopyWith<$Res> implements $SermonCopyWith<$Res> {
  factory _$$SermonImplCopyWith(
    _$SermonImpl value,
    $Res Function(_$SermonImpl) then,
  ) = __$$SermonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    @JsonKey(name: 'sub_title') String? subTitle,
    int number,
    @JsonKey(name: 'verse_number') dynamic verseNumber,
    String? audio,
    @JsonKey(name: 'audio_name') String? audioName,
    String? video,
    String? time,
    String chapter,
    @JsonKey(name: 'cover_picture') String? coverPicture,
    String? cover,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'similar_sermon') String? similarSermon,
    @JsonKey(name: 'publication_date') String? publicationDate,
    String? pdf,
    String? epub,
    String? legende,
    List<Verse>? verses,
  });
}

/// @nodoc
class __$$SermonImplCopyWithImpl<$Res>
    extends _$SermonCopyWithImpl<$Res, _$SermonImpl>
    implements _$$SermonImplCopyWith<$Res> {
  __$$SermonImplCopyWithImpl(
    _$SermonImpl _value,
    $Res Function(_$SermonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Sermon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subTitle = freezed,
    Object? number = null,
    Object? verseNumber = freezed,
    Object? audio = freezed,
    Object? audioName = freezed,
    Object? video = freezed,
    Object? time = freezed,
    Object? chapter = null,
    Object? coverPicture = freezed,
    Object? cover = freezed,
    Object? coverUrl = freezed,
    Object? similarSermon = freezed,
    Object? publicationDate = freezed,
    Object? pdf = freezed,
    Object? epub = freezed,
    Object? legende = freezed,
    Object? verses = freezed,
  }) {
    return _then(
      _$SermonImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subTitle: freezed == subTitle
            ? _value.subTitle
            : subTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        verseNumber: freezed == verseNumber
            ? _value.verseNumber
            : verseNumber // ignore: cast_nullable_to_non_nullable
                  as dynamic,
        audio: freezed == audio
            ? _value.audio
            : audio // ignore: cast_nullable_to_non_nullable
                  as String?,
        audioName: freezed == audioName
            ? _value.audioName
            : audioName // ignore: cast_nullable_to_non_nullable
                  as String?,
        video: freezed == video
            ? _value.video
            : video // ignore: cast_nullable_to_non_nullable
                  as String?,
        time: freezed == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String?,
        chapter: null == chapter
            ? _value.chapter
            : chapter // ignore: cast_nullable_to_non_nullable
                  as String,
        coverPicture: freezed == coverPicture
            ? _value.coverPicture
            : coverPicture // ignore: cast_nullable_to_non_nullable
                  as String?,
        cover: freezed == cover
            ? _value.cover
            : cover // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        similarSermon: freezed == similarSermon
            ? _value.similarSermon
            : similarSermon // ignore: cast_nullable_to_non_nullable
                  as String?,
        publicationDate: freezed == publicationDate
            ? _value.publicationDate
            : publicationDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        pdf: freezed == pdf
            ? _value.pdf
            : pdf // ignore: cast_nullable_to_non_nullable
                  as String?,
        epub: freezed == epub
            ? _value.epub
            : epub // ignore: cast_nullable_to_non_nullable
                  as String?,
        legende: freezed == legende
            ? _value.legende
            : legende // ignore: cast_nullable_to_non_nullable
                  as String?,
        verses: freezed == verses
            ? _value._verses
            : verses // ignore: cast_nullable_to_non_nullable
                  as List<Verse>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SermonImpl implements _Sermon {
  const _$SermonImpl({
    required this.id,
    required this.title,
    @JsonKey(name: 'sub_title') this.subTitle,
    required this.number,
    @JsonKey(name: 'verse_number') this.verseNumber,
    this.audio,
    @JsonKey(name: 'audio_name') this.audioName,
    this.video,
    this.time,
    required this.chapter,
    @JsonKey(name: 'cover_picture') this.coverPicture,
    this.cover,
    @JsonKey(name: 'cover_url') this.coverUrl,
    @JsonKey(name: 'similar_sermon') this.similarSermon,
    @JsonKey(name: 'publication_date') this.publicationDate,
    this.pdf,
    this.epub,
    this.legende,
    final List<Verse>? verses,
  }) : _verses = verses;

  factory _$SermonImpl.fromJson(Map<String, dynamic> json) =>
      _$$SermonImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: 'sub_title')
  final String? subTitle;
  @override
  final int number;
  @override
  @JsonKey(name: 'verse_number')
  final dynamic verseNumber;
  // peut être int ou String
  @override
  final String? audio;
  @override
  @JsonKey(name: 'audio_name')
  final String? audioName;
  @override
  final String? video;
  @override
  final String? time;
  @override
  final String chapter;
  @override
  @JsonKey(name: 'cover_picture')
  final String? coverPicture;
  @override
  final String? cover;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  @JsonKey(name: 'similar_sermon')
  final String? similarSermon;
  @override
  @JsonKey(name: 'publication_date')
  final String? publicationDate;
  @override
  final String? pdf;
  @override
  final String? epub;
  @override
  final String? legende;
  final List<Verse>? _verses;
  @override
  List<Verse>? get verses {
    final value = _verses;
    if (value == null) return null;
    if (_verses is EqualUnmodifiableListView) return _verses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Sermon(id: $id, title: $title, subTitle: $subTitle, number: $number, verseNumber: $verseNumber, audio: $audio, audioName: $audioName, video: $video, time: $time, chapter: $chapter, coverPicture: $coverPicture, cover: $cover, coverUrl: $coverUrl, similarSermon: $similarSermon, publicationDate: $publicationDate, pdf: $pdf, epub: $epub, legende: $legende, verses: $verses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SermonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subTitle, subTitle) ||
                other.subTitle == subTitle) &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality().equals(
              other.verseNumber,
              verseNumber,
            ) &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.audioName, audioName) ||
                other.audioName == audioName) &&
            (identical(other.video, video) || other.video == video) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.coverPicture, coverPicture) ||
                other.coverPicture == coverPicture) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.similarSermon, similarSermon) ||
                other.similarSermon == similarSermon) &&
            (identical(other.publicationDate, publicationDate) ||
                other.publicationDate == publicationDate) &&
            (identical(other.pdf, pdf) || other.pdf == pdf) &&
            (identical(other.epub, epub) || other.epub == epub) &&
            (identical(other.legende, legende) || other.legende == legende) &&
            const DeepCollectionEquality().equals(other._verses, _verses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    subTitle,
    number,
    const DeepCollectionEquality().hash(verseNumber),
    audio,
    audioName,
    video,
    time,
    chapter,
    coverPicture,
    cover,
    coverUrl,
    similarSermon,
    publicationDate,
    pdf,
    epub,
    legende,
    const DeepCollectionEquality().hash(_verses),
  ]);

  /// Create a copy of Sermon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SermonImplCopyWith<_$SermonImpl> get copyWith =>
      __$$SermonImplCopyWithImpl<_$SermonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SermonImplToJson(this);
  }
}

abstract class _Sermon implements Sermon {
  const factory _Sermon({
    required final int id,
    required final String title,
    @JsonKey(name: 'sub_title') final String? subTitle,
    required final int number,
    @JsonKey(name: 'verse_number') final dynamic verseNumber,
    final String? audio,
    @JsonKey(name: 'audio_name') final String? audioName,
    final String? video,
    final String? time,
    required final String chapter,
    @JsonKey(name: 'cover_picture') final String? coverPicture,
    final String? cover,
    @JsonKey(name: 'cover_url') final String? coverUrl,
    @JsonKey(name: 'similar_sermon') final String? similarSermon,
    @JsonKey(name: 'publication_date') final String? publicationDate,
    final String? pdf,
    final String? epub,
    final String? legende,
    final List<Verse>? verses,
  }) = _$SermonImpl;

  factory _Sermon.fromJson(Map<String, dynamic> json) = _$SermonImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'sub_title')
  String? get subTitle;
  @override
  int get number;
  @override
  @JsonKey(name: 'verse_number')
  dynamic get verseNumber; // peut être int ou String
  @override
  String? get audio;
  @override
  @JsonKey(name: 'audio_name')
  String? get audioName;
  @override
  String? get video;
  @override
  String? get time;
  @override
  String get chapter;
  @override
  @JsonKey(name: 'cover_picture')
  String? get coverPicture;
  @override
  String? get cover;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  @JsonKey(name: 'similar_sermon')
  String? get similarSermon;
  @override
  @JsonKey(name: 'publication_date')
  String? get publicationDate;
  @override
  String? get pdf;
  @override
  String? get epub;
  @override
  String? get legende;
  @override
  List<Verse>? get verses;

  /// Create a copy of Sermon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SermonImplCopyWith<_$SermonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
