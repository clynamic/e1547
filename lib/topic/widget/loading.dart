import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicLoadingPage extends StatelessWidget {
  const TopicLoadingPage(this.id, {super.key, this.orderByOldest});

  final int id;
  final bool? orderByOldest;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return QueryBuilder(
      query: client.topics.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(AppLocalizations.of(context).topicLink(id)),
          ),
          body: child(context),
        ),
        onError: Text(AppLocalizations.of(context).topicFailedToLoadTopic),
        onEmpty: Text(AppLocalizations.of(context).topicNotFound),
        child: (context) =>
            TopicRepliesPage(topic: state.data!, orderByOldest: orderByOldest),
      ),
    );
  }
}
