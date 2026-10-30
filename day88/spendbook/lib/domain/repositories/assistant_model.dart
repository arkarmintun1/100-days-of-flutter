import '../entities/expense.dart';

/// A chat model that answers in a stream of text chunks (Day 73).
///
/// It remembers the conversation so far. Errors arrive in the stream as
/// Failures.
abstract interface class AssistantModel {
  Stream<String> send(String message);

  /// What the model did in the app (Day 74), e.g. an expense it added.
  Stream<AssistantAction> get actions;

  /// The chat is over (Day 74): an answer still on its way does nothing
  /// more in the app.
  void close();
}

/// Something the assistant did, so the UI can show it and undo it.
sealed class AssistantAction {}

final class ExpenseAdded extends AssistantAction {
  ExpenseAdded(this.expense);
  final Expense expense;
}
