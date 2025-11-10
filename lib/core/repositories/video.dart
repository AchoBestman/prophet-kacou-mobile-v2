import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/video.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class VideoRepository {
  final DBManager _dbManager = DBManager();

  Future<PaginatedResult<Video>> findAll({
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

    if (eventId != null) {
      where.add('event_id = ?');
      args.add(eventId);
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      where.add('(title LIKE ? OR description LIKE ?)');
      final pattern = '%${searchQuery.trim()}%';
      args.addAll([pattern, pattern]);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

    // Count total
    final countResult =
        await db.rawQuery('SELECT COUNT(*) as count FROM videos $whereClause', args);
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;
    final offset = (page - 1) * perPage;

    final results = await db.rawQuery(
      '''
      SELECT *
      FROM videos
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
      ''',
      [...args, perPage, offset],
    );

    final videos = results.map((map) => Video.fromMap(map)).toList();

    return PaginatedResult<Video>(
      data: videos,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }
}
