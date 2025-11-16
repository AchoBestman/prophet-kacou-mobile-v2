import 'package:prophet_kacou/core/constants/app_strings.dart';

String extractCountryCode(String locale) {
  if (!RegExp(r'^[A-Za-z]{2}-[A-Za-z]{2,4}$').hasMatch(locale) ||
      locale.isEmpty) {
    throw Exception('Invalid format: $locale must be in format AA-AA{BC}');
  }

  return locale.split('-')[0].toLowerCase();
}

String extractLangueCode(String locale) {
  if (!RegExp(r'^[A-Za-z]{2}-[A-Za-z]{2,4}$').hasMatch(locale) ||
      locale.isEmpty) {
    throw Exception('Invalid format: $locale must be in format AA-AA{BC}');
  }

  final parts = locale.split('-');
  return parts.length > 1 ? parts[1].toLowerCase() : '';
}

String languePath(String locale) {
  return '${extractCountryCode(locale)}/${AppStrings.dbName}_${extractLangueCode(locale)}.db';
}

String commonPath(String locale) {
  return 'common/common.db';
}
