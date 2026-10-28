import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixly/models/photo.dart';

part 'photos_page.freezed.dart';
part 'photos_page.g.dart';

/// One page of results from /curated or /search.
@freezed
abstract class PhotosPage with _$PhotosPage {
  const PhotosPage._();

  const factory PhotosPage({
    @Default(1) int page,
    // Pexels' default page size, used if the response leaves it out.
    @Default(15) int perPage,
    @Default([]) List<Photo> photos,
    int? totalResults,
    String? nextPage,
  }) = _PhotosPage;

  factory PhotosPage.fromJson(Map<String, dynamic> json) =>
      _$PhotosPageFromJson(json);

  /// Pexels only sends `next_page` when there is another page.
  bool get hasMore => nextPage != null;
}
