// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwmCurrent _$OwmCurrentFromJson(Map<String, dynamic> json) => _OwmCurrent(
  weather: (json['weather'] as List<dynamic>)
      .map((e) => OwmCondition.fromJson(e as Map<String, dynamic>))
      .toList(),
  main: OwmMain.fromJson(json['main'] as Map<String, dynamic>),
  wind: OwmWind.fromJson(json['wind'] as Map<String, dynamic>),
  dt: (json['dt'] as num).toInt(),
  sys: OwmSys.fromJson(json['sys'] as Map<String, dynamic>),
  timezone: (json['timezone'] as num).toInt(),
  name: json['name'] as String? ?? '',
);

Map<String, dynamic> _$OwmCurrentToJson(_OwmCurrent instance) =>
    <String, dynamic>{
      'weather': instance.weather.map((e) => e.toJson()).toList(),
      'main': instance.main.toJson(),
      'wind': instance.wind.toJson(),
      'dt': instance.dt,
      'sys': instance.sys.toJson(),
      'timezone': instance.timezone,
      'name': instance.name,
    };

_OwmForecast _$OwmForecastFromJson(Map<String, dynamic> json) => _OwmForecast(
  list: (json['list'] as List<dynamic>)
      .map((e) => OwmForecastItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  city: OwmCity.fromJson(json['city'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwmForecastToJson(_OwmForecast instance) =>
    <String, dynamic>{
      'list': instance.list.map((e) => e.toJson()).toList(),
      'city': instance.city.toJson(),
    };

_OwmForecastItem _$OwmForecastItemFromJson(Map<String, dynamic> json) =>
    _OwmForecastItem(
      dt: (json['dt'] as num).toInt(),
      main: OwmMain.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => OwmCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      wind: OwmWind.fromJson(json['wind'] as Map<String, dynamic>),
      pop: (json['pop'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$OwmForecastItemToJson(_OwmForecastItem instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main.toJson(),
      'weather': instance.weather.map((e) => e.toJson()).toList(),
      'wind': instance.wind.toJson(),
      'pop': instance.pop,
    };

_OwmCondition _$OwmConditionFromJson(Map<String, dynamic> json) =>
    _OwmCondition(
      id: (json['id'] as num).toInt(),
      main: json['main'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$OwmConditionToJson(_OwmCondition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': instance.main,
      'description': instance.description,
      'icon': instance.icon,
    };

_OwmMain _$OwmMainFromJson(Map<String, dynamic> json) => _OwmMain(
  temp: (json['temp'] as num).toDouble(),
  feelsLike: (json['feels_like'] as num).toDouble(),
  tempMin: (json['temp_min'] as num).toDouble(),
  tempMax: (json['temp_max'] as num).toDouble(),
  pressure: (json['pressure'] as num).toInt(),
  humidity: (json['humidity'] as num).toInt(),
);

Map<String, dynamic> _$OwmMainToJson(_OwmMain instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.feelsLike,
  'temp_min': instance.tempMin,
  'temp_max': instance.tempMax,
  'pressure': instance.pressure,
  'humidity': instance.humidity,
};

_OwmWind _$OwmWindFromJson(Map<String, dynamic> json) => _OwmWind(
  speed: (json['speed'] as num).toDouble(),
  deg: (json['deg'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OwmWindToJson(_OwmWind instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
};

_OwmSys _$OwmSysFromJson(Map<String, dynamic> json) => _OwmSys(
  country: json['country'] as String?,
  sunrise: (json['sunrise'] as num?)?.toInt(),
  sunset: (json['sunset'] as num?)?.toInt(),
);

Map<String, dynamic> _$OwmSysToJson(_OwmSys instance) => <String, dynamic>{
  'country': instance.country,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};

_OwmCity _$OwmCityFromJson(Map<String, dynamic> json) => _OwmCity(
  name: json['name'] as String? ?? '',
  country: json['country'] as String?,
  timezone: (json['timezone'] as num).toInt(),
);

Map<String, dynamic> _$OwmCityToJson(_OwmCity instance) => <String, dynamic>{
  'name': instance.name,
  'country': instance.country,
  'timezone': instance.timezone,
};

_OwmGeoPlace _$OwmGeoPlaceFromJson(Map<String, dynamic> json) => _OwmGeoPlace(
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  country: json['country'] as String? ?? '',
  state: json['state'] as String?,
);

Map<String, dynamic> _$OwmGeoPlaceToJson(_OwmGeoPlace instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'country': instance.country,
      'state': instance.state,
    };
