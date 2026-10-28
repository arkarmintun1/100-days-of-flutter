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

/// Which place the weather is for: a city the user picked, or null for
/// "where I am".

@ProviderFor(SelectedPlace)
final selectedPlaceProvider = SelectedPlaceProvider._();

/// Which place the weather is for: a city the user picked, or null for
/// "where I am".
final class SelectedPlaceProvider
    extends $NotifierProvider<SelectedPlace, Place?> {
  /// Which place the weather is for: a city the user picked, or null for
  /// "where I am".
  SelectedPlaceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPlaceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPlaceHash();

  @$internal
  @override
  SelectedPlace create() => SelectedPlace();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Place? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Place?>(value),
    );
  }
}

String _$selectedPlaceHash() => r'fecdc5936ec7146c2f357a384d091d7eddaecd44';

/// Which place the weather is for: a city the user picked, or null for
/// "where I am".

abstract class _$SelectedPlace extends $Notifier<Place?> {
  Place? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Place?, Place?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Place?, Place?>,
              Place?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Cities matching [query], for the search screen.

@ProviderFor(placeSearch)
final placeSearchProvider = PlaceSearchFamily._();

/// Cities matching [query], for the search screen.

final class PlaceSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Place>>,
          List<Place>,
          FutureOr<List<Place>>
        >
    with $FutureModifier<List<Place>>, $FutureProvider<List<Place>> {
  /// Cities matching [query], for the search screen.
  PlaceSearchProvider._({
    required PlaceSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'placeSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$placeSearchHash();

  @override
  String toString() {
    return r'placeSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Place>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Place>> create(Ref ref) {
    final argument = this.argument as String;
    return placeSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$placeSearchHash() => r'2cb192fa70968b3a38070d90a25b5fd59aa2a6c1';

/// Cities matching [query], for the search screen.

final class PlaceSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Place>>, String> {
  PlaceSearchFamily._()
    : super(
        retry: null,
        name: r'placeSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Cities matching [query], for the search screen.

  PlaceSearchProvider call(String query) =>
      PlaceSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'placeSearchProvider';
}
