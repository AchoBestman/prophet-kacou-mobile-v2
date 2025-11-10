class Photo {
  final int id;
  final String url;
  final String? title;
  final String? description;
  final int? eventId;
  final int order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Photo({
    required this.id,
    required this.url,
    this.title,
    this.description,
    this.eventId,
    this.order = 1,
    this.createdAt,
    this.updatedAt,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as int,
      url: map['url'] as String,
      title: map['title'] as String?,
      description: map['description'] as String?,
      eventId: map['event_id'] as int?,
      order: map['order'] as int? ?? 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'description': description,
      'event_id': eventId,
      'order': order,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Photo copyWith({
    int? id,
    String? url,
    String? title,
    String? description,
    int? eventId,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Photo(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      eventId: eventId ?? this.eventId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Photo(id: $id, url: $url, eventId: $eventId)';
}
