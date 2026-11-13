import 'dart:math';

import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';

final Expando<QueryLoader<int, Post>> _postLoaders = Expando();

extension PostQuerying on PostClient {
  static const queryDomain = 'posts';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<Post, int> get postCache =>
      queryCache.bridge(queryKey, fromJson: Post.fromJson);

  QueryBridge<PartialPost, int> get partialPostCache => queryCache.bridge([
    ...queryKey,
    'partial',
  ], fromJson: PartialPost.fromJson);

  QueryLoader<int, Post> get postLoader => _postLoaders[this] ??= postCache
      .loader((ids) => byIds(ids: ids, hidden: true), limit: maxPageLimit);

  Query<Post> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => postLoader.require(id),
    config: postCache.getConfig(vendored: vendored),
  );

  Query<List<PartialPost>> useArtistRecommendations({required int id}) => Query(
    cache: queryCache,
    key: [...queryKey, 'recommendations', 'artist', id],
    queryFn: () async {
      final List<PartialPost> posts = await artistRecommendations(id: id);
      partialPostCache.savePage(posts);
      return posts;
    },
  );

  InfiniteQuery<List<int>, int> usePageOfIds({required List<int> ids}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, 'page_of_ids', ids.join(',')],
        getNextArg: (state) => state == null || state.args.isEmpty ? 1 : null,
        config: pagedIdConfig(),
        queryFn: (_) => byIds(ids: ids).then(postCache.savePage),
      );

  InfiniteQuery<List<int>, int> usePage({required QueryMap? query}) {
    final normalized = _normalize(query);
    final tags = TagMap(normalized?['tags']);
    final order = tags['order'];
    final username = identity.username;

    if (tags.length == 2 && order == 'pool') {
      final poolId = int.tryParse(tags['pool'] ?? '');
      if (poolId != null) return useByPool(id: poolId);
    }
    if (tags['id'] case final id? when tags.length == 1 && id.contains(',')) {
      final List<int?> ids = id.split(',').map(int.tryParse).toList();
      if (!ids.contains(null)) return usePageOfIds(ids: ids.nonNulls.toList());
    }
    if (tags.length == 2 && order == 'id') {
      final parentId = int.tryParse(tags['parent'] ?? '');
      if (parentId != null) return useByParent(id: parentId);
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

  InfiniteQuery<List<int>, int> _usePage({required QueryMap? query}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, query],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (page) =>
            this.page(page: page, query: query).then(postCache.savePage),
      );

  InfiniteQuery<List<int>, int> useFavorites() => InfiniteQuery<List<int>, int>(
    cache: queryCache,
    key: [...queryKey, 'favorites'],
    getNextArg: (state) => state.nextPage,
    config: pagedIdConfig(),
    queryFn: (page) => favorites(page: page).then(postCache.savePage),
  );

  InfiniteQuery<List<int>, int> useByPool({required int id}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, 'by_pool', id],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (page) async {
          final poolQuery = pools.useGet(id: id);
          await poolQuery.fetch();
          final pool = poolQuery.state.data;
          if (pool == null) return const [];
          final perPage = traits.value.perPage ?? 75;
          final ids = pool.postIds;
          final lower = (page - 1) * perPage;
          if (lower >= ids.length) return const [];
          final slice = ids.sublist(lower, min(lower + perPage, ids.length));
          final fetched = await byIds(ids: slice);
          return postCache.savePage(fetched);
        },
      );

  static const int childPageLimit = 320;

  InfiniteQuery<List<int>, int> useByParent({required int id}) {
    final QueryMap query = {'tags': 'parent:$id order:id'};
    final List<int> children =
        postCache.get(id)?.relationships.children ?? const [];
    return InfiniteQuery<List<int>, int>(
      cache: queryCache,
      key: [...queryKey, query],
      getNextArg: (state) {
        if (state == null || state.args.isEmpty) return 1;
        if (children.isNotEmpty && children.length <= childPageLimit) {
          return null;
        }
        return state.nextPage;
      },
      config: pagedIdConfig(),
      queryFn: (page) => this
          .page(page: page, limit: childPageLimit, query: query)
          .then(postCache.savePage),
    );
  }

  InfiniteQuery<List<int>, int> useByTags({required List<String> tags}) =>
      InfiniteQuery<List<int>, int>(
        cache: queryCache,
        key: [...queryKey, 'by_tags', tags],
        getNextArg: (state) => state.nextPage,
        config: pagedIdConfig(),
        queryFn: (page) =>
            byTags(tags: tags, page: page).then(postCache.savePage),
      );

  Query<List<Post>> useByIds({required List<int> ids}) => Query(
    cache: queryCache,
    key: [...queryKey, 'ids', ids],
    queryFn: () => byIds(ids: ids, hidden: true).then((fetched) {
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
