import 'dart:math';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
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
      child: SelectionItemOverlay(
        item: post,
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
                    child: Hero(
                      tag: post.link,
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
      return Center(child: Text(AppLocalizations.of(context).postStateDeleted));
    }
    if (post.type == PostType.unsupported) {
      return Center(
        child: Text(AppLocalizations.of(context).postStateUnsupported),
      );
    }
    if (post.file == null) {
      return Center(
        child: Text(AppLocalizations.of(context).postStateUnavailable),
      );
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
    MaterialPageRoute(
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

  @override
  Widget build(BuildContext context) {
    Widget actions() {
      return Dimmed(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostCommentsPage(postId: post.id),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(post.commentCount.toString()),
              ],
            ),
            MutationBuilder(
              mutation: context.watch<Client>().posts.useVote(id: post.id),
              builder: (context, state, mutate) {
                final client = context.watch<Client>();
                final messenger = ScaffoldMessenger.of(context);
                final l10n = AppLocalizations.of(context);
                final enabled = client.hasLogin && !state.isLoading;

                return VoteDisplay(
                  vote: post.vote,
                  score: post.score,
                  onUpvote: enabled
                      ? (isLiked) async {
                          mutate((upvote: true, replace: !isLiked)).catchError((
                            error,
                          ) {
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(l10n.postUpvoteFailed(post.id)),
                              ),
                            );
                            return error;
                          });
                          return !isLiked;
                        }
                      : null,
                  onDownvote: enabled
                      ? (isLiked) async {
                          mutate((
                            upvote: false,
                            replace: !isLiked,
                          )).catchError((error) {
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(l10n.postDownvoteFailed(post.id)),
                              ),
                            );
                            return error;
                          });
                          return !isLiked;
                        }
                      : null,
                );
              },
            ),
            Row(
              children: [
                FavoriteButton(post: post),
                const SizedBox(width: 4),
                Text(post.favCount.toString()),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => Share.text(
                context,
                context.read<Client>().withHost(post.link),
              ),
            ),
          ],
        ),
      );
    }

    Widget menu() {
      return PopupMenuButton<VoidCallback>(
        icon: Icon(Icons.more_vert, color: dimTextColor(context)),
        iconSize: 18,
        onSelected: (value) => value(),
        itemBuilder: (context) => [
          if (post.file != null)
            PopupMenuTile(
              value: () => postDownloadingNotification(context, {post}),
              title: AppLocalizations.of(context).menuDownload,
              icon: Icons.file_download,
            ),
          PopupMenuTile(
            value: () => launch(context.read<Client>().withHost(post.link)),
            title: AppLocalizations.of(context).menuBrowse,
            icon: Icons.open_in_browser,
          ),
        ],
      );
    }

    Widget image() {
      final params = context.read<PostParamsController?>();
      final filter = context.read<PostFilter?>();
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: AspectRatio(
          aspectRatio: max(post.width / post.height, 0.9),
          child: PostImageTile(
            post: post,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageCacheSizeProvider(
                  size: fullscreenImageCacheSize,
                  child: PostRouteScope(
                    params: params,
                    filter: filter,
                    child: params != null
                        ? PostFullscreenGallery(initialPostId: post.id)
                        : PostFullscreen(post: post),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => defaultPushPostDetail(context, post),
            child: Padding(
              padding: const EdgeInsets.all(8).copyWith(bottom: 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: TimedText(
                          created: post.createdAt,
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                            child: ArtistName(post: post),
                          ),
                        ),
                      ),
                      menu(),
                    ],
                  ),
                  if (post.description.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: DText(post.description.ellipse(200)),
                          ),
                        ),
                      ],
                    ),
                  image(),
                  const SizedBox(height: 8),
                  actions(),
                ],
              ),
            ),
          ),
        ),
        const Divider(indent: 8, endIndent: 8),
      ],
    );
  }
}
