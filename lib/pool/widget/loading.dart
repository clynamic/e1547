import 'package:e1547/client/client.dart';
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
        isLoading: state.isLoading || state.isInitial,
        isError: state.isError,
        isEmpty: state.data == null,
        loadingBuilder: (context, child) => Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text('Pool #$id'),
          ),
          body: child(context),
        ),
        skeleton: (context) =>
            PoolPage(pool: const PoolGhost(), orderByOldest: orderByOldest),
        onError: const Text('Failed to load pool'),
        onEmpty: const Text('Pool not found'),
        child: (context) =>
            PoolPage(pool: state.data!, orderByOldest: orderByOldest),
      ),
    );
  }
}
