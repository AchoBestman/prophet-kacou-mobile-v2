import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/utils/path_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseInitializer {
  
  static Future<void> initializeDatabases() async {
    final prefs = await SharedPreferences.getInstance();

    // 📂 Chemin du dossier des bases
    final dbRoot = await PathUtils.getDatabaseRootDir();

    // 🔖 Version actuelle
    final appInfo = await PackageInfo.fromPlatform();
    final currentVersion = appInfo.version;
    final savedVersion = prefs.getString(AppStrings.prefsVersionKey);

    final mustCopy = savedVersion == null || savedVersion != currentVersion;

    if (mustCopy || !await dbRoot.exists()) {
      await _copyAllDatabases(dbRoot);
      await prefs.setString(AppStrings.prefsVersionKey, currentVersion);
    }
  }

  static Future<void> _copyAllDatabases(Directory dbRoot) async {
    // S'assurer que le dossier existe
    await dbRoot.create(recursive: true);

    for (final relativePath in AppStrings.defaultDatabases) {
      final newDbData = await rootBundle.load('assets/databases/$relativePath');
      final targetFile = File(join(dbRoot.path, relativePath));

      // Créer le dossier parent si nécessaire
      await targetFile.parent.create(recursive: true);

      // 1️⃣ Si l’ancienne DB existe, on la sauvegarde temporairement
      File? oldFileBackup;
      if (await targetFile.exists()) {
        final backupPath = "${targetFile.path}.bak";
        oldFileBackup = await targetFile.copy(backupPath);
      }

      try {
        // 2️⃣ On écrit la nouvelle base
        await targetFile.writeAsBytes(newDbData.buffer.asUint8List());

        // 3️⃣ Si succès → supprimer la backup
        if (oldFileBackup != null && await oldFileBackup.exists()) {
          await oldFileBackup.delete();
        }

        print("✅ Base copiée : ${targetFile.path}");
      } catch (e) {
        // 4️⃣ En cas d’échec → restaurer l’ancienne base
        if (oldFileBackup != null && await oldFileBackup.exists()) {
          await oldFileBackup.rename(targetFile.path);
        }
        print("❌ ERREUR copie DB : $relativePath → $e");
      }
    }
  }
}
