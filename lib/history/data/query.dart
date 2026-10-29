import 'package:e1547/history/history.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

extension HistoryQuerying on HistoryClient {
  static const queryDomain = 'histories';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<History, int> get historyCache => queryCache.bridge(queryKey);

  Query<History> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: historyCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        queryFn: (key) =>
            page(page: key, query: query).then(historyCache.savePage),
      );

  Query<List<History>> useRecentSearches({
    required HistoryType type,
    int limit = 50,
  }) => Query(
    cache: queryCache,
    key: [...queryKey, 'recent_searches', type.name, limit],
    queryFn: () => page(
      limit: limit,
      query: HistoryParams(
        categories: {HistoryCategory.searches},
        types: {type},
      ).toQuery(),
    ),
  );

  Query<int> useCount() => Query(
    cache: queryCache,
    key: [...queryKey, 'count'],
    queryFn: () => count(),
  );

  Query<List<DateTime>> useDays() => Query(
    cache: queryCache,
    key: [...queryKey, 'days'],
    queryFn: () => days(),
  );

  Mutation<void, HistoryRequest> useAdd() => Mutation(
    mutationFn: (request) => add(request),
    onSuccess: (_, __) => queryCache.invalidateKey(queryKey),
  );

  Mutation<void, List<int>> useRemove() => Mutation(
    mutationFn: (ids) => removeAll(ids),
    onSuccess: (_, __) => queryCache.invalidateKey(queryKey),
  );

  Mutation<void, void> useClear() => Mutation(
    mutationFn: (_) => removeAll(null),
    onSuccess: (_, __) => queryCache.invalidateKey(queryKey),
  );
}
