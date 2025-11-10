// lib/app/data/repositories/country_repository.dart

import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/country.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class CountryRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère tous les pays avec pagination et filtres
  Future<PaginatedResult<Country>> findAll({
    int page = 1,
    int perPage = 20,
    String? name,
    String? sigle,
    bool? isActive,
    String orderBy = 'order ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    // Construction de la clause WHERE
    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (name != null && name.isNotEmpty) {
      whereConditions.add('name LIKE ?');
      whereArgs.add('%$name%');
    }

    if (sigle != null && sigle.isNotEmpty) {
      whereConditions.add('sigle LIKE ?');
      whereArgs.add('%$sigle%');
    }

    if (isActive != null) {
      whereConditions.add('is_active = ?');
      whereArgs.add(isActive ? 1 : 0);
    }

    final String whereClause =
        whereConditions.isNotEmpty ? whereConditions.join(' AND ') : '';

    // Compter le nombre total d'éléments
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM countries${whereClause.isNotEmpty ? ' WHERE $whereClause' : ''}',
      whereArgs,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // Récupérer les données paginées
    final offset = (page - 1) * perPage;
    final List<Map<String, dynamic>> results = await db.query(
      'countries',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: orderBy,
      limit: perPage,
      offset: offset,
    );

    final countries = results.map((map) => Country.fromMap(map)).toList();

    return PaginatedResult<Country>(
      data: countries,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère un pays
  Future<Country?> findBy({String key = 'id', value}) async {
    final db = await _dbManager.openCommonDB();

    final List<Map<String, dynamic>> results = await db.query(
      'countries',
      where: '$key = ?',
      whereArgs: [value],
      limit: 1,
    );

    if (results.isEmpty) return null;

    return Country.fromMap(results.first);
  }
}