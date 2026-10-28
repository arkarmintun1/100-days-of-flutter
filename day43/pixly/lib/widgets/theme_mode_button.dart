import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixly/providers/theme_notifier.dart';
import 'package:pixly/widgets/theme_mode_sheet.dart';

/// AppBar button whose icon shows the current theme mode.
class ThemeModeButton extends ConsumerWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return IconButton(
      tooltip: 'Appearance',
      icon: Icon(switch (themeMode) {
        .system => Icons.brightness_auto,
        .light => Icons.light_mode,
        .dark => Icons.dark_mode,
      }),
      onPressed: () => showThemeModeSheet(context),
    );
  }
}
