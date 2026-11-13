import 'package:e1547/pool/pool.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

final Expando<QueryLoader<int, Pool>> _poolLoaders = Expando();

extension PoolQuerying on PoolClient {
  static const queryDomain = 'pools';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Pool, int> get poolCache =>
      queryCache.bridge(queryKey, fromJson: Pool.fromJson);

  QueryLoader<int, Pool> get poolLoader => _poolLoaders[this] ??= poolCache
      .loader((ids) => byIds(ids: ids), limit: maxPageLimit);

  Query<Pool> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => poolLoader.require(id),
    config: poolCache.getConfig(vendored: vendored),
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
