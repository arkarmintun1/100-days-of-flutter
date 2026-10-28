import 'package:flutter/material.dart';
import 'package:pixly/widgets/empty_state.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: const EmptyState(
        title: 'No bookmarks yet',
        message: 'Photos you bookmark will show up here.',
      ),
    );
  }
}
