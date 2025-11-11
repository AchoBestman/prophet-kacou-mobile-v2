import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/concordance.dart';
import 'package:prophet_kacou/core/models/image_sermon.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/verse.dart';

class SermonRepository {
  final DBManager _dbManager = DBManager();

  /// 🔹 Récupérer tous les sermons actifs avec filtres
  Future<List<Sermon>> findAll({
    bool isActive = true,
    String lang ='',
    String? searchQuery,
    int? number,
    String? chapter,
    String? title,
    String? subTitle,
    String orderBy = '"number" ASC',
  }) async {
    final db = await _dbManager.openLanguageDB(lang);
    final where = <String>[];
    final args = <dynamic>[];

    if (isActive) {
      where.add('is_active = 1');
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where.add('(chapter LIKE ? OR title LIKE ? OR sub_title LIKE ?)');
      args.add('%$searchQuery%');
      args.add('%$searchQuery%');
    }

    if (number != null) {
      where.add('"number" = ?');
      args.add(number);
    }
    // if (chapter != null && chapter.isNotEmpty) {
    //   where.add('"chapter" LIKE ?');
    //   args.add('%$chapter%');
    // }
    // if (title != null && title.isNotEmpty) {
    //   where.add('"title" LIKE ?');
    //   args.add('%$title%');
    // }
    // if (subTitle != null && subTitle.isNotEmpty) {
    //   where.add('"sub_title" LIKE ?');
    //   args.add('%$subTitle%');
    // }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';
    final results = await db.rawQuery(
      'SELECT * FROM sermons $whereClause ORDER BY $orderBy',
      args,
    );

    return results.map((r) => Sermon.fromMap(r)).toList();
  }

  /// 🔹 Récupérer un sermon par ID avec toutes ses relations
  Future<Sermon?> findById(int id, String lang) async {
    final db = await _dbManager.openLanguageDB(lang);

    // Sermon principal
    final sermonResult =
        await db.rawQuery('SELECT * FROM sermons WHERE id = ?', [id]);
    if (sermonResult.isEmpty) return null;

    final sermon = Sermon.fromMap(sermonResult.first);

    // Image associée
    if (sermon.cover != null) {
      final imageResult = await db.rawQuery(
        'SELECT * FROM image_sermons WHERE name = ? LIMIT 1',
        [sermon.cover],
      );
      if (imageResult.isNotEmpty) {
        sermon.image = ImageSermon.fromMap(imageResult.first);
      }
    }

    // Versets
    final verseResults = await db.rawQuery(
      'SELECT * FROM verses WHERE sermon_id = ? ORDER BY "number" ASC',
      [sermon.id],
    );
    sermon.verses = verseResults.map((v) => Verse.fromMap(v)).toList();

    // Concordances
    final concordanceResults = await db.rawQuery('SELECT * FROM concordances');
    sermon.concordances =
        concordanceResults.map((c) => Concordance.fromMap(c)).toList();

    return sermon;
  }
}
