import 'package:prophet_kacou/core/models/brother.dart';
import 'package:prophet_kacou/core/models/city.dart';

class Assembly {
  final int id;
  final String? name;
  final int cityId;
  final String? localisation;
  final String? address;
  final String? photo;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final City? city;
  final Brother? head;

  Assembly({
    required this.id,
    this.name,
    required this.cityId,
    this.localisation,
    this.address,
    this.photo,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.head,
  });

  factory Assembly.fromMap(Map<String, dynamic> map) {
    return Assembly(
      id: map['id'] as int,
      name: map['name'] as String?,
      cityId: map['city_id'] as int,
      localisation: map['localisation'] as String?,
      address: map['address'] as String?,
      photo: map['photo'] as String?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      city: map['city_name'] != null
          ? City(
              id: map['city_id'] as int,
              libelle: map['city_name'] as String,
              description: map['city_description'] as String?,
              countryId: map['country_id'] as int?,
            )
          : null,
      head: map['brother_id'] != null
          ? Brother(
              id: map['brother_id'] as int,
              fullName: map['brother_name'] as String,
              phone: map['brother_phone'] as String?,
              avatar: map['brother_avatar'] as String?,
              email: map['brother_email'] as String?,
            )
          : null,
    );
  }

  /// CopyWith
  Assembly copyWith({
    int? id,
    String? name,
    int? cityId,
    String? localisation,
    String? address,
    String? photo,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    City? city,
    Brother? head,
  }) {
    return Assembly(
      id: id ?? this.id,
      name: name ?? this.name,
      cityId: cityId ?? this.cityId,
      localisation: localisation ?? this.localisation,
      address: address ?? this.address,
      photo: photo ?? this.photo,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      city: city ?? this.city,
      head: head ?? this.head,
    );
  }

  @override
  String toString() => 'Assembly(id: $id, name: $name, cityId: $cityId, head: ${head?.fullName})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assembly && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
