import 'package:flutter/material.dart';
import 'package:pixly/core/error_kind.dart';

/// A full-screen error with an icon and title that match the [kind], and a
/// "Try again" button only when trying again can help.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.kind,
    required this.message,
    this.onRetry,
  });

  final ErrorKind kind;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title) = switch (kind) {
      .network => (Icons.wifi_off, 'No connection'),
      .rateLimited => (Icons.hourglass_empty, 'Taking a short break'),
      .unauthorized => (Icons.key_off, 'API key problem'),
      .notFound => (Icons.image_not_supported_outlined, 'Not found'),
      .server => (Icons.cloud_off, 'Pexels is having trouble'),
      .unknown => (Icons.error_outline, 'Something went wrong'),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge, textAlign: .center),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: .center,
            ),
            if (onRetry != null && kind.canRetry) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
