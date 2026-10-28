import 'package:flutter/material.dart';
import 'package:pixly/config/constants.dart';
import 'package:pixly/config/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pixly = context.pixlyColors;

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('ColorScheme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _Swatch('primary', colorScheme.primary, colorScheme.onPrimary),
          _Swatch(
            'primaryContainer',
            colorScheme.primaryContainer,
            colorScheme.onPrimaryContainer,
          ),
          _Swatch('secondary', colorScheme.secondary, colorScheme.onSecondary),
          _Swatch('surface', colorScheme.surface, colorScheme.onSurface),
          const SizedBox(height: 16),
          Text('PixlyColors', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _Swatch('shimmerBase', pixly.shimmerBase, colorScheme.onSurface),
          _Swatch(
            'shimmerHighlight',
            pixly.shimmerHighlight,
            colorScheme.onSurface,
          ),
          _Swatch('photoOverlay', pixly.photoOverlay, Colors.white),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.name, this.color, this.onColor);

  final String name;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: .centerLeft,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(name, style: TextStyle(color: onColor)),
    );
  }
}
