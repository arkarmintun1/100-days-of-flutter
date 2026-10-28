import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixly/models/photo_src.dart';

part 'photo.freezed.dart';
part 'photo.g.dart';

@freezed
abstract class Photo with _$Photo {
  // Lets us add our own getters and methods (see aspectRatio).
  const Photo._();

  const factory Photo({
    required int id,
    @Default(0) int width,
    @Default(0) int height,
    @Default('') String url,
    @Default('Unknown') String photographer,
    @Default('') String photographerUrl,
    @Default('#9E9E9E') String avgColor,
    @Default('') String alt,
    required PhotoSrc src,
  }) = _Photo;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  /// width ÷ height of the original photo, handy for layouts.
  double get aspectRatio => height == 0 ? 1 : width / height;
}
