// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotosPage _$PhotosPageFromJson(Map<String, dynamic> json) => _PhotosPage(
  page: (json['page'] as num?)?.toInt() ?? 1,
  perPage: (json['per_page'] as num?)?.toInt() ?? 15,
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalResults: (json['total_results'] as num?)?.toInt(),
  nextPage: json['next_page'] as String?,
);

Map<String, dynamic> _$PhotosPageToJson(_PhotosPage instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'total_results': instance.totalResults,
      'next_page': instance.nextPage,
    };
