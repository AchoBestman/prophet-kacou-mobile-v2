// lib/core/repositories/langue_repository.dart
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/langue.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class LangueRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère toutes les langues actives avec pagination, recherche et tri
  Future<PaginatedResult<Langue>> findAll({
    int page = 1,
    int perPage = 20,
    String? name,
    String? initial,
    String orderBy = '"order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    final whereConditions = <String>['is_active = 1'];
    final whereArgs = <dynamic>[];

    // Recherche sur libelle
    if (name != null && name.trim().isNotEmpty) {
      whereConditions.add('libelle LIKE ?');
      whereArgs.add('%${name.trim()}%');
    }

    // Recherche sur initial
    if (initial != null && initial.trim().isNotEmpty) {
      whereConditions.add('initial LIKE ?');
      whereArgs.add('%${initial.trim()}%');
    }

    final whereClause =
        whereConditions.isNotEmpty ? whereConditions.join(' AND ') : '';

    // Compter le total
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM langues WHERE $whereClause',
      whereArgs,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // Pagination
    final offset = (page - 1) * perPage;
    final List<Map<String, dynamic>> results = await db.query(
      'langues',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: orderBy,
      limit: perPage,
      offset: offset,
    );

    final langues = results.map((map) => Langue.fromMap(map)).toList();

    return PaginatedResult<Langue>(
      data: langues,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère une langue par id
  Future<Langue?> findById(int id) async {
    final db = await _dbManager.openCommonDB();
    final List<Map<String, dynamic>> results = await db.query(
      'langues',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return Langue.fromMap(results.first);
  }
}
