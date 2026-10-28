// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_src.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PhotoSrc _$PhotoSrcFromJson(Map<String, dynamic> json) => _PhotoSrc(
  original: json['original'] as String? ?? '',
  large2x: json['large2x'] as String? ?? '',
  large: json['large'] as String? ?? '',
  medium: json['medium'] as String? ?? '',
  small: json['small'] as String? ?? '',
  portrait: json['portrait'] as String? ?? '',
  landscape: json['landscape'] as String? ?? '',
  tiny: json['tiny'] as String? ?? '',
);

Map<String, dynamic> _$PhotoSrcToJson(_PhotoSrc instance) => <String, dynamic>{
  'original': instance.original,
  'large2x': instance.large2x,
  'large': instance.large,
  'medium': instance.medium,
  'small': instance.small,
  'portrait': instance.portrait,
  'landscape': instance.landscape,
  'tiny': instance.tiny,
};
