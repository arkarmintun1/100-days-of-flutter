import 'package:breeze/core/app_exception.dart';
import 'package:breeze/providers/weather_providers.dart';
import 'package:breeze/widgets/weather_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/fake_location_service.dart';

void main() {
  Widget errorView(ErrorKind kind) => ProviderScope(
    overrides: [
      locationServiceProvider.overrideWithValue(FakeLocationService()),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: WeatherErrorView(AppException('The message.', kind: kind)),
      ),
    ),
  );

  for (final kind in ErrorKind.values) {
    testWidgets('$kind: its icon, title, message and "Try again"', (
      tester,
    ) async {
      await tester.pumpWidget(errorView(kind));

      expect(find.byIcon(kind.icon), findsOneWidget);
      expect(find.text(kind.title), findsOneWidget);
      expect(find.text('The message.'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(
        find.text('Search for a city'),
        kind.isLocationProblem ? findsOneWidget : findsNothing,
      );
    });
  }

  testWidgets('a key problem: new keys can take a while', (tester) async {
    await tester.pumpWidget(errorView(ErrorKind.unauthorized));
    expect(find.textContaining('up to 2 hours'), findsOneWidget);
  });
}
