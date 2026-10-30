import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sample_notes.dart';
import '../../domain/failures.dart';
import '../providers/dependencies.dart';

/// Day 75: search the sample notes by meaning, not by words.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _question = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  void _search() => setState(() => _query = _question.text.trim());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Buddy')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _question,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: 'Ask your notes',
                hintText: 'Where do I sleep?',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.isEmpty ? const _AllNotes() : _Results(_query),
          ),
        ],
      ),
    );
  }
}

class _AllNotes extends StatelessWidget {
  const _AllNotes();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (final note in sampleNotes)
          ListTile(leading: const Icon(Icons.notes), title: Text(note)),
      ],
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results(this.query);

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(noteSearchProvider(query));
    return switch (results) {
      // Check the error first: Riverpod keeps the previous value in it.
      AsyncError(:final error) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error is Failure ? error.message : 'Something went wrong.'),
            TextButton(
              onPressed: () {
                // The notes are embedded again only if that failed (e.g.
                // offline at the first search), the question every time.
                if (ref.read(notesIndexProvider) case AsyncError()) {
                  ref.invalidate(notesIndexProvider);
                }
                ref.invalidate(noteSearchProvider(query));
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
      AsyncData(:final value) => ListView(
        children: [
          for (final (:item, :score) in value)
            ListTile(
              leading: const Icon(Icons.notes),
              title: Text(item),
              // 1.0 = same direction. Useful to compare, not a percentage.
              trailing: Text(score.toStringAsFixed(2)),
            ),
        ],
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
