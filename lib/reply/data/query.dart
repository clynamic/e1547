import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';

extension ReplyQuerying on ReplyClient {
  static const queryKey = 'replies';

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Reply, int> get replyCache => queryCache.bridge<Reply, int>(
    queryKey,
    fetch: (id) => get(id: id, force: true),
  );

  Query<Reply> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [queryKey, id],
    queryFn: () => get(id: id, force: true),
    config: replyCache.getConfig(vendored: vendored),
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
        ).then(replyCache.savePage),
      );
}
