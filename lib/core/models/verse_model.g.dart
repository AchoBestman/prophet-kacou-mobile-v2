// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerseLinkImpl _$$VerseLinkImplFromJson(Map<String, dynamic> json) =>
    _$VerseLinkImpl(
      url: json['url'] as String,
      type: json['type'] as String,
      fileName: json['file_name'] as String?,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$$VerseLinkImplToJson(_$VerseLinkImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
      'file_name': instance.fileName,
      'content': instance.content,
    };

_$VerseImpl _$$VerseImplFromJson(Map<String, dynamic> json) => _$VerseImpl(
  id: (json['id'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  content: json['content'] as String,
  info: json['info'] as String?,
  linkAtContent: json['link_at_content'] as String?,
  urlContent: json['url_content'] as String?,
  title: json['title'] as String?,
  sermonId: (json['sermon_id'] as num).toInt(),
  concordances: json['concordances'] == null
      ? null
      : Concordance.fromJson(json['concordances'] as Map<String, dynamic>),
  concordance: json['concordance'] as String?,
  verseLinks: (json['verse_links'] as List<dynamic>?)
      ?.map((e) => VerseLink.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$VerseImplToJson(_$VerseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'content': instance.content,
      'info': instance.info,
      'link_at_content': instance.linkAtContent,
      'url_content': instance.urlContent,
      'title': instance.title,
      'sermon_id': instance.sermonId,
      'concordances': instance.concordances,
      'concordance': instance.concordance,
      'verse_links': instance.verseLinks,
    };
