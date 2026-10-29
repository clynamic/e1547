import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostResults extends StatefulWidget {
  const PostResults({super.key, required this.top, this.dimmed = false});

  final SliverTop top;
  final bool dimmed;

  @override
  State<PostResults> createState() => _PostResultsState();
}

class _PostResultsState extends State<PostResults> {
  final RefreshNote note = RefreshNote();

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<void> refresh(InfiniteQuery<List<int>, int> query) async {
    final List<int>? before = query.state.data?.pages.firstOrNull;
    await query.invalidate();
    if (!mounted) return;
    final InfiniteQueryStatus<List<int>, int> after = query.state;
    if (after.isError) {
      final Object? error = after.error;
      note.value = (context, retry) =>
          RefreshFailedNote(error: error, onRetry: retry);
    } else if (before != null &&
        listEquals(before, after.data?.pages.firstOrNull)) {
      note.value = (context, retry) => const RefreshUnchangedNote();
    }
  }

  @override
  Widget build(BuildContext context) => ListenableProvider<RefreshNote>.value(
    value: note,
    child: PostPageHistoryConnector(
      child: FollowSeenConnector(
        child: PostPageQueryBuilder(
          builder: (context, state, query) => PostSearchDock(
            child: LimitedWidthLayout(
              child: ListenableBuilder(
                listenable: context.watch<Settings>().tileSize,
                builder: (context, child) => TileLayout(
                  tileSize: context.watch<Settings>().tileSize.value,
                  child: RefreshShortcuts(
                    onRefresh: () => refresh(query),
                    child: CustomScrollView(
                      primary: true,
                      physics: refreshPhysics,
                      slivers: [
                        ...widget.top(() => refresh(query)),
                        SliverDim(
                          dimmed: widget.dimmed,
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
