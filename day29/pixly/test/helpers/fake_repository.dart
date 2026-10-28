import 'dart:async';

import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/repositories/photo_repository.dart';

import 'fake_adapter.dart';

/// A PhotoRepository whose answers are decided by the test.
class FakePhotoRepository extends PhotoRepository {
  FakePhotoRepository({this.onCurated, this.onSearch})
    : super(ApiClient(apiKey: 'test-key'));

  Future<Result<PhotosPage>> Function(int page)? onCurated;
  Future<Result<PhotosPage>> Function(String query, int page)? onSearch;
  final List<int> curatedCalls = [];
  final List<(String, int)> searchCalls = [];

  @override
  Future<Result<PhotosPage>> curated({int page = 1}) {
    curatedCalls.add(page);
    return onCurated?.call(page) ?? Future.value(fixturePage('curated_page1'));
  }

  @override
  Future<Result<PhotosPage>> search(String query, {int page = 1}) {
    searchCalls.add((query, page));
    return onSearch?.call(query, page) ??
        Future.value(fixturePage('search_nature'));
  }

  static Result<PhotosPage> fixturePage(String name) =>
      Success(PhotosPage.fromJson(FakeAdapter.fixture(name)));

  /// A future that never completes - keeps the UI in its loading state.
  static Future<Result<PhotosPage>> never() =>
      Completer<Result<PhotosPage>>().future;
}
