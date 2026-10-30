import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.post, this.size = 30});

  final Post post;
  final double size;

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
            size: size,
            isLiked: post.isFavorited,
            circleColor: const CircleColor(start: Colors.pink, end: Colors.red),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.pink,
              dotSecondaryColor: Colors.red,
            ),
            likeBuilder: (isLiked) => Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
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
                          ? 'Failed to remove Post #${post.id} from favorites'
                          : 'Failed to add Post #${post.id} to favorites',
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
