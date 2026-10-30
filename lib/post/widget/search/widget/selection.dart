import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class PostSelectionAppBar extends StatelessWidget with AppBarBuilderWidget {
  const PostSelectionAppBar({super.key, required this.child});

  @override
  final PreferredSizeWidget child;

  @override
  Widget build(BuildContext context) {
    return SelectionAppBar<Post>(
      child: child,
      titleBuilder: (context, data) => data.selections.length == 1
          ? Text('post #${data.selections.first.id}')
          : Text('${data.selections.length} posts'),
      actionBuilder: (context, data) => [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
            postDownloadingNotification(context, Set.from(data.selections));
            data.onChanged({});
          },
        ),
        InkResponse(
          onTap: () {},
          child: LikeButton(
            isLiked:
                data.selections.isNotEmpty &&
                data.selections.every((post) => post.isFavorited),
            circleColor: const CircleColor(start: Colors.pink, end: Colors.red),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Colors.pink,
              dotSecondaryColor: Colors.red,
            ),
            likeBuilder: (bool isLiked) => Icon(
              Icons.favorite,
              color: isLiked
                  ? Colors.pinkAccent
                  : Theme.of(context).iconTheme.color,
            ),
            onTap: (isLiked) async {
              postFavoritingNotification(
                context,
                Set.from(data.selections),
                isLiked,
              );
              data.onChanged({});
              return !isLiked;
            },
          ),
        ),
      ],
    );
  }
}

class PostSelectionBar extends StatelessWidget {
  const PostSelectionBar({super.key, required this.selection});

  final SelectionLayoutData<Post> selection;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Set<Post> posts = selection.selections;
    final int favorited = posts.where((post) => post.isFavorited).length;
    final bool all = favorited == posts.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        spacing: 4,
        children: [
          IconButton(
            tooltip: 'Close',
            onPressed: selection.clear,
            icon: const Icon(Icons.close),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    posts.length == 1 ? '1 post' : '${posts.length} posts',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (favorited > 0)
                    Text(
                      all
                          ? 'All favorited'
                          : '$favorited of ${posts.length} favorited',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: 'Select all',
            onPressed: selection.selectAll,
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            tooltip: 'Download',
            onPressed: () {
              postDownloadingNotification(context, Set.of(posts));
              selection.clear();
            },
            icon: const Icon(Icons.file_download),
          ),
          IconButton(
            tooltip: all ? 'Unfavorite' : 'Favorite',
            onPressed: () =>
                postFavoritingNotification(context, Set.of(posts), all),
            icon: Icon(
              all ? Icons.favorite : Icons.favorite_border,
              color: all ? Colors.pinkAccent : null,
            ),
          ),
        ],
      ),
    );
  }
}
