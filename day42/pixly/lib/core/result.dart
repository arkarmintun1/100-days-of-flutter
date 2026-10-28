import 'package:pixly/core/error_kind.dart';

/// Either a value or an error message - the Result pattern from Day 9.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, {this.kind = ErrorKind.unknown});
  final String message;
  final ErrorKind kind;
}
