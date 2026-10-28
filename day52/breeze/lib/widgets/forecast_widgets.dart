import 'package:breeze/models/daily_forecast.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/models/weather_kind.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The next 24 hours (8 steps of 3 hours), scrolling sideways.
class HourlyStrip extends StatelessWidget {
  const HourlyStrip({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final steps = weather.hourly.take(8).toList();
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        separatorBuilder: (_, _) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final step = steps[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat.Hm().format(weather.localTime(step.time))),
              Icon(step.condition.iconData, size: 28),
              Text(
                '${(step.precipitationChance * 100).round()}%',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${step.temperature.round()}°',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// One row per day: day name, icon, chance of rain, low and high.
class DailyList extends StatelessWidget {
  const DailyList({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final days = weather.daily;
    final today = weather.today?.date;
    return Column(
      children: [
        for (final day in days)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Text(
                    day.date == today
                        ? 'Today'
                        : DateFormat.E().format(day.date),
                  ),
                ),
                Icon(day.condition.iconData, size: 22),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(
                    day.precipitationChance >= 0.2
                        ? '${(day.precipitationChance * 100).round()}%'
                        : '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                const Spacer(),
                Text(
                  '${day.min.round()}°',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Text(
                  '${day.max.round()}°',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Feels like, humidity, wind, pressure, sunrise and sunset.
class WeatherDetails extends StatelessWidget {
  const WeatherDetails({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    String time(DateTime? utc) =>
        utc == null ? '–' : DateFormat.Hm().format(weather.localTime(utc));
    final items = [
      (Icons.thermostat, 'Feels like', '${current.feelsLike.round()}°'),
      (Icons.water_drop_outlined, 'Humidity', '${current.humidity}%'),
      (Icons.air, 'Wind', '${current.windSpeed.toStringAsFixed(1)} m/s'),
      (Icons.compress, 'Pressure', '${current.pressure} hPa'),
      (Icons.wb_twilight, 'Sunrise', time(current.sunrise)),
      (Icons.nights_stay, 'Sunset', time(current.sunset)),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.6,
      children: [
        for (final (icon, label, value) in items)
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.white70),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
