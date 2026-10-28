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

/// The SQLite database for Riverpod's offline persistence (Day 48).
/// Tests override it with Storage.inMemory().

@ProviderFor(storage)
final storageProvider = StorageProvider._();

/// The SQLite database for Riverpod's offline persistence (Day 48).
/// Tests override it with Storage.inMemory().

final class StorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<Storage<String, String>>,
          Storage<String, String>,
          FutureOr<Storage<String, String>>
        >
    with
        $FutureModifier<Storage<String, String>>,
        $FutureProvider<Storage<String, String>> {
  /// The SQLite database for Riverpod's offline persistence (Day 48).
  /// Tests override it with Storage.inMemory().
  StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<Storage<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Storage<String, String>> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'5f9927994a41bf4e5ec37861fe1437f24d0ff471';

/// Which place the weather is for: a city the user picked, or null for
/// "where I am". Saved on the device, so the app opens on the same place.

@ProviderFor(SelectedPlace)
final selectedPlaceProvider = SelectedPlaceProvider._();

/// Which place the weather is for: a city the user picked, or null for
/// "where I am". Saved on the device, so the app opens on the same place.
final class SelectedPlaceProvider
    extends $AsyncNotifierProvider<SelectedPlace, Place?> {
  /// Which place the weather is for: a city the user picked, or null for
  /// "where I am". Saved on the device, so the app opens on the same place.
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
}

String _$selectedPlaceHash() => r'4909c1ff8d8cfc10a31c855caf8e84f972baa1ed';

/// Which place the weather is for: a city the user picked, or null for
/// "where I am". Saved on the device, so the app opens on the same place.

abstract class _$SelectedPlace extends $AsyncNotifier<Place?> {
  FutureOr<Place?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Place?>, Place?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Place?>, Place?>,
              AsyncValue<Place?>,
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

/// The current time. Tests override it to get a fixed "now".

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current time. Tests override it to get a fixed "now".

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// The current time. Tests override it to get a fixed "now".
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';
