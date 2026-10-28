import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/theme_notifier.dart';
import 'package:pixly/screens/home_screen.dart';
import 'package:pixly/storage/settings_storage.dart';
import 'package:pixly/widgets/photo_image.dart';
import 'package:pixly/widgets/theme_mode_sheet.dart';

import 'helpers/fake_cache_manager.dart';
import 'helpers/memory_settings.dart';
import 'helpers/test_app.dart';

void main() {
  setUpAll(() => PhotoImage.cacheManagerOverride = FakeCacheManager());

  Brightness homeBrightness(WidgetTester tester) =>
      Theme.of(tester.element(find.byType(HomeScreen))).brightness;

  Future<void> pumpApp(
    WidgetTester tester, {
    String? saved,
    Brightness device = Brightness.light,
  }) async {
    tester.platformDispatcher.platformBrightnessTestValue = device;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(testApp(settings: MemorySettingsStorage(saved)));
    await tester.pumpAndSettle();
  }

  testWidgets('system mode follows a light device', (tester) async {
    await pumpApp(tester, device: Brightness.light);
    expect(homeBrightness(tester), Brightness.light);
  });

  testWidgets('system mode follows a dark device', (tester) async {
    await pumpApp(tester, device: Brightness.dark);
    expect(homeBrightness(tester), Brightness.dark);
  });

  testWidgets('a saved Dark choice wins over a light device', (tester) async {
    await pumpApp(tester, saved: 'dark', device: Brightness.light);
    expect(homeBrightness(tester), Brightness.dark);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });

  testWidgets('picking Dark in the sheet switches the whole app', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.byIcon(Icons.brightness_auto), findsOneWidget);

    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();
    expect(find.byType(ThemeModeSheet), findsOneWidget);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(containerOf(tester).read(themeModeProvider), ThemeMode.dark);
    expect(homeBrightness(tester), Brightness.dark);
    // The AppBar icon shows the new mode too (behind the sheet).
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.dark_mode),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a choice that cannot be saved shows a message', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final storage = MemorySettingsStorage()..failWrites = true;
    await tester.pumpWidget(testApp(settings: storage));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(homeBrightness(tester), Brightness.dark);
    expect(find.textContaining("Couldn't save your choice"), findsOneWidget);

    storage.failWrites = false;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(storage.themeMode, 'dark');
    expect(find.textContaining("Couldn't save your choice"), findsNothing);
  });

  testWidgets('an older save finishing late does not show its error', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final storage = _ControlledStorage();
    await tester.pumpWidget(testApp(settings: storage));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Appearance'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark')); // save 1 starts
    await tester.pump();
    await tester.tap(find.text('Light')); // save 2 starts
    await tester.pump();

    storage.writes[1].complete(); // the newest save works
    await tester.pump();
    storage.writes[0].completeError(Exception('disk full')); // old one fails
    await tester.pumpAndSettle();

    expect(find.textContaining("Couldn't save your choice"), findsNothing);
  });
}

/// Storage whose writes finish only when the test says so.
class _ControlledStorage implements SettingsStorage {
  final writes = <Completer<void>>[];

  @override
  String? readThemeMode() => null;

  @override
  Future<void> writeThemeMode(String value) {
    final write = Completer<void>();
    writes.add(write);
    return write.future;
  }
}
