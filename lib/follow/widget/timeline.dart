import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class FollowsTimelinePage extends StatelessWidget {
  const FollowsTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return RouterDrawerEntry<FollowsTimelinePage>(
      child: FilterControllerProvider(
        create: (_) => PostFilter(client),
        keys: (_) => [client],
        child: QueryBuilder(
          query: client.follows.useTimelineTags(),
          builder: (context, tagsState) {
            final tags = tagsState.data;
            if (tags == null) {
              return Scaffold(
                appBar: DefaultAppBar(
                  title: Text(t('Timeline')),
                  actions: const [ContextDrawerButton()],
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            final followedTags = [
              ...tags[FollowType.update] ?? const <String>[],
              ...tags[FollowType.notify] ?? const <String>[],
            ];
            return AdaptiveScaffold(
              appBar: DefaultAppBar(
                title: Text(t('Timeline')),
                actions: const [ContextDrawerButton()],
              ),
              drawer: const RouterDrawer(),
              endDrawer: ContextDrawer(
                title: Text(t('Timeline')),
                children: const [
                  FollowEditingTile(),
                  Divider(),
                  DrawerDenySwitch(),
                ],
              ),
              body: LimitedWidthLayout(
                child: ListenableBuilder(
                  listenable: context.watch<Settings>().tileSize,
                  builder: (context, child) => TileLayout(
                    tileSize: context.watch<Settings>().tileSize.value,
                    child: FollowTimelinePostList(tags: followedTags),
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

class FollowTimelinePostList extends StatelessWidget {
  const FollowTimelinePostList({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final query = client.posts.useByTags(tags: tags);
    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.posts.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => PullToRefresh(
          onRefresh: query.invalidate,
          child: CustomScrollView(
            primary: true,
            slivers: [
              SliverPadding(
                padding: defaultActionListPadding,
                sliver: PostTimelineSliver(
                  state: state.paging,
                  fetchNextPage: query.getNextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
