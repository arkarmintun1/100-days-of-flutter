import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/sample_guide.dart';
import '../../domain/failures.dart';
import '../../domain/hybrid_search.dart';
import '../../domain/trip_memory.dart';
import '../providers/dependencies.dart';

/// Day 76: the documents Trip Buddy remembers, and hybrid search in them.
class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen({super.key});

  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  final _question = TextEditingController();
  String _query = '';
  bool _memorizing = false;

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  void _search() => setState(() => _query = _question.text.trim());

  void _clear() {
    _question.clear();
    setState(() => _query = '');
  }

  Future<void> _addSampleGuide() async {
    setState(() => _memorizing = true);
    try {
      await ref.read(memorizeDocumentProvider)(
        title: sampleGuideTitle,
        text: sampleGuide,
      );
    } on Failure catch (failure) {
      _show(failure.message);
    } finally {
      if (mounted) setState(() => _memorizing = false);
    }
  }

  Future<void> _delete(TripDocument document) async {
    try {
      await ref.read(tripMemoryProvider).deleteDocument(document.id);
    } on Failure catch (failure) {
      _show(failure.message);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
                labelText: 'Search your documents',
                hintText: 'When does SQ321 land?',
                border: const OutlineInputBorder(),
                prefixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Back to documents',
                        icon: const Icon(Icons.arrow_back),
                        onPressed: _clear,
                      ),
                suffixIcon: IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.isEmpty
                ? _Documents(
                    memorizing: _memorizing,
                    onAddSample: _addSampleGuide,
                    onDelete: _delete,
                  )
                : _Results(_query),
          ),
        ],
      ),
    );
  }
}

class _Documents extends ConsumerWidget {
  const _Documents({
    required this.memorizing,
    required this.onAddSample,
    required this.onDelete,
  });

  final bool memorizing;
  final VoidCallback onAddSample;
  final void Function(TripDocument document) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(documentsProvider)) {
      AsyncError(:final error) => Center(child: Text(_message(error))),
      AsyncData(:final value) => ListView(
        children: [
          for (final document in value)
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(document.title),
              subtitle: Text(
                document.chunkCount == 1
                    ? '1 chunk'
                    : '${document.chunkCount} chunks',
              ),
              trailing: IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDelete(document),
              ),
            ),
          if (value.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No documents yet.', textAlign: TextAlign.center),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: memorizing
                ? const Center(child: CircularProgressIndicator())
                : OutlinedButton.icon(
                    onPressed: onAddSample,
                    icon: const Icon(Icons.add),
                    label: const Text('Add the sample guide'),
                  ),
          ),
        ],
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Results extends ConsumerWidget {
  const _Results(this.question);

  final String question;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(memorySearchProvider(question))) {
      // Check the error first: Riverpod keeps the previous value in it.
      AsyncError(:final error) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_message(error)),
            TextButton(
              onPressed: () => ref.invalidate(memorySearchProvider(question)),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
      AsyncData(value: []) => const Center(child: Text('Nothing found.')),
      AsyncData(:final value) => ListView(
        children: [for (final hit in value) _HitTile(hit)],
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _HitTile extends StatelessWidget {
  const _HitTile(this.hit);

  final SearchHit hit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hit.chunk.text, maxLines: 4, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  hit.chunk.documentTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                // Which search found it: meaning, words, or both.
                if (hit.byMeaning) const Chip(label: Text('meaning')),
                if (hit.byKeyword) const Chip(label: Text('keyword')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _message(Object error) =>
    error is Failure ? error.message : 'Something went wrong.';
