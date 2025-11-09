import 'package:prophet_kacou/core/models/concordance_model.dart';

List<ParsedReference> parseConcordance(String input) {
  final regex = RegExp(r'\[Kc\.(\d+)v([\d,\-\s]+)\]');
  final matches = regex.allMatches(input);
  final result = <ParsedReference>[];

  for (final match in matches) {
    final sermonNumber = int.parse(match.group(1)!);
    final verseParts = match.group(2)!.replaceAll(RegExp(r'\s+'), '').split(',');

    var firstVerse = verseParts.first;
    if (firstVerse.contains('-')) {
      firstVerse = firstVerse.split('-').first;
    }

    result.add(ParsedReference(
      label: match.group(0)!,
      sermonNumber: sermonNumber,
      verseNumber: int.parse(firstVerse),
    ));
  }

  return result;
}