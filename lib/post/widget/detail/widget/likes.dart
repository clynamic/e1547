import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeDisplay extends StatelessWidget {
  const LikeDisplay({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final messenger = ScaffoldMessenger.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MutationBuilder(
              mutation: client.posts.useVote(id: post.id),
              builder: (context, state, mutate) {
                final bool enabled = client.hasLogin && !state.isLoading;
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
                                content: Text(
                                  tf(
                                    'Failed to upvote Post #{id}',
                                    params: {'id': post.id},
                                  ),
                                ),
                              ),
                            );
                            return error;
                          });
                          return !isLiked;
                        }
                      : null,
                  onDownvote: enabled
                      ? (isLiked) async {
                          mutate((upvote: false, replace: !isLiked)).catchError(
                            (error) {
                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                    tf(
                                      'Failed to downvote Post #{id}',
                                      params: {'id': post.id},
                                    ),
                                  ),
                                ),
                              );
                              return error;
                            },
                          );
                          return !isLiked;
                        }
                      : null,
                );
              },
            ),
            Row(
              children: [
                Text(post.favCount.toString()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.favorite,
                    color: post.isFavorited
                        ? Colors.pinkAccent
                        : IconTheme.of(context).color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final settings = context.read<Settings>();
    final messenger = ScaffoldMessenger.of(context);

    final addMutation = client.posts.useAddFavorite();
    final removeMutation = client.posts.useRemoveFavorite();
    return MutationBuilder(
      mutation: post.isFavorited ? removeMutation : addMutation,
      builder: (context, state, mutate) {
        return InkResponse(
          onTap: state.isLoading ? null : () {},
          child: LikeButton(
            isLiked: post.isFavorited,
            circleColor: const CircleColor(start: Colors.pink, end: Colors.red),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.pink,
              dotSecondaryColor: Colors.red,
            ),
            likeBuilder: (isLiked) => Icon(
              Icons.favorite,
              color: isLiked ? Colors.pinkAccent : IconTheme.of(context).color,
            ),
            onTap: (isLiked) async {
              try {
                await mutate(post.id);
                if (!isLiked && settings.upvoteFavs.value) {
                  try {
                    await client.posts.useVote(id: post.id).mutate((
                      upvote: true,
                      replace: true,
                    ));
                  } on Exception {
                    // upvote is best-effort once the favorite succeeded
                  }
                }
              } on Exception {
                messenger.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                      isLiked
                          ? tf(
                              'Failed to remove Post #{id} from favorites',
                              params: {'id': post.id},
                            )
                          : tf(
                              'Failed to add Post #{id} to favorites',
                              params: {'id': post.id},
                            ),
                    ),
                  ),
                );
              }
              return !isLiked;
            },
          ),
        );
      },
    );
  }
}
