import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:prophet_kacou/core/models/song.dart';
import 'package:sqflite/sqflite.dart';

class SongRepository {
  final DBManager _dbManager = DBManager();

  Future<PaginatedResult<Song>> findAll({
    int? albumId,
    bool? isActive,
    String? searchQuery,
    int page = 1,
    int perPage = 100,
    String orderBy = '"order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();
    final where = <String>[];
    final args = <dynamic>[];

    if (albumId != null) {
      where.add('album_id = ?');
      args.add(albumId);
    }

    if (isActive != null) {
      where.add('is_active = ?');
      args.add(isActive ? 1 : 0);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('(title LIKE ? OR content LIKE ?)');
      args.add('%$searchQuery%');
      args.add('%$searchQuery%');
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sings $whereClause',
      args,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;
    final offset = (page - 1) * perPage;

    final query = '''
      SELECT * FROM sings
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';
    final results = await db.rawQuery(query, [...args, perPage, offset]);

    final songs = results.map((r) => Song.fromMap(r)).toList();

    return PaginatedResult<Song>(
      data: songs,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }
}
