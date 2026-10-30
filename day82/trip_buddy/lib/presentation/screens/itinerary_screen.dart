import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/failures.dart';
import '../providers/dependencies.dart';
import '../widgets/booking_tile.dart';

/// Day 80: the trip's bookings, earliest first.
class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary')),
      body: switch (ref.watch(bookingsProvider)) {
        AsyncError(:final error) => Center(
          child: Text(
            error is Failure ? error.message : 'Something went wrong.',
          ),
        ),
        AsyncData(value: []) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No bookings yet. Ask in the chat, e.g. "Add my flight '
              'SQ321 on 12 Dec at 21:40 from London."',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        AsyncData(:final value) => ListView(
          children: [
            for (final booking in value)
              BookingTile(
                booking,
                trailing: IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    try {
                      await ref.read(itineraryProvider).delete(booking.id);
                    } on Failure catch (failure) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message)));
                    }
                  },
                ),
              ),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
