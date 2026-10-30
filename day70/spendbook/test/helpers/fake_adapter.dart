import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A Dio adapter that never touches the network.
/// [handler] decides what each request returns; [requests] records them.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final ResponseBody Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  static ResponseBody json(
    Object body, {
    int status = 200,
    Map<String, String> headers = const {},
  }) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final MapEntry(:key, :value) in headers.entries) key: [value],
      },
    );
  }

  static Map<String, dynamic> fixture(String name) =>
      jsonDecode(File('test/fixtures/$name.json').readAsStringSync())
          as Map<String, dynamic>;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}
