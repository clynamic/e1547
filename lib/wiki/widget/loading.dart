import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/wiki/wiki.dart';
import 'package:flutter/material.dart';

class WikiLoadingPage extends StatelessWidget {
  const WikiLoadingPage(int this.id, {super.key}) : title = null;

  const WikiLoadingPage.title(String this.title, {super.key}) : id = null;

  final int? id;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final wikis = context.watch<Client>().wikis;
    final id = this.id;
    return QueryBuilder(
      query: id != null
          ? wikis.useGet(id: id)
          : wikis.useGetByTitle(title: title!),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(
              id != null
                  ? tf('Wiki #{id}', params: {'id': id})
                  : tf('Wiki {title}', params: {'title': title}),
            ),
          ),
          body: child(context),
        ),
        onError: Text(t('Failed to load wiki')),
        onEmpty: Text(t('Wiki not found')),
        child: (context) => WikiPage(wiki: state.data!),
      ),
    );
  }
}
