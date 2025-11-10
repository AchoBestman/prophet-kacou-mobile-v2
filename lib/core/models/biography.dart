class Biography {
  final int id;
  final String photo;
  final String description;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Biography({
    required this.id,
    required this.photo,
    required this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Créer depuis la base de données
  factory Biography.fromMap(Map<String, dynamic> map) {
    return Biography(
      id: map['id'] as int,
      photo: map['photo'] as String,
      description: map['description'] as String,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  /// Convertir en Map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// CopyWith pour créer des copies modifiées
  Biography copyWith({
    int? id,
    String? photo,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Biography(
      id: id ?? this.id,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Biography(id: $id, photo: $photo, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Biography &&
        other.id == id &&
        other.photo == photo &&
        other.description == description &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        photo.hashCode ^
        description.hashCode ^
        isActive.hashCode;
  }
}