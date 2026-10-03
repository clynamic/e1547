import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class CommentLoadingPage extends StatelessWidget {
  const CommentLoadingPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final l10n = AppLocalizations.of(context);
    return QueryBuilder(
      query: client.comments.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(l10n.commentTitle(id)),
          ),
          body: child(context),
        ),
        onError: Text(l10n.failedToLoadComment),
        onEmpty: Text(l10n.commentNotFound),
        child: (context) => PostCommentsPage(postId: state.data!.postId),
      ),
    );
  }
}
