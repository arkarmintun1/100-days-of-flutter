import 'package:flutter/material.dart';

/// Shown above photos that were saved on the device because loading new
/// ones failed (offline persistence, Day 48).
class StaleNotice extends StatelessWidget {
  const StaleNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card.filled(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      color: colors.secondaryContainer,
      child: ListTile(
        leading: Icon(Icons.cloud_off, color: colors.onSecondaryContainer),
        title: const Text("Couldn't load new photos"),
        subtitle: const Text(
          'Showing the photos from your last visit. Pull down to try again.',
        ),
        textColor: colors.onSecondaryContainer,
      ),
    );
  }
}
