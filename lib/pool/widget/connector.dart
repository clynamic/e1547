import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PoolHistoryConnector extends StatelessWidget {
  const PoolHistoryConnector({
    super.key,
    required this.pool,
    required this.child,
  });

  final Pool pool;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PostParamsController>();
    final query = client.posts.usePage(query: controller.value.toQuery());

    return QueryHistoryConnector<InfiniteQueryStatus<List<int>, Object>>(
      query: query,
      getEntry: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final posts = data.pages
            .expand((p) => p)
            .map((id) => client.posts.postCache.get(id))
            .whereType<Post>()
            .toList();
        return PoolHistoryRequest.item(pool: pool, posts: posts);
      },
      child: child,
    );
  }
}

class PoolsHistoryConnector extends StatelessWidget {
  const PoolsHistoryConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PoolParamsController>();
    final query = client.pools.usePage(query: controller.value.toQuery());

    return QueryHistoryConnector<InfiniteQueryStatus<List<int>, int>>(
      query: query,
      getEntry: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final pools = data.pages
            .expand((p) => p)
            .map((id) => client.pools.poolCache.get(id))
            .whereType<Pool>()
            .toList();
        final thumbIds = pools
            .map((p) => p.postIds.isEmpty ? null : p.postIds.first)
            .whereType<int>()
            .toList();
        final posts = thumbIds
            .map((id) => client.posts.postCache.get(id))
            .whereType<Post>()
            .toList();
        return PoolHistoryRequest.search(
          query: controller.value.toQuery(),
          pools: pools,
          posts: posts,
        );
      },
      child: child,
    );
  }
}
