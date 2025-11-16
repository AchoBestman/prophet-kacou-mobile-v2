import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:path/path.dart' as p;

class PathUtils {
  /// Retourne le dossier racine pour les bases SQLite
  static Future<Directory> getDatabaseRootDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return Directory(join(dir.path, AppStrings.databasesDirName));
  }

  /// Retourne le chemin complet d’une base de données
  static Future<String> getDBPath(String relativePath) async {
    final dbRoot = await PathUtils.getDatabaseRootDir();
    return join(dbRoot.path, relativePath);
  }

  /// 🔹 Retourne le dossier de téléchargement propre à l’application.
  ///
  /// - Sur **Android/Desktop**, utilise le dossier "Téléchargements" utilisateur.
  /// - Sur **iOS**, utilise `Documents` (car iOS ne permet pas d’accéder directement à "Downloads").
  /// - Crée un sous-dossier `[AppStrings.downloadDirName]` si besoin.
  static Future<Directory> getDownloadDir() async {
    Directory? baseDir;

    try {
      if (Platform.isAndroid || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        // ✅ Sur Android & Desktop, `getDownloadsDirectory()` fonctionne
        baseDir = await getDownloadsDirectory();
      } else if (Platform.isIOS) {
        // ⚠️ iOS n’a pas de "Downloads", on utilise le dossier Documents
        baseDir = await getApplicationDocumentsDirectory();
      } else {
        throw UnsupportedError('Plateforme non supportée');
      }

      // Si `getDownloadsDirectory()` renvoie null (rare cas), fallback sur Documents
      baseDir ??= await getApplicationDocumentsDirectory();

      // 🔹 Crée le sous-dossier spécifique à ton app
      final appDownloadDir = Directory(p.join(baseDir.path, AppStrings.downloadDirName));

      if (!await appDownloadDir.exists()) {
        await appDownloadDir.create(recursive: true);
      }

      return appDownloadDir;
    } catch (e) {
      print('❌ Erreur lors de la création du dossier de téléchargement : $e');
      // Fallback de secours
      final fallback = await getApplicationDocumentsDirectory();
      return Directory(p.join(fallback.path, AppStrings.downloadDirName));
    }
  }
}
