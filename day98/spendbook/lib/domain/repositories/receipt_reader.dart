import 'package:fpdart/fpdart.dart';

import '../entities/receipt_draft.dart';
import '../failures.dart';

/// Reads a receipt photo straight into a draft (Day 72), e.g. with a
/// multimodal AI model. Day 64's ML Kit only reads text: the parsing is
/// then done by the ScanReceipt use case.
abstract interface class ReceiptReader {
  Future<Either<Failure, ReceiptDraft>> read(String imagePath);
}
