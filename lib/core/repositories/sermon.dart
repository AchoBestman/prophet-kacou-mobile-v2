import 'dart:developer';

import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/concordance.dart';
import 'package:prophet_kacou/core/models/image_sermon.dart';
import 'package:prophet_kacou/core/models/sermon.dart';
import 'package:prophet_kacou/core/models/verse.dart';
import 'dart:typed_data';

import 'package:prophet_kacou/core/utils/formatters.dart';

class SermonRepository {
  final DBManager _dbManager = DBManager();

  /// 🔹 Récupérer tous les sermons actifs avec filtres
  Future<List<Sermon>> findAll({
    bool isActive = true,
    String lang = '',
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
    final commonDb = await _dbManager.openCommonDB();

    // Sermon principal
    final sermonResult = await db.query(
      'sermons',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (sermonResult.isEmpty) return null;
    final sermon = Sermon.fromMap(sermonResult.first);

    // Image associée - Lecture BLOB avec rawQuery et conversion manuelle
    if (sermon.cover != null) {
      try {
        // 1. Essai dans commonDb
        var rows = await commonDb.rawQuery(
          'SELECT id, description, name, link, apply_for_all_langue, hex(file) as hexFile FROM image_sermons WHERE name = ? LIMIT 1',
          [sermon.cover],
        );

        // 2. Sinon essayer dans db,
        if (rows.isEmpty) {
          rows = await db.rawQuery(
            'SELECT id, description, name, link, apply_for_all_langue, hex(file) as hexFile FROM image_sermons WHERE name = ? LIMIT 1',
            [sermon.cover],
          );
        }

        if (rows.isNotEmpty) {
          final row = Map<String, dynamic>.from(rows.first);

          Uint8List? blob;

          final f = row['hexFile'];
          if (f is Uint8List) {
            blob = f;
          } else if (f is List) {
            blob = Uint8List.fromList(List<int>.from(f));
          } else if (f is String) {
            blob = decodeHexToBytes(f);
          }

          row['file'] = blob;
          sermon.image = ImageSermon.fromMap(row);
        }
      } catch (e) {
        log('Erreur BLOB: $e');
      }
    }

    // Versets
    final verseResults = await db.query(
      'verses',
      where: 'sermon_id = ?',
      whereArgs: [sermon.id],
      orderBy: '"number" ASC',
    );
    sermon.verses = verseResults.map((v) => Verse.fromMap(v)).toList();

    // Concordances
    final concordanceResults = await db.query(
      'concordances',
      where: 'num_pred = ?',
      whereArgs: [sermon.number],
    );

    // Lier les concordances aux versets
    for (final verse in sermon.verses!) {
      final verseConcordance = concordanceResults.firstWhere(
        (c) => c['num_verset'] == verse.number,
        orElse: () => <String, Object?>{}, // retourne une Map vide si aucune correspondance
      );

      if (verseConcordance.isNotEmpty) {
        final concordance = Concordance.fromMap(verseConcordance);
        verse.concordance = concordance;
        verse.concordances = parseConcordance(concordance.concordance);
      }
    }
    return sermon;
  }
}
