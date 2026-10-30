import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/document_reader.dart';

/// Reads every file as [text] (or throws [error]), for tests.
class FakeDocumentReader implements DocumentReader {
  FakeDocumentReader({this.text = bookingText, this.error});

  final String text;
  final Object? error;
  final files = <DocumentFile>[];

  @override
  Future<String> read(DocumentFile file) async {
    files.add(file);
    if (error case final error?) throw error;
    return text;
  }

  /// What Gemini might copy out of a hotel booking PDF.
  static const bookingText = '''
Booking confirmation
Hotel: Parkroyal Collection Pickering, 3 Upper Pickering Street, Singapore
Guest: Arkar Min Tun
Check-in: 13 Dec 2026 from 15:00
Check-out: 19 Dec 2026 by 12:00
Room: Deluxe King, breakfast included
Confirmation number: PRC-58213''';
}
