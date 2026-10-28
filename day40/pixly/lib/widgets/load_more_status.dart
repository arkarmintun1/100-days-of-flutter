import 'package:flutter/material.dart';

/// Small floating status at the bottom of a grid: a spinner while the next
/// page loads, or a retry button if it failed.
class LoadMoreStatus extends StatelessWidget {
  const LoadMoreStatus({
    super.key,
    required this.isLoadingMore,
    required this.error,
    required this.onRetry,
  });

  final bool isLoadingMore;
  final String? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return FilledButton.tonalIcon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text("Couldn't load more. Retry"),
      );
    }

    if (isLoadingMore) {
      return const Card(
        shape: CircleBorder(),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
