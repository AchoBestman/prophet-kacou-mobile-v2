import 'dart:convert';

class Verse {
  final int id;
  final int number;
  final String content;
  final String? info;
  final String? linkAtContent;
  final String? urlContent;
  final int sermonId;
  final String? title;
  final List<dynamic>? verseLinks;

  Verse({
    required this.id,
    required this.number,
    required this.content,
    this.info,
    this.linkAtContent,
    this.urlContent,
    required this.sermonId,
    this.title,
    this.verseLinks,
  });

  factory Verse.fromMap(Map<String, dynamic> map) {
    List<dynamic>? parsedLinks;
    if (map['verse_links'] != null && map['verse_links'].toString().isNotEmpty) {
      try {
        parsedLinks = jsonDecode(map['verse_links']);
      } catch (_) {
        parsedLinks = [];
      }
    }
    return Verse(
      id: map['id'],
      number: map['number'],
      content: map['content'],
      info: map['info'],
      linkAtContent: map['link_at_content'],
      urlContent: map['url_content'],
      sermonId: map['sermon_id'],
      title: map['title'],
      verseLinks: parsedLinks,
    );
  }
}
