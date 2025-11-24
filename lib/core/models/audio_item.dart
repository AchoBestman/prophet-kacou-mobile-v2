import 'dart:io';

class AudioItem {
  final int id;
  final String title;
  final String audioUrl;
  final int? albumId;
  final String? videoLink;
  final String? fileOriginalName;
  final File? localFullPath;
  final String? content;
  
  AudioItem({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.albumId,
    this.videoLink,
    this.fileOriginalName,
    this.localFullPath,
    this.content
  });

}