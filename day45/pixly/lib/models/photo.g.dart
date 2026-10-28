// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Photo _$PhotoFromJson(Map<String, dynamic> json) => _Photo(
  id: (json['id'] as num).toInt(),
  width: (json['width'] as num?)?.toInt() ?? 0,
  height: (json['height'] as num?)?.toInt() ?? 0,
  url: json['url'] as String? ?? '',
  photographer: json['photographer'] as String? ?? 'Unknown',
  photographerUrl: json['photographer_url'] as String? ?? '',
  avgColor: json['avg_color'] as String? ?? '#9E9E9E',
  alt: json['alt'] as String? ?? '',
  src: PhotoSrc.fromJson(json['src'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PhotoToJson(_Photo instance) => <String, dynamic>{
  'id': instance.id,
  'width': instance.width,
  'height': instance.height,
  'url': instance.url,
  'photographer': instance.photographer,
  'photographer_url': instance.photographerUrl,
  'avg_color': instance.avgColor,
  'alt': instance.alt,
  'src': instance.src.toJson(),
};
