import 'package:freezed_annotation/freezed_annotation.dart';

part 'owm_models.freezed.dart';
part 'owm_models.g.dart';

// The parts of OpenWeatherMap's JSON that Breeze uses. Fields we don't
// need (base, cod, visibility, ...) are simply not declared and ignored.

/// GET /data/2.5/weather - the weather right now.
@freezed
abstract class OwmCurrent with _$OwmCurrent {
  const factory OwmCurrent({
    required List<OwmCondition> weather,
    required OwmMain main,
    required OwmWind wind,
    required int dt,
    required OwmSys sys,
    required int timezone,
    @Default('') String name,
  }) = _OwmCurrent;

  factory OwmCurrent.fromJson(Map<String, dynamic> json) =>
      _$OwmCurrentFromJson(json);
}

/// GET /data/2.5/forecast - 5 days in 3-hour steps.
@freezed
abstract class OwmForecast with _$OwmForecast {
  const factory OwmForecast({
    required List<OwmForecastItem> list,
    required OwmCity city,
  }) = _OwmForecast;

  factory OwmForecast.fromJson(Map<String, dynamic> json) =>
      _$OwmForecastFromJson(json);
}

/// One 3-hour step of the forecast.
@freezed
abstract class OwmForecastItem with _$OwmForecastItem {
  const factory OwmForecastItem({
    required int dt,
    required OwmMain main,
    required List<OwmCondition> weather,
    required OwmWind wind,

    /// Probability of precipitation, 0 to 1.
    @Default(0) double pop,
  }) = _OwmForecastItem;

  factory OwmForecastItem.fromJson(Map<String, dynamic> json) =>
      _$OwmForecastItemFromJson(json);
}

/// `weather[]`: the condition, e.g. 500 / Rain / light rain / 10d.
@freezed
abstract class OwmCondition with _$OwmCondition {
  const factory OwmCondition({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _OwmCondition;

  factory OwmCondition.fromJson(Map<String, dynamic> json) =>
      _$OwmConditionFromJson(json);
}

/// `main`: temperatures (°C with units=metric), pressure and humidity.
@freezed
abstract class OwmMain with _$OwmMain {
  const factory OwmMain({
    required double temp,
    required double feelsLike,
    required double tempMin,
    required double tempMax,
    required int pressure,
    required int humidity,
  }) = _OwmMain;

  factory OwmMain.fromJson(Map<String, dynamic> json) =>
      _$OwmMainFromJson(json);
}

/// `wind`: speed in m/s with units=metric, direction in degrees.
@freezed
abstract class OwmWind with _$OwmWind {
  const factory OwmWind({required double speed, @Default(0) int deg}) =
      _OwmWind;

  factory OwmWind.fromJson(Map<String, dynamic> json) =>
      _$OwmWindFromJson(json);
}

/// `sys` of the current weather: country and sun times (Unix, UTC).
@freezed
abstract class OwmSys with _$OwmSys {
  const factory OwmSys({String? country, int? sunrise, int? sunset}) = _OwmSys;

  factory OwmSys.fromJson(Map<String, dynamic> json) => _$OwmSysFromJson(json);
}

/// `city` of the forecast.
@freezed
abstract class OwmCity with _$OwmCity {
  const factory OwmCity({
    @Default('') String name,
    String? country,
    required int timezone,
  }) = _OwmCity;

  factory OwmCity.fromJson(Map<String, dynamic> json) =>
      _$OwmCityFromJson(json);
}

/// One result of GET /geo/1.0/direct (city search).
@freezed
abstract class OwmGeoPlace with _$OwmGeoPlace {
  const factory OwmGeoPlace({
    required String name,
    required double lat,
    required double lon,
    @Default('') String country,
    String? state,
  }) = _OwmGeoPlace;

  factory OwmGeoPlace.fromJson(Map<String, dynamic> json) =>
      _$OwmGeoPlaceFromJson(json);
}
