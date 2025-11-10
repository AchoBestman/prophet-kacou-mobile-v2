class Country {
  final int id;
  final String name;
  final String sigle;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.sigle,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  /// Créer depuis la base de données
  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as int,
      name: map['name'] as String,
      sigle: map['sigle'] as String,
      order: map['order'] as int? ?? 1,
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
      'name': name,
      'sigle': sigle,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// CopyWith pour créer des copies modifiées
  Country copyWith({
    int? id,
    String? name,
    String? sigle,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Country(
      id: id ?? this.id,
      name: name ?? this.name,
      sigle: sigle ?? this.sigle,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Country(id: $id, name: $name, sigle: $sigle, order: $order, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country &&
        other.id == id &&
        other.name == name &&
        other.sigle == sigle &&
        other.order == order &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        sigle.hashCode ^
        order.hashCode ^
        isActive.hashCode;
  }
}