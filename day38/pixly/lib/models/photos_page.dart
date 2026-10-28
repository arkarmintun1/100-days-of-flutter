import 'package:pixly/models/photo.dart';

/// One page of results from /curated or /search.
class PhotosPage {
  final int page;
  final int perPage;
  final List<Photo> photos;
  final int? totalResults;
  final String? nextPage;

  const PhotosPage({
    required this.page,
    required this.perPage,
    required this.photos,
    this.totalResults,
    this.nextPage,
  });

  /// Pexels only sends `next_page` when there is another page.
  bool get hasMore => nextPage != null;

  factory PhotosPage.fromJson(Map<String, dynamic> json) {
    final photos = (json['photos'] as List<dynamic>? ?? [])
        .map((item) => Photo.fromJson(item as Map<String, dynamic>))
        .toList();

    return PhotosPage(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? photos.length,
      photos: photos,
      totalResults: json['total_results'] as int?,
      nextPage: json['next_page'] as String?,
    );
  }
}
