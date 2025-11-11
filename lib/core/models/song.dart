class Song {
  final int id;
  final String title;
  final String audio;
  final String? fileName;
  final String? content;
  final int? time;
  final int order;
  final bool isActive;
  final int albumId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Song({
    required this.id,
    required this.title,
    required this.audio,
    this.fileName,
    this.content,
    this.time,
    this.order = 1,
    this.isActive = true,
    required this.albumId,
    this.createdAt,
    this.updatedAt,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as int,
      title: map['title'] as String,
      audio: map['audio'] as String,
      fileName: map['file_name'] as String?,
      content: map['content'] as String?,
      time: map['time'] as int?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      albumId: map['album_id'] as int,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'audio': audio,
      'file_name': fileName,
      'content': content,
      'time': time,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'album_id': albumId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
