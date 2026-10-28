// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Weather _$WeatherFromJson(Map<String, dynamic> json) => _Weather(
  place: json['place'] as String,
  country: json['country'] as String?,
  utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
  current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
  hourly: (json['hourly'] as List<dynamic>)
      .map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>))
      .toList(),
  fetchedAt: DateTime.parse(json['fetched_at'] as String),
  isStale: json['is_stale'] as bool? ?? false,
);

Map<String, dynamic> _$WeatherToJson(_Weather instance) => <String, dynamic>{
  'place': instance.place,
  'country': instance.country,
  'utc_offset_seconds': instance.utcOffsetSeconds,
  'current': instance.current.toJson(),
  'hourly': instance.hourly.map((e) => e.toJson()).toList(),
  'fetched_at': instance.fetchedAt.toIso8601String(),
  'is_stale': instance.isStale,
};

_CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    _CurrentWeather(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      tempMin: (json['temp_min'] as num).toDouble(),
      tempMax: (json['temp_max'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      pressure: (json['pressure'] as num).toInt(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      sunrise: json['sunrise'] == null
          ? null
          : DateTime.parse(json['sunrise'] as String),
      sunset: json['sunset'] == null
          ? null
          : DateTime.parse(json['sunset'] as String),
    );

Map<String, dynamic> _$CurrentWeatherToJson(_CurrentWeather instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'feels_like': instance.feelsLike,
      'temp_min': instance.tempMin,
      'temp_max': instance.tempMax,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'wind_speed': instance.windSpeed,
      'condition': instance.condition.toJson(),
      'sunrise': instance.sunrise?.toIso8601String(),
      'sunset': instance.sunset?.toIso8601String(),
    };

_HourlyForecast _$HourlyForecastFromJson(Map<String, dynamic> json) =>
    _HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
      precipitationChance: (json['precipitation_chance'] as num).toDouble(),
    );

Map<String, dynamic> _$HourlyForecastToJson(_HourlyForecast instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperature': instance.temperature,
      'condition': instance.condition.toJson(),
      'precipitation_chance': instance.precipitationChance,
    };

_Condition _$ConditionFromJson(Map<String, dynamic> json) => _Condition(
  code: (json['code'] as num).toInt(),
  main: json['main'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$ConditionToJson(_Condition instance) =>
    <String, dynamic>{
      'code': instance.code,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };
