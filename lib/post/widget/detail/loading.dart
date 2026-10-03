import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostLoadingPage extends StatelessWidget {
  const PostLoadingPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return QueryBuilder(
      query: client.posts.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        onError: Text(AppLocalizations.of(context).failedToLoadPost),
        onEmpty: Text(AppLocalizations.of(context).postNotFound),
        child: (context) => PostDetail(post: state.data!),
      ),
    );
  }
}
