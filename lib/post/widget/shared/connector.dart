import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

// TODO: Rename these to Historian :33
class PostHistoryConnector extends StatelessWidget {
  const PostHistoryConnector({
    super.key,
    required this.post,
    required this.child,
  });

  final Post post;
  final Widget child;

  @override
  Widget build(BuildContext context) => ItemHistoryConnector<Post>(
    item: post,
    getEntry: (context, item) => PostHistoryRequest.item(post: post),
    child: child,
  );
}

class PostPageHistoryConnector extends StatelessWidget {
  const PostPageHistoryConnector({super.key, required this.child});

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
        return PostHistoryRequest.search(
          query: controller.value.toQuery(),
          posts: posts,
        );
      },
      child: child,
    );
  }
}
