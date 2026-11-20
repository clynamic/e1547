import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostLoadingPage extends StatelessWidget {
  const PostLoadingPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final query = client.posts.useGet(id: id);
    final Widget page = QueryBuilder(
      query: query,
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading || state.isInitial,
        isError: state.isError,
        isEmpty: state.data == null,
        skeleton: (context) => PostDetail(
          post: const PostGhost(),
          summary: client.posts.partialPostCache.get(id),
        ),
        onError: const Text('Failed to load post'),
        onRetry: query.invalidate,
        onEmpty: const Text('Post not found'),
        child: (context) => PostDetail(post: state.data!),
      ),
    );
    if (context.watch<PostFilter?>() != null) return page;
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: page,
    );
  }
}

void pushPostLoadingPage(BuildContext context, int id) {
  final filter = context.read<PostFilter?>();
  Navigator.of(context).push(
    DismissRoute<void>(
      builder: (context) => PostRouteScope(
        params: null,
        filter: filter,
        child: PostLoadingPage(id),
      ),
    ),
  );
}
