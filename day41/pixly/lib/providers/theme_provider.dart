import 'package:flutter/material.dart';
import 'package:pixly/storage/settings_storage.dart';

/// Which theme the user picked: follow the system, always light or always
/// dark. Saved on the device so the choice survives a restart.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider(SettingsStorage storage)
    : _storage = storage,
      _themeMode = _parse(storage.readThemeMode());

  final SettingsStorage _storage;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  /// Switches to [mode] and saves it. Returns false if saving failed: the
  /// app still uses [mode] now, but the next launch won't remember it.
  Future<bool> setThemeMode(ThemeMode mode) async {
    if (mode != _themeMode) {
      _themeMode = mode;
      notifyListeners();
    }
    // Saved even when the mode didn't change, so picking it again
    // retries a save that failed before.
    try {
      await _storage.writeThemeMode(mode.name);
      return true;
    } on Exception {
      return false;
    }
  }

  /// 'dark' -> ThemeMode.dark. Nothing saved yet (null) or an unknown value
  /// falls back to following the system.
  static ThemeMode _parse(String? name) =>
      ThemeMode.values.asNameMap()[name] ?? ThemeMode.system;
}
