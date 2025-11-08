import 'package:flutter/material.dart';
import 'package:prophet_kacou/i18n/i18n.dart';
import 'package:prophet_kacou/i18n/langue_model.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageData? _currentLanguage;
  bool _isInitialized = false;

  LanguageData? get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;
  String get lang => i18n.lang;
  String get langName => i18n.langName;

  // Initialisation au démarrage de l'app
  Future<void> init() async {
    await i18n.init();
    
    // Trouver la langue correspondante dans la liste
    final languages = LanguageData.homeLanguages();
    _currentLanguage = languages.firstWhere(
      (l) => l.lang == i18n.lang,
      orElse: () => languages.first,
    );
    
    _isInitialized = true;
    notifyListeners();
  }

  // Changer la langue
  Future<void> changeLanguage(LanguageData language) async {
    _currentLanguage = language;
    
    // Créer l'objet AppDefaultLanguage à partir de LanguageData
    final appLang = AppDefaultLanguage(
      lang: language.lang,
      langName: language.name,
      langTranslation: language.translation,
    );
    
    await i18n.setLanguage(appLang);
    notifyListeners();
  }
}