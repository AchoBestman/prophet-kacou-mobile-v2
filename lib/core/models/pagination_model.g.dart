// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LinksTypeImpl _$$LinksTypeImplFromJson(Map<String, dynamic> json) =>
    _$LinksTypeImpl(
      first: (json['first'] as num?)?.toInt(),
      last: (json['last'] as num?)?.toInt(),
      prev: (json['prev'] as num?)?.toInt(),
      next: (json['next'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LinksTypeImplToJson(_$LinksTypeImpl instance) =>
    <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };

_$MetaTypeImpl _$$MetaTypeImplFromJson(Map<String, dynamic> json) =>
    _$MetaTypeImpl(
      currentPage: (json['current_page'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$MetaTypeImplToJson(_$MetaTypeImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'per_page': instance.perPage,
      'total': instance.total,
    };

_$DataTypeImpl<T> _$$DataTypeImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _$DataTypeImpl<T>(
  data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
  links: LinksType.fromJson(json['links'] as Map<String, dynamic>),
  meta: MetaType.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$DataTypeImplToJson<T>(
  _$DataTypeImpl<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'data': instance.data.map(toJsonT).toList(),
  'links': instance.links,
  'meta': instance.meta,
};
