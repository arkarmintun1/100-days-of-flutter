import 'package:pixly/core/api/api_client.dart';
import 'package:pixly/core/api/api_exception.dart';
import 'package:pixly/core/result.dart';
import 'package:pixly/models/photo.dart';
import 'package:pixly/models/photos_page.dart';

/// Everything Pixly needs from Pexels, returned as [Result]s.
class PhotoRepository {
  PhotoRepository(this._client);

  final ApiClient _client;

  static const int perPage = 20;

  Future<Result<PhotosPage>> curated({int page = 1}) {
    return _fetch('/curated', {'page': page, 'per_page': perPage});
  }

  Future<Result<PhotosPage>> search(String query, {int page = 1}) {
    return _fetch('/search', {
      'query': query,
      'page': page,
      'per_page': perPage,
    });
  }

  /// A single photo, e.g. when the app is opened from a link to it.
  Future<Result<Photo>> photo(int id) async {
    try {
      final json = await _client.get('/photos/$id');
      return Success(Photo.fromJson(json));
    } on ApiException catch (e) {
      return Failure(e.message);
    } on TypeError {
      return const Failure('Unexpected response from the server.');
    }
  }

  Future<Result<PhotosPage>> _fetch(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final json = await _client.get(path, queryParameters: query);
      return Success(PhotosPage.fromJson(json));
    } on ApiException catch (e) {
      return Failure(e.message);
    } on TypeError {
      // The JSON didn't have the shape our models expect.
      return const Failure('Unexpected response from the server.');
    }
  }
}
