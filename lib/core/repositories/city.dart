// lib/core/repositories/city.dart

import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/city.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class CityRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère toutes les villes avec pagination et filtres
  Future<PaginatedResult<City>> findAll({
    int page = 1,
    int perPage = 20,
    String? libelle,
    int? countryId,
    bool? isActive,
    String orderBy = 'cities."order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    // Construction de la clause WHERE
    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (libelle != null && libelle.isNotEmpty) {
      whereConditions.add('cities.libelle LIKE ?');
      whereArgs.add('%$libelle%');
    }

    if (countryId != null) {
      whereConditions.add('cities.country_id = ?');
      whereArgs.add(countryId);
    }

    if (isActive != null) {
      whereConditions.add('cities.is_active = ?');
      whereArgs.add(isActive ? 1 : 0);
    }

    final String whereClause =
        whereConditions.isNotEmpty ? ' WHERE ${whereConditions.join(' AND ')}' : '';

    // Compter le nombre total d'éléments
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cities$whereClause',
      whereArgs,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // Récupérer les données paginées avec jointure
    final offset = (page - 1) * perPage;
    final String query = '''
      SELECT 
        cities.*,
        countries.name as country_name,
        countries.sigle as country_sigle,
        countries."order" as country_order,
        countries.is_active as country_is_active
      FROM cities
      LEFT JOIN countries ON cities.country_id = countries.id
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(
      query,
      [...whereArgs, perPage, offset],
    );

    final cities = results.map((map) => City.fromMap(map)).toList();

    return PaginatedResult<City>(
      data: cities,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère une ville par clé
  Future<City?> findBy({String key = 'id', required dynamic value}) async {
    final db = await _dbManager.openCommonDB();

    final String query = '''
      SELECT 
        cities.*,
        countries.name as country_name,
        countries.sigle as country_sigle,
        countries.order as country_order,
        countries.is_active as country_is_active
      FROM cities
      LEFT JOIN countries ON cities.country_id = countries.id
      WHERE cities.$key = ?
      LIMIT 1
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [value]);

    if (results.isEmpty) return null;

    return City.fromMap(results.first);
  }

  /// Récupère toutes les villes d'un pays
  Future<List<City>> findByCountryId(int countryId) async {
    final result = await findAll(
      countryId: countryId,
      isActive: true,
      perPage: 1000,
    );
    return result.data;
  }

  /// Récupère toutes les villes actives
  Future<List<City>> findAllActive() async {
    final result = await findAll(
      isActive: true,
      perPage: 1000,
    );
    return result.data;
  }

}