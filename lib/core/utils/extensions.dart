import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    debugPrint('Erreur lors de l\'ouverture du lien: $e');
  }
}

void changeLanguage(LanguageData langue) async {
  await i18n.setLanguage(
    AppDefaultLanguage(
      lang: langue.lang,
      langName: langue.name,
      langTranslation: langue.translation,
    ),
  );
}
