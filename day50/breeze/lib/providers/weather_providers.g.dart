// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openWeatherApi)
final openWeatherApiProvider = OpenWeatherApiProvider._();

final class OpenWeatherApiProvider
    extends $FunctionalProvider<OpenWeatherApi, OpenWeatherApi, OpenWeatherApi>
    with $Provider<OpenWeatherApi> {
  OpenWeatherApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openWeatherApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openWeatherApiHash();

  @$internal
  @override
  $ProviderElement<OpenWeatherApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenWeatherApi create(Ref ref) {
    return openWeatherApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenWeatherApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenWeatherApi>(value),
    );
  }
}

String _$openWeatherApiHash() => r'456b1dbee20ba1e1cb0342d547b8b609d39a9c06';

/// Tests replace this with a fake repository.

@ProviderFor(weatherRepository)
final weatherRepositoryProvider = WeatherRepositoryProvider._();

/// Tests replace this with a fake repository.

final class WeatherRepositoryProvider
    extends
        $FunctionalProvider<
          WeatherRepository,
          WeatherRepository,
          WeatherRepository
        >
    with $Provider<WeatherRepository> {
  /// Tests replace this with a fake repository.
  WeatherRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeatherRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRepository create(Ref ref) {
    return weatherRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRepository>(value),
    );
  }
}

String _$weatherRepositoryHash() => r'c7a31be1759b9ae92eb1b162df45ffae21e54f5d';

/// Tests replace this with a fake location.

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

/// Tests replace this with a fake location.

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  /// Tests replace this with a fake location.
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'f7fd0ffb4698d96772b6ac4b6d14a429632720b2';

/// Where the device is (asks for permission the first time).

@ProviderFor(currentPosition)
final currentPositionProvider = CurrentPositionProvider._();

/// Where the device is (asks for permission the first time).

final class CurrentPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Coordinates>,
          Coordinates,
          FutureOr<Coordinates>
        >
    with $FutureModifier<Coordinates>, $FutureProvider<Coordinates> {
  /// Where the device is (asks for permission the first time).
  CurrentPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPositionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPositionHash();

  @$internal
  @override
  $FutureProviderElement<Coordinates> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Coordinates> create(Ref ref) {
    return currentPosition(ref);
  }
}

String _$currentPositionHash() => r'abe99cc782b2767b1b893d6a9800d7a3f8014892';

/// The weather where the device is.

@ProviderFor(localWeather)
final localWeatherProvider = LocalWeatherProvider._();

/// The weather where the device is.

final class LocalWeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  /// The weather where the device is.
  LocalWeatherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localWeatherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localWeatherHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    return localWeather(ref);
  }
}

String _$localWeatherHash() => r'c03d7458807fdaea26f8cfe9d1d5d64cac4ed8fc';
