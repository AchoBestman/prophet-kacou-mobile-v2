// lib/core/models/information.dart
class Information {
  final int id;
  final String title;
  final String? description;
  final int order;
  final bool isActive;
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Information({
    required this.id,
    required this.title,
    this.description,
    this.order = 1,
    this.isActive = true,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Information.fromMap(Map<String, dynamic> map) {
    return Information(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      date: DateTime.parse(map['date'] as String),
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
      'title': title,
      'description': description,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'date': date.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Information copyWith({
    int? id,
    String? title,
    String? description,
    int? order,
    bool? isActive,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Information(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Information(id: $id, title: $title)';
}
