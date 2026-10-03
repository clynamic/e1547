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

class PoolPage extends StatelessWidget {
  const PoolPage({super.key, required this.pool, this.orderByOldest});

  final Pool pool;
  final bool? orderByOldest;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final oldestFirst = orderByOldest ?? true;
    return FilterControllerProvider(
      create: (_) => PostFilter(client),
      keys: (_) => [client],
      child: ChangeNotifierProvider(
        create: (_) => PostParamsController(
          initial: PostParams(
            tags: oldestFirst
                ? 'pool:${pool.id} order:pool'
                : 'pool:${pool.id} order:${PostOrder.newest.value}',
          ),
          canSearch: false,
        ),
        child: ChangeNotifierProvider(
          create: (_) => PostDisplayController(PostDisplayType.comic),
          child: PoolHistoryConnector(
            pool: pool,
            child: FollowSeenConnector(
              child: PostPageQueryBuilder(
                builder: (context, state, query) => SelectionLayout<Post>(
                  items: state.data?.pages.expand((p) => p).toList(),
                  child: AdaptiveScaffold(
                    appBar: PostSelectionAppBar(
                      child: DefaultAppBar(
                        title: Text(tagToName(pool.name)),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            tooltip: AppLocalizations.of(context).info,
                            onPressed: () =>
                                showPoolPrompt(context: context, pool: pool),
                          ),
                          const ContextDrawerButton(),
                        ],
                      ),
                    ),
                    endDrawer: ContextDrawer(
                      title: Text(AppLocalizations.of(context).filterPool),
                      children: [
                        const PoolReaderSwitch(),
                        const PoolOrderSwitch(),
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
    );
  }
}

class PoolOrderSwitch extends StatelessWidget {
  const PoolOrderSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PostParamsController>();
    final oldestFirst = controller.value.poolOldestFirst;
    return SwitchListTile(
      secondary: const Icon(Icons.sort),
      title: Text(AppLocalizations.of(context).poolOrder),
      subtitle: Text(
        oldestFirst
            ? AppLocalizations.of(context).poolOldestFirst
            : AppLocalizations.of(context).poolNewestFirst,
      ),
      value: oldestFirst,
      onChanged: (value) {
        final next = TagMap(controller.value.tags);
        if (value) {
          next['order'] = 'pool';
        } else {
          next['order'] = PostOrder.newest.value;
        }
        controller.update((p) => p.copyWith(tags: next.toString()));
      },
    );
  }
}

class PoolReaderSwitch extends StatelessWidget {
  const PoolReaderSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final display = context.watch<PostDisplayController>();
    final readerMode = display.value == PostDisplayType.comic;
    return SwitchListTile(
      secondary: const Icon(Icons.auto_stories),
      title: Text(AppLocalizations.of(context).poolReaderMode),
      subtitle: Text(
        readerMode
            ? AppLocalizations.of(context).poolReaderLargeImages
            : AppLocalizations.of(context).poolReaderNormalGrid,
      ),
      value: readerMode,
      onChanged: (value) {
        display.value = value ? PostDisplayType.comic : PostDisplayType.grid;
        Scaffold.of(context).closeEndDrawer();
      },
    );
  }
}
