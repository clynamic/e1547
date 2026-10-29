import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class FollowTimelinePostList extends StatelessWidget {
  const FollowTimelinePostList({super.key, required this.tags, this.header});

  final List<String> tags;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final query = client.posts.useByTags(tags: tags);
    return PagedQueryBuilder(
      query: query,
      getItem: (id) => client.posts.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) => PullToRefresh(
          onRefresh: query.invalidate,
          child: CustomScrollView(
            primary: true,
            slivers: [
              ?header,
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
