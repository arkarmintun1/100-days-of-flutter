import 'package:flutter/material.dart';
import 'package:pixly/providers/theme_provider.dart';
import 'package:provider/provider.dart';

/// Opens a bottom sheet where the user picks System, Light or Dark.
Future<void> showThemeModeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const ThemeModeSheet(),
  );
}

class ThemeModeSheet extends StatefulWidget {
  const ThemeModeSheet({super.key});

  @override
  State<ThemeModeSheet> createState() => _ThemeModeSheetState();
}

class _ThemeModeSheetState extends State<ThemeModeSheet> {
  // A SnackBar would be hidden behind this sheet, so a failed save is
  // shown inside the sheet instead.
  bool _saveFailed = false;

  /// Counts saves, so an older save that finishes late is ignored.
  int _saveCount = 0;

  Future<void> _select(ThemeMode mode) async {
    final save = ++_saveCount;
    final saved = await context.read<ThemeProvider>().setThemeMode(mode);
    if (!mounted || save != _saveCount) return;
    setState(() => _saveFailed = !saved);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final theme = Theme.of(context);

    // A modal bottom sheet is at most 9/16 of the screen tall, so let the
    // content scroll on short screens or with large text.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Text('Appearance', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: .system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text('System'),
                ),
                ButtonSegment(
                  value: .light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Light'),
                ),
                ButtonSegment(
                  value: .dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Dark'),
                ),
              ],
              selected: {themeMode},
              // Only one segment can be selected, so the set has one item.
              onSelectionChanged: (selection) => _select(selection.first),
              showSelectedIcon: false,
            ),
            const SizedBox(height: 12),
            Text(
              themeMode == .system
                  ? "Pixly follows your device's light or dark setting."
                  : 'Pixly stays in this mode, whatever the device uses.',
              style: theme.textTheme.bodyMedium,
            ),
            if (_saveFailed) ...[
              const SizedBox(height: 8),
              Text(
                "Couldn't save your choice. It applies until you close Pixly.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              Align(
                alignment: .centerLeft,
                // Tapping the selected segment again does nothing, so the
                // retry needs its own button.
                child: TextButton(
                  onPressed: () => _select(themeMode),
                  child: const Text('Try again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
