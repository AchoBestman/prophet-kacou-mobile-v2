class Head {
  final int id;
  final bool isPastor;
  final int brotherId;
  final int assemblyId;
  final bool principal;
  final int? countryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Head({
    required this.id,
    required this.isPastor,
    required this.brotherId,
    required this.assemblyId,
    this.principal = false,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  factory Head.fromMap(Map<String, dynamic> map) {
    return Head(
      id: map['id'] as int,
      isPastor: (map['is_pastor'] as int? ?? 0) == 1,
      brotherId: map['brother_id'] as int,
      assemblyId: map['assembly_id'] as int,
      principal: (map['principal'] as int? ?? 0) == 1,
      countryId: map['country_id'] as int?,
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
        'is_pastor': isPastor ? 1 : 0,
        'brother_id': brotherId,
        'assembly_id': assemblyId,
        'principal': principal ? 1 : 0,
        'country_id': countryId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// CopyWith
  Head copyWith({
    int? id,
    bool? isPastor,
    int? brotherId,
    int? assemblyId,
    bool? principal,
    int? countryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Head(
      id: id ?? this.id,
      isPastor: isPastor ?? this.isPastor,
      brotherId: brotherId ?? this.brotherId,
      assemblyId: assemblyId ?? this.assemblyId,
      principal: principal ?? this.principal,
      countryId: countryId ?? this.countryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Head(id: $id, brotherId: $brotherId, assemblyId: $assemblyId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Head && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
