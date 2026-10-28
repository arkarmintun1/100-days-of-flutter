// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_by_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One photo from Pexels, for links to photos that are not loaded yet.
///
/// A family (one provider per id) and autoDispose, like every generated
/// provider without keepAlive. A photo that loaded is cached for
/// [cacheDuration]; a failed one is disposed as soon as nobody shows it.

@ProviderFor(photoById)
final photoByIdProvider = PhotoByIdFamily._();

/// One photo from Pexels, for links to photos that are not loaded yet.
///
/// A family (one provider per id) and autoDispose, like every generated
/// provider without keepAlive. A photo that loaded is cached for
/// [cacheDuration]; a failed one is disposed as soon as nobody shows it.

final class PhotoByIdProvider
    extends $FunctionalProvider<AsyncValue<Photo>, Photo, FutureOr<Photo>>
    with $FutureModifier<Photo>, $FutureProvider<Photo> {
  /// One photo from Pexels, for links to photos that are not loaded yet.
  ///
  /// A family (one provider per id) and autoDispose, like every generated
  /// provider without keepAlive. A photo that loaded is cached for
  /// [cacheDuration]; a failed one is disposed as soon as nobody shows it.
  PhotoByIdProvider._({
    required PhotoByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: noRetry,
         name: r'photoByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$photoByIdHash();

  @override
  String toString() {
    return r'photoByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Photo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Photo> create(Ref ref) {
    final argument = this.argument as int;
    return photoById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$photoByIdHash() => r'4eb7e0b0cf79655d2e4e8b4a29d149c7b97a94cf';

/// One photo from Pexels, for links to photos that are not loaded yet.
///
/// A family (one provider per id) and autoDispose, like every generated
/// provider without keepAlive. A photo that loaded is cached for
/// [cacheDuration]; a failed one is disposed as soon as nobody shows it.

final class PhotoByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Photo>, int> {
  PhotoByIdFamily._()
    : super(
        retry: noRetry,
        name: r'photoByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One photo from Pexels, for links to photos that are not loaded yet.
  ///
  /// A family (one provider per id) and autoDispose, like every generated
  /// provider without keepAlive. A photo that loaded is cached for
  /// [cacheDuration]; a failed one is disposed as soon as nobody shows it.

  PhotoByIdProvider call(int id) =>
      PhotoByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'photoByIdProvider';
}
