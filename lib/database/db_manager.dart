// lib/app/core/database/db_manager.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:prophet_kacou/core/constants/app_strings.dart';
import 'package:prophet_kacou/core/utils/path_utils.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static final DBManager _instance = DBManager._internal();
  factory DBManager() => _instance;
  DBManager._internal();

  final Map<String, Database> _dbCache = {};

  /// Retourne le chemin complet d’une base de données
  Future<String> _getDBPath(String relativePath) async {
    final dbRoot = await PathUtils.getDatabaseRootDir();
    return join(dbRoot.path, relativePath);
  }

  /// Ouvre une base de données et la met en cache
  Future<Database> openDB(String relativePath) async {
    if (_dbCache.containsKey(relativePath)) {
      return _dbCache[relativePath]!;
    }

    final path = await _getDBPath(relativePath);
    if (!await File(path).exists()) {
      throw Exception("❌ Base de données introuvable : $relativePath");
    }

    final db = await openDatabase(path);
    _dbCache[relativePath] = db;
    return db;
  }

  /// Ouvre la base commune
  Future<Database> openCommonDB() async => openDB(AppStrings.commonDBPath);

  /// Ouvre la base correspondant à la langue actuelle (ex: fr-fr, en-en)
  Future<Database> openLanguageDB(String lang) async {
    final parsed = _parseLang(lang);
    final folder = parsed['countryCode']!;
    final langCode = parsed['langInitial']!;
    final relativePath = '$folder/matth25v6_${langCode}.db';
    return openDB(relativePath);
  }

  /// Valide et découpe le code langue (ex: "fr-fr" → {"countryCode": "fr", "langInitial": "fr"})
  Map<String, String> _parseLang(String lang) {
    final regex = RegExp(r'^([a-z]{2})-([a-z]{2,4})$');
    final match = regex.firstMatch(lang.toLowerCase());
    if (match == null) {
      throw FormatException(
        "Format de langue invalide : $lang. Attendu ex: fr-fr, en-en",
      );
    }

    return {'countryCode': match.group(1)!, 'langInitial': match.group(2)!};
  }

  /// Ferme toutes les connexions de base de données
  Future<void> closeAll() async {
    for (final db in _dbCache.values) {
      await db.close();
    }
    _dbCache.clear();
  }
}
