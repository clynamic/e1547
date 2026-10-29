import 'package:e1547/query/query.dart';
import 'package:e1547/set/set.dart';
import 'package:e1547/shared/shared.dart';

extension PostSetQuerying on PostSetClient {
  static const queryDomain = 'sets';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<PostSet, int> get setCache =>
      queryCache.bridge(queryKey, fromJson: PostSet.fromJson);

  Query<PostSet> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: setCache.getConfig(vendored: vendored),
  );

  Query<List<PostSet>> useSearch({required QueryMap? query, int? limit}) =>
      Query(
        cache: queryCache,
        key: [...queryKey, 'search', ?limit, query],
        queryFn: () => page(limit: limit, query: query).then((sets) {
          setCache.savePage(sets);
          return sets;
        }),
      );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (key) => page(page: key, query: query).then(setCache.savePage),
      );
}
