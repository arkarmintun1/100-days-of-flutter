import 'package:flutter/material.dart';

/// Pixly-specific colours that Material's ColorScheme doesn't have a slot for.
@immutable
class PixlyColors extends ThemeExtension<PixlyColors> {
  const PixlyColors({
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.photoOverlay,
  });

  /// Skeleton colours for loading placeholders.
  final Color shimmerBase;
  final Color shimmerHighlight;

  /// Dark gradient drawn over photos so white text stays readable.
  final Color photoOverlay;

  static const light = PixlyColors(
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    photoOverlay: Color(0x99000000),
  );

  static const dark = PixlyColors(
    shimmerBase: Color(0xFF2C2C2C),
    shimmerHighlight: Color(0xFF3D3D3D),
    photoOverlay: Color(0xB3000000),
  );

  @override
  PixlyColors copyWith({
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? photoOverlay,
  }) {
    return PixlyColors(
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      photoOverlay: photoOverlay ?? this.photoOverlay,
    );
  }

  @override
  PixlyColors lerp(PixlyColors? other, double t) {
    if (other == null) return this;
    return PixlyColors(
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(
        shimmerHighlight,
        other.shimmerHighlight,
        t,
      )!,
      photoOverlay: Color.lerp(photoOverlay, other.photoOverlay, t)!,
    );
  }
}

class AppTheme {
  static const Color seedColor = Color(0xFF05A081);

  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final base = ThemeData(colorScheme: colorScheme);

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: .bold),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        clipBehavior: .antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      extensions: [
        brightness == Brightness.light ? PixlyColors.light : PixlyColors.dark,
      ],
    );
  }
}

/// Shortcut: `context.pixlyColors.shimmerBase`
extension PixlyThemeX on BuildContext {
  PixlyColors get pixlyColors => Theme.of(this).extension<PixlyColors>()!;
}
