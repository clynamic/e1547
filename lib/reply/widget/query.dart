import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class ReplyPageQueryBuilder extends StatelessWidget {
  const ReplyPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<Reply, int> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<ReplyParams>();
    final query = client.replies.usePage(query: controller.request);

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.replies.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter<Reply, int>(
        state: state,
        builder: (context, state) => builder(context, state, query),
      ),
    );
  }
}
