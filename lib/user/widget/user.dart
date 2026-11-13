import 'package:dio/dio.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:e1547/traits/traits.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key, required this.user, this.summary});

  final User user;
  final UserSummary? summary;

  @override
  Widget build(BuildContext context) {
    final Client client = context.watch<Client>();
    final UserStats? stats = user.stats;
    final PostParams uploads = PostParams(tags: 'user:${user.name}');
    final PostParams favorites = PostParams(tags: 'fav:${user.name}');
    void open(PostParams params) => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PostsPage(params: params)));
    return UserHistoryConnector(
      user: user,
      child: FilterControllerProvider<PostFilter, Post>(
        create: (_) => PostFilter(client),
        keys: (_) => [client],
        child: Scaffold(
          drawer: const RouterDrawer(),
          body: LimitedWidthLayout(
            child: Builder(
              builder: (context) => CustomScrollView(
                controller: PrimaryScrollController.of(context),
                slivers: [
                  UserSliverAppBar(
                    user: user,
                    summary: summary,
                    scrollController: PrimaryScrollController.of(context),
                  ),
                  SliverPadding(
                    padding: defaultListPadding.add(
                      LimitedWidthLayout.of(context).padding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SkeletonIgnore(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            UserInfo(user: user),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 8),
                                  UserPostRow(
                                    title: 'Uploads',
                                    count: stats?.postUploadCount,
                                    params: uploads,
                                    onAll: () => open(uploads),
                                  ),
                                  UserPostRow(
                                    title: 'Favorites',
                                    count: stats?.favoriteCount,
                                    params: favorites,
                                    onAll: () => open(favorites),
                                    hidden:
                                        '${user.name} keeps their favorites '
                                        'private',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserPostRow extends StatelessWidget {
  const UserPostRow({
    super.key,
    required this.title,
    required this.count,
    required this.params,
    required this.onAll,
    this.hidden,
  });

  final String title;
  final int? count;
  final PostParams params;
  final VoidCallback onAll;
  final String? hidden;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    if (isSkeleton(context)) {
      return PostRowSection.loading(title: title, onAll: onAll);
    }
    final Client client = context.watch<Client>();
    return PagedQueryBuilder(
      query: client.posts.usePage(query: params.toQuery()),
      getItem: (id) => client.posts.useGet(id: id, vendored: true),
      builder: (context, state) => QueryFilter(
        state: state,
        builder: (context, state) {
          final List<Post>? posts = state.data?.pages.firstOrNull;
          if (posts == null) {
            if ((hidden, state.error) case (
              final String hidden,
              DioException(response: Response(statusCode: 403)),
            )) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RelationHeader(title: title),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                    child: Row(
                      spacing: 12,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 18,
                          color: dimTextColor(context),
                        ),
                        Expanded(
                          child: Text(
                            hidden,
                            style: TextStyle(color: dimTextColor(context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            }
            if (state.error != null) return const SizedBox.shrink();
            return PostRowSection.loading(title: title, onAll: onAll);
          }
          if (posts.isEmpty) return const SizedBox.shrink();
          return PostRowSection(
            title: title,
            count: count,
            onAll: onAll,
            children: [
              for (final Post post in posts)
                PostRowTile(
                  post: post,
                  onTap: () => pushPostGallery(
                    context,
                    params: params,
                    initialPostId: post.id,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class UserSliverAppBar extends StatelessWidget {
  const UserSliverAppBar({
    super.key,
    required this.user,
    this.summary,
    this.scrollController,
  });

  final User user;
  final UserSummary? summary;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final UserSummary header = summary ?? user;
    final bool known = header is! Ghost;
    return DefaultSliverAppBar(
      scrollController: scrollController,
      pinned: true,
      expandedHeight: 250,
      flexibleSpace: Builder(
        builder: (context) {
          FlexibleSpaceBarSettings settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;
          double extension =
              (settings.currentExtent - settings.minExtent) /
              settings.maxExtent;
          double? leadingWidth = context
              .findAncestorWidgetOfExactType<SliverAppBar>()
              ?.leadingWidth;
          return FlexibleSpaceBar(
            titlePadding: leadingWidth != null
                ? EdgeInsets.only(left: leadingWidth + 8, bottom: 16)
                : null,
            collapseMode: CollapseMode.pin,
            title: Opacity(
              opacity: 1 - (extension * 6).clamp(0, 1),
              child: Skeleton.keep(keep: known, child: Text(header.name)),
            ),
            background: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Skeleton.keep(
                      keep: known,
                      child: UserAvatar(
                        id: header.avatarId,
                        userId: header.id,
                        hasCroppedAvatar: header.hasCroppedAvatar,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Skeleton.keep(
                      keep: known,
                      child: Text(
                        header.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [_UserProfileActions(user: user)],
    );
  }
}

class _UserProfileActions extends StatelessWidget {
  const _UserProfileActions({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Traits> traits = context.watch<Client>().traits;
    String userTag = 'user:${user.id}';
    bool blocked = traits.value.denylist.contains(userTag);
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => value(),
      itemBuilder: (context) => [
        PopupMenuTile(
          title: 'Browse',
          icon: Icons.open_in_browser,
          value: () async => launch(context.read<Client>().withHost(user.link)),
        ),
        PopupMenuTile(
          title: 'Report',
          icon: Icons.report,
          value: () => guardWithLogin(
            context: context,
            callback: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserReportScreen(user: user),
                ),
              );
            },
            error: 'You must be logged in to report users!',
          ),
        ),
        PopupMenuTile(
          title: blocked ? 'Unblock' : 'Block',
          icon: blocked ? Icons.check : Icons.block,
          value: () {
            if (blocked) {
              traits.value = traits.value.copyWith(
                denylist: traits.value.denylist.toList()..remove(userTag),
              );
            } else {
              traits.value = traits.value.copyWith(
                denylist: traits.value.denylist.toList()..add(userTag),
              );
            }
          },
        ),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    Widget info(
      IconData icon,
      String title,
      Object? value, {
      VoidCallback? onLongPress,
    }) {
      if (value == null) return const SizedBox();
      return UserInfoTile(
        icon: icon,
        title: title,
        value: value.toString(),
        onLongPress: onLongPress,
      );
    }

    return Expandables(
      expanded: true,
      child: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.about?.bio case final bio? when bio.isNotEmpty)
              Card(
                child: ExpandablePanel(
                  controller: Expandables.of(context, 'about'),
                  header: const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('About'),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DTextFold(text: bio),
                  ),
                ),
              ),
            if (user.about?.comission case final comission?
                when comission.isNotEmpty)
              Card(
                child: ExpandablePanel(
                  controller: Expandables.of(context, 'comission'),
                  header: const ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Comission'),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DTextFold(text: comission),
                  ),
                ),
              ),
            Card(
              child: ExpandablePanel(
                controller: Expandables.of(context, 'info', expanded: false),
                header: const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Info'),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      info(
                        Icons.tag,
                        'id',
                        user.id.toString(),
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: user.id.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text('Copied user id #${user.id}'),
                            ),
                          );
                        },
                      ),
                      if (user.stats case final stats?) ...[
                        info(
                          Icons.calendar_today,
                          'joined',
                          stats.createdAt != null
                              ? DateFormatting.named(stats.createdAt!)
                              : null,
                        ),
                        info(
                          Icons.shield,
                          'rank',
                          stats.levelString?.toLowerCase(),
                        ),
                        info(Icons.upload, 'posts', stats.postUploadCount),
                        info(Icons.edit, 'edits', stats.postUpdateCount),
                        info(Icons.favorite, 'favorites', stats.favoriteCount),
                        info(Icons.comment, 'comments', stats.commentCount),
                        info(Icons.forum, 'forum', stats.forumPostCount),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({
    super.key,
    required this.value,
    required this.title,
    required this.icon,
    this.onLongPress,
  });

  final String value;
  final String title;
  final IconData icon;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Theme.of(context).textTheme.bodySmall!.color,
    );
    final valueStyle = Theme.of(context).textTheme.titleMedium;

    return InkWell(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  Text(value, style: valueStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
