
import 'package:prophet_kacou/core/models/photo.dart';

class Event {
  final int id;
  final String libelle;
  final String? description;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<Photo>? photos;

  Event({
    required this.id,
    required this.libelle,
    this.description,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.photos,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as int,
      libelle: map['libelle'] as String,
      description: map['description'] as String?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      photos: map['photos'] != null
          ? (map['photos'] as List).map((e) => Photo.fromMap(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Event copyWith({
    int? id,
    String? libelle,
    String? description,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Photo>? photos,
  }) {
    return Event(
      id: id ?? this.id,
      libelle: libelle ?? this.libelle,
      description: description ?? this.description,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
    );
  }

  @override
  String toString() => 'Event(id: $id, libelle: $libelle, photos: ${photos?.length})';
}
