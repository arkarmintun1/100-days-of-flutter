import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_buddy/domain/failures.dart';
import 'package:trip_buddy/domain/trip_place.dart';

import '../helpers/fake_location.dart';
import '../helpers/fake_places.dart';
import '../helpers/test_app.dart';

void main() {
  /// Tall enough for the map and the whole list.
  void tall(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> openMap(WidgetTester tester) async {
    await tester.tap(find.text('Add the sample guide'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();
  }

  final saved = [
    testPlace('Gardens by the Bay', PlaceKind.sight, 1.2816, 103.8636),
    testPlace('Maxwell Food Centre', PlaceKind.food, 1.2804, 103.8448),
  ];

  testWidgets('nothing is read until asked; then places and a map', (
    tester,
  ) async {
    tall(tester);
    final finder = FakePlaceFinder();
    final store = FakePlaceStore();
    await tester.pumpWidget(testApp(placeFinder: finder, placeStore: store));
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
    // Day 82: saved for next time.
    expect(store.places, hasLength(3));
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

  testWidgets('Day 82: saved places show without asking Gemini', (
    tester,
  ) async {
    final finder = FakePlaceFinder();
    await tester.pumpWidget(
      testApp(placeFinder: finder, placeStore: FakePlaceStore(saved)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    expect(find.text('Map: 2 places'), findsOneWidget);
    expect(finder.calls, isEmpty);
  });

  testWidgets('Day 82: "Near me" sorts by distance', (tester) async {
    tall(tester);
    await tester.pumpWidget(testApp(placeStore: FakePlaceStore(saved)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Near me'));
    await tester.pumpAndSettle();

    final names = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();
    expect(names, ['Maxwell Food Centre', 'Gardens by the Bay']);
    expect(find.text('450 m'), findsOneWidget);
    expect(find.text('2.2 km'), findsOneWidget);
  });

  testWidgets('Day 82: location off for the app: a way to settings', (
    tester,
  ) async {
    final location = FakeLocationService(
      error: const LocationFailure(
        'Location access is off for Trip Buddy. Allow it in the app settings.',
        fix: LocationFix.allowInAppSettings,
      ),
    );
    await tester.pumpWidget(
      testApp(placeStore: FakePlaceStore(saved), location: location),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Near me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open app settings'));

    expect(location.openedAppSettings, isTrue);
  });
}
