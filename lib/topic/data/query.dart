import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';

extension TopicQuerying on TopicClient {
  static const queryKey = 'topics';

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Topic, int> get topicCache => queryCache.bridge<Topic, int>(
    queryKey,
    fetch: (id) => get(id: id, force: true),
  );

  Query<Topic> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [queryKey, id],
    queryFn: () => get(id: id, force: true),
    config: topicCache.getConfig(vendored: vendored),
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
        ).then(topicCache.savePage),
      );
}
