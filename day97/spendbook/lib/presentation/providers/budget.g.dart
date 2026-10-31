// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The monthly budget in cents (null: not set yet).

@ProviderFor(MonthlyBudget)
final monthlyBudgetProvider = MonthlyBudgetProvider._();

/// The monthly budget in cents (null: not set yet).
final class MonthlyBudgetProvider
    extends $StreamNotifierProvider<MonthlyBudget, int?> {
  /// The monthly budget in cents (null: not set yet).
  MonthlyBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyBudgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyBudgetHash();

  @$internal
  @override
  MonthlyBudget create() => MonthlyBudget();
}

String _$monthlyBudgetHash() => r'94ecd21e4239b236c5c7e293663fc4ecbff2dd8b';

/// The monthly budget in cents (null: not set yet).

abstract class _$MonthlyBudget extends $StreamNotifier<int?> {
  Stream<int?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int?>, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int?>, int?>,
              AsyncValue<int?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
