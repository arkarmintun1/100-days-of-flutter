import 'package:breeze/core/app_exception.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/providers/weather_controller.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:breeze/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A plain screen to check that location, API and repository work.
/// Day 52 replaces it with the real design.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breeze'),
        actions: [
          if (ref.watch(selectedPlaceProvider) != null)
            IconButton(
              tooltip: 'My location',
              icon: const Icon(Icons.my_location),
              onPressed: ref.read(selectedPlaceProvider.notifier).useMyLocation,
            ),
          IconButton(
            tooltip: 'Search for a city',
            icon: const Icon(Icons.search),
            onPressed: () => openSearch(context),
          ),
        ],
      ),
      body: switch (weather) {
        // Errors first: an AsyncError keeps the previous value, which
        // can be another place's weather (Day 51).
        AsyncError(:final error, isLoading: false) => _ErrorView(
          AppException.from(error),
        ),
        AsyncValue(value: final weather?, hasError: false) => _WeatherDetails(
          weather,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// The message, "Try again", and a way out for location problems.
class _ErrorView extends ConsumerWidget {
  const _ErrorView(this.error);

  final AppException error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.read(locationServiceProvider);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              // Runs build() again: asks for the position (and permission)
              // again too.
              onPressed: () => ref.invalidate(weatherControllerProvider),
              child: const Text('Try again'),
            ),
            if (error.kind == ErrorKind.locationOff)
              TextButton(
                onPressed: location.openLocationSettings,
                child: const Text('Open location settings'),
              ),
            if (error.kind == ErrorKind.locationDeniedForever)
              TextButton(
                onPressed: location.openAppSettings,
                child: const Text('Open app settings'),
              ),
            // Not sharing the location is fine: pick a city instead.
            if (error.kind.isLocationProblem)
              TextButton(
                onPressed: () => openSearch(context),
                child: const Text('Search for a city'),
              ),
          ],
        ),
      ),
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
