import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genui/genui.dart';

import '../../domain/answer.dart';
import '../../domain/booking.dart';
import '../../domain/failures.dart';
import '../../domain/trip_chat.dart';
import '../chat/answer_parser.dart';
import '../chat/trip_catalog.dart';
import '../providers/dependencies.dart';
import '../widgets/booking_tile.dart';
import '../widgets/thinking_indicator.dart';

/// One message pair on the screen: the question, then the answer as far
/// as it has arrived, or what went wrong.
class _Exchange {
  _Exchange(this.question, this.parser);
  final String question;

  /// Day 83: the answer's text and UI, parsed out of the stream.
  final AnswerParser parser;
  ChatReply? answer;
  String? error;
  var done = false;
}

/// Day 79: chat with Trip Buddy about your documents.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _question = TextEditingController();
  final _scroll = ScrollController();
  final _exchanges = <_Exchange>[];
  StreamSubscription<ChatReply>? _answering;

  /// Day 80: bookings the user took back with Undo.
  final _undone = <int>{};

  bool get _waiting => _answering != null;

  @override
  void dispose() {
    _answering?.cancel();
    for (final exchange in _exchanges) {
      exchange.parser.dispose();
    }
    _question.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _question.text.trim();
    if (text.isEmpty || _waiting) return;
    final exchange = _Exchange(
      text,
      AnswerParser(
        tripCatalog,
        onChanged: () {
          if (mounted) setState(() {});
        },
      ),
    );
    _question.clear();
    setState(() => _exchanges.add(exchange));
    _answering = ref
        .read(tripChatProvider)
        .ask(text)
        .listen(
          // Each event is the whole answer so far.
          (answer) => setState(() {
            exchange.answer = answer;
            exchange.parser.update(answer.text);
          }),
          onError: (Object error) => setState(() {
            exchange.error = error is Failure
                ? error.message
                : 'Something went wrong.';
            _answering = null;
          }),
          onDone: () => setState(() {
            exchange.done = true;
            exchange.parser.close();
            _answering = null;
          }),
          cancelOnError: true,
        );
  }

  /// Day 80: delete a booking the assistant added, and tell it.
  Future<void> _undo(Booking booking) async {
    try {
      await ref.read(itineraryProvider).delete(booking.id);
    } on Failure catch (failure) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }
    ref.read(tripChatProvider).noteUndone(booking);
    if (mounted) setState(() => _undone.add(booking.id));
  }

  void _newChat() {
    _answering?.cancel();
    ref.read(tripChatProvider).clear();
    for (final exchange in _exchanges) {
      exchange.parser.dispose();
    }
    setState(() {
      _answering = null;
      _exchanges.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            tooltip: 'New chat',
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _exchanges.isEmpty ? null : _newChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _exchanges.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Ask about your trip. Answers come from the '
                        'documents in your vault.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    controller: _scroll,
                    // Newest at the bottom, and the list starts there.
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final exchange in _exchanges.reversed)
                        _ExchangeView(exchange, undone: _undone, onUndo: _undo),
                    ],
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _question,
                      enabled: !_waiting,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'When does my flight land?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Send',
                    icon: const Icon(Icons.send),
                    onPressed: _waiting ? null : _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExchangeView extends StatelessWidget {
  const _ExchangeView(
    this.exchange, {
    required this.undone,
    required this.onUndo,
  });

  final _Exchange exchange;
  final Set<int> undone;
  final void Function(Booking booking) onUndo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final answer = exchange.answer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.only(left: 48, bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(exchange.question),
          ),
        ),
        // Day 80: what Trip Buddy did, with an Undo (Spendbook, Day 74),
        // also when the answer failed after it.
        if (answer != null)
          for (final booking in answer.added)
            Card(
              child: BookingTile(
                booking,
                prefix: undone.contains(booking.id) ? 'Removed' : 'Added',
                trailing: undone.contains(booking.id)
                    ? null
                    : TextButton(
                        onPressed: () => onUndo(booking),
                        child: const Text('Undo'),
                      ),
              ),
            ),
        if (exchange.error case final error?)
          Text(error, style: TextStyle(color: colors.error))
        else if (answer == null && !exchange.done)
          // Day 85: Rive instead of a spinner.
          const Align(
            alignment: Alignment.centerLeft,
            child: ThinkingIndicator(),
          )
        else if (answer != null) ...[
          // Day 83: the text without the A2UI JSON, then the widgets.
          if (exchange.parser.text.trim().isNotEmpty)
            SelectableText(exchange.parser.text.trim()),
          for (final id in exchange.parser.surfaceIds)
            Surface(
              key: ValueKey(id),
              surfaceContext: exchange.parser.surfaces.contextFor(id),
            ),
          if (exchange.parser.error != null)
            Text(
              "Couldn't show part of the answer.",
              style: TextStyle(color: colors.error),
            ),
          // Sources once the answer is complete: the [n]s can still
          // change while it streams.
          if (exchange.done)
            Wrap(
              spacing: 8,
              children: [
                for (final n in citations(
                  exchange.parser.text,
                  answer.sources.length,
                ))
                  ActionChip(
                    label: Text(
                      '[$n] ${answer.sources[n - 1].chunk.documentTitle}',
                    ),
                    onPressed: () => _showSource(context, answer, n),
                  ),
              ],
            ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  void _showSource(BuildContext context, ChatReply answer, int n) {
    final chunk = answer.sources[n - 1].chunk;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[$n] ${chunk.documentTitle}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SelectableText(chunk.text),
            ],
          ),
        ),
      ),
    );
  }
}
