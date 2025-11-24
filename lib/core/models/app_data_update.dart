class AppDataUpdate {
  final String langue;
  final String updatedAt;

  AppDataUpdate({
    required this.langue,
    required this.updatedAt,
  });

  factory AppDataUpdate.fromJson(Map<String, dynamic> json) {
    return AppDataUpdate(
      langue: json['langue'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'langue': langue,
      'updated_at': updatedAt,
    };
  }
}
