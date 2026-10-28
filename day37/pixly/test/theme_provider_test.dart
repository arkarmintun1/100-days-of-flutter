import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/theme_provider.dart';

import 'helpers/memory_settings.dart';

void main() {
  test('follows the system when nothing is saved yet', () {
    final provider = ThemeProvider(MemorySettingsStorage());
    expect(provider.themeMode, ThemeMode.system);
  });

  test('starts with the saved mode', () {
    final provider = ThemeProvider(MemorySettingsStorage('dark'));
    expect(provider.themeMode, ThemeMode.dark);
  });

  test('an unknown saved value falls back to system', () {
    final provider = ThemeProvider(MemorySettingsStorage('purple'));
    expect(provider.themeMode, ThemeMode.system);
  });

  test('setThemeMode notifies and saves the name', () async {
    final storage = MemorySettingsStorage();
    final provider = ThemeProvider(storage);
    var notified = 0;
    provider.addListener(() => notified++);

    expect(await provider.setThemeMode(ThemeMode.light), isTrue);

    expect(provider.themeMode, ThemeMode.light);
    expect(notified, 1);
    expect(storage.themeMode, 'light');
  });

  test('picking the current mode again does not notify', () async {
    final provider = ThemeProvider(MemorySettingsStorage('dark'));
    var notified = 0;
    provider.addListener(() => notified++);

    await provider.setThemeMode(ThemeMode.dark);

    expect(notified, 0);
  });

  test('picking the same mode again retries a failed save', () async {
    final storage = MemorySettingsStorage()..failWrites = true;
    final provider = ThemeProvider(storage);
    expect(await provider.setThemeMode(ThemeMode.dark), isFalse);

    storage.failWrites = false;
    expect(await provider.setThemeMode(ThemeMode.dark), isTrue);
    expect(storage.themeMode, 'dark');
  });

  test('the choice survives a restart', () async {
    final storage = MemorySettingsStorage();
    await ThemeProvider(storage).setThemeMode(ThemeMode.dark);

    expect(ThemeProvider(storage).themeMode, ThemeMode.dark);
  });

  test('a failed save keeps the mode for now and reports it', () async {
    final storage = MemorySettingsStorage()..failWrites = true;
    final provider = ThemeProvider(storage);

    expect(await provider.setThemeMode(ThemeMode.dark), isFalse);

    expect(provider.themeMode, ThemeMode.dark); // still used right now
    expect(ThemeProvider(storage).themeMode, ThemeMode.system); // not saved
  });
}
