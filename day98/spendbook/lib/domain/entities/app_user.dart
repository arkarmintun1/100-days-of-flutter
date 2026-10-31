import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

/// Who is using Spendbook (Day 90). A guest has an id, but no email yet.
@freezed
class const AppUser({
  /// Stays the same when a guest makes an account, so what was saved
  /// under it stays theirs (Day 91).
  required final String id,
  final String? email,
}) with _$AppUser {
  bool get isGuest => email == null;
}
