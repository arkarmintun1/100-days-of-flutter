import 'dart:typed_data';

/// A file the user picked for the vault (Day 77): its name, its type and
/// its bytes, read once.
class DocumentFile {
  const DocumentFile({
    required this.name,
    required this.mimeType,
    required this.bytes,
  });

  final String name;
  final String mimeType;
  final Uint8List bytes;

  /// The name without its extension: "Hotel booking.pdf" → "Hotel booking".
  String get title {
    final dot = name.lastIndexOf('.');
    return (dot > 0 ? name.substring(0, dot) : name).trim();
  }

  /// The types Gemini can read, by file extension. Firebase AI Logic
  /// takes PDFs and these image types inline.
  static const mimeTypes = {
    'pdf': 'application/pdf',
    'png': 'image/png',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'webp': 'image/webp',
  };
}
