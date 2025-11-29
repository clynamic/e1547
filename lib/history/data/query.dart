import 'package:e1547/history/history.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

extension HistoryQuerying on HistoryClient {
  static const queryKey = 'histories';

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<History, int> get historyCache => queryCache.bridge<History, int>(
    queryKey,
    fetch: (id) => get(id: id, force: true),
  );

  Query<History> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [queryKey, id],
    queryFn: () => get(id: id, force: true),
    config: historyCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, query],
        getNextArg: (state) => state.nextPage,
        queryFn: (key) => page(
          page: key,
          query: query,
          force: true,
        ).then(historyCache.savePage),
      );

  Query<int> useCount() => Query(
    cache: queryCache,
    key: [queryKey, 'count'],
    queryFn: () => count(),
  );

  Query<List<DateTime>> useDays() =>
      Query(cache: queryCache, key: [queryKey, 'days'], queryFn: () => days());

  Mutation<void, HistoryRequest> useAdd() => Mutation(
    mutationFn: (request) => add(request),
    onSuccess: (_, __) => queryCache.invalidateCache(
      filterFn: (key, _) => key is List && key.first == queryKey,
    ),
  );

  Mutation<void, List<int>> useRemove() => Mutation(
    mutationFn: (ids) => removeAll(ids),
    onSuccess: (_, __) => queryCache.invalidateCache(
      filterFn: (key, _) => key is List && key.first == queryKey,
    ),
  );
}
