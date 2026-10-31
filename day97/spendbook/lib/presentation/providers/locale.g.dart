// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localeStore)
final localeStoreProvider = LocaleStoreProvider._();

final class LocaleStoreProvider
    extends $FunctionalProvider<LocaleStore, LocaleStore, LocaleStore>
    with $Provider<LocaleStore> {
  LocaleStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeStoreHash();

  @$internal
  @override
  $ProviderElement<LocaleStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocaleStore create(Ref ref) {
    return localeStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocaleStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocaleStore>(value),
    );
  }
}

String _$localeStoreHash() => r'9ec9e95cfbc834528050c59986f01e578de525df';

/// The language the user picked, or null for the phone's language.

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The language the user picked, or null for the phone's language.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale?> {
  /// The language the user picked, or null for the phone's language.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLocaleHash() => r'8f8457d0f1a3e081737ff8a71a07956394a81d37';

/// The language the user picked, or null for the phone's language.

abstract class _$AppLocale extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
