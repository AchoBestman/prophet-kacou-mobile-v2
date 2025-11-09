import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';

class PathUtils {
  /// Retourne le dossier racine pour les bases SQLite
  static Future<Directory> getDatabaseRootDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return Directory(join(dir.path, AppStrings.databasesDirName));
  }

  /// Retourne le dossier de téléchargement de l’application
  static Future<Directory> getDownloadDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(join(dir.path, AppStrings.downloadDirName));
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }
}
