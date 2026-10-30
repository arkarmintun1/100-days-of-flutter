import 'document_file.dart';

/// Turns a PDF or a photo into plain text (Day 77). Throws a Failure.
abstract interface class DocumentReader {
  Future<String> read(DocumentFile file);
}
