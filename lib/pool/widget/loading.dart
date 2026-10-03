import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PoolLoadingPage extends StatelessWidget {
  const PoolLoadingPage(this.id, {super.key, this.orderByOldest});

  final int id;
  final bool? orderByOldest;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return QueryBuilder(
      query: client.pools.useGet(id: id),
      builder: (context, state) => LoadingPage(
        isLoading: state.isLoading,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(AppLocalizations.of(context).poolLink(id)),
          ),
          body: child(context),
        ),
        onError: Text(AppLocalizations.of(context).poolFailedToLoadPool),
        onEmpty: Text(AppLocalizations.of(context).poolNotFound),
        child: (context) =>
            PoolPage(pool: state.data!, orderByOldest: orderByOldest),
      ),
    );
  }
}
