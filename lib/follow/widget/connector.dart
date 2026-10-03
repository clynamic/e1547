import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class FollowConnector extends StatelessWidget {
  const FollowConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubEffect(
      effect: () {
        client.followServer.sync();
        return null;
      },
      keys: [client],
      child: SubStream<List<Follow>>(
        create: () => client.follows.all().streamed,
        keys: [client],
        listener: (event) => client.followServer.sync(),
        builder: (context, _) => child,
      ),
    );
  }
}

class FollowSeenConnector extends StatelessWidget {
  const FollowSeenConnector({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PostParamsController>();
    final query = client.posts.usePage(query: controller.value.toQuery());

    return QueryOnceConnector<
      InfiniteQueryStatus<List<int>, Object>,
      FollowSeenRequest
    >(
      query: query,
      getRequest: (context, state) {
        final data = state.data;
        if (data == null || data.pages.isEmpty) return null;
        final params = controller.value;
        final poolId = params.poolId;
        final tags = poolId != null
            ? 'pool:$poolId'
            : params.tags?.nullWhenEmpty;
        if (tags == null) return null;
        final posts = data.pages
            .expand((p) => p)
            .map((id) => client.posts.postCache.get(id))
            .whereType<Post>()
            .toList();
        return (
          tags: tags,
          posts: posts,
          pool: poolId != null ? client.pools.poolCache.get(poolId) : null,
        );
      },
      onRequest: (context, request) => client.useFollowSeen().mutate(request),
      child: child,
    );
  }
}
