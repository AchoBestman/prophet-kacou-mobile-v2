
import 'package:prophet_kacou/core/models/country.dart';

class Langue {
  final int id;
  final int countryId;
  final String libelle;
  final String initial;
  final bool principal;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? webTranslation;

  // Relation avec Country
  final Country? country;

  Langue({
    required this.id,
    required this.countryId,
    required this.libelle,
    required this.initial,
    this.principal = false,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.webTranslation,
    this.country,
  });

  /// Créer depuis la base de données
  factory Langue.fromMap(Map<String, dynamic> map) {
    return Langue(
      id: map['id'] as int,
      countryId: map['country_id'] as int,
      libelle: map['libelle'] as String,
      initial: map['initial'] as String,
      principal: (map['principal'] as int) == 1,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      webTranslation: map['web_translation'] as String?,
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
      'country_id': countryId,
      'libelle': libelle,
      'initial': initial,
      'principal': principal ? 1 : 0,
      'order': order,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'web_translation': webTranslation,
    };
  }

  /// CopyWith pour créer des copies modifiées
  Langue copyWith({
    int? id,
    int? countryId,
    String? libelle,
    String? initial,
    bool? principal,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? webTranslation,
    Country? country,
  }) {
    return Langue(
      id: id ?? this.id,
      countryId: countryId ?? this.countryId,
      libelle: libelle ?? this.libelle,
      initial: initial ?? this.initial,
      principal: principal ?? this.principal,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      webTranslation: webTranslation ?? this.webTranslation,
      country: country ?? this.country,
    );
  }

  /// Code langue complet (ex: "fr-fr")
  String get fullCode {
    final countryCode = country?.sigle.toLowerCase() ?? '';
    return '$countryCode-$initial';
  }

  @override
  String toString() {
    return 'Langue(id: $id, libelle: $libelle, initial: $initial, principal: $principal, country: ${country?.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Langue &&
        other.id == id &&
        other.countryId == countryId &&
        other.libelle == libelle &&
        other.initial == initial;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        countryId.hashCode ^
        libelle.hashCode ^
        initial.hashCode;
  }
}