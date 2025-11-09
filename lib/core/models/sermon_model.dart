import 'package:freezed_annotation/freezed_annotation.dart';
import 'verse_model.dart';

part 'sermon_model.freezed.dart';
part 'sermon_model.g.dart';

@freezed
class Sermon with _$Sermon {
  const factory Sermon({
    required int id,
    required String title,
    @JsonKey(name: 'sub_title') String? subTitle,
    required int number,
    @JsonKey(name: 'verse_number') dynamic verseNumber, // peut être int ou String
    String? audio,
    @JsonKey(name: 'audio_name') String? audioName,
    String? video,
    String? time,
    required String chapter,
    @JsonKey(name: 'cover_picture') String? coverPicture,
    String? cover,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'similar_sermon') String? similarSermon,
    @JsonKey(name: 'publication_date') String? publicationDate,
    String? pdf,
    String? epub,
    String? legende,
    List<Verse>? verses,
  }) = _Sermon;

  factory Sermon.fromJson(Map<String, dynamic> json) =>
      _$SermonFromJson(json);
}
