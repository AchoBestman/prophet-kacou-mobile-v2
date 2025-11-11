class AudioItem {
  final int id;
  final String title;
  final String audioUrl;
  final int? albumId;
  final String? fileOriginalName;
  
  AudioItem({
    required this.id,
    required this.title,
    required this.audioUrl,
    this.albumId,
    this.fileOriginalName,
  });
}