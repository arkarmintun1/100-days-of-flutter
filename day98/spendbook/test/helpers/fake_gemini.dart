import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake network for the real firebase_ai SDK (Day 70–71): records the
/// requests and answers each one with [answer].
class FakeGemini {
  FakeGemini(http.Response Function() answer)
    : client = MockClient((request) async {
        _last.add(request);
        return answer();
      });

  final http.Client client;
  static final _last = <http.Request>[];

  /// Forget earlier requests (they're kept across instances).
  static void reset() => _last.clear();

  /// The JSON body of the latest request.
  Map<String, Object?> get lastBody =>
      jsonDecode(_last.last.body) as Map<String, Object?>;

  Uri get lastUrl => _last.last.url;

  /// A generateContent answer in the Gemini API's JSON shape.
  static http.Response text(String text) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'role': 'model',
            'parts': [
              {'text': text},
            ],
          },
          'finishReason': 'STOP',
        },
      ],
    }),
    200,
    headers: {'content-type': 'application/json'},
  );

  /// A streamed answer (streamGenerateContent?alt=sse): one
  /// `data: {json}` line per chunk (Day 73).
  static http.Response sse(List<String> chunks) => http.Response(
    [
      for (final chunk in chunks)
        'data: ${jsonEncode({
          'candidates': [
            {
              'content': {
                'role': 'model',
                'parts': [
                  {'text': chunk},
                ],
              },
            },
          ],
        })}\r\n\r\n',
    ].join(),
    200,
    headers: {'content-type': 'text/event-stream'},
  );

  /// All the request bodies so far.
  List<Map<String, Object?>> get bodies => [
    for (final request in _last)
      jsonDecode(request.body) as Map<String, Object?>,
  ];

  /// Day 74: an answer that asks the app to run functions.
  static http.Response functionCalls(
    List<(String, Map<String, Object?>)> calls,
  ) => http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'role': 'model',
            'parts': [
              for (final (name, args) in calls)
                {
                  'functionCall': {'name': name, 'args': args},
                },
            ],
          },
          'finishReason': 'STOP',
        },
      ],
    }),
    200,
    headers: {'content-type': 'application/json'},
  );

  /// An error answer, as the API sends it.
  static http.Response error(int code, String message, String status) =>
      http.Response(
        jsonEncode({
          'error': {'code': code, 'message': message, 'status': status},
        }),
        code,
        headers: {'content-type': 'application/json'},
      );
}
