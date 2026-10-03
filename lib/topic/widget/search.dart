import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key, this.query});

  final QueryMap? query;

  @override
  Widget build(BuildContext context) => RouterDrawerEntry<TopicsPage>(
    child: FilterControllerProvider(
      create: (_) => TopicFilter(),
      child: ChangeNotifierProvider(
        create: (_) => TopicParamsController(TopicParams.fromQuery(query)),
        child: TopicsHistoryConnector(
          child: AdaptiveScaffold(
            appBar: DefaultAppBar(
              title: Text(AppLocalizations.of(context).topicsTitle),
              actions: const [ContextDrawerButton()],
            ),
            floatingActionButton: const TopicSearchFab(),
            drawer: const RouterDrawer(),
            endDrawer: const TopicListDrawer(),
            body: const TopicList(),
          ),
        ),
      ),
    ),
  );
}
