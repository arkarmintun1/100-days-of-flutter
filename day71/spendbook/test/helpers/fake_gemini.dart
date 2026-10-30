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
