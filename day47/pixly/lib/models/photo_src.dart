import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_src.freezed.dart';
part 'photo_src.g.dart';

/// The different image sizes Pexels gives us for one photo.
@freezed
abstract class PhotoSrc with _$PhotoSrc {
  const factory PhotoSrc({
    @Default('') String original,
    @Default('') String large2x,
    @Default('') String large,
    @Default('') String medium,
    @Default('') String small,
    @Default('') String portrait,
    @Default('') String landscape,
    @Default('') String tiny,
  }) = _PhotoSrc;

  factory PhotoSrc.fromJson(Map<String, dynamic> json) =>
      _$PhotoSrcFromJson(json);
}
