import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_places.dart';
import '../helpers/test_app.dart';

void main() {
  Future<void> openMap(WidgetTester tester) async {
    await tester.tap(find.text('Add the sample guide'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();
  }

  testWidgets('nothing is read until asked; then places and a map', (
    tester,
  ) async {
    // Tall enough for the map and the whole list.
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final finder = FakePlaceFinder();
    await tester.pumpWidget(testApp(placeFinder: finder));
    await tester.pumpAndSettle();
    await openMap(tester);
    expect(finder.calls, isEmpty);

    await tester.tap(find.text('Find places in my documents'));
    await tester.pumpAndSettle();

    expect(finder.calls.single.title, 'Singapore trip plan');
    expect(find.text('Map: 3 places'), findsOneWidget);
    expect(find.text('Parkroyal Collection Pickering'), findsOneWidget);
    expect(find.text("Couldn't place on the map"), findsOneWidget);
    expect(find.text('Changi Airport Terminal 3'), findsOneWidget);
  });

  testWidgets('tapping a place selects it on the map', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    await openMap(tester);
    await tester.tap(find.text('Find places in my documents'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Gardens by the Bay'));
    await tester.pumpAndSettle();

    expect(find.text('Map: Gardens by the Bay'), findsOneWidget);
  });

  testWidgets('with no documents, the map says why', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Find places in my documents'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Add documents to the vault first'),
      findsOneWidget,
    );
  });
}
