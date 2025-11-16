class AudioItem {
  final int id;
  final String title;
  final String audioUrl;
  final int? albumId;
  final String? fileOriginalName;
  final String? localFullPath;
  
  AudioItem({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.albumId,
    this.fileOriginalName,
    this.localFullPath
  });
}