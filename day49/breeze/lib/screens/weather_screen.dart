import 'package:breeze/core/app_exception.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Day 49: a plain screen to check that the API, models and repository
/// work. Day 52 replaces it with the real design.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(yangonWeatherProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Breeze')),
      body: switch (weather) {
        AsyncValue(value: final weather?) => _WeatherDetails(weather),
        AsyncError(:final error, isLoading: false) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppException.from(error).message),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(yangonWeatherProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '${weather.place}, ${weather.country ?? ''}',
          style: text.titleLarge,
        ),
        Text('${current.temperature.round()}°C', style: text.displayLarge),
        Text(current.condition.description),
        Text('Feels like ${current.feelsLike.round()}°C'),
        Text('Humidity ${current.humidity}%'),
        Text('Wind ${current.windSpeed} m/s'),
        const Divider(height: 32),
        Text('Next 24 hours', style: text.titleMedium),
        for (final hour in weather.hourly.take(8))
          ListTile(
            dense: true,
            // The time at the place, not on this phone (Day 52 explains).
            title: Text(_localTime(hour.time)),
            subtitle: Text(hour.condition.description),
            trailing: Text(
              '${hour.temperature.round()}°C  '
              '${(hour.precipitationChance * 100).round()}%',
            ),
          ),
      ],
    );
  }

  /// HH:mm at the place. Yangon is UTC+6:30, so the minutes matter.
  String _localTime(DateTime utc) {
    final local = utc.add(Duration(seconds: weather.utcOffsetSeconds));
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)}';
  }
}
