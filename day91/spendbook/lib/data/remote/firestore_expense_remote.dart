import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../local/app_database.dart';
import '../models/expense_firestore.dart';

/// Day 91: users/{uid}/expenses in Cloud Firestore.
class FirestoreExpenseRemote {
  FirestoreExpenseRemote(this._db);

  final FirebaseFirestore _db;

  /// Expenses per batched write. A batch is one request, and a request
  /// has a size limit (10 MiB): many small batches stay far below it.
  static const batchSize = 200;

  CollectionReference<Map<String, dynamic>> _expenses(String userId) =>
      _db.collection('users').doc(userId).collection('expenses');

  /// Writes the rows; the expense's id is the document's id, so uploading
  /// the same row twice gives one document.
  Future<void> upload(String userId, List<ExpenseRow> rows) async {
    for (var start = 0; start < rows.length; start += batchSize) {
      final batch = _db.batch();
      for (final row in rows.skip(start).take(batchSize)) {
        batch.set(_expenses(userId).doc(row.id), row.toFirestore());
      }
      await batch.commit();
    }
  }

  /// Everything synced at or after [since] (Firestore's time, from
  /// [RemoteChanges.upTo]); everything when null.
  Future<RemoteChanges> changesSince(String userId, Timestamp? since) async {
    Query<Map<String, dynamic>> query = _expenses(userId);
    if (since != null) {
      // ">=": a document written in the same microsecond isn't missed.
      // Getting one twice is harmless.
      query = query.where('syncedAt', isGreaterThanOrEqualTo: since);
    }
    // From the server when it can be reached. Not Source.server: right
    // after the app starts, before Firestore has connected, that fails
    // with "unavailable". Without the server, the answer comes from the
    // memory cache (persistence is off), often empty: anything in it was
    // read before, so applying it again changes nothing, and pulledUpTo
    // can't move past a change we haven't seen.
    final snapshot = await query.orderBy('syncedAt').get();

    final rows = <ExpenseRow>[];
    Timestamp? upTo = since;
    var skipped = false;
    for (final doc in snapshot.docs) {
      final row = expenseRowFromFirestore(doc.id, doc.data());
      if (row == null) {
        log('Skipped an expense document Spendbook does not understand.');
      } else {
        rows.add(row);
      }
      // Stop moving forward at the first document we couldn't read: it's
      // asked for again every time, until an app update can read it.
      if (!skipped) {
        if (doc.data()['syncedAt'] case final Timestamp syncedAt) {
          upTo = syncedAt;
        }
      }
      if (row == null) skipped = true;
    }
    return RemoteChanges(rows, upTo);
  }
}

/// What [FirestoreExpenseRemote.changesSince] found, and how far it got.
class const RemoteChanges(final List<ExpenseRow> rows, final Timestamp? upTo);
