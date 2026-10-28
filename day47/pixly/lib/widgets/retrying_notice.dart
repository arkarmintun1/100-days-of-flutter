import 'package:flutter/material.dart';

/// Tells the user that a request failed and the app is trying again by
/// itself (Riverpod's automatic retry), so the loading takes longer.
class RetryingNotice extends StatelessWidget {
  const RetryingNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Icon(Icons.refresh, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Couldn't load. Trying again…",
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
