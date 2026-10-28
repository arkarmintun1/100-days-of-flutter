import 'package:breeze/core/app_exception.dart';
import 'package:breeze/core/updated_ago.dart';
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
import 'package:breeze/widgets/weather_error_view.dart';

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
          if (ref.watch(selectedPlaceProvider).value != null)
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
          AsyncError(:final error, isLoading: false) => WeatherErrorView(
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

class _WeatherView extends ConsumerWidget {
  const _WeatherView(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      // Below the app bar (the body's top padding, see SliverSafeArea).
      edgeOffset: MediaQuery.paddingOf(context).top,
      onRefresh: () => _refresh(ref),
      child: CustomScrollView(
        slivers: [
          // With extendBodyBehindAppBar, Scaffold makes the body's top
          // padding the app bar's height, so this starts below the app bar.
          SliverSafeArea(
            sliver: SliverList.list(
              children: [
                _Header(weather),
                if (weather.isStale) const _StaleNotice(),
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
      ),
    );
  }

  /// Pull to refresh: the indicator spins until this completes.
  static Future<void> _refresh(WidgetRef ref) async {
    try {
      await ref.read(weatherControllerProvider.notifier).refresh();
    } on Object {
      // Nothing to do: the screen shows the error (an AsyncError).
      // RefreshIndicator doesn't catch it: it would be reported as an
      // uncaught error.
    }
  }
}

/// Place, big temperature, condition, today's low and high, and how
/// fresh it is.
class _Header extends ConsumerWidget {
  const _Header(this.weather);

  final Weather weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = weather.current;
    final text = Theme.of(context).textTheme;
    final today = weather.today;
    final now = ref.watch(clockProvider)();
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
          const SizedBox(height: 4),
          Text(
            updatedAgo(weather.fetchedAt, now),
            style: text.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  static String _capitalized(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

/// Loading new weather failed: say so, and offer to try again.
class _StaleNotice extends ConsumerWidget {
  const _StaleNotice();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: Row(
        children: [
          const Icon(Icons.cloud_off),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Couldn't load new weather. "
              'Showing the last weather we had.',
            ),
          ),
          TextButton(
            onPressed: () =>
                ref.read(weatherControllerProvider.notifier).refresh().ignore(),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
