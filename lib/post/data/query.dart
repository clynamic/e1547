import 'dart:math';

import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';

/// The highest page number e621 serves, past which it rejects requests.
const int maxSitePage = 750;

/// The `order` values that keep results in descending id order.
///
/// Only these orders honor `b<id>` cursor pagination on the server; any other
/// order makes it silently ignore the cursor and restart from the newest
/// posts, which would duplicate and skip entries. Searches with those orders
/// must therefore paginate by page number, capped at [maxSitePage].
const Set<String?> cursorOrders = {null, 'new', 'id', 'id_desc'};

/// Whether posts for [query] are served in descending id order, making cursor
/// pagination usable for it.
bool servesNewestFirst(QueryMap? query) =>
    cursorOrders.contains(TagMap(query?['tags'])['order']);

extension PostQuerying on PostClient {
  static const queryDomain = 'posts';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Post, int> get postCache =>
      queryCache.bridge(queryKey, fromJson: Post.fromJson);

  Query<Post> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: postCache.getConfig(vendored: vendored),
  );

  InfiniteQuery<List<int>, Object> usePage({required QueryMap? query}) {
    final normalized = _normalize(query);
    final tags = TagMap(normalized?['tags']);
    final order = tags['order'];
    final username = identity.username;

    if (tags.length == 2 && order == 'pool') {
      final poolId = int.tryParse(tags['pool'] ?? '');
      if (poolId != null) return useByPool(id: poolId);
    }
    if (tags.length == 2 &&
        order == 'fav' &&
        username != null &&
        tags['fav'] == username) {
      return useFavorites();
    }

    return _usePage(query: normalized);
  }

  QueryMap? _normalize(QueryMap? query) {
    final tags = TagMap(query?['tags']);
    if (tags.length != 1) return query;
    if (tags['order'] != null) return query;

    if (int.tryParse(tags['pool'] ?? '') != null) {
      tags['order'] = 'pool';
      return {...?query, 'tags': tags.toString()};
    }
    final username = identity.username;
    if (username != null && tags['fav'] == username) {
      tags['order'] = 'fav';
      return {...?query, 'tags': tags.toString()};
    }
    return query;
  }

  InfiniteQuery<List<int>, Object> _usePage({required QueryMap? query}) {
    final cursor = servesNewestFirst(query);
    return InfiniteQuery<List<int>, Object>(
      cache: queryCache,
      key: [...queryKey, query],
      getNextArg: (state) => cursor
          ? state.nextCursorPage()
          : state.nextPageArg(maxPage: maxSitePage),
      config: pagedObjectIdConfig(),
      queryFn: (page) =>
          this.page(page: page, query: query).then(postCache.savePage),
    );
  }

  InfiniteQuery<List<int>, Object> useFavorites() =>
      InfiniteQuery<List<int>, Object>(
        cache: queryCache,
        key: [...queryKey, 'favorites'],
        getNextArg: (state) => state.nextPageArg(maxPage: maxSitePage),
        config: pagedObjectIdConfig(),
        queryFn: (page) => favorites(page: page).then(postCache.savePage),
      );

  InfiniteQuery<List<int>, Object> useByPool({required int id}) =>
      InfiniteQuery<List<int>, Object>(
        cache: queryCache,
        key: [...queryKey, 'by_pool', id],
        getNextArg: (state) => state.nextPageArg(),
        config: pagedObjectIdConfig(),
        queryFn: (page) async {
          final poolQuery = pools.useGet(id: id);
          await poolQuery.fetch();
          final pool = poolQuery.state.data;
          if (pool == null) return const [];
          final perPage = traits.value.perPage ?? 75;
          final ids = pool.postIds;
          final lower = ((page as int) - 1) * perPage;
          if (lower >= ids.length) return const [];
          final slice = ids.sublist(lower, min(lower + perPage, ids.length));
          final fetched = await byIds(ids: slice);
          return postCache.savePage(fetched);
        },
      );

  InfiniteQuery<List<int>, Object> useByTags({required List<String> tags}) =>
      InfiniteQuery<List<int>, Object>(
        cache: queryCache,
        key: [...queryKey, 'by_tags', tags],
        getNextArg: (state) => state.nextPageArg(maxPage: maxSitePage),
        config: pagedObjectIdConfig(),
        queryFn: (page) =>
            byTags(tags: tags, page: page as int?).then(postCache.savePage),
      );

  Query<List<Post>> useByIds({required List<int> ids}) => Query(
    cache: queryCache,
    key: [...queryKey, 'ids', ids],
    queryFn: () => byIds(ids: ids).then((fetched) {
      postCache.savePage(fetched);
      return fetched;
    }),
  );

  Mutation<void, PostEdit> useUpdate({required int id}) => Mutation(
    mutationFn: (edit) {
      final body = edit.toForm();
      if (body == null) return Future.value();
      return postCache.optimistic(
        id,
        edit.applyTo,
        () => update(id: id, data: body),
      );
    },
    onSuccess: (_, _) => get(id: id).then(postCache.set).ignore(),
  );

  Mutation<void, VoteRequest> useVote({required int id}) => Mutation(
    mutationFn: (p) {
      final (:upvote, :replace) = p;
      return postCache.optimistic(
        id,
        (post) => post.withVote(upvote: upvote, replace: replace),
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
