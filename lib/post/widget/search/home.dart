import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return RouterDrawerEntry<HomePage>(
      child: FilterControllerProvider(
        create: (_) => PostFilter(client),
        keys: (_) => [client],
        child: ChangeNotifierProvider(
          create: (_) => PostParamsController(
            initial: PostParams(tags: client.traits.value.homeTags),
          ),
          builder: (context, _) => SubValueListener(
            listenable: context.watch<PostParamsController>(),
            listener: (PostParams value) => client.traits.value = client
                .traits
                .value
                .copyWith(homeTags: value.tags ?? ''),
            builder: (context, _) => PostPageHistoryConnector(
              child: PostPageQueryBuilder(
                builder: (context, state, query) => SelectionLayout<Post>(
                  items: state.data?.pages.expand((p) => p).toList(),
                  child: AdaptiveScaffold(
                    appBar: const PostSelectionAppBar(
                      child: DefaultAppBar(
                        title: AppIcon(),
                        centerTitle: true,
                        actions: [
                          PostsPageFilterButton(),
                          ContextDrawerButton(),
                        ],
                      ),
                    ),
                    floatingActionButton: const PostsPageFab(),
                    drawer: const RouterDrawer(),
                    endDrawer: ContextDrawer(
                      title: Text(AppLocalizations.of(context).postsTitle),
                      children: [
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
