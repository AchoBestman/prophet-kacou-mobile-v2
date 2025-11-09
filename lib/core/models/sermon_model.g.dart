// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SermonImpl _$$SermonImplFromJson(Map<String, dynamic> json) => _$SermonImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  subTitle: json['sub_title'] as String?,
  number: (json['number'] as num).toInt(),
  verseNumber: json['verse_number'],
  audio: json['audio'] as String?,
  audioName: json['audio_name'] as String?,
  video: json['video'] as String?,
  time: json['time'] as String?,
  chapter: json['chapter'] as String,
  coverPicture: json['cover_picture'] as String?,
  cover: json['cover'] as String?,
  coverUrl: json['cover_url'] as String?,
  similarSermon: json['similar_sermon'] as String?,
  publicationDate: json['publication_date'] as String?,
  pdf: json['pdf'] as String?,
  epub: json['epub'] as String?,
  legende: json['legende'] as String?,
  verses: (json['verses'] as List<dynamic>?)
      ?.map((e) => Verse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$SermonImplToJson(_$SermonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sub_title': instance.subTitle,
      'number': instance.number,
      'verse_number': instance.verseNumber,
      'audio': instance.audio,
      'audio_name': instance.audioName,
      'video': instance.video,
      'time': instance.time,
      'chapter': instance.chapter,
      'cover_picture': instance.coverPicture,
      'cover': instance.cover,
      'cover_url': instance.coverUrl,
      'similar_sermon': instance.similarSermon,
      'publication_date': instance.publicationDate,
      'pdf': instance.pdf,
      'epub': instance.epub,
      'legende': instance.legende,
      'verses': instance.verses,
    };
