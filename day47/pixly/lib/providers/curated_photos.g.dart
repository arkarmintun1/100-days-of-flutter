// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curated_photos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The curated photos on Home, page by page.
///
/// keepAlive: the feed stays loaded while the app runs (Day 46).

@ProviderFor(CuratedPhotos)
final curatedPhotosProvider = CuratedPhotosProvider._();

/// The curated photos on Home, page by page.
///
/// keepAlive: the feed stays loaded while the app runs (Day 46).
final class CuratedPhotosProvider
    extends $AsyncNotifierProvider<CuratedPhotos, PhotoFeed> {
  /// The curated photos on Home, page by page.
  ///
  /// keepAlive: the feed stays loaded while the app runs (Day 46).
  CuratedPhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'curatedPhotosProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$curatedPhotosHash();

  @$internal
  @override
  CuratedPhotos create() => CuratedPhotos();
}

String _$curatedPhotosHash() => r'd13afee90cbcd73c5822c5e0ffb0cf8874251520';

/// The curated photos on Home, page by page.
///
/// keepAlive: the feed stays loaded while the app runs (Day 46).

abstract class _$CuratedPhotos extends $AsyncNotifier<PhotoFeed> {
  FutureOr<PhotoFeed> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PhotoFeed>, PhotoFeed>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PhotoFeed>, PhotoFeed>,
              AsyncValue<PhotoFeed>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
