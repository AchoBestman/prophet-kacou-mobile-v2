import 'package:freezed_annotation/freezed_annotation.dart';
import 'concordance_model.dart';
part 'verse_model.freezed.dart';
part 'verse_model.g.dart';

@freezed
class VerseLink with _$VerseLink {
  const factory VerseLink({
    required String url,
    required String type,
    @JsonKey(name: 'file_name') String? fileName,
    String? content,
  }) = _VerseLink;

  factory VerseLink.fromJson(Map<String, dynamic> json) =>
      _$VerseLinkFromJson(json);
}

@freezed
class Verse with _$Verse {
  const factory Verse({
    required int id,
    required int number,
    required String content,
    String? info,
    @JsonKey(name: 'link_at_content') String? linkAtContent,
    @JsonKey(name: 'url_content') String? urlContent,
    String? title,
    @JsonKey(name: 'sermon_id') required int sermonId,
    Concordance? concordances,
    String? concordance,
    @JsonKey(name: 'verse_links') List<VerseLink>? verseLinks,
  }) = _Verse;

  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);
}
