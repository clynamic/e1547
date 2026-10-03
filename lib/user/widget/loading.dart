import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';

class UserLoadingPage extends StatelessWidget {
  const UserLoadingPage(
    int this.id, {
    super.key,
    this.initalPage = UserPageSection.favorites,
  }) : name = null;

  const UserLoadingPage.name(
    String this.name, {
    super.key,
    this.initalPage = UserPageSection.favorites,
  }) : id = null;

  final int? id;
  final String? name;
  final UserPageSection initalPage;

  @override
  Widget build(BuildContext context) {
    final users = context.watch<Client>().users;
    final id = this.id;
    final l10n = AppLocalizations.of(context);
    return QueryBuilder(
      query: id != null
          ? users.useGet(id: id)
          : users.useGetByName(name: name!),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(l10n.userTitle(id != null ? '#$id' : name!)),
          ),
          body: child(context),
        ),
        onError: Text(l10n.failedToLoadUser),
        onEmpty: Text(l10n.userNotFound),
        child: (context) =>
            UserPage(user: state.data!, initialPage: initalPage),
      ),
    );
  }
}
