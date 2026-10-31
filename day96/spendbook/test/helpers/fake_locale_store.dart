import 'package:spendbook/presentation/providers/locale.dart';

/// Day 96: the saved language, in memory.
class FakeLocaleStore implements LocaleStore {
  FakeLocaleStore([this.saved]);

  String? saved;

  @override
  Future<String?> read() async => saved;

  @override
  Future<void> write(String? languageCode) async => saved = languageCode;
}
