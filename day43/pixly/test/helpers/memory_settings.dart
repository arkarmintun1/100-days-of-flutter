import 'package:pixly/storage/settings_storage.dart';

/// Keeps settings in memory instead of on the device.
class MemorySettingsStorage implements SettingsStorage {
  MemorySettingsStorage([this.themeMode]);

  String? themeMode;
  int writes = 0;

  /// When true, every write fails like a full disk would.
  bool failWrites = false;

  @override
  String? readThemeMode() => themeMode;

  @override
  Future<void> writeThemeMode(String value) async {
    writes++;
    if (failWrites) throw Exception('Could not write to storage');
    themeMode = value;
  }
}
