import 'package:e1547/l10n/app_localizations.dart';
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
          if (items != null) close();
          return const Scaffold(
            appBar: TransparentAppBar(child: DefaultAppBar()),
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
                onEmpty: Text(AppLocalizations.of(context).noPosts),
                onError: Text(AppLocalizations.of(context).failedToLoadPosts),
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
      MaterialPageRoute(
        builder: (context) => ImageCacheSizeProvider(
          size: fullscreenImageCacheSize,
          child: PostRouteScope(
            params: params,
            filter: filter,
            child: PostFullscreenGallery(
              initialPostId: post.id,
              onPageChanged: pageController.jumpToPage,
            ),
          ),
        ),
      ),
    );
  }
}
