import 'package:shared_preferences/shared_preferences.dart';

/// Where bookmarks are saved: a list of strings (one JSON photo per item).
///
/// An interface, so tests can keep bookmarks in memory instead.
abstract interface class BookmarksStorage {
  List<String> read();
  Future<void> write(List<String> items);
}

/// Saves bookmarks on the device with shared_preferences.
class PrefsBookmarksStorage implements BookmarksStorage {
  PrefsBookmarksStorage(this._prefs);

  static const key = 'bookmarked_photos';

  final SharedPreferencesWithCache _prefs;

  @override
  List<String> read() => _prefs.getStringList(key) ?? [];

  @override
  Future<void> write(List<String> items) => _prefs.setStringList(key, items);
}
