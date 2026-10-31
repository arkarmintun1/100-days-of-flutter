import 'package:fpdart/fpdart.dart';

import '../failures.dart';

/// Reads the lines of text in a photo (on-device OCR in the data layer).
abstract interface class ReceiptTextReader {
  Future<Either<Failure, List<String>>> readLines(String imagePath);
}
