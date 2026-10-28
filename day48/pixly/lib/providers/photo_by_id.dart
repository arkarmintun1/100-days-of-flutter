import 'package:pixly/core/app_exception.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/providers/cache_for.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_by_id.g.dart';

/// One photo from Pexels, for links to photos that are not loaded yet.
///
/// A family (one provider per id) and autoDispose, like every generated
/// provider without keepAlive. A photo that loaded is cached for
/// [cacheDuration]; a failed one is disposed as soon as nobody shows it.
@riverpod
Future<Photo> photoById(Ref ref, int id) async {
  final result = await ref.watch(photoRepositoryProvider).photo(id);
  switch (result) {
    case Success(:final data):
      // The provider may have been disposed or rebuilt while we waited.
      if (ref.mounted) ref.cacheFor(cacheDuration);
      return data;
    case Failure():
      throw result.exception;
  }
}
