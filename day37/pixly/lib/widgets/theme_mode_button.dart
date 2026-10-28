import 'package:flutter/material.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:pixly/widgets/theme_mode_sheet.dart';
import 'package:provider/provider.dart';

/// AppBar button whose icon shows the current theme mode.
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<ThemeProvider, ThemeMode>(
      (provider) => provider.themeMode,
    );

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
