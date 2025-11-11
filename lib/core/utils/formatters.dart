import 'package:prophet_kacou/core/models/concordance.dart';

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

String extractCountryCode(String locale) {
  if (locale.isEmpty) return '';
  return locale.split('-').first.toLowerCase();
}