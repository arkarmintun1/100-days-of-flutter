import 'package:shared_preferences/shared_preferences.dart';

/// Where app settings are saved. An interface, so tests can use memory.
abstract interface class SettingsStorage {
  String? readThemeMode();
  Future<void> writeThemeMode(String value);
}

/// Saves settings on the device with shared_preferences.
class PrefsSettingsStorage implements SettingsStorage {
  PrefsSettingsStorage(this._prefs);

  static const themeModeKey = 'theme_mode';

  final SharedPreferencesWithCache _prefs;

  @override
  String? readThemeMode() => _prefs.getString(themeModeKey);

  @override
  Future<void> writeThemeMode(String value) =>
      _prefs.setString(themeModeKey, value);
}
