import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/biography.dart';

class BiographyRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère la biography
  Future<Biography?> findBy(String lang) async {
    final db = await _dbManager.openLanguageDB(lang);

    final List<Map<String, dynamic>> results = await db.query(
      'biographies',
      limit: 1,
    );

    if (results.isEmpty) return null;

    return Biography.fromMap(results.first);
  }
}