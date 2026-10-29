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
        List<Widget> top(Future<void> Function()? onRefresh) => [
          if (onRefresh != null)
            SliverHexagonRefresh(
              onRefresh: onRefresh,
              headerExtent:
                  pickerHeaderHeight + MediaQuery.paddingOf(context).top,
              header: BrowseHeader(
                feed: feed,
                scale: scale,
                picking: picking,
                onToggle: () => setState(() => picking = !picking),
              ),
            )
          else
            SliverToBoxAdapter(
              child: BrowseHeader(
                feed: feed,
                scale: scale,
                picking: picking,
                onToggle: () => setState(() => picking = !picking),
              ),
            ),
          SliverToBoxAdapter(
            child: BrowseFeedPicker(
              feed: feed,
              scale: scale,
              picking: picking,
              onPick: (value, scale) {
                settings.browseFeed.value = value;
                settings.popularScale.value = scale;
                setState(() => picking = false);
              },
            ),
          ),
        ];
        return Scaffold(
          body: GestureDetector(
            onTap: picking ? () => setState(() => picking = false) : null,
            child: switch (feed) {
              BrowseFeed.timeline => BrowseTimeline(top: top, dimmed: picking),
              _ => BrowsePosts(
                key: ValueKey(browseFeedTags(feed, scale)),
                tags: browseFeedTags(feed, scale),
                top: top,
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
    required this.top,
    required this.dimmed,
  });

  final String tags;
  final List<Widget> Function(Future<void> Function()? onRefresh) top;
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
        child: PostResults(top: top, dimmed: dimmed),
      ),
    );
  }
}

class BrowseTimeline extends StatelessWidget {
  const BrowseTimeline({super.key, required this.top, required this.dimmed});

  final List<Widget> Function(Future<void> Function()? onRefresh) top;
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
                ...top(null),
                const SliverToBoxAdapter(child: PostFeedSkeleton()),
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
                ...top(null),
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
          return ChangeNotifierProvider(
            create: (_) => PostDisplayController(PostDisplayType.timeline),
            child: PostResults(
              query: client.posts.useByTags(tags: followed),
              top: top,
              dimmed: dimmed,
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

class BrowseHeader extends StatelessWidget {
  const BrowseHeader({
    super.key,
    required this.feed,
    required this.scale,
    required this.picking,
    required this.onToggle,
  });

  final BrowseFeed feed;
  final PopularScale scale;
  final bool picking;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => PickerHeader(
    label: feed.label,
    subtitle: feed == BrowseFeed.popular ? scale.period : null,
    picking: picking,
    onToggle: onToggle,
    leading: Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
      child: Transform.translate(
        offset: const Offset(-2, 0),
        child: Image.asset('assets/icon/app/inapp.png', width: 52, height: 52),
      ),
    ),
  );
}

class BrowseFeedPicker extends StatelessWidget {
  const BrowseFeedPicker({
    super.key,
    required this.feed,
    required this.scale,
    required this.picking,
    required this.onPick,
  });

  final BrowseFeed feed;
  final PopularScale scale;
  final bool picking;
  final void Function(BrowseFeed feed, PopularScale scale) onPick;

  @override
  Widget build(BuildContext context) => PickerList(
    picking: picking,
    children: [
      for (final BrowseFeed value in BrowseFeed.values)
        BrowseFeedCard(
          feed: value,
          scale: scale,
          selected: value == feed,
          onPick: onPick,
        ),
    ],
  );
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
  Widget build(BuildContext context) => PickerCard(
    title: feed.label,
    icon: feed.icon,
    subtitle: BrowseFeedSubtitle(feed: feed),
    selected: selected,
    onTap: () => onPick(feed, scale),
    child: feed == BrowseFeed.popular
        ? PopularScalePicker(
            scale: scale,
            onPick: (value) => onPick(BrowseFeed.popular, value),
          )
        : null,
  );
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
