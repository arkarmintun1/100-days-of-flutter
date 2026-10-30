import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../helpers/fake_chat_writer.dart';
import '../helpers/rive_helper.dart';
import '../helpers/test_app.dart';

void main() {
  Future<Completer<void>> askAndWait(
    WidgetTester tester, {
    FileLoader? thinking,
  }) async {
    final hold = Completer<void>();
    await tester.pumpWidget(
      testApp(
        chatWriter: FakeChatWriter(chunks: ['OK.'], hold: hold.future),
        thinking: thinking,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Anything?');
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();
    return hold;
  }

  /// The answer arrives; the indicator goes.
  Future<void> answer(WidgetTester tester, Completer<void> hold) async {
    hold.complete();
    await tester.pump();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('Rive plays while Trip Buddy is thinking', (tester) async {
    final semantics = tester.ensureSemantics();
    final hold = await askAndWait(tester, thinking: testThinkingAnimation());
    await waitForRive(tester);
    expect(find.bySemanticsLabel('Trip Buddy is thinking'), findsOneWidget);

    await answer(tester, hold);
    expect(find.byType(RiveWidget), findsNothing);
    expect(find.text('OK.'), findsOneWidget);
    semantics.dispose();
  });

  for (final (setting, features) in [
    (
      'Android: Remove animations',
      const FakeAccessibilityFeatures(disableAnimations: true),
    ),
    ('iOS: Reduce Motion', const FakeAccessibilityFeatures(reduceMotion: true)),
  ]) {
    testWidgets('$setting: a still icon', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue = features;
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final semantics = tester.ensureSemantics();

      final hold = await askAndWait(tester, thinking: testThinkingAnimation());
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(RiveWidgetBuilder), findsNothing);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.bySemanticsLabel('Trip Buddy is thinking'), findsOneWidget);
      await answer(tester, hold);
      semantics.dispose();
    });
  }
}
