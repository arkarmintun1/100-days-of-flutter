import 'package:breeze/models/weather.dart';
import 'package:flutter/material.dart';

/// OpenWeatherMap's condition groups (by code), each with an icon and the
/// colours of the background.
enum WeatherKind {
  thunderstorm(Icons.thunderstorm, [Color(0xFF283048), Color(0xFF5B6478)]),
  drizzle(Icons.grain, [Color(0xFF4B6CB7), Color(0xFF89A4D6)]),
  rain(Icons.umbrella, [Color(0xFF34495E), Color(0xFF6C8EAD)]),
  snow(Icons.ac_unit, [Color(0xFF83A4D4), Color(0xFFD6E4F0)]),
  mist(Icons.foggy, [Color(0xFF757F9A), Color(0xFFB9C2D0)]),
  clear(Icons.wb_sunny, [Color(0xFF2F80ED), Color(0xFF56CCF2)]),
  clouds(Icons.cloud, [Color(0xFF5D7A99), Color(0xFF9EB3C9)]);

  const WeatherKind(this.icon, this.colors);

  final IconData icon;

  /// Top and bottom of the background gradient (day).
  final List<Color> colors;

  /// The group of an OpenWeatherMap condition code: 2xx thunderstorm,
  /// 3xx drizzle, 5xx rain, 6xx snow, 7xx mist/fog/haze..., 800 clear,
  /// 801-804 clouds.
  static WeatherKind fromCode(int code) => switch (code) {
    >= 200 && < 300 => thunderstorm,
    >= 300 && < 400 => drizzle,
    >= 500 && < 600 => rain,
    >= 600 && < 700 => snow,
    >= 700 && < 800 => mist,
    800 => clear,
    _ => clouds,
  };
}

extension ConditionKind on Condition {
  WeatherKind get kind => WeatherKind.fromCode(code);

  /// The icon, with a moon instead of a sun at night.
  IconData get iconData =>
      kind == WeatherKind.clear && isNight ? Icons.nightlight : kind.icon;

  /// The background: darker at night.
  List<Color> get backgroundColors => isNight
      ? [
          for (final color in kind.colors)
            Color.lerp(color, const Color(0xFF0B1026), 0.6)!,
        ]
      : kind.colors;
}
