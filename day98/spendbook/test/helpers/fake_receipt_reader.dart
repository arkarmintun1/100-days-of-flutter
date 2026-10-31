import 'package:fpdart/fpdart.dart';
import 'package:spendbook/domain/entities/receipt_draft.dart';
import 'package:spendbook/domain/failures.dart';
import 'package:spendbook/domain/repositories/receipt_reader.dart';

/// Day 72: stands in for Gemini reading a receipt photo.
class FakeReceiptReader implements ReceiptReader {
  FakeReceiptReader(this.result);

  final Either<Failure, ReceiptDraft> result;
  final paths = <String>[];

  @override
  Future<Either<Failure, ReceiptDraft>> read(String imagePath) async {
    paths.add(imagePath);
    return result;
  }
}
