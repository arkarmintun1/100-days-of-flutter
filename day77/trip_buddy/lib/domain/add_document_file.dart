import 'document_file.dart';
import 'document_reader.dart';
import 'failures.dart';
import 'memorize_document.dart';

/// File → text → memory (Day 77): the vault's "Add a file".
/// Throws a Failure.
class AddDocumentFile {
  AddDocumentFile(this._reader, this._memorize);

  final DocumentReader _reader;
  final MemorizeDocument _memorize;

  /// Firebase AI Logic takes requests up to 20 MB, and a file sent
  /// inline grows by a third (base64). 14 MB leaves room for the rest.
  static const maxBytes = 14 * 1000 * 1000;

  Future<void> call(DocumentFile file) async {
    if (!DocumentFile.mimeTypes.containsValue(file.mimeType)) {
      throw const ValidationFailure('Choose a PDF, PNG, JPEG or WebP file.');
    }
    if (file.bytes.isEmpty) {
      throw const ValidationFailure('This file is empty.');
    }
    if (file.bytes.length > maxBytes) {
      throw const ValidationFailure('This file is too big (14 MB at most).');
    }
    final text = await _reader.read(file);
    // Day 76 does the rest: chunk, embed, store.
    await _memorize(title: file.title, text: text);
  }
}
