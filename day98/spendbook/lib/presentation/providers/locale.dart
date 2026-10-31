import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale.g.dart';

/// Day 96: where the chosen language is kept between launches.
abstract interface class LocaleStore {
  /// A language code ('en', 'my'), or null: the phone's language.
  Future<String?> read();
  Future<void> write(String? languageCode);
}

class PreferencesLocaleStore implements LocaleStore {
  static const _key = 'language';
  final _preferences = SharedPreferencesAsync();

  @override
  Future<String?> read() => _preferences.getString(_key);

  @override
  Future<void> write(String? languageCode) => languageCode == null
      ? _preferences.remove(_key)
      : _preferences.setString(_key, languageCode);
}

@Riverpod(keepAlive: true)
LocaleStore localeStore(Ref ref) => PreferencesLocaleStore();

/// The language the user picked, or null for the phone's language.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  var _chosen = false;

  @override
  Locale? build() {
    _load();
    return null; // the phone's language until the saved one is read
  }

  Future<void> _load() async {
    try {
      final code = await ref.read(localeStoreProvider).read();
      // Picked meanwhile: that wins.
      if (code != null && !_chosen && ref.mounted) state = Locale(code);
    } on Exception catch (e) {
      // Not worth a crash report: the phone's language it is.
      log("Couldn't read the language: $e");
    }
  }

  Future<void> choose(Locale? locale) async {
    _chosen = true;
    state = locale;
    try {
      await ref.read(localeStoreProvider).write(locale?.languageCode);
    } on Exception catch (e) {
      // Still changed for now; only not remembered.
      log("Couldn't save the language: $e");
    }
  }
}
