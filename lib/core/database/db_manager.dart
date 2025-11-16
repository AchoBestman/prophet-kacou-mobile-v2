// lib/app/core/database/db_manager.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/utils/langues.dart';
import 'package:prophet_kacou/core/utils/path_utils.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static final DBManager _instance = DBManager._internal();
  factory DBManager() => _instance;
  DBManager._internal();

  final Map<String, Database> _dbCache = {};

  /// Ouvre la base commune
  Future<Database> openCommonDB() async => openDB(AppStrings.commonDBPath);

  /// Ouvre la base correspondant à la langue actuelle (ex: fr-fr, en-en)
  Future<Database> openLanguageDB(String lang) async {
    final relativePath = languePath(lang);
    return openDB(relativePath);
  }

  /// Ferme toutes les connexions de base de données
  Future<void> closeAll() async {
    for (final db in _dbCache.values) {
      await db.close();
    }
    _dbCache.clear();
  }

  /// Supprimer une base de donnees
  static Future<bool> deleteDatabase(String initial) async {
    final file = await PathUtils.getDBPath(languePath(initial));

    if (!await File(file).exists()) {
      await File(file).delete();
      return true;
    }
    return false;
  }

  static Future<bool> dbExists(String initial) async {
    final file = await PathUtils.getDBPath(languePath(initial));
    return await File(file).exists();
  }

  static Future<List<String>> priorityDB() async {
    final localLangues = await getAllExistingDB();
    final priority = ['en-en', 'fr-fr', 'es-es', 'pt-pt'];

    final common = {...priority}; // ensemble pour vérifier les doublons

    final merged = [
      ...priority,
      ...localLangues.where((lang) => !common.contains(lang)),
    ];

    return merged;
  }

  /// Ouvre une base de données et la met en cache
  Future<Database> openDB(String relativePath) async {
    if (_dbCache.containsKey(relativePath)) {
      return _dbCache[relativePath]!;
    }

    final path = await PathUtils.getDBPath(relativePath);
    if (!await File(path).exists()) {
      throw Exception("❌ Base de données introuvable : $relativePath");
    }

    final db = await openDatabase(path);
    _dbCache[relativePath] = db;
    return db;
  }

  static Future<List<String>> getAllExistingDB() async {
    final dbRoot = await PathUtils.getDatabaseRootDir();
    final rootDir = Directory(dbRoot.path);

    if (!await rootDir.exists()) return [];

    final entries = rootDir.listSync(recursive: true);
    final List<String> result = [];

    for (final entity in entries) {
      if (entity is File) {
        final path = entity.path;
        final fileName = basename(path);

        // 📌 1) Détection du dossier "common"
        if (fileName == "common.db") {
          if (!result.contains("common")) {
            result.add("common");
          }
          continue;
        }

        // 📌 2) Détection d’une langue : fr/fr_fr.db → fr-fr
        if (fileName.endsWith('.db') && fileName.contains('_')) {
          final dirName = basename(dirname(path)); // Ex : fr
          final langCode = fileName
              .split('.')
              .first
              .split('_')
              .last; // ex : fr_fr → fr

          final locale = "${dirName.toLowerCase()}-${langCode.toLowerCase()}";
          if (!result.contains(locale)) {
            result.add(locale);
          }
        }
      }
    }

    return result;
  }
}
