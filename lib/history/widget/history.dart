import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
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
          child: AdaptiveScaffold(
            appBar: const HistoryAppBar(),
            floatingActionButton: const HistorySearchFab(),
            drawer: const RouterDrawer(),
            endDrawer: ContextDrawer(
              title: Text(AppLocalizations.of(context).navHistory),
              children: const [
                HistoryEnableTile(),
                HistoryLimitTile(),
                HistoryClearTile(),
                Divider(),
                HistoryCategoryFilterTile(),
                HistoryTypeFilterTile(),
              ],
            ),
            body: const HistoryList(),
          ),
        ),
      ),
    ),
  );
}
