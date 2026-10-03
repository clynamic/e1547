import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return RouterDrawerEntry<FavPage>(
      child: client.identity.username == null
          ? AdaptiveScaffold(
              appBar: DefaultAppBar(
                title: Text(AppLocalizations.of(context).navFavorites),
              ),
              body: IconMessage(
                icon: const Icon(Icons.person_search),
                title: Text(AppLocalizations.of(context).favoritesUnavailable),
              ),
            )
          : FilterControllerProvider<PostFilter, Post>(
              create: (_) => FavoritePostFilter(client),
              keys: (_) => [client],
              child: ChangeNotifierProvider(
                create: (_) => PostParamsController(
                  initial: PostParams(tags: 'fav:${client.identity.username}'),
                ),
                child: PostPageHistoryConnector(
                  child: PostPageQueryBuilder(
                    builder: (context, state, query) => SelectionLayout<Post>(
                      items: state.data?.pages.expand((p) => p).toList(),
                      child: AdaptiveScaffold(
                        appBar: const PostSelectionAppBar(
                          child: PostPageAppBar(),
                        ),
                        floatingActionButton: const PostsPageFab(),
                        drawer: const RouterDrawer(),
                        endDrawer: ContextDrawer(
                          title: Text(AppLocalizations.of(context).postsTitle),
                          children: [
                            const FavoriteOrderSwitch(),
                            const Divider(),
                            const DrawerDenySwitch(),
                            DrawerTagCounter(
                              posts: state.data?.pages
                                  .expand((p) => p)
                                  .toList(),
                              error: state.error,
                            ),
                          ],
                        ),
                        body: LimitedWidthLayout(
                          child: ListenableBuilder(
                            listenable: context.watch<Settings>().tileSize,
                            builder: (context, child) => TileLayout(
                              tileSize: context
                                  .watch<Settings>()
                                  .tileSize
                                  .value,
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
    );
  }
}

class FavoriteOrderSwitch extends StatelessWidget {
  const FavoriteOrderSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    final tags = TagMap(controller.value.tags);
    final order = tags['order'];
    final addedOrder = order == null || order == 'fav';
    return SwitchListTile(
      secondary: const Icon(Icons.sort),
      title: Text(AppLocalizations.of(context).favoriteOrder),
      subtitle: Text(
        addedOrder
            ? AppLocalizations.of(context).orderAdded
            : AppLocalizations.of(context).orderId,
      ),
      value: addedOrder,
      onChanged: (value) {
        final next = TagMap(controller.value.tags);
        if (value) {
          next.remove('order');
        } else {
          next['order'] = PostOrder.newest.value;
        }
        controller.update((p) => p.copyWith(tags: next.toString()));
      },
    );
  }
}
