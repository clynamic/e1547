import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class FollowsBookmarkPage extends StatelessWidget {
  const FollowsBookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RouterDrawerEntry<FollowsBookmarkPage>(
      child: ChangeNotifierProvider(
        create: (_) => FollowParamsController(
          const FollowParams(types: [FollowType.bookmark]),
        ),
        child: SubEffect(
          effect: () {
            final client = context.read<Client>();
            client.followServer.sync();
            return null;
          },
          keys: const [],
          child: FollowPageQueryBuilder(
            builder: (context, state, query) => SelectionLayout<Follow>(
              items: state.data?.pages.expand((p) => p).toList(),
              child: PromptActions(
                child: AdaptiveScaffold(
                  appBar: FollowSelectionAppBar(
                    child: DefaultAppBar(
                      title: Text(AppLocalizations.of(context).navBookmarks),
                    ),
                  ),
                  drawer: const RouterDrawer(),
                  floatingActionButton: AddTagFab(
                    title: AppLocalizations.of(context).followAddToBookmarks,
                    onSubmit: (value) async {
                      value = value.trim();
                      if (value.isEmpty) return;
                      await context.read<Client>().follows.create(
                        tags: value,
                        type: FollowType.bookmark,
                      );
                    },
                  ),
                  body: TileLayout(
                    child: Builder(
                      builder: (context) => PullToRefresh(
                        onRefresh: query.invalidate,
                        child: PagedAlignedGridView<int, Follow>.count(
                          primary: true,
                          padding: defaultActionListPadding,
                          addAutomaticKeepAlives: false,
                          state: state.paging,
                          fetchNextPage: query.getNextPage,
                          builderDelegate: defaultPagedChildBuilderDelegate(
                            onRetry: query.getNextPage,
                            itemBuilder: (context, item, index) =>
                                FollowTile(follow: item),
                            onEmpty: Text(
                              AppLocalizations.of(context).followNoBookmarks,
                            ),
                            onError: Text(
                              AppLocalizations.of(
                                context,
                              ).followFailedToLoadBookmarks,
                            ),
                          ),
                          crossAxisCount: TileLayout.of(context).crossAxisCount,
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
