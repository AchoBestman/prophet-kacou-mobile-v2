import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/assembly.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class AssemblyRepository {
  final DBManager _dbManager = DBManager();

  /// Récupère toutes les assemblées avec pagination et filtres
  Future<PaginatedResult<Assembly>> findAll({
    int page = 1,
    int perPage = 20,
    String? name,
    int? cityId,
    bool? isActive,
    String orderBy = 'assemblies."order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    final where = <String>[];
    final args = <dynamic>[];

    if (name != null && name.isNotEmpty) {
      where.add('assemblies.name LIKE ?');
      args.add('%$name%');
    }

    if (cityId != null) {
      where.add('assemblies.city_id = ?');
      args.add(cityId);
    }

    if (isActive != null) {
      where.add('assemblies.is_active = ?');
      args.add(isActive ? 1 : 0);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

    // Compter total
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM assemblies $whereClause',
      args,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;

    final offset = (page - 1) * perPage;

    // Requête principale avec jointures et dernier head principal
    final query = '''
      SELECT 
        assemblies.*,
        cities.libelle as city_name,
        cities.description as city_description,
        countries.id as country_id,
        countries.name as country_name,
        brothers.id as brother_id,
        brothers.full_name as brother_name,
        brothers.phone as brother_phone,
        brothers.avatar as brother_avatar,
        brothers.email as brother_email
      FROM assemblies
      LEFT JOIN cities ON assemblies.city_id = cities.id
      LEFT JOIN countries ON cities.country_id = countries.id
      LEFT JOIN (
          SELECT h1.*
          FROM heads h1
          WHERE h1.principal = 1
            AND h1.id = (
                SELECT MAX(h2.id)
                FROM heads h2
                WHERE h2.assembly_id = h1.assembly_id
            )
      ) heads ON heads.assembly_id = assemblies.id
      LEFT JOIN brothers ON heads.brother_id = brothers.id
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final results = await db.rawQuery(query, [...args, perPage, offset]);
    final assemblies = results.map((e) => Assembly.fromMap(e)).toList();

    return PaginatedResult<Assembly>(
      data: assemblies,
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  /// Récupère une assemblée par clé
  Future<Assembly?> findBy({String key = 'id', required dynamic value}) async {
    final db = await _dbManager.openCommonDB();

    final query = '''
      SELECT 
        assemblies.*,
        cities.libelle as city_name,
        cities.description as city_description,
        countries.id as country_id,
        countries.name as country_name,
        brothers.id as brother_id,
        brothers.full_name as brother_name,
        brothers.phone as brother_phone,
        brothers.avatar as brother_avatar,
        brothers.email as brother_email
      FROM assemblies
      LEFT JOIN cities ON assemblies.city_id = cities.id
      LEFT JOIN countries ON cities.country_id = countries.id
      LEFT JOIN (
          SELECT h1.*
          FROM heads h1
          WHERE h1.principal = 1
            AND h1.id = (
                SELECT MAX(h2.id)
                FROM heads h2
                WHERE h2.assembly_id = h1.assembly_id
            )
      ) heads ON heads.assembly_id = assemblies.id
      LEFT JOIN brothers ON heads.brother_id = brothers.id
      WHERE assemblies.$key = ?
      LIMIT 1
    ''';

    final results = await db.rawQuery(query, [value]);
    if (results.isEmpty) return null;
    return Assembly.fromMap(results.first);
  }
}
