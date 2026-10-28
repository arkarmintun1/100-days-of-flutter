// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'8a644d41ebab6efe60fe4fa590d83036f91a7132';

/// The domain's interface, implemented by the data layer.

@ProviderFor(expenseRepository)
final expenseRepositoryProvider = ExpenseRepositoryProvider._();

/// The domain's interface, implemented by the data layer.

final class ExpenseRepositoryProvider
    extends
        $FunctionalProvider<
          ExpenseRepository,
          ExpenseRepository,
          ExpenseRepository
        >
    with $Provider<ExpenseRepository> {
  /// The domain's interface, implemented by the data layer.
  ExpenseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExpenseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExpenseRepository create(Ref ref) {
    return expenseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseRepository>(value),
    );
  }
}

String _$expenseRepositoryHash() => r'6e2a7bfec772ce05e6ac18b6bf2938e4c472de9e';

/// The current time. Tests override it to get a fixed "now".

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The current time. Tests override it to get a fixed "now".

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// The current time. Tests override it to get a fixed "now".
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(addExpense)
final addExpenseProvider = AddExpenseProvider._();

final class AddExpenseProvider
    extends $FunctionalProvider<AddExpense, AddExpense, AddExpense>
    with $Provider<AddExpense> {
  AddExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addExpenseHash();

  @$internal
  @override
  $ProviderElement<AddExpense> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddExpense create(Ref ref) {
    return addExpense(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddExpense value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddExpense>(value),
    );
  }
}

String _$addExpenseHash() => r'607443b46998f787b9add5d3b902e19b2a8fd3ae';

@ProviderFor(deleteExpense)
final deleteExpenseProvider = DeleteExpenseProvider._();

final class DeleteExpenseProvider
    extends $FunctionalProvider<DeleteExpense, DeleteExpense, DeleteExpense>
    with $Provider<DeleteExpense> {
  DeleteExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteExpenseHash();

  @$internal
  @override
  $ProviderElement<DeleteExpense> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteExpense create(Ref ref) {
    return deleteExpense(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteExpense value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteExpense>(value),
    );
  }
}

String _$deleteExpenseHash() => r'b1cfffc6d422efbb7ccf5dd860e43c8d6593323a';

@ProviderFor(watchExpenses)
final watchExpensesProvider = WatchExpensesProvider._();

final class WatchExpensesProvider
    extends $FunctionalProvider<WatchExpenses, WatchExpenses, WatchExpenses>
    with $Provider<WatchExpenses> {
  WatchExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchExpensesHash();

  @$internal
  @override
  $ProviderElement<WatchExpenses> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WatchExpenses create(Ref ref) {
    return watchExpenses(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchExpenses value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchExpenses>(value),
    );
  }
}

String _$watchExpensesHash() => r'bcb226f8bcda42507fcb7db976571e8f507edd77';

@ProviderFor(budgetRepository)
final budgetRepositoryProvider = BudgetRepositoryProvider._();

final class BudgetRepositoryProvider
    extends
        $FunctionalProvider<
          BudgetRepository,
          BudgetRepository,
          BudgetRepository
        >
    with $Provider<BudgetRepository> {
  BudgetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetRepository create(Ref ref) {
    return budgetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRepository>(value),
    );
  }
}

String _$budgetRepositoryHash() => r'b4e27874123ef1f7339d00194666f0dc2867be37';

@ProviderFor(watchMonthlyBudget)
final watchMonthlyBudgetProvider = WatchMonthlyBudgetProvider._();

final class WatchMonthlyBudgetProvider
    extends
        $FunctionalProvider<
          WatchMonthlyBudget,
          WatchMonthlyBudget,
          WatchMonthlyBudget
        >
    with $Provider<WatchMonthlyBudget> {
  WatchMonthlyBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchMonthlyBudgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchMonthlyBudgetHash();

  @$internal
  @override
  $ProviderElement<WatchMonthlyBudget> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WatchMonthlyBudget create(Ref ref) {
    return watchMonthlyBudget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WatchMonthlyBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WatchMonthlyBudget>(value),
    );
  }
}

String _$watchMonthlyBudgetHash() =>
    r'1e8ae185accd6134fb9e81fc602ea08f751c7d59';

@ProviderFor(setMonthlyBudget)
final setMonthlyBudgetProvider = SetMonthlyBudgetProvider._();

final class SetMonthlyBudgetProvider
    extends
        $FunctionalProvider<
          SetMonthlyBudget,
          SetMonthlyBudget,
          SetMonthlyBudget
        >
    with $Provider<SetMonthlyBudget> {
  SetMonthlyBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setMonthlyBudgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setMonthlyBudgetHash();

  @$internal
  @override
  $ProviderElement<SetMonthlyBudget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetMonthlyBudget create(Ref ref) {
    return setMonthlyBudget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetMonthlyBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetMonthlyBudget>(value),
    );
  }
}

String _$setMonthlyBudgetHash() => r'f8fc0012705ca96273e8dc4744aed158c0eac704';
