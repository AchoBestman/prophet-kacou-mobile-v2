
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';
import 'package:prophet_kacou/core/models/langue.dart';

class LangueRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère toutes les langues avec pagination et filtres
  Future<PaginatedResult<Langue>> findAll({
    int page = 1,
    int perPage = 20,
    String? libelle,
    String? initial,
    int? countryId,
    bool? principal,
    bool? isActive,
    String orderBy = 'langues.order ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    // Construction de la clause WHERE
    final List<String> whereConditions = [];
    final List<dynamic> whereArgs = [];

    if (libelle != null && libelle.isNotEmpty) {
      whereConditions.add('langues.libelle LIKE ?');
      whereArgs.add('%$libelle%');
    }

    if (initial != null && initial.isNotEmpty) {
      whereConditions.add('langues.initial LIKE ?');
      whereArgs.add('%$initial%');
    }

    if (countryId != null) {
      whereConditions.add('langues.country_id = ?');
      whereArgs.add(countryId);
    }

    if (principal != null) {
      whereConditions.add('langues.principal = ?');
      whereArgs.add(principal ? 1 : 0);
    }

    if (isActive != null) {
      whereConditions.add('langues.is_active = ?');
      whereArgs.add(isActive ? 1 : 0);
    }

    final String whereClause =
        whereConditions.isNotEmpty ? ' WHERE ${whereConditions.join(' AND ')}' : '';

    // Compter le nombre total d'éléments
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM langues$whereClause',
      whereArgs,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    // Récupérer les données paginées avec jointure
    final offset = (page - 1) * perPage;
    final String query = '''
      SELECT 
        langues.*,
        countries.name as country_name,
        countries.sigle as country_sigle,
        countries.order as country_order,
        countries.is_active as country_is_active
      FROM langues
      LEFT JOIN countries ON langues.country_id = countries.id
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(
      query,
      [...whereArgs, perPage, offset],
    );

    final langues = results.map((map) => Langue.fromMap(map)).toList();

    return PaginatedResult<Langue>(
      data: langues,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère une langue par
  Future<Langue?> findById({String key = 'id', value}) async {
    final db = await _dbManager.openCommonDB();

    final String query = '''
      SELECT 
        langues.*,
        countries.name as country_name,
        countries.sigle as country_sigle,
        countries.order as country_order,
        countries.is_active as country_is_active
      FROM langues
      LEFT JOIN countries ON langues.country_id = countries.id
      WHERE langues.$key = ?
      LIMIT 1
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, [value]);

    if (results.isEmpty) return null;

    return Langue.fromMap(results.first);
  }

}
