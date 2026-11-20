import 'package:e1547/history/history.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HistoriesPage extends StatelessWidget {
  const HistoriesPage({super.key, this.query});

  final QueryMap? query;

  @override
  Widget build(BuildContext context) => RouterDrawerEntry<HistoriesPage>(
    child: ChangeNotifierProvider(
      create: (_) => HistoryParamsController(HistoryParams.fromQuery(query)),
      child: HistoryPageQueryBuilder(
        builder: (context, state, query) => SelectionLayout<History>(
          items: state.data?.pages.expand((p) => p).toList(),
          keyOf: (history) => history.id,
          child: const AdaptiveScaffold(
            appBar: HistoryAppBar(),
            floatingActionButton: HistorySearchFab(),
            drawer: RouterDrawer(),
            endDrawer: ContextDrawer(
              title: Text('History'),
              children: [
                HistoryEnableTile(),
                HistoryLimitTile(),
                HistoryClearTile(),
                Divider(),
                HistoryCategoryFilterTile(),
                HistoryTypeFilterTile(),
              ],
            ),
            body: HistoryList(),
          ),
        ),
      ),
    ),
  );
}
