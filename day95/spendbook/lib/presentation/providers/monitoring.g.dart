// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Day 95: Crashlytics when Firebase is set up; otherwise the debug log.

@ProviderFor(errorReporter)
final errorReporterProvider = ErrorReporterProvider._();

/// Day 95: Crashlytics when Firebase is set up; otherwise the debug log.

final class ErrorReporterProvider
    extends $FunctionalProvider<ErrorReporter, ErrorReporter, ErrorReporter>
    with $Provider<ErrorReporter> {
  /// Day 95: Crashlytics when Firebase is set up; otherwise the debug log.
  ErrorReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorReporterHash();

  @$internal
  @override
  $ProviderElement<ErrorReporter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ErrorReporter create(Ref ref) {
    return errorReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ErrorReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ErrorReporter>(value),
    );
  }
}

String _$errorReporterHash() => r'0997797e5a46c86f90a3db7d70cd1778119a837f';

/// Day 95: Google Analytics when Firebase is set up; otherwise nothing.

@ProviderFor(analytics)
final analyticsProvider = AnalyticsProvider._();

/// Day 95: Google Analytics when Firebase is set up; otherwise nothing.

final class AnalyticsProvider
    extends $FunctionalProvider<Analytics, Analytics, Analytics>
    with $Provider<Analytics> {
  /// Day 95: Google Analytics when Firebase is set up; otherwise nothing.
  AnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $ProviderElement<Analytics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Analytics create(Ref ref) {
    return analytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Analytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Analytics>(value),
    );
  }
}

String _$analyticsHash() => r'21339550853890c336ef5277fb9762d09a185a9b';
