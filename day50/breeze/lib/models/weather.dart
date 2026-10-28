import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

/// Everything Breeze shows for one place: the app's own model, built from
/// OpenWeatherMap's two responses by the repository.
@freezed
abstract class Weather with _$Weather {
  const factory Weather({
    required String place,
    String? country,

    /// The place's offset from UTC, e.g. 23400 (UTC+6:30) for Yangon.
    required int utcOffsetSeconds,
    required CurrentWeather current,

    /// The next 5 days in 3-hour steps.
    required List<HourlyForecast> hourly,

    /// When the app fetched this, to show how fresh it is.
    required DateTime fetchedAt,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@freezed
abstract class CurrentWeather with _$CurrentWeather {
  const factory CurrentWeather({
    /// When OpenWeatherMap calculated it (UTC).
    required DateTime time,
    required double temperature,
    required double feelsLike,
    required double tempMin,
    required double tempMax,
    required int humidity,
    required int pressure,
    required double windSpeed,
    required Condition condition,
    DateTime? sunrise,
    DateTime? sunset,
  }) = _CurrentWeather;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
}

@freezed
abstract class HourlyForecast with _$HourlyForecast {
  const factory HourlyForecast({
    /// The start of the 3-hour step (UTC).
    required DateTime time,
    required double temperature,
    required Condition condition,

    /// 0 to 1.
    required double precipitationChance,
  }) = _HourlyForecast;

  factory HourlyForecast.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastFromJson(json);
}

/// A weather condition, e.g. code 500, "Rain", "light rain", icon "10d".
@freezed
abstract class Condition with _$Condition {
  const Condition._();

  const factory Condition({
    required int code,
    required String main,
    required String description,
    required String icon,
  }) = _Condition;

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  /// OpenWeatherMap's icons end in "d" (day) or "n" (night).
  bool get isNight => icon.endsWith('n');

  /// The icon image from OpenWeatherMap, twice the base size.
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
