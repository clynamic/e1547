import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/set/set.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

final NumberFormat postSetCountFormat = NumberFormat.decimalPattern('en');

String postSetCountWords(PostSet set) =>
    '${postSetCountFormat.format(set.postCount)} posts';

String postSetSubtitle(PostSet set) =>
    '${postSetCountWords(set)} · ${set.public ? 'public' : 'private'}';

String postSetParamsWords(PostSetParams params) =>
    (params.order ?? PostSetOrder.updatedAt).label;

void openPostSet(BuildContext context, PostSet set) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PostsPage(params: PostParams(tags: 'set:${set.shortname}')),
      ),
    );

class PublicPostSetFilter extends FilterController<PostSet> {
  PublicPostSetFilter({this.userId});

  final int? userId;

  @override
  Object idOf(PostSet item) => item.id;

  @override
  bool filter(PostSet item) => item.public && item.creatorId != userId;
}

class PostSetRow extends StatelessWidget {
  const PostSetRow({
    super.key,
    required this.set,
    required this.onTap,
    this.owned = true,
    this.tag,
  });

  final PostSet set;
  final VoidCallback onTap;
  final bool owned;
  final String? tag;

  @override
  Widget build(BuildContext context) => CoverRow(
    cover: set.postIds.firstOrNull,
    title: tagToName(set.name),
    subtitle: switch ((owned, tag)) {
      (true, null) => Text(postSetSubtitle(set)),
      (true, final String tag) => Text('${postSetCountWords(set)} · $tag'),
      (false, _) => PostSetByline(set: set, suffix: tag),
    },
    onTap: onTap,
  );
}

class PostSetCard extends StatelessWidget {
  const PostSetCard({super.key, required this.set, required this.onTap});

  final PostSet set;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 6,
          children: [
            SizedBox(
              height: 170,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: PostCover(
                  id: set.postIds.firstOrNull,
                  size: PostImageSize.sample,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tagToName(set.name),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  child: PostSetByline(set: set),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostSetByline extends StatelessWidget {
  const PostSetByline({super.key, required this.set, this.suffix});

  final PostSet set;
  final String? suffix;

  @override
  Widget build(BuildContext context) => QueryBuilder(
    query: context.watch<Client>().users.useGet(
      id: set.creatorId,
      vendored: true,
    ),
    builder: (context, state) {
      final User? user = state.data;
      return Text(
        [
          if (user != null) 'by ${user.name}',
          postSetCountWords(set),
          ?suffix,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    },
  );
}

class SliverPostSetGrid extends StatelessWidget {
  const SliverPostSetGrid({
    super.key,
    required this.state,
    required this.query,
  });

  final InfiniteQueryStatus<List<PostSet>, int> state;
  final InfiniteQuery<List<int>, int> query;

  @override
  Widget build(BuildContext context) =>
      PagedSliverMasonryGrid<int, PostSet>.count(
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        state: state.paging,
        fetchNextPage: query.getNextPage,
        crossAxisCount: coverCardColumns(context),
        crossAxisSpacing: 8,
        builderDelegate: defaultPagedChildBuilderDelegate<PostSet>(
          onRetry: query.getNextPage,
          itemBuilder: (context, item, index) => ImageCacheSizeProvider(
            size: TileLayout.of(context).tileSize * 2,
            child: PostSetCard(
              set: item,
              onTap: () => openPostSet(context, item),
            ),
          ),
          onLoading: const CoverCardSkeleton(coverHeight: 170),
          onEmpty: const Text('No sets'),
          onError: const Text('Failed to load sets'),
        ),
      );
}

class PostSetDock extends StatelessWidget {
  const PostSetDock({super.key, required this.params, required this.onOpen});

  final PostSetParamsController params;
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
                name.isEmpty ? 'Set name' : name,
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
                postSetParamsWords(params.value),
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

Future<void> showPostSetSearchSheet(
  BuildContext context, {
  AnimationController? transition,
}) {
  final PostSetParamsController params = context
      .read<PostSetParamsController>();
  final NavigatorState page = Navigator.of(context);
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    transitionAnimationController: transition,
    builder: (sheetContext) => FloatingSheet(
      child: PostSetSearchSheet(
        params: params.value,
        onSubmit: (value) => params.value = value,
        onOpen: (set) {
          Navigator.of(sheetContext).pop();
          openPostSet(page.context, set);
        },
      ),
    ),
  );
}

class PostSetSearchSheet extends StatelessWidget {
  const PostSetSearchSheet({
    super.key,
    required this.params,
    required this.onSubmit,
    required this.onOpen,
  });

  final PostSetParams params;
  final ValueChanged<PostSetParams> onSubmit;
  final ValueChanged<PostSet> onOpen;

  @override
  Widget build(BuildContext context) => NameSearchSheet<PostSetParams>(
    params: params,
    name: params.name,
    hint: 'Set name',
    suggestions: (params, typed) => PostSetSuggestions(
      params: params.copyWith(name: typed),
      onPick: onOpen,
    ),
    filters: (params, onChange, onClose) => PostSetFilterPanel(
      params: params,
      onChange: onChange,
      onClose: onClose,
    ),
    onSubmit: (params, name) => onSubmit(params.copyWith(name: name)),
  );
}

class PostSetSuggestions extends StatelessWidget {
  const PostSetSuggestions({
    super.key,
    required this.params,
    required this.onPick,
    this.tagged = false,
  });

  final PostSetParams params;
  final ValueChanged<PostSet> onPick;
  final bool tagged;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final String? me = client.identity.username;
    Widget list(List<PostSet> sets) {
      final List<PostSet> shown = sets.take(searchSheetEntries).toList();
      if (shown.isEmpty) return const SizedBox.shrink();
      prefetchCovers(client, shown.map((e) => e.postIds.firstOrNull));
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final PostSet set in shown)
              PostSetRow(
                set: set,
                owned: set.creatorId == client.traits.value.userId,
                tag: tagged ? 'set:${set.shortname}' : null,
                onTap: () => onPick(set),
              ),
          ],
        ),
      );
    }

    final Query<List<PostSet>> everyone = client.sets.useSearch(
      query: params.toQuery(),
      limit: searchSheetEntries,
    );
    if (me == null) {
      return QueryBuilder(
        query: everyone,
        builder: (context, state) => list(state.data ?? const []),
      );
    }
    return QueryBuilder(
      query: client.sets.useSearch(
        query: params.copyWith(creator: me).toQuery(),
        limit: searchSheetEntries,
      ),
      builder: (context, own) => QueryBuilder(
        query: everyone,
        builder: (context, all) {
          final List<PostSet> mine = own.data ?? const [];
          final Set<int> seen = mine.map((e) => e.id).toSet();
          return list([
            ...mine,
            ...(all.data ?? const <PostSet>[]).where(
              (e) => e.public && !seen.contains(e.id),
            ),
          ]);
        },
      ),
    );
  }
}

class PostSetFilterPanel extends StatelessWidget {
  const PostSetFilterPanel({
    super.key,
    required this.params,
    required this.onChange,
    required this.onClose,
  });

  final PostSetParams params;
  final ValueChanged<PostSetParams> onChange;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final PostSetOrder order = params.order ?? PostSetOrder.updatedAt;
    return SheetPanel(
      title: 'Filters',
      onClose: onClose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          const MetaLabel('Order'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final PostSetOrder value in PostSetOrder.values)
                MetaOption(
                  label: value.label,
                  selected: value == order,
                  onTap: () => onChange(
                    params.copyWith(
                      order: value == PostSetOrder.updatedAt ? null : value,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
