// lib/core/models/city.dart

import 'package:prophet_kacou/core/models/country.dart';

class City {
  final int id;
  final String libelle;
  final String? description;
  final int? countryId;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Relation avec Country
  final Country? country;

  City({
    required this.id,
    required this.libelle,
    this.description,
    this.countryId,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.country,
  });

  /// Créer depuis la base de données
  factory City.fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as int,
      libelle: map['libelle'] as String,
      description: map['description'] as String?,
      countryId: map['country_id'] as int?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      country: map['country_name'] != null
          ? Country(
              id: map['country_id'] as int,
              name: map['country_name'] as String,
              sigle: map['country_sigle'] as String,
              order: map['country_order'] as int? ?? 1,
              isActive: (map['country_is_active'] as int? ?? 1) == 1,
            )
          : null,
    );
  }

  /// Convertir en Map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'country_id': countryId,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// CopyWith pour créer des copies modifiées
  City copyWith({
    int? id,
    String? libelle,
    String? description,
    int? countryId,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Country? country,
  }) {
    return City(
      id: id ?? this.id,
      libelle: libelle ?? this.libelle,
      description: description ?? this.description,
      countryId: countryId ?? this.countryId,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      country: country ?? this.country,
    );
  }

  @override
  String toString() {
    return 'City(id: $id, libelle: $libelle, countryId: $countryId, country: ${country?.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is City &&
        other.id == id &&
        other.libelle == libelle &&
        other.countryId == countryId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ libelle.hashCode ^ countryId.hashCode;
  }
}