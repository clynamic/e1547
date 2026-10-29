import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  bool picking = false;

  @override
  Widget build(BuildContext context) {
    final Settings settings = context.watch<Settings>();
    return ListenableBuilder(
      listenable: Listenable.merge([
        settings.browseFeed,
        settings.popularScale,
      ]),
      builder: (context, child) {
        final BrowseFeed feed = settings.browseFeed.value;
        final PopularScale scale = settings.popularScale.value;
        final Widget header = SliverToBoxAdapter(
          child: BrowseHeader(
            feed: feed,
            scale: scale,
            picking: picking,
            onToggle: () => setState(() => picking = !picking),
            onPick: (value, scale) {
              settings.browseFeed.value = value;
              settings.popularScale.value = scale;
              setState(() => picking = false);
            },
          ),
        );
        return Scaffold(
          body: GestureDetector(
            onTap: picking ? () => setState(() => picking = false) : null,
            child: switch (feed) {
              BrowseFeed.timeline => BrowseTimeline(
                header: header,
                dimmed: picking,
              ),
              _ => BrowsePosts(
                key: ValueKey(browseFeedTags(feed, scale)),
                tags: browseFeedTags(feed, scale),
                header: header,
                dimmed: picking,
              ),
            },
          ),
        );
      },
    );
  }
}

class BrowsePosts extends StatelessWidget {
  const BrowsePosts({
    super.key,
    required this.tags,
    required this.header,
    required this.dimmed,
  });

  final String tags;
  final Widget header;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: ChangeNotifierProvider(
        create: (_) => PostParamsController(
          initial: PostParams(tags: tags),
          canSearch: false,
        ),
        child: PostPageHistoryConnector(
          child: PostPageQueryBuilder(
            builder: (context, state, query) => LimitedWidthLayout(
              child: ListenableBuilder(
                listenable: context.watch<Settings>().tileSize,
                builder: (context, child) => TileLayout(
                  tileSize: context.watch<Settings>().tileSize.value,
                  child: PullToRefresh(
                    onRefresh: query.invalidate,
                    child: CustomScrollView(
                      primary: true,
                      slivers: [
                        header,
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
}

class BrowseTimeline extends StatelessWidget {
  const BrowseTimeline({super.key, required this.header, required this.dimmed});

  final Widget header;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: QueryBuilder(
        query: client.follows.useTimelineTags(),
        builder: (context, state) {
          final Map<FollowType, List<String>>? tags = state.data;
          if (tags == null) {
            return CustomScrollView(
              slivers: [
                header,
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }
          final List<String> followed = [
            ...tags[FollowType.update] ?? const <String>[],
            ...tags[FollowType.notify] ?? const <String>[],
          ];
          if (followed.isEmpty) {
            return CustomScrollView(
              slivers: [
                header,
                SliverDim(
                  dimmed: dimmed,
                  sliver: const SliverFillRemaining(
                    hasScrollBody: false,
                    child: TimelineEmpty(),
                  ),
                ),
              ],
            );
          }
          return LimitedWidthLayout(
            child: ListenableBuilder(
              listenable: context.watch<Settings>().tileSize,
              builder: (context, child) => TileLayout(
                tileSize: context.watch<Settings>().tileSize.value,
                child: FollowTimelinePostList(tags: followed, header: header),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TimelineEmpty extends StatelessWidget {
  const TimelineEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text(
            'No subscriptions',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          Text(
            'The Timeline shows new posts from the tags you subscribe to: '
            'artists, characters, anything you search for.',
            style: TextStyle(color: dimTextColor(context), height: 1.4),
          ),
          Material(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FollowsSubscriptionsPage(),
                ),
              ),
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Add tags',
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                      ),
                      SizedBox.square(
                        dimension: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.add,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SliverDim extends StatelessWidget {
  const SliverDim({super.key, required this.dimmed, required this.sliver});

  final bool dimmed;
  final Widget sliver;

  @override
  Widget build(BuildContext context) => SliverIgnorePointer(
    ignoring: dimmed,
    sliver: SliverAnimatedOpacity(
      opacity: dimmed ? 0.45 : 1,
      duration: defaultAnimationDuration,
      sliver: sliver,
    ),
  );
}

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({
    super.key,
    required this.feed,
    required this.scale,
    required this.picking,
    required this.onToggle,
    required this.onPick,
  });

  final BrowseFeed feed;
  final PopularScale scale;
  final bool picking;
  final VoidCallback onToggle;
  final void Function(BrowseFeed feed, PopularScale scale) onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
            child: Material(
              color: picking ? theme.cardColor : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        Text(
                          feed.label,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AnimatedRotation(
                          turns: picking ? 0.5 : 0,
                          duration: defaultAnimationDuration,
                          child: Icon(
                            Icons.expand_more,
                            color: picking
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: defaultAnimationDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: picking
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Column(
                      spacing: 8,
                      children: [
                        for (final BrowseFeed value in BrowseFeed.values)
                          BrowseFeedCard(
                            feed: value,
                            scale: scale,
                            selected: value == feed,
                            onPick: onPick,
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class BrowseFeedCard extends StatelessWidget {
  const BrowseFeedCard({
    super.key,
    required this.feed,
    required this.scale,
    required this.selected,
    required this.onPick,
  });

  final BrowseFeed feed;
  final PopularScale scale;
  final bool selected;
  final void Function(BrowseFeed feed, PopularScale scale) onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = theme.colorScheme.primary;
    return Material(
      color: selected
          ? accent.withValues(alpha: 0.08)
          : Color.alphaBlend(
              theme.colorScheme.onSurface.withValues(alpha: 0.03),
              theme.canvasColor,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: selected ? accent : Colors.transparent),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onPick(feed, scale),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          feed.label,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: selected ? accent : null,
                          ),
                        ),
                        DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 13,
                            color: dimTextColor(context),
                          ),
                          child: BrowseFeedSubtitle(feed: feed),
                        ),
                      ],
                    ),
                  ),
                  if (selected) Icon(Icons.check, color: accent),
                ],
              ),
              if (feed == BrowseFeed.popular)
                PopularScalePicker(
                  scale: scale,
                  onPick: (value) => onPick(BrowseFeed.popular, value),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrowseFeedSubtitle extends StatelessWidget {
  const BrowseFeedSubtitle({super.key, required this.feed});

  final BrowseFeed feed;

  @override
  Widget build(BuildContext context) => switch (feed) {
    BrowseFeed.latest => const Text('Every post, newest first'),
    BrowseFeed.popular => const Text('Highest scored in a period'),
    BrowseFeed.hot => const Text('order:rank'),
    BrowseFeed.timeline => QueryBuilder(
      query: context.watch<Client>().follows.useAll(
        query: FollowsQuery(types: [FollowType.update, FollowType.notify]),
      ),
      builder: (context, state) {
        final List<Follow> follows = state.data ?? const [];
        final int unseen = follows.fold(0, (sum, e) => sum + (e.unseen ?? 0));
        return Text(
          [
            if (follows.isEmpty) 'No tags',
            if (follows.isNotEmpty) '${follows.length} subscribed tags',
            if (unseen > 0) '$unseen new',
          ].join(' · '),
        );
      },
    ),
  };
}

class PopularScalePicker extends StatelessWidget {
  const PopularScalePicker({
    super.key,
    required this.scale,
    required this.onPick,
  });

  final PopularScale scale;
  final ValueChanged<PopularScale> onPick;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        spacing: 4,
        children: [
          for (final PopularScale value in PopularScale.values)
            Expanded(
              child: Material(
                color: value == scale
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => onPick(value),
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 32,
                    child: Center(
                      child: Text(
                        value.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: value == scale
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
