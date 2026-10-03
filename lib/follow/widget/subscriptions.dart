import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class FollowsSubscriptionsPage extends StatelessWidget {
  const FollowsSubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RouterDrawerEntry<FollowsSubscriptionsPage>(
      child: ValueListenableBuilder(
        valueListenable: context.watch<Settings>().filterUnseenFollows,
        builder: (context, filterUnseenFollows, child) =>
            ChangeNotifierProvider<FollowParamsController>(
              create: (_) => FollowParamsController(
                FollowParams(
                  types: const [FollowType.update, FollowType.notify],
                  hasUnseen: filterUnseenFollows ? true : null,
                ),
              ),
              key: ValueKey(filterUnseenFollows),
              child: child,
            ),
        child: SubEffect(
          effect: () {
            final client = context.read<Client>();
            client.followServer.sync();
            return null;
          },
          keys: const [],
          child: FollowPageQueryBuilder(
            builder: (context, state, query) {
              final paramsController = context.read<FollowParamsController>();
              if (paramsController.value.hasUnseen == true &&
                  state is InfiniteQuerySuccess &&
                  (state.data?.pages.expand((p) => p).isEmpty ?? true)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  paramsController.update((p) => p.copyWith(hasUnseen: null));
                });
              }
              return SelectionLayout<Follow>(
                items: state.data?.pages.expand((p) => p).toList(),
                child: PromptActions(
                  child: AdaptiveScaffold(
                    appBar: FollowSelectionAppBar(
                      child: DefaultAppBar(
                        title: Text(
                          AppLocalizations.of(context).navSubscriptions,
                        ),
                        actions: const [ContextDrawerButton()],
                      ),
                    ),
                    drawer: const RouterDrawer(),
                    endDrawer: ContextDrawer(
                      title: Text(
                        AppLocalizations.of(context).navSubscriptions,
                      ),
                      children: const [
                        FollowEditingTile(),
                        Divider(),
                        FollowFilterReadTile(),
                        FollowMarkReadTile(),
                        Divider(),
                        FollowForceSyncTile(),
                      ],
                    ),
                    floatingActionButton: AddTagFab(
                      title: AppLocalizations.of(
                        context,
                      ).followAddToSubscriptions,
                      onSubmit: (value) async {
                        value = value.trim();
                        if (value.isEmpty) return;
                        await context.read<Client>().follows.create(
                          tags: value,
                          type: FollowType.update,
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
                            state: state.paging,
                            fetchNextPage: query.getNextPage,
                            addAutomaticKeepAlives: false,
                            builderDelegate: defaultPagedChildBuilderDelegate(
                              onRetry: query.getNextPage,
                              itemBuilder: (context, item, index) =>
                                  FollowTile(follow: item),
                              onEmpty: Text(
                                AppLocalizations.of(
                                  context,
                                ).followNoSubscriptions,
                              ),
                              onError: Text(
                                AppLocalizations.of(
                                  context,
                                ).followFailedToLoadSubscriptions,
                              ),
                            ),
                            crossAxisCount: TileLayout.of(
                              context,
                            ).crossAxisCount,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
