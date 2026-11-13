import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

/// Closes the enclosing route once its list stops holding what it shows.
/// [close] is latched, so repeated calls from build close once.
mixin PostSearchRouteAware<T extends StatefulWidget> on State<T> {
  String? _openedWith;
  bool _closing = false;

  void closeWhenSearchChanged(BuildContext context) {
    final tags = context.watch<PostParamsController>().value.tags ?? '';
    _openedWith ??= tags;
    if (_openedWith != tags) close();
  }

  void close() {
    if (_closing) return;
    _closing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route == null) return;
      if (route.isCurrent) {
        Navigator.of(context).maybePop();
      } else {
        Navigator.of(context).removeRoute(route);
      }
    });
  }
}

class PostDetailGallery extends StatefulWidget {
  const PostDetailGallery({
    super.key,
    this.initialPostId,
    this.pageController,
    this.onPageChanged,
  }) : assert(
         initialPostId == null || pageController == null,
         'Cannot pass both initialPostId and pageController',
       );

  final int? initialPostId;
  final PageController? pageController;
  final ValueChanged<int>? onPageChanged;

  @override
  State<PostDetailGallery> createState() => _PostDetailGalleryState();
}

class _PostDetailGalleryState extends State<PostDetailGallery>
    with PostSearchRouteAware<PostDetailGallery> {
  late int? postId = widget.initialPostId;
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    closeWhenSearchChanged(context);
    return PostPageQueryBuilder(
      builder: (context, state, query) {
        final items = state.paging.items;
        final index = postId == null
            ? 0
            : items?.indexWhere((post) => post.id == postId) ?? -1;

        if (index < 0) {
          final int? id = postId;
          if (items != null) {
            if (!_shown && id != null) return PostLoadingPage(id);
            close();
          }
          if (id != null) {
            if (context.read<Client>().posts.postCache.get(id)
                case final Post post) {
              return PostDetail(post: post);
            }
            return SkeletonPage(
              child: PostDetail(
                post: const PostGhost(),
                summary: context.read<Client>().posts.partialPostCache.get(id),
              ),
            );
          }
          return const Scaffold(
            appBar: TransparentAppBar(child: DefaultAppBar()),
            body: Center(child: HexagonalLoadingIndicator()),
          );
        }

        _shown = true;
        return SubDefault<PageController>(
          value: widget.pageController,
          create: () => PageController(initialPage: index),
          builder: (context, pageController) => GalleryButtons(
            controller: pageController,
            child: PagedPageView(
              pageController: pageController,
              state: state.paging,
              fetchNextPage: query.getNextPage,
              builderDelegate: defaultPagedChildBuilderDelegate<Post>(
                onRetry: query.getNextPage,
                pageBuilder: (context, child) => Scaffold(
                  appBar: const TransparentAppBar(child: DefaultAppBar()),
                  body: child,
                ),
                onEmpty: const Text('No posts'),
                onError: const Text('Failed to load posts'),
                itemBuilder: (context, item, index) => SubScrollController(
                  builder: (context, scrollController) =>
                      PrimaryScrollController(
                        controller: scrollController,
                        child: PostDetail(
                          post: item,
                          onTapImage: () =>
                              _pushFullscreen(context, item, pageController),
                        ),
                      ),
                ),
              ),
              onPageChanged: (index) {
                final items = state.paging.items;
                if (items != null && index < items.length) {
                  postId = items[index].id;
                }
                widget.onPageChanged?.call(index);
                preloadPostImages(
                  context: context,
                  index: index,
                  posts: items ?? [],
                  size: PostImageSize.sample,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _pushFullscreen(
    BuildContext context,
    Post post,
    PageController pageController,
  ) {
    final params = context.read<PostParamsController>();
    final filter = context.read<PostFilter?>();
    Navigator.of(context).push(
      DismissRoute<void>(
        builder: (context) => PostRouteScope(
          params: params,
          filter: filter,
          child: PostFullscreenGallery(
            initialPostId: post.id,
            onPageSettled: pageController.jumpToPage,
          ),
        ),
      ),
    );
  }
}

void pushPostGallery(
  BuildContext context, {
  required PostParams params,
  required int initialPostId,
}) {
  final PostFilter? filter = context.read<PostFilter?>();
  Navigator.of(context).push(
    DismissRoute<void>(
      builder: (context) => ChangeNotifierProvider(
        create: (_) => PostParamsController(initial: params, canSearch: false),
        child: PostRouteScope(
          params: null,
          filter: filter,
          child: PostDetailGallery(initialPostId: initialPostId),
        ),
      ),
    ),
  );
}
