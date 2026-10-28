// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Place _$PlaceFromJson(Map<String, dynamic> json) => _Place(
  name: json['name'] as String,
  country: json['country'] as String,
  state: json['state'] as String?,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$PlaceToJson(_Place instance) => <String, dynamic>{
  'name': instance.name,
  'country': instance.country,
  'state': instance.state,
  'lat': instance.lat,
  'lon': instance.lon,
};
