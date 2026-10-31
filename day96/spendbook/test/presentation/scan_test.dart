import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/receipt_text_reader.dart';

import '../helpers/receipts.dart';
import '../helpers/fake_expense_repository.dart';
import '../helpers/test_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextFormField, label);

  Future<void> scan(WidgetTester tester, FakeReader reader) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        receiptReader: reader,
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();
  }

  testWidgets('a scanned receipt fills the amount and the title', (
    tester,
  ) async {
    await scan(tester, FakeReader(right(cafe)));

    expect(
      tester.widget<TextFormField>(field('Amount')).controller!.text,
      '10.25',
    );
    expect(
      tester.widget<TextFormField>(field('Title')).controller!.text,
      'Kopi Corner',
    );
    expect(find.text('Check the amount and the currency.'), findsOneWidget);
  });

  testWidgets('a photo that cannot be read shows why', (tester) async {
    await scan(
      tester,
      FakeReader(left(const ValidationFailure("Couldn't read this photo."))),
    );

    expect(find.text("Couldn't read this photo."), findsOneWidget);
  });

  testWidgets('no camera access: an error instead of a crash', (tester) async {
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        takePhoto: () async =>
            throw PlatformException(code: 'camera_access_denied'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't open the camera."), findsOneWidget);
    // Not stuck: the button works again.
    final button = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.document_scanner_outlined),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets("Save waits while a receipt is being read", (tester) async {
    final reader = _SlowReader();
    await tester.pumpWidget(
      testApp(
        FakeExpenseRepository(),
        receiptReader: reader,
        receiptPhoto: '/tmp/receipt.jpg',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add expense'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Scan receipt'));
    await tester.pump();

    FilledButton save() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
    expect(save().onPressed, isNull);

    reader.done.complete(right(cafe));
    await tester.pumpAndSettle();
    expect(save().onPressed, isNotNull);
  });
}

/// A reader that answers only when the test says so.
class _SlowReader implements ReceiptTextReader {
  final done = Completer<Either<Failure, List<String>>>();

  @override
  Future<Either<Failure, List<String>>> readLines(String imagePath) =>
      done.future;
}
