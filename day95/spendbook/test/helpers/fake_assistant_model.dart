import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart' show basicCatalogId;
import 'package:spendbook/domain/repositories/assistant_model.dart';

/// Streams prepared chunks, like Gemini would (Day 73).
class FakeAssistantModel implements AssistantModel {
  FakeAssistantModel(
    this.chunks, {
    this.error,
    this.actionsToReport = const [],
    this.hold,
  });

  final List<String> chunks;
  final Object? error;

  /// If set, the answer only ends when this completes.
  final Future<void>? hold;

  /// Day 74: actions "the model" takes while answering.
  final List<AssistantAction> actionsToReport;
  final _actions = StreamController<AssistantAction>.broadcast();

  @override
  Stream<AssistantAction> get actions => _actions.stream;

  var closed = false;

  @override
  void close() => closed = true;
  final requests = <String>[];
  String? instructions;

  @override
  Stream<String> send(String message) async* {
    requests.add(message);
    actionsToReport.forEach(_actions.add);
    for (final chunk in chunks) {
      yield chunk;
    }
    if (hold case final hold?) await hold;
    if (error case final error?) throw error;
  }

  /// An answer in A2UI: create a surface, then fill it with components.
  /// One JSON message per line, without the ```json fences GenUI's
  /// prompt asks for: a model may skip them, and this is the harder case.
  static List<String> answer(
    String surfaceId,
    List<Map<String, Object?>> c,
  ) => [
    'Here is your month.\n',
    '${jsonEncode({
      'version': 'v0.9',
      'createSurface': {'surfaceId': surfaceId, 'catalogId': basicCatalogId},
    })}\n',
    '${jsonEncode({
      'version': 'v0.9',
      'updateComponents': {'surfaceId': surfaceId, 'components': c},
    })}\n',
  ];
}

/// Lets an answer finish in a widget test. GenUI's parser sends the end
/// of its stream through a future made outside the test's fake clock, so
/// `pumpAndSettle` alone would wait for it forever (Day 73).
Future<void> finishAnswer(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(Duration.zero));
  await tester.pumpAndSettle();
}
