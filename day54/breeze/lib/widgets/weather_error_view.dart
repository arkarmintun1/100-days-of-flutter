import 'package:breeze/core/app_exception.dart';
import 'package:breeze/providers/weather_controller.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:breeze/screens/search_screen.dart';
import 'package:breeze/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// An icon and a short title for each kind of error.
extension ErrorKindLook on ErrorKind {
  IconData get icon => switch (this) {
    .network => Icons.wifi_off,
    .unauthorized => Icons.key_off,
    .notFound => Icons.wrong_location,
    .rateLimited => Icons.hourglass_top,
    .server => Icons.cloud_off,
    .locationOff => Icons.location_disabled,
    .locationDenied || .locationDeniedForever => Icons.location_off,
    .locationUnavailable => Icons.gps_off,
    .unknown => Icons.error_outline,
  };

  String get title => switch (this) {
    .network => 'No connection',
    .unauthorized => 'API key problem',
    .notFound => 'No weather here',
    .rateLimited => 'Too many requests',
    .server => 'Weather service problem',
    .locationOff => 'Location is off',
    .locationDenied => 'Location not allowed',
    .locationDeniedForever => 'Location is blocked',
    .locationUnavailable => "Can't find you",
    .unknown => 'Something went wrong',
  };
}

/// What went wrong, and what the user can do about it.
class WeatherErrorView extends ConsumerWidget {
  const WeatherErrorView(this.error, {super.key});

  final AppException error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.read(locationServiceProvider);
    final text = Theme.of(context).textTheme;
    final kind = error.kind;
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: GlassCard(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Icon(kind.icon, size: 56),
                  const SizedBox(height: 16),
                  Text(kind.title, style: text.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    error.message,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                  if (kind == .unauthorized) ...[
                    const SizedBox(height: 8),
                    Text(
                      'A new OpenWeatherMap key can take up to 2 hours '
                      'to start working.',
                      textAlign: TextAlign.center,
                      style: text.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    // Runs build() again: asks for the position (and
                    // permission) again too.
                    onPressed: () => ref.invalidate(weatherControllerProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                  if (kind == .locationOff)
                    TextButton(
                      onPressed: location.openLocationSettings,
                      child: const Text('Open location settings'),
                    ),
                  if (kind == .locationDeniedForever)
                    TextButton(
                      onPressed: location.openAppSettings,
                      child: const Text('Open app settings'),
                    ),
                  // Not sharing the location is fine: pick a city instead.
                  if (kind.isLocationProblem)
                    TextButton(
                      onPressed: () => openSearch(context),
                      child: const Text('Search for a city'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
