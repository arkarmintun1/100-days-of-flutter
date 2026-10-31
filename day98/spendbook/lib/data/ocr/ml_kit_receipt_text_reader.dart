import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../domain/failures.dart';
import '../../domain/repositories/receipt_text_reader.dart';

/// On-device text recognition with Google's ML Kit (Android and iOS only).
/// The photo never leaves the phone.
class MlKitReceiptTextReader implements ReceiptTextReader {
  @override
  Future<Either<Failure, List<String>>> readLines(String imagePath) async {
    // Latin script: English receipts. Burmese text isn't supported by
    // ML Kit's text recognition.
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final text = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return right([
        for (final block in text.blocks)
          for (final line in block.lines) line.text,
      ]);
    } catch (error, stackTrace) {
      log('Text recognition error', error: error, stackTrace: stackTrace);
      return left(const ValidationFailure("Couldn't read this photo."));
    } finally {
      // Frees the native recognizer.
      await recognizer.close();
    }
  }
}
