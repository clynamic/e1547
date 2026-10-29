import 'package:e1547/pool/pool.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

extension PoolQuerying on PoolClient {
  static const queryDomain = 'pools';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Pool, int> get poolCache =>
      queryCache.bridge(queryKey, fromJson: Pool.fromJson);

  Query<Pool> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: poolCache.getConfig(vendored: vendored),
  );

  Query<List<Pool>> useSearch({required QueryMap? query, int limit = 5}) =>
      Query(
        cache: queryCache,
        key: [...queryKey, 'search', limit, query],
        queryFn: () => page(limit: limit, query: query).then((pools) {
          poolCache.savePage(pools);
          return pools;
        }),
      );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (key) =>
            page(page: key, query: query).then(poolCache.savePage),
      );
}
