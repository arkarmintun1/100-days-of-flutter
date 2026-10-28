import 'package:flutter/material.dart';
import 'package:pixly/widgets/empty_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const EmptyState(
        title: 'Search photos',
        message: 'Search for any photo on Pexels. Coming soon!',
      ),
    );
  }
}
