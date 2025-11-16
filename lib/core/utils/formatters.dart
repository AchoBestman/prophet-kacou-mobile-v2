import 'dart:io';

import 'package:prophet_kacou/core/models/play_mode.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:prophet_kacou/core/utils/download_utils.dart';
import 'package:slugify/slugify.dart';

// List<ParsedReference> parseConcordance(String input) {
//   final regex = RegExp(r'\[Kc\.(\d+)v([\d,\-\s]+)\]');
//   final matches = regex.allMatches(input);
//   final result = <ParsedReference>[];

//   for (final match in matches) {
//     final sermonNumber = int.parse(match.group(1)!);
//     final verseParts = match.group(2)!.replaceAll(RegExp(r'\s+'), '').split(',');

//     var firstVerse = verseParts.first;
//     if (firstVerse.contains('-')) {
//       firstVerse = firstVerse.split('-').first;
//     }

//     result.add(ParsedReference(
//       label: match.group(0)!,
//       sermonNumber: sermonNumber,
//       verseNumber: int.parse(firstVerse),
//     ));
//   }

//   return result;
// }

String getVideoId(String url) {
  if (url.isEmpty) return '';

  Uri? uri;
  try {
    uri = Uri.parse(url);
  } catch (_) {
    return '';
  }

  // Essayer d'abord de récupérer list=xxxx
  if (uri.queryParameters.containsKey('list')) {
    return uri.queryParameters['list'] ?? '';
  }

  // Sinon récupérer v=xxxx
  if (uri.queryParameters.containsKey('v')) {
    return uri.queryParameters['v'] ?? '';
  }

  // fallback : essayer de prendre le dernier segment après '='
  final segments = url.split(RegExp(r'[?&]'));
  for (final s in segments) {
    if (s.startsWith('v=')) return s.substring(2);
    if (s.startsWith('list=')) return s.substring(5);
  }

  return '';
}

String cleanAndSlugifyFileName(String fileName, String extension) {
  // 1. Supprimer l'extension
  final cleanFileName = fileName.replaceAll(
    RegExp('\\.$extension\$', caseSensitive: false),
    '',
  );

  // 2. Convertir en slug
  final slug = slugify(cleanFileName);

  return slug;
}

String sermonFileNameFormatter(Sermon sermon) {
  return "${sermon.chapter.toLowerCase()}_${sermon.title.toLowerCase()}";
}

String sermonTitleFormatter(Sermon sermon) {
  return "${sermon.chapter}: ${sermon.title}";
}

String sermonIdInDownloadProviderFormatter(Sermon sermon) {
  return 'sermon_${sermon.id}';
}

Future<File> localSermonPath(Sermon sermon, initial) async {
  final fullPath = await DownloadUtils.createPaths(
    initial,
    AudioFolder.sermons,
    sermonFileNameFormatter(sermon),
    FileExtension.mp3,
  );
  final file = File(fullPath);

  return file;
}

Future<File> localSongPath(Song song, initial) async {
  final fullPath = await DownloadUtils.createPaths(
    initial,
    AudioFolder.hymns,
    song.title,
    FileExtension.mp3,
  );
  final file = File(fullPath);

  return file;
}
