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
    if (await dbRoot.exists()) {
      await dbRoot.delete(recursive: true);
    }
    await dbRoot.create(recursive: true);

    for (final path in AppStrings.defaultDatabases) {
      final data = await rootBundle.load('assets/databases/$path');
      final file = File(join(dbRoot.path, path));
      await file.parent.create(recursive: true);
      await file.writeAsBytes(data.buffer.asUint8List());
    }

    print("✅ Bases copiées dans ${dbRoot.path}");
  }
}
