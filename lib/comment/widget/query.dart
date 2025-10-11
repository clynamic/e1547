import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentPageQueryBuilder extends StatelessWidget {
  const CommentPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Comment, int> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<CommentParams>();
    final query = client.comments.usePage(query: controller.request);

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.comments.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => builder(context, state, query),
      ),
    );
  }
}
