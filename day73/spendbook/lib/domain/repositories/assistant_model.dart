/// A chat model that answers in a stream of text chunks (Day 73).
///
/// It remembers the conversation so far. Errors arrive in the stream as
/// Failures.
abstract interface class AssistantModel {
  Stream<String> send(String message);
}
