import 'package:flutter_test/flutter_test.dart';
import 'package:spendbook/presentation/assistant/answer_transport.dart';

void main() {
  test('piecesAtBraces cuts before every {', () {
    expect(piecesAtBraces('a {b} {c}'), ['a ', '{b} ', '{c}']);
    expect(piecesAtBraces('{"a":{"b":1}}'), ['{"a":', '{"b":1}}']);
    expect(piecesAtBraces('no braces'), ['no braces']);
    expect(piecesAtBraces(''), ['']);
  });
}
