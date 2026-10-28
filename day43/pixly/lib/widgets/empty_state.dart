import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixly/config/assets.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: .min,
          children: [
            SvgPicture.asset(AppAssets.emptyPhotos, width: 180),
            const SizedBox(height: 24),
            Text(title, style: textTheme.titleLarge, textAlign: .center),
            const SizedBox(height: 8),
            Text(message, style: textTheme.bodyMedium, textAlign: .center),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
