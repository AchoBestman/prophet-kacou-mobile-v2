import 'dart:io';

import 'package:prophet_kacou/core/models/play_mode.dart';

class AudioItem {
  final int id;
  final String title;
  final String audioUrl;
  final int? albumId;
  final String? videoLink;
  final String? fileOriginalName;
  final String? content;
  final File? localFullPath;
  final AudioFolder type;

  AudioItem({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.type,
    this.albumId,
    this.videoLink,
    this.fileOriginalName,
    this.localFullPath,
    this.content
  });

}