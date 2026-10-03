import 'dart:async';

import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/shared/shared.dart';
export 'package:cached_query_flutter/cached_query_flutter.dart';

bool _liveFetch(Object key, Object? data, DateTime createdAt) => true;

bool _vendoredFetch(Object key, Object? data, DateTime createdAt) => false;

const Duration queryStorageDuration = Duration(days: 1);

InfiniteQueryData<List<int>, int> pagedIdsFromJson(dynamic json) =>
    InfiniteQueryData<List<int>, int>.fromJson(
      json,
      pagesConverter: (pages) =>
          pages.map((page) => (page as List).cast<int>()).toList(),
      argsConverter: (args) => args.cast<int>(),
    );

QueryConfig<InfiniteQueryData<List<int>, int>> pagedIdConfig() =>
    const QueryConfig(
      storeQuery: true,
      storageDuration: queryStorageDuration,
      storageDeserializer: pagedIdsFromJson,
    );

/// Like [pagedIdsFromJson], but for queries whose page arguments may be either
/// a page number or a server cursor.
///
/// Args stored as ints by older versions deserialize unchanged, since casting
/// to [Object] keeps them as they are.
InfiniteQueryData<List<int>, Object> pagedObjectIdsFromJson(dynamic json) =>
    InfiniteQueryData<List<int>, Object>.fromJson(
      json,
      pagesConverter: (pages) =>
          pages.map((page) => (page as List).cast<int>()).toList(),
      argsConverter: (args) => args.cast<Object>(),
    );

QueryConfig<InfiniteQueryData<List<int>, Object>> pagedObjectIdConfig() =>
    const QueryConfig(
      storeQuery: true,
      storageDuration: queryStorageDuration,
      storageDeserializer: pagedObjectIdsFromJson,
    );

/// Cache normalisation intermediary
class QueryBridge<T, K> {
  QueryBridge({
    required this.cache,
    required this.baseKey,
    required this.getId,
    this.fromJson,
  });

  final CachedQuery cache;
  final List<Object> baseKey;
  final K Function(T) getId;

  final Deserializer<T>? fromJson;

  Query<T>? _getQuery(K id) => cache.getQuery<Query<T>>([...baseKey, id]);

  /// Identical for equal [vendored], so that a rebuild reuses the query facade
  /// instead of replacing it, which resets its state to [QueryInitial].
  static ShouldFetch<T> vendorFetch<T>(bool? vendored) =>
      (vendored ?? false) ? _vendoredFetch : _liveFetch;

  QueryConfig<T> getConfig({bool? vendored}) => QueryConfig(
    shouldFetch: vendorFetch<T>(vendored),
    storeQuery: fromJson != null,
    storageDuration: fromJson != null ? queryStorageDuration : null,
    storageDeserializer: fromJson,
  );

  T? get(K id) {
    final itemQuery = _getQuery(id);
    return itemQuery?.state.data;
  }

  void update(K id, T Function(T) updateFn) {
    final itemQuery = _getQuery(id);
    if (itemQuery != null) {
      final current = itemQuery.state.data;
      if (current != null) {
        final updated = updateFn(current);
        if (updated != current) {
          itemQuery.setData(updated);
        }
      }
    }
  }

  void set(T item) =>
      cache.setQueryData<T>(key: [...baseKey, getId(item)], data: item);

  List<K> savePage(List<T> items) {
    for (final item in items) {
      set(item);
    }
    return items.map(getId).toList();
  }

  Future<R> optimistic<R>(
    K id,
    T Function(T) updateFn,
    Future<R> Function() callback,
  ) async {
    final itemQuery = _getQuery(id);
    if (itemQuery == null) return callback();

    final current = itemQuery.state.data;
    if (current == null) return callback();

    T previous = current;
    try {
      final updated = updateFn(current);
      if (updated != current) {
        itemQuery.setData(updated);
      }
      final result = await callback();
      return result;
    } on Object {
      itemQuery.setData(previous);
      rethrow;
    }
  }

  void invalidate(K id) {
    final itemQuery = _getQuery(id);
    itemQuery?.invalidate();
  }
}

extension QueryCacheBridging on CachedQuery {
  static K _dynamicGetId<T, K>(T item) {
    try {
      return (item as dynamic).id as K;
      // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      throw ArgumentError(
        'Item does not have an id property. '
        'Either add an id property to the item or provide a custom getId function.',
      );
    }
  }

  QueryBridge<T, K> bridge<T, K>(
    List<Object> key, {
    K Function(T)? getId,
    Deserializer<T>? fromJson,
  }) => QueryBridge(
    cache: this,
    baseKey: key,
    getId: getId ?? _dynamicGetId,
    fromJson: fromJson,
  );

  Future<void> invalidateKey(
    List<Object> key, {
    bool Function(QueryMap params)? where,
  }) => invalidateCache(
    filterFn: (unencoded, _) {
      if (unencoded is! List || unencoded.length < key.length) return false;
      for (int i = 0; i < key.length; i++) {
        if (unencoded[i] != key[i]) return false;
      }
      if (where == null) return true;
      final params = unencoded.elementAtOrNull(key.length);
      if (params is! QueryMap) return false;
      return where(params);
    },
  );
}
