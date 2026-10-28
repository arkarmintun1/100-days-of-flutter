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

@ProviderFor(yangonWeather)
final yangonWeatherProvider = YangonWeatherProvider._();

final class YangonWeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  YangonWeatherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yangonWeatherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yangonWeatherHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    return yangonWeather(ref);
  }
}

String _$yangonWeatherHash() => r'a03e1151823018bcfbbc9e45b14bb0f07bf6c10f';
