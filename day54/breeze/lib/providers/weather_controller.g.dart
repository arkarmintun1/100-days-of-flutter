// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The weather Breeze shows: for the picked city, or where the device is.
///
/// keepAlive: there's only one, and it should survive the search screen.

@ProviderFor(WeatherController)
final weatherControllerProvider = WeatherControllerProvider._();

/// The weather Breeze shows: for the picked city, or where the device is.
///
/// keepAlive: there's only one, and it should survive the search screen.
final class WeatherControllerProvider
    extends $AsyncNotifierProvider<WeatherController, Weather> {
  /// The weather Breeze shows: for the picked city, or where the device is.
  ///
  /// keepAlive: there's only one, and it should survive the search screen.
  WeatherControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherControllerHash();

  @$internal
  @override
  WeatherController create() => WeatherController();
}

String _$weatherControllerHash() => r'4b4dc285dddcfa4fca2efb329e979cc11ad77f6d';

/// The weather Breeze shows: for the picked city, or where the device is.
///
/// keepAlive: there's only one, and it should survive the search screen.

abstract class _$WeatherController extends $AsyncNotifier<Weather> {
  FutureOr<Weather> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Weather>, Weather>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Weather>, Weather>,
              AsyncValue<Weather>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
