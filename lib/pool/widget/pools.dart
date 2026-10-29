import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PoolsPage extends StatelessWidget {
  const PoolsPage({super.key, this.search});

  final PoolParams? search;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return FilterControllerProvider<PostFilter, Post>(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: ChangeNotifierProvider(
        create: (_) => PoolParamsController(search),
        child: PickerPage(
          label: 'Pools',
          body: (top) => SearchPools(top: top, dimmed: false),
        ),
      ),
    );
  }
}
