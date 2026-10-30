import 'dart:math';

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
                DismissRoute<void>(
                  builder: (context) => PostFullscreen(post: post),
                ),
              );
            }
          },
        ),
      ),
    ),
  );

  Widget grip(BuildContext context) => IgnorePointer(
    child: Center(
      child: Container(
        width: 32,
        height: 4,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [BoxShadow(color: Color(0x99000000), blurRadius: 4)],
        ),
      ),
    ),
  );

  Widget body(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              PostDetailHeader(post: post),
              if (post.description.trim().isNotEmpty)
                PostDescription(post: post),
              if (post.isDeleted) DeletionDisplay(post: post),
              if (context.watch<PostFilter?>()?.entriesFor(post).isNotEmpty ??
                  false)
                DenylistTagDisplay(post: post),
            ],
          ),
        ),
        PostPoolsSection(post: post),
        PostFamilySection(post: post),
        PostTagsSection(post: post),
        PostCommentsLine(post: post),
        PostArtistSection(post: post),
        PostSourcesSection(post: post),
        PostDetailsSection(post: post),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return NavBarCovered(
      child: Builder(
        builder: (context) {
          final double bottom = MediaQuery.paddingOf(context).bottom;
          return PostVideoRoute(
            post: post,
            child: PostHistoryConnector(
              post: post,
              child: ScrollToDismiss(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: MediaQuery.removeViewInsets(
                    context: context,
                    removeTop: true,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DismissFade(
                          child: ColoredBox(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        LimitedWidthLayout(
                          child: Builder(
                            builder: (context) => ListView(
                              primary: true,
                              padding: EdgeInsets.only(
                                top: MediaQuery.paddingOf(context).top,
                                bottom: postToolbarClearance + bottom,
                              ),
                              children: [
                                Stack(
                                  children: [
                                    image(context, MediaQuery.sizeOf(context)),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: DismissFade(child: grip(context)),
                                    ),
                                  ],
                                ),
                                DismissFade(child: body(context)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: postToolbarFadeHeight + bottom,
                          child: IgnorePointer(
                            child: DismissFade(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Theme.of(context).scaffoldBackgroundColor
                                          .withValues(alpha: 0),
                                      Theme.of(context).scaffoldBackgroundColor
                                          .withValues(alpha: 0.55),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: DismissFade(child: PostToolbar(post: post)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
