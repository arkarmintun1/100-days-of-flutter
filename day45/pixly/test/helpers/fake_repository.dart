import 'package:dio/dio.dart' show CancelToken;
import 'dart:async';

import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photos_page.dart';
import 'package:pixly/repositories/photo_repository.dart';

import 'fake_adapter.dart';

/// A PhotoRepository whose answers are decided by the test.
class FakePhotoRepository extends PhotoRepository {
  FakePhotoRepository({this.onCurated, this.onSearch, this.onPhoto})
    : super(ApiClient(apiKey: 'test-key'));

  Future<Result<PhotosPage>> Function(int page)? onCurated;
  Future<Result<PhotosPage>> Function(String query, int page)? onSearch;
  Future<Result<Photo>> Function(int id)? onPhoto;
  final List<int> curatedCalls = [];
  final List<int> photoCalls = [];
  final List<(String, int)> searchCalls = [];

  @override
  Future<Result<PhotosPage>> curated({int page = 1}) {
    curatedCalls.add(page);
    return onCurated?.call(page) ?? Future.value(defaultCurated(page));
  }

  /// The CancelToken of every search request, in order.
  final List<CancelToken?> searchTokens = [];

  @override
  Future<Result<PhotosPage>> search(
    String query, {
    int page = 1,
    CancelToken? cancelToken,
  }) {
    searchCalls.add((query, page));
    searchTokens.add(cancelToken);
    return onSearch?.call(query, page) ??
        Future.value(fixturePage('search_nature'));
  }

  @override
  Future<Result<Photo>> photo(int id) {
    photoCalls.add(id);
    return onPhoto?.call(id) ??
        Future.value(
          Success(
            PhotosPage.fromJson(
              FakeAdapter.fixture('curated_page1'),
            ).photos.firstWhere((p) => p.id == id),
          ),
        );
  }

  /// Like the real API: page 1, page 2, then an empty last page.
  static Result<PhotosPage> defaultCurated(int page) => switch (page) {
    1 => fixturePage('curated_page1'),
    2 => fixturePage('curated_page2'),
    _ => Success(PhotosPage(page: page, perPage: 12, photos: const [])),
  };

  static Result<PhotosPage> fixturePage(String name) =>
      Success(PhotosPage.fromJson(FakeAdapter.fixture(name)));

  /// A future that never completes - keeps the UI in its loading state.
  static Future<Result<PhotosPage>> never() =>
      Completer<Result<PhotosPage>>().future;
}
