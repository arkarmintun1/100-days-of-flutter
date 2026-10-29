import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A ring that fills up as the budget is spent, drawn with CustomPaint.
class BudgetRing extends StatelessWidget {
  const BudgetRing({
    super.key,
    required this.progress,
    required this.color,
    required this.child,
    this.size = 140,
  });

  /// 0 = nothing spent, 1 = the whole budget. Above 1 is drawn as full.
  final double progress;
  final Color color;

  /// Shown in the middle of the ring.
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      // Animates from the old progress to the new one (Day 67 has more
      // about implicit animations).
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: progress.clamp(0, 1).toDouble()),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => CustomPaint(
          painter: BudgetRingPainter(
            progress: value,
            color: color,
            trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: child,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class BudgetRingPainter extends CustomPainter {
  BudgetRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  static const strokeWidth = 14.0;

  @override
  void paint(Canvas canvas, Size size) {
    // The stroke is centered on the path: inset by half its width so the
    // ring isn't cut off at the edges.
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(arcRect, 0, 2 * math.pi, false, track);

    if (progress <= 0) return;
    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    // Angles are in radians, clockwise from 3 o'clock: -π/2 is 12 o'clock.
    canvas.drawArc(arcRect, -math.pi / 2, 2 * math.pi * progress, false, arc);
  }

  /// Repaint only when something we draw changed.
  @override
  bool shouldRepaint(BudgetRingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor;
}
