import 'package:prophet_kacou/core/models/concordance.dart';
import 'package:prophet_kacou/core/models/image_sermon.dart';
import 'package:prophet_kacou/core/models/verse.dart';

class Sermon {
  final int id;
  final String title;
  final String chapter;
  final String? subTitle;
  final int number;
  final String? audio;
  final String? cloudAudio;
  final String? audioName;
  final String? video;
  final String? time;
  final String? cover;
  final String? similarSermon;
  final String? publicationDate;
  final String? pdf;
  final String? epub;
  final String? legende;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  ImageSermon? image;
  List<Verse>? verses;
  List<Concordance>? concordances;

  Sermon({
    required this.id,
    required this.title,
    required this.chapter,
    this.subTitle,
    required this.number,
    this.audio,
    this.cloudAudio,
    this.audioName,
    this.video,
    this.time,
    this.cover,
    this.similarSermon,
    this.publicationDate,
    this.pdf,
    this.epub,
    this.legende,
    this.createdAt,
    this.updatedAt,
    required this.isActive,
    this.image,
    this.verses,
    this.concordances,
  });

  factory Sermon.fromMap(Map<String, dynamic> map) {
    return Sermon(
      id: map['id'],
      title: map['title'],
      chapter: map['chapter'],
      subTitle: map['sub_title'],
      number: map['number'],
      audio: map['audio'],
      cloudAudio: map['cloud_audio'],
      audioName: map['audio_name'],
      video: map['video'],
      time: map['time'],
      cover: map['cover'],
      similarSermon: map['similar_sermon'],
      publicationDate: map['publication_date'],
      pdf: map['pdf'],
      epub: map['epub'],
      legende: map['legende'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      isActive: map['is_active'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'chapter': chapter,
      'sub_title': subTitle,
      'number': number,
      'audio': audio,
      'cloud_audio': cloudAudio,
      'audio_name': audioName,
      'video': video,
      'time': time,
      'cover': cover,
      'similar_sermon': similarSermon,
      'publication_date': publicationDate,
      'pdf': pdf,
      'epub': epub,
      'legende': legende,
      'is_active': isActive ? 1 : 0,
    };
  }
}
