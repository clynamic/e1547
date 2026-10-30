import 'dart:math';

import 'package:e1547/comment/comment.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostImageTile extends StatelessWidget {
  const PostImageTile({
    super.key,
    required this.post,
    this.size,
    this.fit,
    this.showProgress,
    this.withLowRes,
    this.onTap,
    this.bottomBar,
  });

  final Post post;
  final VoidCallback? onTap;
  final PostImageSize? size;
  final BoxFit? fit;
  final bool? showProgress;
  final bool? withLowRes;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: TileSelectionOverlay<Post>(
        item: post,
        marker: post.isFavorited
            ? const Icon(Icons.favorite, size: 18, color: Colors.pinkAccent)
            : null,
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: PostTileOverlay(
                    post: post,
                    child: ContentHero(
                      tag: post.link,
                      content: FittedContent(
                        fit: fit ?? BoxFit.cover,
                        aspectRatio: post.width / post.height,
                      ),
                      child: PostImageWidget(
                        post: post,
                        size: size ?? PostImageSize.sample,
                        fit: fit ?? BoxFit.cover,
                        showProgress: showProgress ?? false,
                        withLowRes: withLowRes ?? false,
                        cacheSize: context.watch<ImageCacheSize?>()?.size,
                      ),
                    ),
                  ),
                ),
                if (bottomBar != null) bottomBar!,
              ],
            ),
            Positioned(top: 0, right: 0, child: PostImageTag(post: post)),
            if (onTap != null)
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
          ],
        ),
      ),
    );
  }
}

class PostImageTag extends StatelessWidget {
  const PostImageTag({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    if (post.ext == 'gif') {
      return const ColoredBox(
        color: Colors.black12,
        child: Icon(Icons.gif, color: Colors.white),
      );
    }
    if (post.type == PostType.video) {
      return const ColoredBox(
        color: Colors.black12,
        child: Icon(Icons.play_arrow, color: Colors.white),
      );
    }
    return const SizedBox.shrink();
  }
}

class PostTileOverlay extends StatelessWidget {
  const PostTileOverlay({super.key, required this.post, required this.child});

  final Post post;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (post.isDeleted) {
      return const Center(child: Text('deleted'));
    }
    if (post.type == PostType.unsupported) {
      return const Center(child: Text('unsupported'));
    }
    if (post.file == null) {
      return const Center(child: Text('unavailable'));
    }
    return child;
  }
}

class PostInfoBar extends StatelessWidget {
  const PostInfoBar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: Theme.of(context).iconTheme.copyWith(size: 16),
      child: ColoredBox(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.score.toString()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            post.score >= 0
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: switch (post.vote) {
                              1 => Colors.deepOrange,
                              -1 => Colors.blue,
                              _ => null,
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.favCount.toString()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.favorite,
                            color: post.isFavorited ? Colors.pinkAccent : null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${post.commentCount}'),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.comment),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(post.rating.name.toUpperCase()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: post.rating.icon,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void defaultPushPostDetail(BuildContext context, Post post) {
  int? cacheSize = context.read<ImageCacheSize>().size;
  final params = context.read<PostParamsController?>();
  final filter = context.read<PostFilter?>();
  Navigator.of(context).push(
    DismissRoute<void>(
      builder: (context) => ImageCacheSizeProvider(
        size: cacheSize,
        child: PostRouteScope(
          params: params,
          filter: filter,
          child: params != null
              ? PostDetailGallery(initialPostId: post.id)
              : PostDetail(post: post),
        ),
      ),
    ),
  );
}

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post, this.onTap});

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PostImageTile(
      post: post,
      onTap: onTap ?? () => defaultPushPostDetail(context, post),
      bottomBar: ValueListenableBuilder<bool>(
        valueListenable: context.watch<Settings>().showPostInfo,
        builder: (context, value, child) =>
            value ? PostInfoBar(post: post) : const SizedBox(),
      ),
    );
  }
}

class PostComicTile extends StatelessWidget {
  const PostComicTile({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.width / post.height,
      child: PostImageTile(
        post: post,
        size: post.type == PostType.video
            ? PostImageSize.sample
            : PostImageSize.file,
        withLowRes: true,
        showProgress: false,
        onTap: () => defaultPushPostDetail(context, post),
      ),
    );
  }
}

class PostFeedTile extends StatelessWidget {
  const PostFeedTile({super.key, required this.post});

  final Post post;

  static const double minRatio = 0.6;

  void _openFullscreen(BuildContext context) {
    final int? cacheSize = context.read<ImageCacheSize>().size;
    final PostParamsController? params = context.read<PostParamsController?>();
    final PostFilter? filter = context.read<PostFilter?>();
    Navigator.of(context).push(
      DismissRoute<void>(
        builder: (context) => ImageCacheSizeProvider(
          size: cacheSize,
          child: PostRouteScope(
            params: params,
            filter: filter,
            child: params != null
                ? PostFullscreenGallery(initialPostId: post.id)
                : PostFullscreen(post: post),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color onSurface = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AspectRatio(
              aspectRatio: max(post.width / post.height, minRatio),
              child: PostImageTile(
                post: post,
                onTap: () => _openFullscreen(context),
              ),
            ),
          ),
          InkWell(
            onTap: () => defaultPushPostDetail(context, post),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          child: PostArtistNames(
                            post: post,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 18 / 15,
                            ),
                          ),
                        ),
                        Text(
                          DateFormatting.age(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostCommentsPage(postId: post.id),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.comment,
                            size: 16,
                            color: onSurface.withValues(alpha: 0.6),
                          ),
                          Text(
                            '${post.commentCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: onSurface.withValues(alpha: 0.75),
                    ),
                    child: FavoriteButton(post: post, size: 22, outlined: true),
                  ),
                ],
              ),
            ),
          ),
          if (post.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize: 13,
                  height: 18 / 13,
                  color: onSurface.withValues(alpha: 0.65),
                ),
                child: DText(post.description.ellipse(200)),
              ),
            ),
        ],
      ),
    );
  }
}
