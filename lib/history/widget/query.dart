import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HistoryPageQueryBuilder extends StatelessWidget {
  const HistoryPageQueryBuilder({super.key, required this.builder});

  final PageQueryBuilderCallback<History, int> builder;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<HistoryParams>();
    final query = client.histories.usePage(query: controller.request);

    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.histories.useGet(id: id, vendored: true),
      builder: (context, state) => builder(context, state, query),
    );
  }
}
