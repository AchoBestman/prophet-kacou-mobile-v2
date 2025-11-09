import 'package:prophet_kacou/core/database/base_service.dart';
import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/pagination_model.dart';
import 'package:prophet_kacou/core/models/sermon_model.dart';

class SermonService {
  final BaseService _base = BaseService();
  final DBManager _dbManager = DBManager();

  Future<DataType<Sermon>> findAll(
    String lang, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? order,
  }) async {
    const resource = "sermons";

    final baseQuery = '''
      SELECT s.*, v.number as verse_number
      FROM $resource s
      LEFT JOIN verses v ON v.sermon_id = s.id AND v.number = 1
    ''';

    var countQuery = '''
      SELECT COUNT(DISTINCT s.id) as total
      FROM $resource s
      LEFT JOIN verses v ON v.sermon_id = s.id AND v.number = 1
    ''';

    final conditions = <String>[];
    final searchParams = <Object?>[];

    if (params?['search'] != null) {
      conditions.add('(s.chapter LIKE ? OR s.title LIKE ?)');
      searchParams.addAll([
        '%${params!['search']}%',
        '%${params['search']}%',
      ]);
    }

    if (params?['number'] != null) {
      conditions.add('v.number = ?');
      searchParams.add(params!['number']);
    }

    conditions.add('s.is_active = ?');
    searchParams.add(1);

    if (conditions.isNotEmpty) {
      final whereClause = " WHERE ${conditions.join(' AND ')}";
      countQuery += whereClause;
    }

    final response = await _base.allModels(
      lang,
      false,
      baseQuery,
      countQuery,
      searchParams,
      conditions,
      params: params,
      order: order,
    );

    final sermons = response.data.map((e) => Sermon.fromJson(e)).toList();

    return DataType<Sermon>(
      data: sermons,
      links: response.links,
      meta: response.meta,
    );
  }

  Future<List<Map<String, dynamic>>> findAllVerses(
    String lang, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? order,
  }) async {
    final db = await _dbManager.openLanguageDB(lang);
    const resource = "verses";

    var baseQuery = '''
      SELECT 
        v.id,
        v.sermon_id,
        v.number,
        v.title,
        v.content,
        v.verse_links,
        s.number as sermon_number
      FROM $resource v
      INNER JOIN sermons s ON v.sermon_id = s.id
      WHERE s.is_active = 1
    ''';

    final searchParams = <Object?>[];

    if (params?['search'] == null) return [];

    baseQuery += ' AND (v.title LIKE ? OR v.content LIKE ?)';
    searchParams.addAll([
      '%${params!['search']}%',
      '%${params['search']}%',
    ]);

    if (order != null) {
      baseQuery +=
          ' ORDER BY v.${order['column']} ${order['direction']}';
    }

    return await db.rawQuery(baseQuery, searchParams);
  }

  /// Récupère un sermon par une colonne spécifique avec relations
  Future<Sermon?> findBy(
    String lang, {
    required String column,
    required dynamic value,
    List<Map<String, String>>? relationships,
    bool useCache = true,
  }) async {
    try {
      final result = await _base.oneModel(
        'sermons',
        lang,
        false,
        {
          'column': column,
          'value': value,
        },
        relationships: relationships ??
            [
              {'table': 'verses', 'type': 'HasMany'}
            ],
        useCache: useCache,
      );


      if (result == null) return null;


return result as Sermon;
      return Sermon.fromJson(result as Map<String, dynamic>);
    } catch (e) {
      print('Error in SermonService.findBy: $e');
      return null;
    }
  }
}
