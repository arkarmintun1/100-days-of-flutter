import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/answer.dart';
import '../../domain/failures.dart';
import '../providers/dependencies.dart';

/// One message pair on the screen: the question, then the answer as far
/// as it has arrived, or what went wrong.
class _Exchange {
  _Exchange(this.question);
  final String question;
  Answer? answer;
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
  StreamSubscription<Answer>? _answering;

  bool get _waiting => _answering != null;

  @override
  void dispose() {
    _answering?.cancel();
    _question.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _question.text.trim();
    if (text.isEmpty || _waiting) return;
    final exchange = _Exchange(text);
    _question.clear();
    setState(() => _exchanges.add(exchange));
    _answering = ref
        .read(tripChatProvider)
        .ask(text)
        .listen(
          // Each event is the whole answer so far.
          (answer) => setState(() => exchange.answer = answer),
          onError: (Object error) => setState(() {
            exchange.error = error is Failure
                ? error.message
                : 'Something went wrong.';
            _answering = null;
          }),
          onDone: () => setState(() {
            exchange.done = true;
            _answering = null;
          }),
          cancelOnError: true,
        );
  }

  void _newChat() {
    _answering?.cancel();
    ref.read(tripChatProvider).clear();
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
                        _ExchangeView(exchange),
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
  const _ExchangeView(this.exchange);

  final _Exchange exchange;

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
        if (exchange.error case final error?)
          Text(error, style: TextStyle(color: colors.error))
        else if (answer == null && !exchange.done)
          const Align(
            alignment: Alignment.centerLeft,
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          )
        else if (answer != null) ...[
          SelectableText(answer.text),
          // Sources once the answer is complete: the [n]s can still
          // change while it streams.
          if (exchange.done)
            Wrap(
              spacing: 8,
              children: [
                for (final n in answer.cited)
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

  void _showSource(BuildContext context, Answer answer, int n) {
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
