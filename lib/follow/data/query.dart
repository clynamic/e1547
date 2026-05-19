import 'package:e1547/follow/follow.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

extension FollowQuerying on FollowClient {
  static const queryKey = 'follows';

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Follow, int> get followCache => queryCache.bridge(queryKey);

  Query<Follow> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [queryKey, id],
    queryFn: () => get(id: id, force: true),
    config: followCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, 'page', query],
        getNextArg: (state) => state.nextPage,
        queryFn: (pageKey) => page(
          page: pageKey,
          query: query,
          force: true,
        ).then(followCache.savePage),
      );

  Query<Map<FollowType, List<String>>> useTimelineTags() => Query(
    cache: queryCache,
    key: [queryKey, 'timeline_tags'],
    queryFn: () async {
      final follows = await all(
        query: FollowsQuery(types: [FollowType.update, FollowType.notify]),
        force: true,
      );

      final Map<FollowType, List<String>> result = {
        FollowType.update: [],
        FollowType.notify: [],
      };

      for (final follow in follows) {
        if (!follow.tags.contains(' ')) {
          result[follow.type]?.add(follow.tags);
        }
      }

      return result;
    },
  );
}
