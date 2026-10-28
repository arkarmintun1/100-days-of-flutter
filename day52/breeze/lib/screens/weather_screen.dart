import 'package:breeze/core/app_exception.dart';
import 'package:breeze/models/daily_forecast.dart';
import 'package:breeze/models/weather.dart';
import 'package:breeze/models/weather_kind.dart';
import 'package:breeze/providers/weather_controller.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:breeze/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breeze/widgets/forecast_widgets.dart';
import 'package:breeze/widgets/glass_card.dart';
import 'package:breeze/widgets/weather_background.dart';

/// Breeze's main screen: the weather on a background that matches it.
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  /// Shown while nothing is loaded yet, or after an error.
  static const _defaultColors = [Color(0xFF3A4A6B), Color(0xFF7B8CA8)];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherControllerProvider);
    return Scaffold(
      // The gradient goes behind the (transparent) app bar too.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: WeatherBackground(
        colors: switch (weather) {
          AsyncValue(value: final weather?, hasError: false) =>
            weather.current.condition.backgroundColors,
          _ => _defaultColors,
        },
        child: switch (weather) {
          // Errors first: an AsyncError keeps the previous value, which
          // can be another place's weather (Day 51).
          AsyncError(:final error, isLoading: false) => _ErrorView(
            AppException.from(error),
          ),
          AsyncValue(value: final weather?, hasError: false) => _WeatherView(
            weather,
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // With extendBodyBehindAppBar, Scaffold makes the body's top
        // padding the app bar's height, so this starts below the app bar.
        SliverSafeArea(
          sliver: SliverList.list(
            children: [
              _Header(weather),
              GlassCard(
                title: 'Next 24 hours',
                child: HourlyStrip(weather: weather),
              ),
              GlassCard(
                title: '5-day forecast',
                child: DailyList(weather: weather),
              ),
              GlassCard(child: WeatherDetails(weather: weather)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Place, big temperature, condition, today's low and high.
class _Header extends StatelessWidget {
  const _Header(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.current;
    final text = Theme.of(context).textTheme;
    final today = weather.today;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        children: [
          Text(
            [weather.place, ?weather.country].join(', '),
            style: text.headlineSmall,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(current.condition.iconData, size: 56),
              const SizedBox(width: 12),
              Text(
                '${current.temperature.round()}°',
                style: text.displayLarge?.copyWith(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Text(
            _capitalized(current.condition.description),
            style: text.titleMedium,
          ),
          if (today != null)
            Text(
              'H ${today.max.round()}°  L ${today.min.round()}°',
              style: text.bodyMedium?.copyWith(color: Colors.white70),
            ),
        ],
      ),
    );
  }

  static String _capitalized(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
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
