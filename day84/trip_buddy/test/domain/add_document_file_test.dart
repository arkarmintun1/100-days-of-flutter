import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/add_document_file.dart';
import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/memorize_document.dart';

import '../helpers/fake_document_reader.dart';
import '../helpers/fake_embedder.dart';
import '../helpers/fake_trip_memory.dart';

void main() {
  late FakeTripMemory memory;
  late FakeDocumentReader reader;
  late AddDocumentFile addFile;

  void setUpWith(FakeDocumentReader documentReader) {
    memory = FakeTripMemory();
    reader = documentReader;
    addFile = AddDocumentFile(
      reader,
      MemorizeDocument(
        memory,
        FakeEmbedder(),
        now: () => DateTime(2026, 10, 30),
      ),
    );
  }

  setUp(() => setUpWith(FakeDocumentReader()));

  DocumentFile file(String name, String mimeType, [int size = 100]) =>
      DocumentFile(name: name, mimeType: mimeType, bytes: Uint8List(size));

  test('a PDF is read and memorized under its file name', () async {
    await addFile(file('Hotel booking.pdf', 'application/pdf'));

    expect(reader.files.single.mimeType, 'application/pdf');
    final document = (await memory.watchDocuments().first).single;
    expect(document.title, 'Hotel booking');
    expect(
      (await memory.allChunks()).map((c) => c.text).join(' '),
      contains('PRC-58213'),
    );
  });

  test('only types Gemini reads are sent', () async {
    await expectLater(
      addFile(file('Notes.docx', 'unknown')),
      throwsA(isA<ValidationFailure>()),
    );
    expect(reader.files, isEmpty);
  });

  test('empty and too big files are not sent', () async {
    await expectLater(
      addFile(file('Empty.png', 'image/png', 0)),
      throwsA(isA<ValidationFailure>()),
    );
    await expectLater(
      addFile(
        file('Huge.pdf', 'application/pdf', AddDocumentFile.maxBytes + 1),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(reader.files, isEmpty);
  });

  test("a file Gemini can't read is not memorized", () async {
    setUpWith(
      FakeDocumentReader(error: const NetworkFailure("Couldn't reach the AI.")),
    );

    await expectLater(
      addFile(file('Ticket.jpg', 'image/jpeg')),
      throwsA(isA<NetworkFailure>()),
    );
    expect(await memory.watchDocuments().first, isEmpty);
  });

  test('the title is the name without its extension', () {
    expect(file('Flight.SQ321.pdf', 'application/pdf').title, 'Flight.SQ321');
    expect(file('README', 'unknown').title, 'README');
  });
}
