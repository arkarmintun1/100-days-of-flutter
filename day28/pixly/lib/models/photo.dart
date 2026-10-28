import 'package:pixly/models/photo_src.dart';

class Photo {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final String avgColor;
  final String alt;
  final PhotoSrc src;

  const Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.avgColor,
    required this.alt,
    required this.src,
  });

  /// width ÷ height of the original photo, handy for layouts.
  double get aspectRatio => height == 0 ? 1 : width / height;

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      photographer: json['photographer'] as String? ?? 'Unknown',
      photographerUrl: json['photographer_url'] as String? ?? '',
      avgColor: json['avg_color'] as String? ?? '#9E9E9E',
      alt: json['alt'] as String? ?? '',
      src: PhotoSrc.fromJson(json['src'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'width': width,
    'height': height,
    'url': url,
    'photographer': photographer,
    'photographer_url': photographerUrl,
    'avg_color': avgColor,
    'alt': alt,
    'src': src.toJson(),
  };
}
