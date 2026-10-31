import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n.dart';
import '../providers/locale.dart';

/// Day 96: the phone's language, English or Myanmar.
class LanguageMenu extends ConsumerWidget {
  const LanguageMenu({super.key});

  static const _phone = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appLocaleProvider)?.languageCode ?? _phone;
    CheckedPopupMenuItem<String> item(String code, String name) =>
        CheckedPopupMenuItem(
          value: code,
          checked: code == current,
          child: Text(name),
        );

    return PopupMenuButton<String>(
      tooltip: context.l10n.language,
      icon: const Icon(Icons.translate),
      onSelected: (code) => ref
          .read(appLocaleProvider.notifier)
          .choose(code == _phone ? null : Locale(code)),
      itemBuilder: (context) => [
        item(_phone, context.l10n.languageSystem),
        // Each language in its own name, so people find theirs.
        item('en', 'English'),
        item('my', 'မြန်မာ'),
      ],
    );
  }
}
