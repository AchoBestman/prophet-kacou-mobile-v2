// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concordance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParsedReferenceImpl _$$ParsedReferenceImplFromJson(
  Map<String, dynamic> json,
) => _$ParsedReferenceImpl(
  label: json['label'] as String,
  sermonNumber: (json['sermon_number'] as num).toInt(),
  verseNumber: (json['verse_number'] as num).toInt(),
);

Map<String, dynamic> _$$ParsedReferenceImplToJson(
  _$ParsedReferenceImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'sermon_number': instance.sermonNumber,
  'verse_number': instance.verseNumber,
};

_$ConcordanceItemImpl _$$ConcordanceItemImplFromJson(
  Map<String, dynamic> json,
) => _$ConcordanceItemImpl(
  label: json['label'] as String,
  sermonNumber: (json['sermon_number'] as num).toInt(),
  verseNumber: (json['verse_number'] as num).toInt(),
);

Map<String, dynamic> _$$ConcordanceItemImplToJson(
  _$ConcordanceItemImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'sermon_number': instance.sermonNumber,
  'verse_number': instance.verseNumber,
};

_$ConcordanceImpl _$$ConcordanceImplFromJson(Map<String, dynamic> json) =>
    _$ConcordanceImpl(
      id: (json['id'] as num).toInt(),
      numPred: (json['num_pred'] as num).toInt(),
      numVerset: (json['num_verset'] as num).toInt(),
      concordance: (json['concordance'] as List<dynamic>)
          .map((e) => ConcordanceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConcordanceImplToJson(_$ConcordanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num_pred': instance.numPred,
      'num_verset': instance.numVerset,
      'concordance': instance.concordance,
    };
