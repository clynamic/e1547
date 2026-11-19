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
                          if ((await mutate((
                            upvote: true,
                            replace: !isLiked,
                          ))).isError) {
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                  'Failed to upvote Post #${post.id}',
                                ),
                              ),
                            );
                            return isLiked;
                          }
                          return !isLiked;
                        }
                      : null,
                  onDownvote: enabled
                      ? (isLiked) async {
                          if ((await mutate((
                            upvote: false,
                            replace: !isLiked,
                          ))).isError) {
                            messenger.showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Text(
                                  'Failed to downvote Post #${post.id}',
                                ),
                              ),
                            );
                            return isLiked;
                          }
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
              if ((await mutate(post.id)).isError) {
                messenger.showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(
                      isLiked
                          ? 'Failed to remove Post #${post.id} from favorites'
                          : 'Failed to add Post #${post.id} to favorites',
                    ),
                  ),
                );
                return isLiked;
              }
              if (!isLiked && settings.upvoteFavs.value) {
                // upvote is best-effort once the favorite succeeded
                await client.posts.useVote(id: post.id).mutate((
                  upvote: true,
                  replace: true,
                ));
              }
              return !isLiked;
            },
          ),
        );
      },
    );
  }
}
