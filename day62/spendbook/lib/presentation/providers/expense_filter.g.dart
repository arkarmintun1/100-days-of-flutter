// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentFilter)
final currentFilterProvider = CurrentFilterProvider._();

final class CurrentFilterProvider
    extends $NotifierProvider<CurrentFilter, ExpenseFilter> {
  CurrentFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentFilterHash();

  @$internal
  @override
  CurrentFilter create() => CurrentFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseFilter>(value),
    );
  }
}

String _$currentFilterHash() => r'86f1feffd91dfeb4ba175d11ffd353b3c4045484';

abstract class _$CurrentFilter extends $Notifier<ExpenseFilter> {
  ExpenseFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExpenseFilter, ExpenseFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExpenseFilter, ExpenseFilter>,
              ExpenseFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The expenses that match the filter, newest first.

@ProviderFor(filteredExpenses)
final filteredExpensesProvider = FilteredExpensesProvider._();

/// The expenses that match the filter, newest first.

final class FilteredExpensesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          AsyncValue<List<Expense>>,
          AsyncValue<List<Expense>>
        >
    with $Provider<AsyncValue<List<Expense>>> {
  /// The expenses that match the filter, newest first.
  FilteredExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredExpensesHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Expense>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Expense>> create(Ref ref) {
    return filteredExpenses(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Expense>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Expense>>>(value),
    );
  }
}

String _$filteredExpensesHash() => r'1399520238753f2c7c4e5bde5896434c54ed7347';

@ProviderFor(summarizeMonth)
final summarizeMonthProvider = SummarizeMonthProvider._();

final class SummarizeMonthProvider
    extends $FunctionalProvider<SummarizeMonth, SummarizeMonth, SummarizeMonth>
    with $Provider<SummarizeMonth> {
  SummarizeMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'summarizeMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$summarizeMonthHash();

  @$internal
  @override
  $ProviderElement<SummarizeMonth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SummarizeMonth create(Ref ref) {
    return summarizeMonth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SummarizeMonth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SummarizeMonth>(value),
    );
  }
}

String _$summarizeMonthHash() => r'dbdb5ea0ec649ada154ed04234c6347799adc8e7';

/// The whole month's totals (all categories), for the header and charts.

@ProviderFor(monthSummary)
final monthSummaryProvider = MonthSummaryProvider._();

/// The whole month's totals (all categories), for the header and charts.

final class MonthSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlySummary>,
          AsyncValue<MonthlySummary>,
          AsyncValue<MonthlySummary>
        >
    with $Provider<AsyncValue<MonthlySummary>> {
  /// The whole month's totals (all categories), for the header and charts.
  MonthSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthSummaryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<MonthlySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<MonthlySummary> create(Ref ref) {
    return monthSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<MonthlySummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<MonthlySummary>>(value),
    );
  }
}

String _$monthSummaryHash() => r'8d4ead19fa268af11203d11445ef5d58fe03af88';
