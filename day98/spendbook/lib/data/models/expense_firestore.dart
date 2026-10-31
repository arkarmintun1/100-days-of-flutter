import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_category.dart';
import '../local/app_database.dart';

/// Day 91: an expense row as a Firestore document, and back.
extension ExpenseRowFirestore on ExpenseRow {
  Map<String, Object?> toFirestore() => {
    'title': title,
    'amountCents': amountCents,
    'category': category.name,
    'date': Timestamp.fromDate(date),
    'note': note,
    'original': originalCurrency == null
        ? null
        : {
            'currency': originalCurrency,
            'minorUnits': originalMinorUnits,
            'decimalDigits': originalDecimalDigits,
          },
    'updatedAt': updatedAt,
    'deleted': deleted,
    // Firestore's own clock, set when the write reaches the server: what
    // other phones ask for ("changes since"), whatever their clocks say.
    'syncedAt': FieldValue.serverTimestamp(),
  };
}

/// Null when the document isn't an expense this app understands, e.g. a
/// category from a newer version of the app.
ExpenseRow? expenseRowFromFirestore(String id, Map<String, Object?> data) {
  try {
    final original = data['original'] as Map<String, Object?>?;
    return ExpenseRow(
      id: id,
      title: data['title']! as String,
      amountCents: data['amountCents']! as int,
      category: ExpenseCategory.values.byName(data['category']! as String),
      date: (data['date']! as Timestamp).toDate(),
      note: data['note'] as String?,
      originalCurrency: original?['currency'] as String?,
      originalMinorUnits: original?['minorUnits'] as int?,
      originalDecimalDigits: original?['decimalDigits'] as int?,
      updatedAt: data['updatedAt']! as int,
      deleted: data['deleted']! as bool,
      dirty: false,
    );
  } on Object {
    // A missing field (null!) or a wrong type: skip this document.
    return null;
  }
}
