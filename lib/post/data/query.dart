import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';

extension PostQuerying on PostClient {
  static const queryKey = 'posts';

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Post, int> get postCache =>
      queryCache.bridge<Post, int>(queryKey, fetch: (id) => get(id: id));

  Query<Post> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [queryKey, id],
    queryFn: () => get(id: id),
    config: postCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, query],
        getNextArg: (state) => state.nextPage,
        queryFn: (key) =>
            page(page: key, query: query).then(postCache.savePage),
      );

  InfiniteQuery<List<int>, int> useHot({QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, 'hot', query],
        getNextArg: (state) => state.nextPage,
        queryFn: (key) => page(
          page: key,
          query: {
            ...?query,
            'tags': '${query?['tags'] ?? ''} order:rank'.trim(),
          },
          force: true,
        ).then(postCache.savePage),
      );

  InfiniteQuery<List<int>, int> useByTags({required List<String> tags}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, 'by_tags', tags],
        getNextArg: (state) => state.nextPage,
        queryFn: (page) => byTags(
          tags: tags,
          page: page,
          force: true,
        ).then(postCache.savePage),
      );

  Query<List<Post>> useByIds({required List<int> ids, int? limit}) => Query(
    cache: queryCache,
    key: [queryKey, 'ids', ids, limit],
    queryFn: () => byIds(ids: ids, limit: limit),
  );

  InfiniteQuery<List<int>, int> useFavorites({QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [queryKey, 'favorites', query],
        getNextArg: (state) => state.nextPage,
        queryFn: (key) => favorites(
          page: key,
          query: query,
          force: true,
        ).then(postCache.savePage),
      );

  Mutation<void, Map<String, String?>> useUpdate({required int id}) => Mutation(
    mutationFn: (data) => postCache.optimistic(
      id,
      (post) => post, // TODO: Apply optimistic updates based on data
      () => update(id: id, data: data),
    ),
  );

  Mutation<void, VoteRequest> useVote({required int id}) => Mutation(
    mutationFn: (p) {
      final (:upvote, :replace) = p;
      return postCache.optimistic(
        id,
        (post) => post.copyWith(vote: post.vote.withVote(upvote, replace)),
        () => vote(id: id, upvote: upvote, replace: replace),
      );
    },
  );

  Mutation<void, int> useAddFavorite() => Mutation(
    mutationFn: (postId) => postCache.optimistic(
      postId,
      (post) => post.copyWith(isFavorited: true, favCount: post.favCount + 1),
      () => addFavorite(postId),
    ),
  );

  Mutation<void, int> useRemoveFavorite() => Mutation(
    mutationFn: (postId) => postCache.optimistic(
      postId,
      (post) => post.copyWith(isFavorited: false, favCount: post.favCount - 1),
      () => removeFavorite(postId),
    ),
  );
}
