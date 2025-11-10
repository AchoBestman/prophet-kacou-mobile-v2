class Brother {
  final int id;
  final String fullName;
  final String? phone;
  final String? avatar;
  final String? facebook;
  final String? youtube;
  final String? email;
  final int order;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Brother({
    required this.id,
    required this.fullName,
    this.phone,
    this.avatar,
    this.facebook,
    this.youtube,
    this.email,
    this.order = 1,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Brother.fromMap(Map<String, dynamic> map) {
    return Brother(
      id: map['id'] as int,
      fullName: map['full_name'] as String,
      phone: map['phone'] as String?,
      avatar: map['avatar'] as String?,
      facebook: map['facebook'] as String?,
      youtube: map['youtube'] as String?,
      email: map['email'] as String?,
      order: map['order'] as int? ?? 1,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'avatar': avatar,
        'facebook': facebook,
        'youtube': youtube,
        'email': email,
        'order': order,
        'is_active': isActive ? 1 : 0,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// CopyWith
  Brother copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? avatar,
    String? facebook,
    String? youtube,
    String? email,
    int? order,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brother(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      facebook: facebook ?? this.facebook,
      youtube: youtube ?? this.youtube,
      email: email ?? this.email,
      order: order ?? this.order,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Brother(id: $id, fullName: $fullName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brother && other.id == id && other.fullName == fullName;
  }

  @override
  int get hashCode => id.hashCode ^ fullName.hashCode;
}
