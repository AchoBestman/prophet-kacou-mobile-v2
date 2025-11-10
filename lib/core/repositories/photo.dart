import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/photo.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class PhotoRepository {
  final DBManager _dbManager = DBManager();
 
 Future<PaginatedResult<Photo>> findAll({
  String lang = "",
  int page = 1,
  int perPage = 20,
  int? eventId,
  String? searchQuery,
  String orderBy = '"order" ASC',
}) async {
  final db = await _dbManager.openLanguageDB(lang);

  final where = <String>[];
  final args = <dynamic>[];

  // Filtre par event_id
  if (eventId != null) {
    where.add('event_id = ?');
    args.add(eventId);
  }

  // Filtre par recherche sur title ou description
  if (searchQuery != null && searchQuery.trim().isNotEmpty) {
    where.add('(title LIKE ? OR description LIKE ?)');
    final queryPattern = '%${searchQuery.trim()}%';
    args.addAll([queryPattern, queryPattern]);
  }

  final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

  // Compter total
  final countResult = await db.rawQuery(
    'SELECT COUNT(*) as count FROM photos $whereClause',
    args,
  );
  final totalCount = Sqflite.firstIntValue(countResult) ?? 0;
  final offset = (page - 1) * perPage;

  // Requête principale
  final query = '''
    SELECT *
    FROM photos
    $whereClause
    ORDER BY $orderBy
    LIMIT ? OFFSET ?
  ''';

  final results = await db.rawQuery(query, [...args, perPage, offset]);
  final photos = results.map((map) => Photo.fromMap(map)).toList();

  return PaginatedResult<Photo>(
    data: photos,
    total: totalCount,
    page: page,
    perPage: perPage,
  );
}

  Future<Photo?> findBy({
    String key = 'id',
    String lang = "",
    required dynamic value,
  }) async {
    final db = await _dbManager.openLanguageDB(lang);

    final results = await db.query(
      'photos',
      where: '$key = ?',
      whereArgs: [value],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return Photo.fromMap(results.first);
  }
}
