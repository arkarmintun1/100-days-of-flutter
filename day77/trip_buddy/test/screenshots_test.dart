// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/document_file.dart';

import 'helpers/screenshot_helper.dart';
import 'helpers/test_app.dart';

/// Screenshots for the blog posts (written to test/screenshots/).
void main() {
  setUpAll(loadRealFonts);

  testWidgets(
    'day76_documents',
    (t) => screenshot(
      t,
      'day76_documents',
      testApp(),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day76_search',
    (t) => screenshot(
      t,
      'day76_search',
      testApp(),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
        await t.enterText(find.byType(TextField), 'When does SQ321 land?');
        await t.tap(find.byTooltip('Search'));
        await t.pump();
        // The app (and its in-memory database) was built inside runAsync
        // by the screenshot helper: let that real async work finish.
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day77_vault',
    (t) => screenshot(
      t,
      'day77_vault',
      testApp(
        pickedFile: DocumentFile(
          name: 'Hotel booking.pdf',
          mimeType: 'application/pdf',
          bytes: Uint8List(100),
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
        await t.tap(find.text('Add a file'));
        await t.pump();
        // Built inside runAsync by the screenshot helper (see day76_search).
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        await t.pumpAndSettle();
        // Hide the "Added" SnackBar: the list is the point.
        ScaffoldMessenger.of(
          t.element(find.byType(Scaffold).first),
        ).removeCurrentSnackBar();
        await t.pumpAndSettle();
      },
    ),
  );
}
