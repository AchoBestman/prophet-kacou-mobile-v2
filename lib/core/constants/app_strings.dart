/// Contient toutes les constantes globales de l’application.
/// À utiliser pour éviter les chaînes codées en dur dans le code.
class AppStrings {
  // Nom de l’application
  static const appName = 'Prophet Kacou';

  // Clés de préférences (SharedPreferences)
  static const prefsVersionKey = 'app_version';

  // Dossiers internes
  static const databasesDirName = 'databases';
  static const downloadDirName = 'downloads';

  // Bases de données embarquées
  static const defaultDatabases = [
    'common/common.db',
    'fr/matth25v6_fr.db',
    'en/matth25v6_en.db',
    'pt/matth25v6_pt.db',
    'es/matth25v6_es.db',
  ];

  // Clé générique pour indiquer le dossier commun
  static const commonDBPath = 'common/common.db';
}
