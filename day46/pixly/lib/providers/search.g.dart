// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The search box: waits for a short pause in typing before it sets [query].

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// The search box: waits for a short pause in typing before it sets [query].
final class SearchQueryProvider
    extends $NotifierProvider<SearchQuery, SearchInput> {
  /// The search box: waits for a short pause in typing before it sets [query].
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchInput value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchInput>(value),
    );
  }
}

String _$searchQueryHash() => r'd4a3cdb74027cb1b6c50a753ef0a450fd90a9eff';

/// The search box: waits for a short pause in typing before it sets [query].

abstract class _$SearchQuery extends $Notifier<SearchInput> {
  SearchInput build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SearchInput, SearchInput>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchInput, SearchInput>,
              SearchInput,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The results for one [query], page by page.
///
/// One provider per query (a "family"). It is autoDispose: when the query
/// changes, nothing listens to the old one any more, so it is disposed and
/// its request is cancelled. Results that loaded are kept for
/// [cacheDuration] from when they loaded.

@ProviderFor(SearchResults)
final searchResultsProvider = SearchResultsFamily._();

/// The results for one [query], page by page.
///
/// One provider per query (a "family"). It is autoDispose: when the query
/// changes, nothing listens to the old one any more, so it is disposed and
/// its request is cancelled. Results that loaded are kept for
/// [cacheDuration] from when they loaded.
final class SearchResultsProvider
    extends $AsyncNotifierProvider<SearchResults, PhotoFeed> {
  /// The results for one [query], page by page.
  ///
  /// One provider per query (a "family"). It is autoDispose: when the query
  /// changes, nothing listens to the old one any more, so it is disposed and
  /// its request is cancelled. Results that loaded are kept for
  /// [cacheDuration] from when they loaded.
  SearchResultsProvider._({
    required SearchResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: noRetry,
         name: r'searchResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @override
  String toString() {
    return r'searchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchResults create() => SearchResults();

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultsHash() => r'fa4716ce756411661942c1f8d5df19040b65a2f6';

/// The results for one [query], page by page.
///
/// One provider per query (a "family"). It is autoDispose: when the query
/// changes, nothing listens to the old one any more, so it is disposed and
/// its request is cancelled. Results that loaded are kept for
/// [cacheDuration] from when they loaded.

final class SearchResultsFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchResults,
          AsyncValue<PhotoFeed>,
          PhotoFeed,
          FutureOr<PhotoFeed>,
          String
        > {
  SearchResultsFamily._()
    : super(
        retry: noRetry,
        name: r'searchResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The results for one [query], page by page.
  ///
  /// One provider per query (a "family"). It is autoDispose: when the query
  /// changes, nothing listens to the old one any more, so it is disposed and
  /// its request is cancelled. Results that loaded are kept for
  /// [cacheDuration] from when they loaded.

  SearchResultsProvider call(String query) =>
      SearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchResultsProvider';
}

/// The results for one [query], page by page.
///
/// One provider per query (a "family"). It is autoDispose: when the query
/// changes, nothing listens to the old one any more, so it is disposed and
/// its request is cancelled. Results that loaded are kept for
/// [cacheDuration] from when they loaded.

abstract class _$SearchResults extends $AsyncNotifier<PhotoFeed> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<PhotoFeed> build(String query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PhotoFeed>, PhotoFeed>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PhotoFeed>, PhotoFeed>,
              AsyncValue<PhotoFeed>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// The last searches that loaded (with or without photos), newest first.

@ProviderFor(RecentSearches)
final recentSearchesProvider = RecentSearchesProvider._();

/// The last searches that loaded (with or without photos), newest first.
final class RecentSearchesProvider
    extends $NotifierProvider<RecentSearches, List<String>> {
  /// The last searches that loaded (with or without photos), newest first.
  RecentSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesHash();

  @$internal
  @override
  RecentSearches create() => RecentSearches();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentSearchesHash() => r'ae432685d966b591cb95fec2482c723d7b479b4d';

/// The last searches that loaded (with or without photos), newest first.

abstract class _$RecentSearches extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
