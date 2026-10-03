import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostPageQueryBuilder extends StatelessWidget {
  const PostPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Post, Object> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<PostParamsController>();
    final query = client.posts.usePage(query: controller.value.toQuery());

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
