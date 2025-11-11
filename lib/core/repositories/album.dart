import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/album.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class AlbumRepository {
  final DBManager _dbManager = DBManager();

  Future<PaginatedResult<Album>> findAll({
    int page = 1,
    int perPage = 20,
    String? searchQuery,
    String orderBy = '"order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    final where = <String>['is_active = 1'];
    final args = <dynamic>[];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('(title LIKE ? OR description LIKE ?)');
      args.add('%$searchQuery%');
      args.add('%$searchQuery%');
    }

    final whereClause = 'WHERE ${where.join(' AND ')}';
    final offset = (page - 1) * perPage;

    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM albums $whereClause',
      args,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    final query = '''
      SELECT * FROM albums
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final results = await db.rawQuery(query, [...args, perPage, offset]);
    final albums = results.map((map) => Album.fromMap(map)).toList();

    return PaginatedResult<Album>(
      data: albums,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }
}
