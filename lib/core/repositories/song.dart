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

  Future<Map<String, dynamic>?> findPreviousSong({
    required String lang,
    required int id,
    int? albumId,
  }) async {
    List<Map<String, dynamic>> result;

    if (albumId != null) {
      final db = await _dbManager.openCommonDB();
      result = await db.rawQuery(
        '''SELECT * FROM sings
           WHERE album_id = ? AND "order" < (
             SELECT "order" FROM sings WHERE id = ? AND album_id = ?
           )
           ORDER BY "order" DESC
           LIMIT 1;''',
        [albumId, id, albumId],
      );
    } else {
      final db = await _dbManager.openLanguageDB(lang);
      result = await db.rawQuery(
        '''SELECT * FROM sermons
           WHERE "number" < (
             SELECT "number" FROM sermons WHERE id = ?
           )
           ORDER BY "number" DESC
           LIMIT 1;''',
        [id],
      );
    }

    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> findNextSong({
    required String lang,
    required int id,
    int? albumId,
    int? firstAudioId,
  }) async {
    try {
      List<Map<String, dynamic>> result;

      if (albumId != null) {
        final db = await _dbManager.openCommonDB();
        result = await db.rawQuery(
          '''SELECT * FROM sings
             WHERE album_id = ? AND "order" > (
               SELECT "order" FROM sings WHERE id = ? AND album_id = ?
             )
             ORDER BY "order" ASC
             LIMIT 1;''',
          [albumId, id, albumId],
        );

        final song = result.isNotEmpty ? result.first : null;

        // 👉 Si rien n'est trouvé, retourner le premier son (boucle)
        if (song == null || song['album_id'] == null) {
          if (firstAudioId != null) {
            result = await db.rawQuery(
              '''SELECT * FROM sings WHERE id = ? AND album_id = ? LIMIT 1;''',
              [firstAudioId, albumId],
            );
          }
        }
      } else {

        final db = await _dbManager.openLanguageDB(lang);

        result = await db.rawQuery(
          '''SELECT * FROM sermons
             WHERE "number" > (
               SELECT "number" FROM sermons WHERE id = ?
             )
             ORDER BY "number" ASC
             LIMIT 1;''',
          [id],
        );

        final song = result.isNotEmpty ? result.first : null;

        // 👉 Si rien n'est trouvé, retourner le premier sermon
        if (song == null || song['chapter'] == null) {
          if (firstAudioId != null) {
            result = await db.rawQuery(
              '''SELECT * FROM sermons WHERE id = ? LIMIT 1;''',
              [firstAudioId],
            );
          }
        }
      }

      return result.isNotEmpty ? result.first : null;
    } catch (error) {
      print("🔥 ERREUR dans findNextSong : $error");
      rethrow; // pour la remonter si nécessaire
    }
  }
}