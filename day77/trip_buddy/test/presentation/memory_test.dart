import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/failures.dart';

import '../helpers/fake_embedder.dart';
import '../helpers/fake_trip_memory.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> addSampleGuide(WidgetTester tester) async {
    await tester.tap(find.text('Add the sample guide'));
    await tester.pumpAndSettle();
  }

  Future<void> search(WidgetTester tester, String question) async {
    await tester.enterText(find.byType(TextField), question);
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
  }

  testWidgets('add the sample guide, then find a flight by number', (
    tester,
  ) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    expect(find.text('No documents yet.'), findsOneWidget);

    await addSampleGuide(tester);
    expect(find.text('Singapore trip plan'), findsOneWidget);
    expect(find.textContaining('chunks'), findsOneWidget);

    await search(tester, 'SQ321');
    final first = find.byType(Card).first;
    expect(
      find.descendant(of: first, matching: find.textContaining('SQ321')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: first, matching: find.text('keyword')),
      findsOneWidget,
    );
  });

  testWidgets('deleting the document empties the search', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    await addSampleGuide(tester);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('No documents yet.'), findsOneWidget);

    await search(tester, 'SQ321');
    expect(find.text('Nothing found.'), findsOneWidget);
  });

  testWidgets('a failure while memorizing is shown', (tester) async {
    final memory = FakeTripMemory();
    await tester.pumpWidget(
      testApp(
        memory: memory,
        embedder: FakeEmbedder(
          error: const NetworkFailure(
            "Couldn't reach the server. Check your connection.",
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await addSampleGuide(tester);

    expect(
      find.text("Couldn't reach the server. Check your connection."),
      findsOneWidget,
    );
    expect(memory.chunks, isEmpty);
  });
}
