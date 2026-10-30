import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';

import '../../domain/add_document_file.dart';
import '../../domain/document_file.dart';
import '../../domain/failures.dart';

/// Opens the system's file picker for the vault (Day 77). Null if the
/// user cancelled. Throws a Failure if the file can't be used.
Future<DocumentFile?> pickDocument() async {
  // Each platform filters by a different kind of type (file_selector's
  // README): extensions and MIME types on Android, Apple's uniform type
  // identifiers (UTIs) on iOS.
  const types = XTypeGroup(
    label: 'Documents',
    extensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
    mimeTypes: ['application/pdf', 'image/png', 'image/jpeg', 'image/webp'],
    uniformTypeIdentifiers: [
      'com.adobe.pdf',
      'public.png',
      'public.jpeg',
      'org.webmproject.webp',
    ],
  );
  final file = await openFile(acceptedTypeGroups: [types]);
  if (file == null) return null;
  final extension = file.name.split('.').last.toLowerCase();
  try {
    // Check the size before the file is read, base64-encoded and sent to
    // Gemini. On iOS the
    // XFile is a file on disk, so a huge one is never read. On Android,
    // file_selector has already read it all before Dart gets it.
    if (await file.length() > AddDocumentFile.maxBytes) {
      throw const ValidationFailure('This file is too big (14 MB at most).');
    }
    return DocumentFile(
      name: file.name,
      // Our own table, not file.mimeType: that can be null on some
      // platforms. An unknown type is rejected when it's added.
      mimeType: DocumentFile.mimeTypes[extension] ?? 'unknown',
      bytes: await file.readAsBytes(),
    );
  } on FileSystemException catch (e) {
    log('Could not read the file', error: e);
    throw const StorageFailure("Couldn't open the file.");
  }
}
