import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class FollowTimelinePostList extends StatelessWidget {
  const FollowTimelinePostList({super.key, required this.tags, this.top});

  final List<String> tags;
  final List<Widget> Function(Future<void> Function()? onRefresh)? top;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final query = client.posts.useByTags(tags: tags);
    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.posts.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => RefreshShortcuts(
          onRefresh: query.invalidate,
          child: CustomScrollView(
            primary: true,
            physics: refreshPhysics,
            slivers: [
              ...top?.call(query.invalidate) ??
                  [SliverHexagonRefresh(onRefresh: query.invalidate)],
              SliverPadding(
                padding: defaultActionListPadding,
                sliver: PostTimelineSliver(
                  state: state.paging,
                  fetchNextPage: query.getNextPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
