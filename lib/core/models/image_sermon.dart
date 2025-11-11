class ImageSermon {
  final int id;
  final String name;
  final String? description;
  final String? link;
  final dynamic file;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool applyForAllLangue;

  ImageSermon({
    required this.id,
    required this.name,
    this.description,
    this.link,
    this.file,
    this.createdAt,
    this.updatedAt,
    required this.applyForAllLangue,
  });

  factory ImageSermon.fromMap(Map<String, dynamic> map) {
    return ImageSermon(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      link: map['link'],
      file: map['file'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      applyForAllLangue: map['apply_for_all_langue'] == 1,
    );
  }
}
