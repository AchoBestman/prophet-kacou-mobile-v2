// lib/core/repositories/information_repository.dart
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/information.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class InformationRepository {
  final DBManager _dbManager = DBManager();

  Future<PaginatedResult<Information>> findAll({
    String lang = '',
    int page = 1,
    int perPage = 20,
    String? searchQuery,
    String orderBy = '"order" ASC',
  }) async {
    final db = await _dbManager.openLanguageDB(lang);

    final where = <String>[];
    final args = <dynamic>[];

    // Actives uniquement
    where.add('is_active = 1');

    // Recherche par title et description
    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('(title LIKE ? OR description LIKE ?)');
      args.addAll(['%$searchQuery%', '%$searchQuery%']);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

    // Compter total
    final countResult =
        await db.rawQuery('SELECT COUNT(*) as count FROM informations $whereClause', args);
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;
    final offset = (page - 1) * perPage;

    // Récupérer données
    final results = await db.rawQuery(
      '''
      SELECT *
      FROM informations
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
      ''',
      [...args, perPage, offset],
    );

    final informations = results.map((map) => Information.fromMap(map)).toList();

    return PaginatedResult<Information>(
      data: informations,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  Future<Information?> findBy({String key = 'id', String lang ='', required dynamic value}) async {
    final db = await _dbManager.openLanguageDB(lang);

    final results = await db.query(
      'informations',
      where: '$key = ? AND is_active = 1',
      whereArgs: [value],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return Information.fromMap(results.first);
  }
}
