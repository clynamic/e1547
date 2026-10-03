import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  const PostList({super.key, this.displayType});

  final PostDisplayType? displayType;

  @override
  Widget build(BuildContext context) => PostPageQueryBuilder(
    builder: (context, state, query) {
      // The scroll view shadows the primary scroll controller from the
      // footer inside it, so it is handed in from out here.
      final scrollController = PrimaryScrollController.of(context);
      return PullToRefresh(
        onRefresh: query.invalidate,
        child: CustomScrollView(
          primary: true,
          slivers: [
            if (state.error case final error?
                when isConnectionError(error) &&
                    (state.data?.pages.isNotEmpty ?? false))
              SliverToBoxAdapter(
                child: _OfflineBanner(onRetry: query.invalidate),
              ),
            SliverPadding(
              padding: defaultListPadding,
              sliver: SliverPostList(displayType: displayType),
            ),
            // The footer carries the bottom clearance of the list, so the
            // posts end flush above it.
            SliverPadding(
              padding: defaultListPadding.copyWith(
                bottom: defaultActionListPadding.bottom,
              ),
              sliver: SliverToBoxAdapter(
                child: PostListFooter(
                  state: state,
                  query: query,
                  scrollController: scrollController,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class SliverPostList extends StatelessWidget {
  const SliverPostList({super.key, this.displayType});

  final PostDisplayType? displayType;

  @override
  Widget build(BuildContext context) => PostPageQueryBuilder(
    builder: (context, state, query) => switch (displayType ??
        context.watch<PostDisplayController?>()?.value ??
        PostDisplayType.grid) {
      PostDisplayType.grid => PostGridSliver(
        state: state.paging,
        fetchNextPage: query.getNextPage,
      ),
      PostDisplayType.comic => PostComicSliver(
        state: state.paging,
        fetchNextPage: query.getNextPage,
      ),
      PostDisplayType.timeline => PostTimelineSliver(
        state: state.paging,
        fetchNextPage: query.getNextPage,
      ),
    },
  );
}

class PostGridSliver extends StatelessWidget {
  const PostGridSliver({
    super.key,
    required this.state,
    required this.fetchNextPage,
  });

  final PagingState<Object, Post> state;
  final VoidCallback fetchNextPage;

  @override
  Widget build(BuildContext context) {
    PagedChildBuilderDelegate<Post> buildBuilderDelegate(
      ItemWidgetBuilder<Post> itemBuilder,
    ) => defaultPagedChildBuilderDelegate<Post>(
      onRetry: fetchNextPage,
      onEmpty: Text(AppLocalizations.of(context).noPosts),
      onError: switch (state.error) {
        final error? when isConnectionError(error) => Text(
          AppLocalizations.of(context).offlineNoData,
        ),
        _ => Text(AppLocalizations.of(context).failedToLoadPosts),
      },
      itemBuilder: itemBuilder,
    );

    Widget itemBuilder(context, item, index) => ImageCacheSizeProvider(
      size: TileLayout.of(context).tileSize * 2,
      child: PostTile(post: item),
    );

    return switch (TileLayout.of(context).stagger) {
      GridQuilt.square => PagedSliverGrid<Object, Post>(
        showNewPageErrorIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: buildBuilderDelegate(itemBuilder),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: TileLayout.of(context).crossAxisCount,
          childAspectRatio: 1 / TileLayout.of(context).tileHeightFactor,
        ),
      ),
      GridQuilt.vertical => PagedSliverMasonryGrid<Object, Post>.count(
        showNewPageErrorIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        state: state,
        fetchNextPage: fetchNextPage,
        builderDelegate: buildBuilderDelegate(
          (context, item, index) => AspectRatio(
            aspectRatio: 1 / (item.height / item.width),
            child: itemBuilder(context, item, index),
          ),
        ),
        crossAxisCount: TileLayout.of(context).crossAxisCount,
      ),
    };
  }
}

class PostComicSliver extends StatelessWidget {
  const PostComicSliver({
    super.key,
    required this.state,
    required this.fetchNextPage,
  });

  final PagingState<Object, Post> state;
  final VoidCallback fetchNextPage;

  @override
  Widget build(BuildContext context) {
    return PagedSliverList(
      state: state,
      fetchNextPage: fetchNextPage,
      builderDelegate: defaultPagedChildBuilderDelegate<Post>(
        onRetry: fetchNextPage,
        onEmpty: Text(AppLocalizations.of(context).noPosts),
        onError: Text(AppLocalizations.of(context).failedToLoadPosts),
        itemBuilder: (context, item, index) => Padding(
          padding:
              LimitedWidthLayout.maybeOf(context)?.padding ?? EdgeInsets.zero,
          child: ImageCacheSizeProvider(
            size: 800,
            child: PostComicTile(post: item),
          ),
        ),
      ),
    );
  }
}

class PostTimelineSliver extends StatelessWidget {
  const PostTimelineSliver({
    super.key,
    required this.state,
    required this.fetchNextPage,
  });

  final PagingState<Object, Post> state;
  final VoidCallback fetchNextPage;

  @override
  Widget build(BuildContext context) {
    return PagedSliverList(
      state: state,
      fetchNextPage: fetchNextPage,
      builderDelegate: defaultPagedChildBuilderDelegate<Post>(
        onRetry: fetchNextPage,
        onEmpty: Text(AppLocalizations.of(context).noPosts),
        onError: Text(AppLocalizations.of(context).failedToLoadPosts),
        itemBuilder: (context, item, index) => Padding(
          padding:
              LimitedWidthLayout.maybeOf(context)?.padding ?? EdgeInsets.zero,
          child: ImageCacheSizeProvider(
            size: 800,
            child: PostFeedTile(post: item),
          ),
        ),
      ),
    );
  }
}

/// A dismissible banner shown while a post list shows cached data offline.
class _OfflineBanner extends StatefulWidget {
  const _OfflineBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<_OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<_OfflineBanner> {
  bool dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (dismissed) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return MaterialBanner(
      content: Text(l10n.offlineBanner),
      actions: [
        TextButton(onPressed: widget.onRetry, child: Text(l10n.actionTryAgain)),
        TextButton(
          onPressed: () => setState(() => dismissed = true),
          child: Text(l10n.actionCancel),
        ),
      ],
    );
  }
}
