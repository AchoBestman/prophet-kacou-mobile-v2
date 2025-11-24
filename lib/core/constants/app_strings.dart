/// Contient toutes les constantes globales de l’application.
/// À utiliser pour éviter les chaînes codées en dur dans le code.
class AppStrings {
  // Nom de l’application
  static const appName = 'Prophet Kacou';

  // Clés de préférences (SharedPreferences)
  static const prefsVersionKey = 'app_version';

  //cles pour recupererer les langues mises a jour du localStorage
  static const downloadDbUpdates = "download_db_updates";

  static const downloadHistory = "download_history";

  // Database last update key
  static const String dbLastUpdateKey = "langues_last_updates";

  // Database available update key
  static const String dbAvailableUpdateKey = "langues_available_updates";

  // Total database available update key
  static const String totalDbAvailableUpdateKey = "total_langues_to_update";

  //check if update langue request is pending
  static const String updateIsPending = "update_is_pending";

  // Dossiers internes
  static const databasesDirName = 'databases';
  static const downloadDirName = 'Philippekacou';
  static const dbName = 'matth25v6';
  static const commonDbName = 'common';
  static const apiUrl = "https://api.philippekacou.org/api";


  // Bases de données embarquées
  static const defaultDatabases = [
    'common/common.db',
    'fr/matth25v6_fr.db',
    'en/matth25v6_en.db',
    'pt/matth25v6_pt.db',
    'es/matth25v6_es.db',
    'sa/matth25v6_ar.db',
    'ir/matth25v6_fa.db',
    'in/matth25v6_hi.db',
    'cn/matth25v6_zh.db',
  ];

  // Clé générique pour indiquer le dossier commun
  static const commonDBPath = 'common/common.db';
}
