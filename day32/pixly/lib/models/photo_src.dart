/// The different image sizes Pexels gives us for one photo.
class PhotoSrc {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  const PhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  factory PhotoSrc.fromJson(Map<String, dynamic> json) {
    return PhotoSrc(
      original: json['original'] as String? ?? '',
      large2x: json['large2x'] as String? ?? '',
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      small: json['small'] as String? ?? '',
      portrait: json['portrait'] as String? ?? '',
      landscape: json['landscape'] as String? ?? '',
      tiny: json['tiny'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'original': original,
    'large2x': large2x,
    'large': large,
    'medium': medium,
    'small': small,
    'portrait': portrait,
    'landscape': landscape,
    'tiny': tiny,
  };
}
