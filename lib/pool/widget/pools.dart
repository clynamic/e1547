import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class PoolsPage extends StatefulWidget {
  const PoolsPage({super.key, this.search});

  final PoolParams? search;

  @override
  State<StatefulWidget> createState() => _PoolsPageState();
}

class _PoolsPageState extends State<PoolsPage> with RouterDrawerEntryWidget {
  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return ChangeNotifierProvider(
      create: (_) => PoolParamsController(widget.search),
      child: PoolsHistoryConnector(
        child: FilterControllerProvider<PostFilter, Post>(
          create: (_) => PostFilter(client),
          keys: (_) => [client],
          child: PoolPageQueryBuilder(
            builder: (context, state, query) {
              final thumbnails =
                  (state.data?.pages.expand((p) => p) ?? const <Pool>[])
                      .map(
                        (p) => p.postIds.isEmpty
                            ? null
                            : client.posts.postCache.get(p.postIds.first),
                      )
                      .whereType<Post>()
                      .toList();
              return AdaptiveScaffold(
                appBar: DefaultAppBar(
                  title: Text(AppLocalizations.of(context).navPools),
                  actions: const [ContextDrawerButton()],
                ),
                floatingActionButton: const PoolsPageFab(),
                drawer: const RouterDrawer(),
                endDrawer: ContextDrawer(
                  title: Text(AppLocalizations.of(context).navPools),
                  children: [
                    const DrawerDenySwitch(),
                    DrawerTagCounter(posts: thumbnails, error: state.error),
                  ],
                ),
                body: LimitedWidthLayout(
                  child: TileLayout(
                    child: PoolGrid(state: state, query: query),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PoolGrid extends StatelessWidget {
  const PoolGrid({super.key, required this.state, required this.query});

  final InfiniteQueryStatus<List<Pool>, int> state;
  final InfiniteQuery<List<int>, int> query;

  @override
  Widget build(BuildContext context) {
    return PullToRefresh(
      onRefresh: query.invalidate,
      child: PagedMasonryGridView<int, Pool>.count(
        primary: true,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        padding: defaultListPadding,
        state: state.paging,
        fetchNextPage: query.getNextPage,
        crossAxisCount: (TileLayout.of(context).crossAxisCount * 0.5).round(),
        builderDelegate: defaultPagedChildBuilderDelegate<Pool>(
          onRetry: query.getNextPage,
          itemBuilder: (context, item, index) => ImageCacheSizeProvider(
            size: TileLayout.of(context).tileSize * 4,
            child: PoolTile(
              pool: item,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PoolPage(pool: item)),
              ),
            ),
          ),
          onEmpty: Text(AppLocalizations.of(context).poolEmpty),
          onError: Text(AppLocalizations.of(context).poolFailedToLoadPools),
        ),
      ),
    );
  }
}
