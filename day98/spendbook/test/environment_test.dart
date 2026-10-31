import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/environment.dart';

import 'helpers/fake_expense_repository.dart';
import 'helpers/test_app.dart';

void main() {
  test('Day 93: the flavor picks the environment; prod only on purpose', () {
    expect(Environment.from('dev'), Environment.dev);
    expect(Environment.from('prod'), Environment.prod);
    expect(Environment.from(null), Environment.dev);
    expect(Environment.from('something else'), Environment.dev);
  });

  test('only dev shows the banner', () {
    expect(Environment.dev.showsBanner, isTrue);
    expect(Environment.prod.showsBanner, isFalse);
  });

  // Delete this test once `flutterfire configure` writes the real
  // lib/firebase_options_dev.dart.
  test('no Firebase project yet: the placeholder says so', () {
    expect(
      () => Environment.dev.firebaseOptions,
      throwsA(isA<UnsupportedError>()),
    );
  });

  testWidgets('the DEV banner', (tester) async {
    await tester.pumpWidget(testApp(FakeExpenseRepository()));
    await tester.pumpAndSettle();
    expect(find.byType(Banner), findsNothing);

    await tester.pumpWidget(
      testApp(FakeExpenseRepository(), showsBanner: true),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Banner), findsOneWidget);
  });
}
