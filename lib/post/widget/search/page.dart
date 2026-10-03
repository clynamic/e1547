import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key, this.params, this.drawerActions = const []});

  final PostParams? params;
  final List<Widget> drawerActions;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return RouterDrawerEntry<PostsPage>(
      child: FilterControllerProvider(
        create: (_) => PostFilter(client),
        keys: (_) => [client],
        child: ChangeNotifierProvider(
          create: (_) => PostParamsController(initial: params),
          child: ChangeNotifierProvider(
            create: (_) => PostDisplayController(),
            child: PostPageHistoryConnector(
              child: FollowSeenConnector(
                child: PostPageQueryBuilder(
                  builder: (context, state, query) => SelectionLayout<Post>(
                    items: state.data?.pages.expand((p) => p).toList(),
                    child: AdaptiveScaffold(
                      appBar: const PostSelectionAppBar(
                        child: PostPageAppBar(),
                      ),
                      floatingActionButton:
                          context.watch<PostParamsController>().canSearch
                          ? const PostsPageFab()
                          : null,
                      drawer: const RouterDrawer(),
                      endDrawer: ContextDrawer(
                        title: Text(AppLocalizations.of(context).postsTitle),
                        children: [
                          ...drawerActions,
                          if (drawerActions.isNotEmpty) const Divider(),
                          if (context
                                  .watch<PostParamsController>()
                                  .value
                                  .poolId !=
                              null) ...[
                            const PoolReaderSwitch(),
                            const PoolOrderSwitch(),
                          ],
                          const DrawerDenySwitch(),
                          DrawerTagCounter(
                            posts: state.data?.pages.expand((p) => p).toList(),
                            error: state.error,
                          ),
                        ],
                      ),
                      body: LimitedWidthLayout(
                        child: ListenableBuilder(
                          listenable: context.watch<Settings>().tileSize,
                          builder: (context, child) => TileLayout(
                            tileSize: context.watch<Settings>().tileSize.value,
                            child: const PostList(),
                          ),
                        ),
                      ),
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
