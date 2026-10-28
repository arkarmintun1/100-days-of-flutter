import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Serves `test/fixtures/images/ID.jpg` for any fixture photo URL
/// (`https://example.com/photos/ID/SIZE.jpg`) - no network, no database.
class FakeCacheManager implements BaseCacheManager {
  static const _fs = LocalFileSystem();

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = false,
  }) {
    final id = RegExp(r'/photos/(\d+)/').firstMatch(url)?.group(1);
    final file = _fs.file('test/fixtures/images/$id.jpg');
    if (id == null || !file.existsSync()) {
      return Stream.error(HttpExceptionWithStatus(404, 'No fixture for $url'));
    }
    return Stream.value(FileInfo(file, FileSource.Cache, DateTime(2100), url));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
