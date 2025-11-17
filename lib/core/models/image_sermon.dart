import 'dart:typed_data';

class ImageSermon {
  final int id;
  final String name;
  final String? description;
  final String? link;
  final Uint8List? file;
  final bool applyForAllLangue;

  ImageSermon({
    required this.id,
    required this.name,
    this.description,
    this.link,
    this.file,
    required this.applyForAllLangue,
  });

  factory ImageSermon.fromMap(Map<String, dynamic> map) {

    return ImageSermon(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      link: map['link'],
      file: map['file'],
      applyForAllLangue: map['apply_for_all_langue'] == 1,
    );
  }
}
