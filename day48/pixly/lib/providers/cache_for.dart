import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/// How long Pixly keeps a loaded photo or search result, counted from when
/// it loaded.
const cacheDuration = Duration(minutes: 5);

extension CacheForExtension on Ref {
  /// Keeps an autoDispose provider's state for [duration] from now, even
  /// when nothing listens to it. After that it is disposed as usual once it
  /// has no listeners.
  void cacheFor(Duration duration) {
    // Stops autoDispose until link.close() is called.
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    // A rebuild (invalidate, refresh) starts over: drop the old timer.
    onDispose(timer.cancel);
  }
}
