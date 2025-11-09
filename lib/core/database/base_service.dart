import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/pagination_model.dart';

class BaseService {
  final DBManager _dbManager = DBManager();

  // 🗄 Cache en mémoire
  final Map<String, List<Map<String, dynamic>>> _queryCache = {};

  String _generateCacheKey(String query, List<Object?> params) {
    return '$query-${params.join("-")}';
  }

  /// Convertit un pluriel en singulier (simple)
  String _toSingular(String word) {
    if (word.endsWith('es')) return word.substring(0, word.length - 2);
    if (word.endsWith('s')) return word.substring(0, word.length - 1);
    return word;
  }

  Future<DataType<Map<String, dynamic>>> allModels(
    String lang,
    bool isCommon,
    String baseQuery,
    String countQuery,
    List<Object?> searchParams,
    List<String> conditions, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? order,
    String? groupBy,
    bool useCache = true, // flag pour activer/désactiver le cache
  }) async {
    final db = isCommon
        ? await _dbManager.openCommonDB()
        : await _dbManager.openLanguageDB(lang);

    final countResult = await db.rawQuery(countQuery, searchParams);
    final total = countResult.first['total'] as int? ?? 0;

    final perPage = (params?['per_page'] ?? 10) as int;
    final page = (params?['current_page'] ?? 1) as int;
    final offset = (page - 1) * perPage;
    final totalPages = (total / perPage).ceil();

    var query = baseQuery;
    if (conditions.isNotEmpty) {
      query += " WHERE ${conditions.join(' AND ')}";
    }

    if (groupBy != null) query += " $groupBy";

    if (order != null) {
      query += ' ORDER BY "${order['column']}" ${order['direction']} LIMIT ? OFFSET ?';
    } else {
      query += ' ORDER BY "id" DESC LIMIT ? OFFSET ?';
    }

    final fullParams = [...searchParams, perPage, offset];
    final cacheKey = _generateCacheKey(query, fullParams);

    // ⚡ Retour depuis cache si existant
    if (useCache && _queryCache.containsKey(cacheKey)) {
      return DataType<Map<String, dynamic>>(
        data: _queryCache[cacheKey]!,
        links: LinksType(
          first: page > 1 ? 1 : null,
          last: totalPages > 1 ? totalPages : null,
          prev: page > 1 ? page - 1 : null,
          next: page < totalPages ? page + 1 : null,
        ),
        meta: MetaType(
          total: total,
          perPage: perPage,
          currentPage: page,
          totalPages: totalPages,
        ),
      );
    }

    final result = await db.rawQuery(query, fullParams);

    // Sauvegarde dans cache
    if (useCache) _queryCache[cacheKey] = result;

    return DataType<Map<String, dynamic>>(
      data: result,
      links: LinksType(
        first: page > 1 ? 1 : null,
        last: totalPages > 1 ? totalPages : null,
        prev: page > 1 ? page - 1 : null,
        next: page < totalPages ? page + 1 : null,
      ),
      meta: MetaType(
        total: total,
        perPage: perPage,
        currentPage: page,
        totalPages: totalPages,
      ),
    );
  }



  Future<dynamic> oneModel(
    String resource,
    String lang,
    bool isCommon,
    dynamic params, {
    List<Map<String, String>>? relationships,
    bool useCache = true,
  }) async {
    final db = isCommon
        ? await _dbManager.openCommonDB()
        : await _dbManager.openLanguageDB(lang);

    // 🧩 Construire dynamiquement les conditions WHERE
    String whereClause;
    List<dynamic> values;

    if (params is List) {
      // Exemple: [{ column: "id", value: 2 }, { column: "status", value: "active" }]
      final conditions =
          params.map((p) => '${p['column']} = ?').toList();
      whereClause = conditions.join(' AND ');
      values = params.map((p) => p['value']).toList();
    } else if (params is Map) {
      // Exemple: { column: "number", value: 5 }
      whereClause = '${params['column']} = ?';
      values = [params['value']];
    } else {
      throw ArgumentError('params must be a Map or List of Maps');
    }

    // 🔍 Exécution de la requête principale
    final query = 'SELECT * FROM $resource WHERE $whereClause ORDER BY id DESC';
    final cacheKey = _generateCacheKey(query, values);

    List<Map<String, dynamic>> result;

    if (useCache && _queryCache.containsKey(cacheKey)) {
      result = _queryCache[cacheKey]!;
    } else {
      result = await db.rawQuery(query, values);
      if (useCache) _queryCache[cacheKey] = result;
    }

    // Cas spécial pour certaines ressources qui retournent une liste
    if (resource == 'sings') {
      return result;
    }

    if (result.isEmpty) {
      throw Exception(
        'Model not found for $resource with $whereClause = ${values.join(', ')}',
      );
    }

    final model = Map<String, dynamic>.from(result.first);

    // 🔗 Charger les relations si spécifiées
    if (relationships != null && relationships.isNotEmpty) {
      for (final relationship in relationships) {
        final table = relationship['table']!;
        final type = relationship['type']!;

        List<Map<String, dynamic>> relatedModels;

        // Cas spécial pour sermons + verses avec concordances
        if (resource == 'sermons' && table == 'verses') {
          final sermonNumber = model['number'];
          final sermonId = model['id'];

          final relationQuery = '''
            SELECT verses.*, 
                   GROUP_CONCAT(concordances.num_verset) as concordance_verse_numbers,
                   GROUP_CONCAT(concordances.num_pred) as concordance_sermon_numbers,
                   GROUP_CONCAT(concordances.concordance) as concordance_labels
            FROM verses
            LEFT JOIN concordances
              ON verses.number = concordances.num_verset
              AND concordances.num_pred = ?
            WHERE verses.sermon_id = ?
            GROUP BY verses.id
            ORDER BY verses.number ASC
          ''';

          relatedModels = await db.rawQuery(relationQuery, [sermonNumber, sermonId]);

          // Transformer les concordances en liste
          relatedModels = relatedModels.map((verse) {
            final verseMap = Map<String, dynamic>.from(verse);
            
            if (verse['concordance_labels'] != null) {
              final labels = verse['concordance_labels'].toString().split(',');
              final sermonNums = verse['concordance_sermon_numbers'].toString().split(',');
              final verseNums = verse['concordance_verse_numbers'].toString().split(',');

              final concordances = <Map<String, dynamic>>[];
              for (var i = 0; i < labels.length; i++) {
                concordances.add({
                  'label': labels[i],
                  'sermon_number': int.tryParse(sermonNums[i]) ?? 0,
                  'verse_number': int.tryParse(verseNums[i]) ?? 0,
                });
              }
              verseMap['concordances'] = concordances;
            } else {
              verseMap['concordances'] = [];
            }

            // Nettoyer les champs temporaires
            verseMap.remove('concordance_verse_numbers');
            verseMap.remove('concordance_sermon_numbers');
            verseMap.remove('concordance_labels');

            return verseMap;
          }).toList();
        } else {
          // Relations normales (BelongsTo, HasOne, HasMany)
          final filterColumn = _getRelationshipFilterColumn(resource, type);
          final valueColumn = _getRelationshipValueColumn(table, type);

          relatedModels = await db.rawQuery(
            'SELECT * FROM $table WHERE $filterColumn = ?',
            [model[valueColumn]],
          );
        }

        // Stocker la relation dans le modèle
        final relationKey = _getRelationshipColumnInModel(table, type);
        model[relationKey] = _getRelationshipValues(relatedModels, type);
      }
    }

    return model;
  }

  /// Détermine la colonne de filtre selon le type de relation
  String _getRelationshipFilterColumn(String resource, String type) {
    if (type == 'BelongsTo') {
      return 'id';
    }
    return '${_toSingular(resource)}_id';
  }

  /// Détermine la colonne de valeur selon le type de relation
  String _getRelationshipValueColumn(String table, String type) {
    if (type == 'BelongsTo') {
      return '${_toSingular(table)}_id';
    }
    return 'id';
  }

  /// Détermine le nom de la clé dans le modèle
  String _getRelationshipColumnInModel(String table, String type) {
    if (type == 'BelongsTo' || type == 'HasOne') {
      return _toSingular(table);
    }
    return table;
  }

  /// Retourne les valeurs selon le type de relation
  dynamic _getRelationshipValues(
    List<Map<String, dynamic>> results,
    String type,
  ) {
    if (type == 'BelongsTo' || type == 'HasOne') {
      return results.isNotEmpty ? results.first : null;
    }
    return results;
  }

  /// Vider le cache
  void clearCache() {
    _queryCache.clear();
  }

  /// Obtenir la taille du cache
  int getCacheSize() {
    return _queryCache.length;
  }

  /// Supprimer une entrée spécifique du cache
  void removeCacheEntry(String query, List<dynamic> args) {
    final key = _generateCacheKey(query, args);
    _queryCache.remove(key);
  }
}
