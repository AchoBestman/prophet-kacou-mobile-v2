import 'package:freezed_annotation/freezed_annotation.dart';
part 'concordance_model.freezed.dart';
part 'concordance_model.g.dart';

@freezed
class ParsedReference with _$ParsedReference {
  const factory ParsedReference({
    required String label,
    @JsonKey(name: 'sermon_number') required int sermonNumber,
    @JsonKey(name: 'verse_number') required int verseNumber,
  }) = _ParsedReference;

  factory ParsedReference.fromJson(Map<String, dynamic> json) =>
      _$ParsedReferenceFromJson(json);
}

@freezed
class ConcordanceItem with _$ConcordanceItem {
  const factory ConcordanceItem({
    required String label,
    @JsonKey(name: 'sermon_number') required int sermonNumber,
    @JsonKey(name: 'verse_number') required int verseNumber,
  }) = _ConcordanceItem;

  factory ConcordanceItem.fromJson(Map<String, dynamic> json) =>
      _$ConcordanceItemFromJson(json);
}

@freezed
class Concordance with _$Concordance {
  const factory Concordance({
    required int id,
    @JsonKey(name: 'num_pred') required int numPred,
    @JsonKey(name: 'num_verset') required int numVerset,
    required List<ConcordanceItem> concordance,
  }) = _Concordance;

  factory Concordance.fromJson(Map<String, dynamic> json) =>
      _$ConcordanceFromJson(json);
}


