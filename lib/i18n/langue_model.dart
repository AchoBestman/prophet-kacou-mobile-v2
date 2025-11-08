class AppDefaultLanguage {
  final String lang;
  final String langName;
  final String langTranslation;

  AppDefaultLanguage({
    required this.lang,
    required this.langName,
    required this.langTranslation,
  });
}

class LanguageData {
  final int id;
  final String name;
  final String lang;
  final String countryFip;
  final String icon;
  final String translation;
  final bool exist;

  LanguageData({
    required this.id,
    required this.name,
    required this.lang,
    required this.countryFip,
    required this.icon,
    required this.translation,
    this.exist = true,
  });

  static List<LanguageData> homeLanguages() {
    
    return [
    LanguageData(
      id: 1,
      name: 'English',
      lang: 'en-en',
      countryFip: 'en',
      icon: 'assets/images/drapeau/en.jpg',
      translation: 'en',
    ),
    LanguageData(
      id: 2,
      name: 'Français',
      lang: 'fr-fr',
      countryFip: 'fr',
      icon: 'assets/images/drapeau/fr.jpg',
      translation: 'fr',
    ),
    LanguageData(
      id: 3,
      name: 'Español',
      lang: 'es-es',
      countryFip: 'es',
      icon: 'assets/images/drapeau/es.jpg',
      translation: 'es',
    ),
    LanguageData(
      id: 4,
      name: 'Português',
      lang: 'pt-pt',
      countryFip: 'pt',
      icon: 'assets/images/drapeau/pt.jpg',
      translation: 'pt',
    ),
    LanguageData(
      id: 6,
      name: '中文',
      lang: 'cn-zh',
      countryFip: 'cn',
      icon: 'assets/images/drapeau/cn.jpg',
      translation: 'zh',
    ),
    LanguageData(
      id: 7,
      name: 'हिन्दी',
      lang: 'in-hi',
      countryFip: 'cn',
      icon: 'assets/images/drapeau/in.jpg',
      translation: 'hi',
    ),
    LanguageData(
      id: 8,
      name: 'العربية',
      lang: 'sa-ar',
      countryFip: 'sa',
      icon: 'assets/images/drapeau/sa.jpg',
      translation: 'ar',
    ),
    LanguageData(
      id: 9,
      name: 'فارسی',
      lang: 'ir-fa',
      countryFip: 'ir',
      icon: 'assets/images/drapeau/ir.jpg',
      translation: 'fa',
    ),
    LanguageData(
      id: 9,
      name: 'Deutsch',
      lang: 'de-de',
      countryFip: 'de',
      icon: 'assets/images/drapeau/de.jpg',
      translation: 'de',
    ),
    LanguageData(
      id: 9,
      name: 'Italiano',
      lang: 'it-it',
      countryFip: 'it',
      icon: 'assets/images/drapeau/it.jpg',
      translation: 'it',
    ),
  ];
  }
}