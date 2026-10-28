import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixly/providers/dependencies.dart';
import 'package:pixly/providers/theme_notifier.dart';

import 'helpers/memory_settings.dart';

void main() {
  ProviderContainer containerWith(MemorySettingsStorage storage) =>
      ProviderContainer.test(
        overrides: [settingsStorageProvider.overrideWithValue(storage)],
      );

  test('follows the system when nothing is saved yet', () {
    final container = containerWith(MemorySettingsStorage());
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('starts with the saved mode', () {
    final container = containerWith(MemorySettingsStorage('dark'));
    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  test('an unknown saved value falls back to system', () {
    final container = containerWith(MemorySettingsStorage('purple'));
    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('setThemeMode updates the state and saves the name', () async {
    final storage = MemorySettingsStorage();
    final container = containerWith(storage);
    final changes = <ThemeMode>[];
    container.listen(themeModeProvider, (_, next) => changes.add(next));

    final saved = await container
        .read(themeModeProvider.notifier)
        .setThemeMode(ThemeMode.light);

    expect(saved, isTrue);
    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(changes, [ThemeMode.light]);
    expect(storage.themeMode, 'light');
  });

  test('picking the current mode again does not notify listeners', () async {
    final container = containerWith(MemorySettingsStorage('dark'));
    final changes = <ThemeMode>[];
    container.listen(themeModeProvider, (_, next) => changes.add(next));

    await container.read(themeModeProvider.notifier).setThemeMode(.dark);

    expect(changes, isEmpty); // Riverpod skips values that are == the old
  });

  test('picking the same mode again retries a failed save', () async {
    final storage = MemorySettingsStorage()..failWrites = true;
    final container = containerWith(storage);
    final notifier = container.read(themeModeProvider.notifier);

    expect(await notifier.setThemeMode(ThemeMode.dark), isFalse);
    expect(container.read(themeModeProvider), ThemeMode.dark);

    storage.failWrites = false;
    expect(await notifier.setThemeMode(ThemeMode.dark), isTrue);
    expect(storage.themeMode, 'dark');
  });

  test('the choice survives a restart (a new container)', () async {
    final storage = MemorySettingsStorage();
    await containerWith(
      storage,
    ).read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

    expect(containerWith(storage).read(themeModeProvider), ThemeMode.dark);
  });
}
