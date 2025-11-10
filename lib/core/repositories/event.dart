import 'package:prophet_kacou/core/database/db_manager.dart';
import 'package:prophet_kacou/core/models/event.dart';
import 'package:prophet_kacou/core/models/photo.dart';
import 'package:prophet_kacou/core/models/paginated_result.dart';
import 'package:sqflite/sqflite.dart';

class EventRepository {
  final DBManager _dbManager = DBManager();

  Future<PaginatedResult<Event>> findAll({
    int page = 1,
    int perPage = 20,
    String? libelle,
    bool? isActive,
    String orderBy = 'events."order" ASC',
  }) async {
    final db = await _dbManager.openCommonDB();

    final where = <String>[];
    final args = <dynamic>[];

    if (libelle != null && libelle.isNotEmpty) {
      where.add('events.libelle LIKE ?');
      args.add('%$libelle%');
    }

    if (isActive != null) {
      where.add('events.is_active = ?');
      args.add(isActive ? 1 : 0);
    }

    final whereClause = where.isNotEmpty ? 'WHERE ${where.join(' AND ')}' : '';

    // Compter total
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM events $whereClause',
      args,
    );
    final totalCount = Sqflite.firstIntValue(countResult) ?? 0;
    final offset = (page - 1) * perPage;

    // Récupérer events + photos
    final query =
        '''
      SELECT 
        events.*,
        photos.id as photo_id,
        photos.url as photo_url,
        photos.title as photo_title,
        photos.description as photo_description,
        photos.order as photo_order,
        photos.is_active as photo_is_active,
        photos.created_at as photo_created_at,
        photos.updated_at as photo_updated_at
      FROM events
      LEFT JOIN photos ON photos.event_id = events.id AND photos.is_active = 1
      $whereClause
      ORDER BY $orderBy
      LIMIT ? OFFSET ?
    ''';

    final results = await db.rawQuery(query, [...args, perPage, offset]);

    // Group by event
    final Map<int, Event> eventMap = {};
    for (var row in results) {
      final eventId = row['id'] as int;
      if (!eventMap.containsKey(eventId)) {
        eventMap[eventId] = Event.fromMap(row);
      }

      if (row['photo_id'] != null) {
        final photo = Photo.fromMap({
          'id': row['photo_id'],
          'url': row['photo_url'],
          'title': row['photo_title'],
          'description': row['photo_description'],
          'event_id': eventId,
          'order': row['photo_order'],
          'is_active': row['photo_is_active'],
          'created_at': row['photo_created_at'],
          'updated_at': row['photo_updated_at'],
        });
        if (eventMap[eventId]!.photos != null) {
          eventMap[eventId]!.photos!.add(photo);
        }
      }
    }

    return PaginatedResult<Event>(
      data: eventMap.values.toList(),
      total: totalCount,
      page: page,
      perPage: perPage,
    );
  }

  Future<Event?> findBy({String key = 'id', required dynamic value}) async {
    final db = await _dbManager.openCommonDB();

    final query =
        '''
      SELECT 
        events.*,
        photos.id as photo_id,
        photos.url as photo_url,
        photos.title as photo_title,
        photos.description as photo_description,
        photos.order as photo_order,
        photos.is_active as photo_is_active,
        photos.created_at as photo_created_at,
        photos.updated_at as photo_updated_at
      FROM events
      LEFT JOIN photos ON photos.event_id = events.id AND photos.is_active = 1
      WHERE events.$key = ?
      LIMIT 1
    ''';

    final results = await db.rawQuery(query, [value]);
    if (results.isEmpty) return null;

    final Map<String, dynamic> firstRow = results.first;
    final event = Event.fromMap(firstRow);

    final photos = results
        .where((r) => r['photo_id'] != null)
        .map(
          (r) => Photo.fromMap({
            'id': r['photo_id'],
            'url': r['photo_url'],
            'title': r['photo_title'],
            'description': r['photo_description'],
            'event_id': r['id'],
            'order': r['photo_order'],
            'is_active': r['photo_is_active'],
            'created_at': r['photo_created_at'],
            'updated_at': r['photo_updated_at'],
          }),
        )
        .toList();

    return event.copyWith(photos: photos);
  }
}
