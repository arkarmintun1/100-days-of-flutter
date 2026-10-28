// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All expenses, newest first, kept up to date by the database.
///
/// It only calls use cases: no Drift, no SQL, no business rules here.

@ProviderFor(ExpenseList)
final expenseListProvider = ExpenseListProvider._();

/// All expenses, newest first, kept up to date by the database.
///
/// It only calls use cases: no Drift, no SQL, no business rules here.
final class ExpenseListProvider
    extends $StreamNotifierProvider<ExpenseList, List<Expense>> {
  /// All expenses, newest first, kept up to date by the database.
  ///
  /// It only calls use cases: no Drift, no SQL, no business rules here.
  ExpenseListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListHash();

  @$internal
  @override
  ExpenseList create() => ExpenseList();
}

String _$expenseListHash() => r'268de41a9a72b1056b325561fb18d33a82c540ff';

/// All expenses, newest first, kept up to date by the database.
///
/// It only calls use cases: no Drift, no SQL, no business rules here.

abstract class _$ExpenseList extends $StreamNotifier<List<Expense>> {
  Stream<List<Expense>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Expense>>, List<Expense>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Expense>>, List<Expense>>,
              AsyncValue<List<Expense>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
