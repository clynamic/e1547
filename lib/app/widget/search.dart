import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/set/set.dart';
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
          ChangeNotifierProvider(create: (_) => PostSetParamsController()),
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
                  SearchKind.sets => SearchSets(top: top, dimmed: picking),
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

class SearchSets extends StatelessWidget {
  const SearchSets({super.key, required this.top, required this.dimmed});

  final SliverTop top;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final PostSetParamsController params = context
        .watch<PostSetParamsController>();
    final String? me = client.identity.username;
    final InfiniteQuery<List<int>, int> everyone = client.sets.usePage(
      query: params.value.toQuery(),
    );
    final Query<List<PostSet>>? own = me == null
        ? null
        : client.sets.useSearch(
            query: params.value.copyWith(creator: me).toQuery(),
          );
    Future<void> refresh() async {
      await Future.wait([everyone.invalidate(), ?own?.invalidate()]);
    }

    return FilterControllerProvider<PublicPostSetFilter, PostSet>(
      create: (_) => PublicPostSetFilter(userId: client.traits.value.userId),
      keys: (_) => [client],
      child: PagedQueryBuilder(
        query: everyone,
        getItem: (id) => client.sets.useGet(id: id, vendored: true),
        builder: (context, state) => QueryFilter<PostSet, int>(
          state: state,
          builder: (context, state) {
            prefetchCovers(
              client,
              (state.data?.pages.expand((e) => e) ?? const <PostSet>[]).map(
                (e) => e.postIds.firstOrNull,
              ),
            );
            return NavBarDock(
              builder: (_) => PostSetDock(
                params: params,
                onOpen: (transition) =>
                    showPostSetSearchSheet(context, transition: transition),
              ),
              child: LimitedWidthLayout(
                child: TileLayout(
                  child: RefreshShortcuts(
                    onRefresh: refresh,
                    child: CustomScrollView(
                      primary: true,
                      physics: refreshPhysics,
                      slivers: [
                        ...top(refresh),
                        SliverDim(
                          dimmed: dimmed,
                          sliver: SliverMainAxisGroup(
                            slivers: [
                              if (own != null)
                                SliverToBoxAdapter(
                                  child: OwnPostSets(query: own),
                                ),
                              SliverToBoxAdapter(
                                child: SearchSection(
                                  'Public · '
                                  '${postSetParamsWords(params.value)}',
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.fromLTRB(
                                  8,
                                  0,
                                  8,
                                  MediaQuery.paddingOf(context).bottom +
                                      defaultListPadding.bottom,
                                ),
                                sliver: SliverPostSetGrid(
                                  state: state,
                                  query: everyone,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OwnPostSets extends StatelessWidget {
  const OwnPostSets({super.key, required this.query});

  final Query<List<PostSet>> query;

  @override
  Widget build(BuildContext context) => QueryBuilder(
    query: query,
    builder: (context, state) {
      final List<PostSet> sets = state.data ?? const [];
      if (sets.isEmpty) return const SizedBox(height: 8);
      prefetchCovers(
        context.read<Client>(),
        sets.map((e) => e.postIds.firstOrNull),
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SearchSection('Yours', first: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (final PostSet set in sets)
                  PostSetRow(set: set, onTap: () => openPostSet(context, set)),
              ],
            ),
          ),
        ],
      );
    },
  );
}

class SearchSection extends StatelessWidget {
  const SearchSection(this.label, {super.key, this.first = false});

  final String label;
  final bool first;

  @override
  Widget build(BuildContext context) => Padding(
    padding: first
        ? const EdgeInsets.fromLTRB(16, 8, 16, 6)
        : const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
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
          icon: value.icon,
          subtitle: Text(value.description),
          selected: value == kind,
          onTap: () => onPick(value),
        ),
    ],
  );
}
