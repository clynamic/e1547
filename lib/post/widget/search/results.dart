import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostResults extends StatelessWidget {
  const PostResults({super.key, required this.top, this.dimmed = false});

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

class PostSearchPage extends StatelessWidget {
  const PostSearchPage({super.key, required this.tags});

  final String tags;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                PostParamsController(initial: PostParams(tags: tags)),
          ),
          ChangeNotifierProvider(create: (_) => PostDisplayController()),
        ],
        child: Scaffold(
          body: PostResults(
            top: (onRefresh) => [
              if (onRefresh != null)
                SliverHexagonRefresh(
                  onRefresh: onRefresh,
                  headerExtent: MediaQuery.paddingOf(context).top,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
