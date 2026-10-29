import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

typedef SliverTop = List<Widget> Function(Future<void> Function()? onRefresh);

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool picking = false;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final Settings settings = context.watch<Settings>();
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PostParamsController()),
          ChangeNotifierProvider(create: (_) => PostDisplayController()),
          ChangeNotifierProvider(create: (_) => PoolParamsController()),
        ],
        child: ListenableBuilder(
          listenable: settings.searchKind,
          builder: (context, child) {
            final SearchKind kind = settings.searchKind.value;
            Widget header() => PickerHeader(
              label: kind.label,
              picking: picking,
              onToggle: () => setState(() => picking = !picking),
            );
            List<Widget> top(Future<void> Function()? onRefresh) => [
              if (onRefresh != null)
                SliverHexagonRefresh(
                  onRefresh: onRefresh,
                  headerExtent:
                      pickerHeaderHeight + MediaQuery.paddingOf(context).top,
                  header: header(),
                )
              else
                SliverToBoxAdapter(child: header()),
              SliverToBoxAdapter(
                child: SearchKindPicker(
                  kind: kind,
                  picking: picking,
                  onPick: (value) {
                    settings.searchKind.value = value;
                    setState(() => picking = false);
                  },
                ),
              ),
            ];
            return Scaffold(
              body: GestureDetector(
                onTap: picking ? () => setState(() => picking = false) : null,
                child: switch (kind) {
                  SearchKind.posts => SearchPosts(top: top, dimmed: picking),
                  SearchKind.pools => SearchPools(top: top, dimmed: picking),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchPosts extends StatelessWidget {
  const SearchPosts({super.key, required this.top, required this.dimmed});

  final SliverTop top;
  final bool dimmed;

  @override
  Widget build(BuildContext context) => PostPageHistoryConnector(
    child: FollowSeenConnector(
      child: PostPageQueryBuilder(
        builder: (context, state, query) => PostSearchDock(
          child: LimitedWidthLayout(
            child: ListenableBuilder(
              listenable: context.watch<Settings>().tileSize,
              builder: (context, child) => TileLayout(
                tileSize: context.watch<Settings>().tileSize.value,
                child: RefreshShortcuts(
                  onRefresh: query.invalidate,
                  child: CustomScrollView(
                    primary: true,
                    physics: refreshPhysics,
                    slivers: [
                      ...top(query.invalidate),
                      SliverDim(
                        dimmed: dimmed,
                        sliver: SliverPadding(
                          padding: defaultListPadding.copyWith(
                            bottom:
                                MediaQuery.paddingOf(context).bottom +
                                defaultListPadding.bottom,
                          ),
                          sliver: const SliverPostList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SearchPools extends StatelessWidget {
  const SearchPools({super.key, required this.top, required this.dimmed});

  final SliverTop top;
  final bool dimmed;

  @override
  Widget build(BuildContext context) => PoolsHistoryConnector(
    child: PoolPageQueryBuilder(
      builder: (context, state, query) => NavBarDock(
        builder: (_) => PoolDock(
          params: context.read<PoolParamsController>(),
          onOpen: (transition) =>
              showPoolSearchSheet(context, transition: transition),
        ),
        child: LimitedWidthLayout(
          child: TileLayout(
            child: RefreshShortcuts(
              onRefresh: query.invalidate,
              child: CustomScrollView(
                primary: true,
                physics: refreshPhysics,
                slivers: [
                  ...top(query.invalidate),
                  SliverDim(
                    dimmed: dimmed,
                    sliver: SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        8,
                        8,
                        8,
                        MediaQuery.paddingOf(context).bottom +
                            defaultListPadding.bottom,
                      ),
                      sliver: SliverPoolGrid(state: state, query: query),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class SearchKindPicker extends StatelessWidget {
  const SearchKindPicker({
    super.key,
    required this.kind,
    required this.picking,
    required this.onPick,
  });

  final SearchKind kind;
  final bool picking;
  final ValueChanged<SearchKind> onPick;

  @override
  Widget build(BuildContext context) => PickerList(
    picking: picking,
    children: [
      for (final SearchKind value in SearchKind.values)
        PickerCard(
          title: value.label,
          subtitle: Text(value.description),
          selected: value == kind,
          onTap: () => onPick(value),
          child: SearchKindTiles(kind: value),
        ),
    ],
  );
}

class SearchKindTiles extends StatelessWidget {
  const SearchKindTiles({super.key, required this.kind});

  final SearchKind kind;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    Widget coverTiles(Iterable<int?>? ids) {
      final List<int?> covers = ids?.toList() ?? const [];
      prefetchCovers(client, covers);
      return PickerTiles(
        children: [for (final int? id in covers) PostCover(id: id)],
      );
    }

    return switch (kind) {
      SearchKind.posts => PagedQueryBuilder(
        query: client.posts.usePage(
          query: context.watch<PostParamsController>().value.toQuery(),
        ),
        getItem: (id) => client.posts.useGet(id: id, vendored: true),
        builder: (context, state) => coverTiles(
          state.data?.pages.expand((e) => e).take(4).map((e) => e.id),
        ),
      ),
      SearchKind.pools => PagedQueryBuilder(
        query: client.pools.usePage(
          query: context.watch<PoolParamsController>().value.toQuery(),
        ),
        getItem: (id) => client.pools.useGet(id: id, vendored: true),
        builder: (context, state) => coverTiles(
          state.data?.pages
              .expand((e) => e)
              .take(4)
              .map((e) => e.postIds.firstOrNull),
        ),
      ),
    };
  }
}
