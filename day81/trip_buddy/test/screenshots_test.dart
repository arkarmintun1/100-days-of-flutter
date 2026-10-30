// Renders the blog's screenshots. Skipped by default (see dart_test.yaml):
// fvm flutter test --run-skipped -t screenshots --update-goldens
@Tags(['screenshots'])
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/booking.dart';
import 'package:trip_buddy/domain/document_file.dart';

import 'helpers/fake_answer_writer.dart';
import 'helpers/fake_chat_writer.dart';
import 'helpers/fake_document_reader.dart';
import 'helpers/fake_itinerary.dart';
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
        await t.tap(find.byTooltip('Ask'));
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

  testWidgets(
    'day78_answer',
    (t) => screenshot(
      t,
      'day78_answer',
      testApp(
        writer: FakeAnswerWriter(
          answer: (sources) {
            final flight = FakeAnswerWriter.numberOf(sources, 'SQ321');
            final hotel = FakeAnswerWriter.numberOf(sources, 'Check-in');
            return 'Your flight SQ321 lands at Changi Terminal 3 on 13 Dec '
                'at 18:05 [$flight]. Check-in at the Parkroyal Collection '
                'Pickering is from 3 pm that day [$hotel].';
          },
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
        await t.enterText(
          find.byType(TextField),
          'When do I land, and when can I check in?',
        );
        await t.tap(find.byTooltip('Ask'));
        await t.pump();
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day78_progress',
    (t) => screenshot(
      t,
      'day78_progress',
      testApp(
        // Gemini is still reading: the bar keeps moving.
        reader: FakeDocumentReader(hold: Completer<void>().future),
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
        // Into the bar's animation, so its moving part shows.
        await t.pump(const Duration(milliseconds: 900));
      },
    ),
  );

  testWidgets(
    'day79_chat',
    (t) => screenshot(
      t,
      'day79_chat',
      testApp(
        chatWriter: FakeChatWriter(
          reply: (question, sources) {
            String n(String text) =>
                '[${FakeAnswerWriter.numberOf(sources, text)}]';
            return question.contains('back')
                ? 'Your return flight SQ322 leaves Changi Terminal 3 on '
                      '19 Dec at 23:30 ${n('SQ322')}. Check-out is by 12 pm '
                      "that day, so you'll have the afternoon free "
                      "${n('Check-in')}."
                : 'You land at Changi Terminal 3 on 13 Dec at 18:05 '
                      '${n('SQ321')}.';
          },
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
        await t.tap(find.text('Chat'));
        await t.pumpAndSettle();
        for (final question in [
          'When do I land in Singapore?',
          'And when do I fly back?',
        ]) {
          await t.enterText(find.byType(TextField).last, question);
          await t.tap(find.byTooltip('Send'));
          await t.pump();
          await t.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 300)),
          );
          await t.pumpAndSettle();
        }
      },
    ),
  );

  final returnFlight = Booking(
    id: 3,
    title: 'Flight SQ322 to London',
    kind: BookingKind.flight,
    startsAt: DateTime(2026, 12, 19, 23, 30),
    timeZone: 'Asia/Singapore',
  );
  final trip = [
    Booking(
      id: 1,
      title: 'Flight SQ321 to Singapore',
      kind: BookingKind.flight,
      startsAt: DateTime(2026, 12, 12, 21, 40),
      timeZone: 'Europe/London',
    ),
    Booking(
      id: 2,
      title: 'Parkroyal Collection Pickering',
      kind: BookingKind.hotel,
      startsAt: DateTime(2026, 12, 13, 15, 0),
      timeZone: 'Asia/Singapore',
    ),
    returnFlight,
  ];

  testWidgets(
    'day80_chat',
    (t) => screenshot(
      t,
      'day80_chat',
      testApp(
        itinerary: FakeItinerary(trip),
        chatWriter: FakeChatWriter(
          added: [returnFlight],
          chunks: [
            'I added your return flight SQ322, leaving Changi Terminal 3 on '
                '19 Dec at 23:30 Singapore time. It is 20:15 in Singapore '
                'right now.',
          ],
        ),
      ),
      before: (t) async {
        await t.tap(find.text('Chat'));
        await t.pumpAndSettle();
        await t.enterText(
          find.byType(TextField).last,
          'Add my flight home: SQ322 on 19 Dec at 23:30 from Singapore. '
          'What time is it there now?',
        );
        await t.tap(find.byTooltip('Send'));
        await t.pump();
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day80_trip',
    (t) => screenshot(
      t,
      'day80_trip',
      testApp(itinerary: FakeItinerary(trip)),
      before: (t) async {
        await t.tap(find.text('Trip'));
        await t.pumpAndSettle();
      },
    ),
  );

  testWidgets(
    'day81_map',
    (t) => screenshot(
      t,
      'day81_map',
      testApp(),
      before: (t) async {
        await t.tap(find.text('Add the sample guide'));
        await t.pumpAndSettle();
        await t.tap(find.text('Map'));
        await t.pumpAndSettle();
        await t.tap(find.text('Find places in my documents'));
        await t.pump();
        await t.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        await t.pumpAndSettle();
        await t.tap(find.text('Parkroyal Collection Pickering'));
        await t.pumpAndSettle();
      },
    ),
  );
}
