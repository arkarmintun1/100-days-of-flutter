import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/embedder.dart';
import 'package:trip_buddy/domain/failures.dart';

import '../helpers/fake_embedder.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> search(WidgetTester tester, String question) async {
    await tester.enterText(find.byType(TextField), question);
    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
  }

  testWidgets('finds the hotel for "where do I sleep"', (tester) async {
    final embedder = FakeEmbedder();
    await tester.pumpWidget(testApp(embedder: embedder));
    await search(tester, 'Where do I sleep?');

    // The best match is listed first, though it shares no word with the
    // question.
    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((t) => (t.title! as Text).data);
    expect(titles.first, startsWith('Hotel:'));
    expect(titles, hasLength(3));

    // Notes as documents (once), the question as a query.
    expect(embedder.calls.map((c) => (c.$1.length, c.$2)), [
      (8, EmbedKind.document),
      (1, EmbedKind.query),
    ]);
  });

  testWidgets('a second search embeds only the question', (tester) async {
    final embedder = FakeEmbedder();
    await tester.pumpWidget(testApp(embedder: embedder));
    await search(tester, 'Where do I sleep?');
    await search(tester, 'When does my flight land?');

    expect(embedder.calls.map((c) => c.$2), [
      EmbedKind.document,
      EmbedKind.query,
      EmbedKind.query,
    ]);
  });

  testWidgets('a failure is shown with Try again', (tester) async {
    await tester.pumpWidget(
      testApp(
        embedder: FakeEmbedder(
          error: const NetworkFailure(
            "Couldn't reach the server. Check your connection.",
          ),
        ),
      ),
    );
    await search(tester, 'Where do I sleep?');

    expect(
      find.text("Couldn't reach the server. Check your connection."),
      findsOneWidget,
    );
    expect(find.text('Try again'), findsOneWidget);
  });
}
