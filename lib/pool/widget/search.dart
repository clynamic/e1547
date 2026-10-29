import 'package:e1547/client/client.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

final DateFormat poolDateWords = DateFormat('d MMM');

String poolCountWords(Pool pool) => switch (pool.category) {
  PoolCategory.series => '${pool.postCount} pages',
  PoolCategory.collection => '${pool.postCount} posts',
};

String poolSubtitle(Pool pool, {bool detailed = false}) => [
  switch (pool.category) {
    PoolCategory.series => 'Series',
    PoolCategory.collection => 'Collection',
  },
  poolCountWords(pool),
  if (detailed && pool.category == PoolCategory.series)
    if (pool.active)
      'updated ${poolDateWords.format(pool.updatedAt)}'
    else
      'finished',
].join(' · ');

String poolParamsWords(PoolParams params) {
  final PoolOrder order = params.order ?? PoolOrder.updatedAt;
  if (params.name?.isEmpty ?? true) {
    return [
      if (params.category != null) params.category!.label,
      order.label,
    ].join(' · ');
  }
  return [
    params.category?.label ?? 'Series and collections',
    order.words,
  ].join(' · ');
}

void openPool(BuildContext context, Pool pool) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (context) => PoolPage(pool: pool)));

class PoolCard extends StatelessWidget {
  const PoolCard({super.key, required this.pool, required this.onTap});

  final Pool pool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        onLongPress: () => showPoolPrompt(context: context, pool: pool),
        borderRadius: BorderRadius.circular(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 6,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: PostCover(
                id: pool.postIds.firstOrNull,
                size: PostImageSize.sample,
                adaptive: true,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagToName(pool.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  poolSubtitle(pool),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SliverPoolGrid extends StatelessWidget {
  const SliverPoolGrid({super.key, required this.state, required this.query});

  final InfiniteQueryStatus<List<Pool>, int> state;
  final InfiniteQuery<List<int>, int> query;

  @override
  Widget build(BuildContext context) => PagedSliverMasonryGrid<int, Pool>.count(
    showNewPageProgressIndicatorAsGridChild: false,
    showNewPageErrorIndicatorAsGridChild: false,
    showNoMoreItemsIndicatorAsGridChild: false,
    state: state.paging,
    fetchNextPage: query.getNextPage,
    crossAxisCount: coverCardColumns(context),
    crossAxisSpacing: 8,
    builderDelegate: defaultPagedChildBuilderDelegate<Pool>(
      onRetry: query.getNextPage,
      itemBuilder: (context, item, index) => ImageCacheSizeProvider(
        size: TileLayout.of(context).tileSize * 2,
        child: PoolCard(pool: item, onTap: () => openPool(context, item)),
      ),
      onLoading: const CoverCardSkeleton(),
      onEmpty: const Text('No pools'),
      onError: const Text('Failed to load pools'),
    ),
  );
}

class PoolDock extends StatelessWidget {
  const PoolDock({super.key, required this.params, required this.onOpen});

  final PoolParamsController params;
  final Future<void> Function(AnimationController? transition) onOpen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SearchDock(
      onOpen: onOpen,
      child: ListenableBuilder(
        listenable: params,
        builder: (context, child) {
          final String name = params.value.name ?? '';
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Pool name' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  color: name.isEmpty
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : null,
                ),
              ),
              Text(
                poolParamsWords(params.value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showPoolSearchSheet(
  BuildContext context, {
  AnimationController? transition,
}) {
  final PoolParamsController params = context.read<PoolParamsController>();
  final NavigatorState page = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    transitionAnimationController: transition,
    builder: (sheetContext) => FloatingSheet(
      child: PoolSearchSheet(
        params: params.value,
        onSubmit: (value) => params.value = value,
        onOpen: (pool) {
          Navigator.of(sheetContext).pop();
          page.push(
            MaterialPageRoute(builder: (context) => PoolPage(pool: pool)),
          );
        },
      ),
    ),
  );
}

class PoolSearchSheet extends StatelessWidget {
  const PoolSearchSheet({
    super.key,
    required this.params,
    required this.onSubmit,
    required this.onOpen,
  });

  final PoolParams params;
  final ValueChanged<PoolParams> onSubmit;
  final ValueChanged<Pool> onOpen;

  @override
  Widget build(BuildContext context) => NameSearchSheet<PoolParams>(
    params: params,
    name: params.name,
    hint: 'Pool name',
    suggestions: (params, typed) => PoolSuggestions(
      params: params.copyWith(name: typed),
      onPick: onOpen,
    ),
    filters: (params, onChange, onClose) =>
        PoolFilterPanel(params: params, onChange: onChange, onClose: onClose),
    onSubmit: (params, name) => onSubmit(params.copyWith(name: name)),
  );
}

class PoolSuggestions extends StatelessWidget {
  const PoolSuggestions({
    super.key,
    required this.params,
    required this.onPick,
  });

  final PoolParams params;
  final ValueChanged<Pool> onPick;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.pools.useSearch(query: params.toQuery()),
      builder: (context, state) {
        final List<Pool> pools = (state.data ?? const <Pool>[])
            .take(searchSheetEntries)
            .toList();
        if (pools.isEmpty) return const SizedBox.shrink();
        prefetchCovers(client, pools.map((e) => e.postIds.firstOrNull));
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final Pool pool in pools)
                CoverRow(
                  cover: pool.postIds.firstOrNull,
                  title: tagToName(pool.name),
                  subtitle: Text(poolSubtitle(pool, detailed: true)),
                  onTap: () => onPick(pool),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PoolFilterPanel extends StatelessWidget {
  const PoolFilterPanel({
    super.key,
    required this.params,
    required this.onChange,
    required this.onClose,
  });

  final PoolParams params;
  final ValueChanged<PoolParams> onChange;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final PoolOrder order = params.order ?? PoolOrder.updatedAt;
    return SheetPanel(
      title: 'Filters',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          MetaChoices<PoolCategory>(
            label: 'Kind',
            options: PoolCategory.values,
            name: (value) => value.label,
            selected: params.category,
            onPick: (value) => onChange(params.copyWith(category: value)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              const MetaLabel('Order'),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final PoolOrder value in PoolOrder.values)
                    MetaOption(
                      label: value.label,
                      selected: value == order,
                      onTap: () => onChange(
                        params.copyWith(
                          order: value == PoolOrder.updatedAt ? null : value,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
