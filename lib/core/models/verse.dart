import 'dart:convert';

import 'package:prophet_kacou/core/models/concordance.dart';
import 'package:prophet_kacou/core/utils/formatters.dart';

class Verse {
  final int id;
  final int number;
  final String content;
  final String? info;
  final String? linkAtContent;
  final String? urlContent;
  final int sermonId;
  final int? sermonNumber;
  final String? title;
  final List<dynamic>? verseLinks;
  List<ParsedReference>? concordances;
  Concordance? concordance;

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
    this.concordances,
    this.concordance,
    this.sermonNumber
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
      sermonNumber: map['sermonNumber'],
      content: map['content'],
      info: map['info'],
      linkAtContent: map['link_at_content'],
      urlContent: map['url_content'],
      sermonId: map['sermon_id'],
      title: map['title'],
      concordances: map['concordances'],
      concordance: map['concordance'],
      verseLinks: parsedLinks,
    );
  }


}

class VerseLink {
  final String url;
  final String type;
  final String? content;
  final String? fileName;

  VerseLink.fromMap(Map<String, dynamic> map)
      : url = map["url"],
        type = map["type"],
        content = map["content"],
        fileName = map["fileName"];
}