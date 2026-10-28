import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/providers/dependencies.dart';

/// The theme the user picked. `ref.watch(themeModeProvider)` gives the
/// ThemeMode; `ref.read(themeModeProvider.notifier)` gives the methods.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// The first state: what was saved on the device, or follow the system.
  @override
  ThemeMode build() {
    final saved = ref.watch(settingsStorageProvider).readThemeMode();
    return ThemeMode.values.asNameMap()[saved] ?? ThemeMode.system;
  }

  /// Switches to [mode] and saves it. Returns false if saving failed: the
  /// app still uses [mode] now, but the next launch won't remember it.
  Future<bool> setThemeMode(ThemeMode mode) async {
    final storage = ref.read(settingsStorageProvider);
    // Listeners are only told if the new value is different (==).
    state = mode;
    // Saved even when the mode didn't change, so picking it again
    // retries a save that failed before.
    try {
      await storage.writeThemeMode(mode.name);
      return true;
    } on Exception {
      return false;
    }
  }
}
