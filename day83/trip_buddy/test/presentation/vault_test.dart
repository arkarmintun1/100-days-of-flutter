import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/document_file.dart';
import 'package:trip_buddy/domain/failures.dart';

import '../helpers/fake_document_reader.dart';
import '../helpers/test_app.dart';

void main() {
  final booking = DocumentFile(
    name: 'Hotel booking.pdf',
    mimeType: 'application/pdf',
    bytes: Uint8List(100),
  );

  testWidgets('a picked file is read, memorized and searchable', (
    tester,
  ) async {
    final reader = FakeDocumentReader();
    await tester.pumpWidget(testApp(reader: reader, pickedFile: booking));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a file'));
    await tester.pumpAndSettle();

    expect(reader.files.single.name, 'Hotel booking.pdf');
    expect(find.text('Hotel booking'), findsOneWidget);
    expect(find.text('Added "Hotel booking".'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'PRC-58213');
    await tester.tap(find.byTooltip('Ask'));
    await tester.pumpAndSettle();
    // In a result card (the search field has it too).
    expect(
      find.descendant(
        of: find.byType(Card),
        matching: find.textContaining('PRC-58213'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('cancelling the picker changes nothing', (tester) async {
    final reader = FakeDocumentReader();
    await tester.pumpWidget(testApp(reader: reader));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a file'));
    await tester.pumpAndSettle();

    expect(reader.files, isEmpty);
    expect(find.text('No documents yet.'), findsOneWidget);
  });

  testWidgets("a file Gemini can't read shows why", (tester) async {
    await tester.pumpWidget(
      testApp(
        reader: FakeDocumentReader(
          error: const ValidationFailure('No text found in this file.'),
        ),
        pickedFile: booking,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a file'));
    await tester.pumpAndSettle();

    expect(find.text('No text found in this file.'), findsOneWidget);
    expect(find.text('No documents yet.'), findsOneWidget);
  });

  testWidgets("a file that can't be opened shows why", (tester) async {
    await tester.pumpWidget(
      testApp(
        picker: () async =>
            throw const StorageFailure("Couldn't open the file."),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add a file'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open the file."), findsOneWidget);
    expect(find.text('No documents yet.'), findsOneWidget);
  });
}
