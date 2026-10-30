import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';
import 'package:relative_time/relative_time.dart';

class PostDetailHeader extends StatelessWidget {
  const PostDetailHeader({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              PostArtistNames(
                post: post,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 19 / 17,
                ),
              ),
              Text(
                post.createdAt.relativeTime(context),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
        PostVotes(post: post),
      ],
    );
  }
}

class PostArtistNames extends StatelessWidget {
  const PostArtistNames({super.key, required this.post, required this.style});

  final Post post;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final List<String> artists = filterArtists(post.tags['artist'] ?? const []);
    if (artists.isEmpty) {
      return Text(
        'no artist',
        style: style.copyWith(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: TagCategory.artist.colorFor(Theme.of(context).brightness),
            width: 2,
          ),
        ),
      ),
      child: Wrap(
        children: [
          for (final (int index, String artist) in artists.indexed)
            TagGesture(
              tag: artist,
              child: Text(
                '${tagToName(artist)}'
                '${index < artists.length - 1 ? ', ' : ''}',
                style: style,
              ),
            ),
        ],
      ),
    );
  }
}

class PostVotes extends StatelessWidget {
  const PostVotes({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    return MutationBuilder(
      mutation: client.posts.useVote(id: post.id),
      builder: (context, state, mutate) {
        final bool enabled = client.hasLogin && !state.isLoading;
        Future<bool> Function(bool)? vote({required bool upvote}) => enabled
            ? (isVoted) async {
                mutate((upvote: upvote, replace: !isVoted)).catchError((error) {
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text(
                        'Failed to ${upvote ? 'upvote' : 'downvote'} '
                        'Post #${post.id}',
                      ),
                    ),
                  );
                  return error;
                });
                return !isVoted;
              }
            : null;
        return VoteDisplay(
          vote: post.vote,
          score: post.score,
          onUpvote: vote(upvote: true),
          onDownvote: vote(upvote: false),
        );
      },
    );
  }
}

class PostArtistSection extends StatelessWidget {
  const PostArtistSection({super.key, required this.post});

  final Post post;

  static const int shown = 6;

  @override
  Widget build(BuildContext context) {
    final List<String> artists = filterArtists(post.tags['artist'] ?? const []);
    if (artists.isEmpty) return const SizedBox.shrink();
    final String artist = artists.first;
    final Client client = context.watch<Client>();
    return QueryBuilder(
      query: client.tags.usePreview(names: [artist]),
      builder: (context, preview) => QueryBuilder(
        query: client.posts.usePage(
          query: {
            ...PostParams(tags: artist).toQuery(),
            'limit': '${shown * 2}',
          },
        ),
        builder: (context, state) {
          final PostFilter? filter = context.watch<PostFilter?>();
          final List<int> others = [
            for (final int id in state.data?.pages.firstOrNull ?? const [])
              if (id != post.id)
                if (client.posts.postCache.get(id) case final Post other
                    when filter?.filter(other) ?? true)
                  id,
          ].take(shown).toList();
          if (state.data != null && others.isEmpty) {
            return const SizedBox.shrink();
          }
          final int? count = preview.data?.firstOrNull?.postCount;
          return PostDetailSection(
            section: PostSection.artist,
            label: 'More by ${tagToName(artist)}',
            count: count,
            summary: count == null ? '' : '$count posts',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int row = 0; row < others.length; row += 3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      spacing: 4,
                      children: [
                        for (int column = row; column < row + 3; column++)
                          Expanded(
                            child: column < others.length
                                ? PostThumbnail(id: others[column], height: 112)
                                : const SizedBox(),
                          ),
                      ],
                    ),
                  ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PostsPage(params: PostParams(tags: artist)),
                    ),
                  ),
                  child: SizedBox(
                    height: 40,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'All posts by ${tagToName(artist)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
