import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {
  const PostDetail({super.key, required this.post, this.onTapImage});

  final Post post;
  final VoidCallback? onTapImage;

  Widget image(BuildContext context, Size size) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: (size.height / 2),
        maxHeight: size.width > size.height
            ? max(400, size.height * 0.8)
            : double.infinity,
      ),
      child: AnimatedSize(
        duration: defaultAnimationDuration,
        child: PostDetailImageDisplay(
          post: post,
          onTap: () {
            PostVideoRoute.of(context).keepPlaying();
            if (onTapImage != null) {
              onTapImage!();
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ImageCacheSizeProvider(
                    size: fullscreenImageCacheSize,
                    child: PostFullscreen(post: post),
                  ),
                ),
              );
            }
          },
        ),
      ),
    ),
  );

  Widget upperBody(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArtistDisplay(post: post),
        DeletionDisplay(post: post),
        LikeDisplay(post: post),
        DescriptionDisplay(post: post),
      ],
    ),
  );

  Widget middleBody(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(children: [CommentDisplay(post: post)]),
  );

  Widget lowerBody(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        RelationshipDisplay(post: post),
        PoolDisplay(post: post),
        DenylistTagDisplay(post: post),
        TagDisplay(post: post),
        FileDisplay(post: post),
        SourceDisplay(post: post),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PostVideoRoute(
      post: post,
      child: PostHistoryConnector(
        post: post,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PostDetailAppBar(post: post),
          floatingActionButton: context.read<Client>().hasLogin
              ? PostDetailFab(post: post)
              : null,
          body: MediaQuery.removeViewInsets(
            context: context,
            removeTop: true,
            child: Builder(
              builder: (context) {
                final size = MediaQuery.sizeOf(context);
                if (size.width < 1000) {
                  return ListView(
                    primary: true,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      bottom: kBottomNavigationBarHeight + 24,
                    ),
                    children: [
                      image(context, size),
                      upperBody(context),
                      middleBody(context),
                      lowerBody(context),
                    ],
                  );
                } else {
                  double sideBarWidth;
                  if (size.width > 1400) {
                    sideBarWidth = 404;
                  } else {
                    sideBarWidth = 304;
                  }
                  return CustomScrollView(
                    primary: true,
                    slivers: [
                      SliverCrossAxisGroup(
                        slivers: [
                          SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    image(context, size),
                                    upperBody(context),
                                  ],
                                ),
                              ),
                              SliverPostCommentSection(postId: post.id),
                            ],
                          ),
                          SliverConstrainedCrossAxis(
                            maxExtent: sideBarWidth,
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 56),
                                  lowerBody(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
