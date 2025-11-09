import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
class LinksType with _$LinksType {
  const factory LinksType({
    int? first,
    int? last,
    int? prev,
    int? next,
  }) = _LinksType;

  factory LinksType.fromJson(Map<String, dynamic> json) =>
      _$LinksTypeFromJson(json);
}

@freezed
class MetaType with _$MetaType {
  const factory MetaType({
    @JsonKey(name: 'current_page')
    required int currentPage,
    @JsonKey(name: 'total_pages')
    required int totalPages,
    @JsonKey(name: 'per_page')
    required int perPage,
    required int total,
  }) = _MetaType;

  factory MetaType.fromJson(Map<String, dynamic> json) =>
      _$MetaTypeFromJson(json);
}

@Freezed(genericArgumentFactories: true)
class DataType<T> with _$DataType<T> {
  const factory DataType({
    required List<T> data,
    required LinksType links,
    required MetaType meta,
  }) = _DataType<T>;

  factory DataType.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$DataTypeFromJson(json, fromJsonT);
}
