import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class ReplyLoadingPage extends StatelessWidget {
  const ReplyLoadingPage(this.id, {super.key, this.orderByOldest});

  final int id;
  final bool? orderByOldest;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final l10n = AppLocalizations.of(context);
    return QueryBuilder(
      query: client.replies.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(l10n.replyTitle(id)),
          ),
          body: child(context),
        ),
        onError: Text(l10n.failedToLoadReply),
        onEmpty: Text(l10n.replyNotFound),
        child: (context) =>
            TopicLoadingPage(state.data!.topicId, orderByOldest: orderByOldest),
      ),
    );
  }
}
