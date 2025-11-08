import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:prophet_kacou/i18n/constants.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class I18n {
  static final I18n _instance = I18n._internal();
  factory I18n() => _instance;
  I18n._internal();

  Map<String, dynamic> _localizedStrings = {};
  String lang = defaultLang;
  String langName = defaultLangName;

  Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  lang = prefs.getString(preferenceKeyLang) ?? defaultLang;
  langName = prefs.getString(preferenceKeyLangName) ?? defaultLangName;
  await load(prefs.getString(preferenceKeyLangTranslation) ?? defaultLangTranslation);
}

  String tr(String key) {
    final keys = key.split('.'); //home.text 
    dynamic value = _localizedStrings;
    for (final k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // retourne la clé si manquante
      }
    }
    return value is String ? value : key;
  }

  Future<void> setLanguage(AppDefaultLanguage appDefaultLang) async {
    final prefs = await SharedPreferences.getInstance();
    lang = appDefaultLang.lang;
    langName = appDefaultLang.langName;

    await prefs.setString(preferenceKeyLang, appDefaultLang.lang);
    await prefs.setString(preferenceKeyLangName, appDefaultLang.langName);
    await prefs.setString(preferenceKeyLangTranslation, appDefaultLang.langTranslation);
    await load(appDefaultLang.langTranslation);
  }


  Future<void> load(String langCode) async {
  try {
    final String jsonString =
        await rootBundle.loadString('$localePath/$langCode.json');
    _localizedStrings = json.decode(jsonString);
  } catch (e) {
    print("Erreur de chargement de la langue '$langCode': $e");
    _localizedStrings = {}; // fallback vide
  }
}

}

final i18n = I18n();
