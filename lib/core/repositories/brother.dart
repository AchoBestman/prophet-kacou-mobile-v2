import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/brother.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class BrotherRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère tous les frères avec pagination et filtres
  Future<PaginatedResult<Brother>> findAll({
    int page = 1,
    int perPage = 20,
    String? fullName,
    bool? isActive,
    String orderBy = 'brothers."order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (fullName != null && fullName.isNotEmpty) {
      whereConditions.add('brothers.full_name LIKE ?');
      whereArgs.add('%$fullName%');
    }

    if (isActive != null) {
      whereConditions.add('brothers.is_active = ?');
      whereArgs.add(isActive ? 1 : 0);
    }

    final String whereClause =
        whereConditions.isNotEmpty ? 'WHERE ${whereConditions.join(' AND ')}' : '';

    // Compter les résultats
    final countResult =
        await db.rawQuery('SELECT COUNT(*) as count FROM brothers $whereClause', whereArgs);
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // Pagination
    final offset = (page - 1) * perPage;

    final String query = '''
      SELECT brothers.*
      FROM brothers
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final results = await db.rawQuery(query, [...whereArgs, perPage, offset]);

    final brothers = results.map((e) => Brother.fromMap(e)).toList();

    return PaginatedResult<Brother>(
      data: brothers,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère un frère par clé
  Future<Brother?> findBy({String key = 'id', required dynamic value}) async {
    final db = await _dbManager.openCommonDB();

    final results = await db.rawQuery(
      'SELECT * FROM brothers WHERE $key = ? LIMIT 1',
      [value],
    );

    if (results.isEmpty) return null;
    return Brother.fromMap(results.first);
  }
}
