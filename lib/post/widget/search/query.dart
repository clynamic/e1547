import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostPageQueryBuilder extends StatelessWidget {
  const PostPageQueryBuilder({super.key, required this.builder, this.query});

  final PageQueryBuilderCallback<Post, int> builder;
  final InfiniteQuery<List<int>, int>? query;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final InfiniteQuery<List<int>, int> query =
        this.query ??
        client.posts.usePage(
          query: context.watch<PostParamsController>().value.toQuery(),
        );

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.posts.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => builder(context, state, query),
      ),
    );
  }
}
