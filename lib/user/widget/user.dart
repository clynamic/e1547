import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:e1547/traits/traits.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sub/flutter_sub.dart';

enum UserPageSection { favorites, uploads, info }

class UserPage extends StatelessWidget {
  const UserPage({
    super.key,
    required this.user,
    this.initialPage = UserPageSection.favorites,
  });

  final User user;
  final UserPageSection initialPage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return UserHistoryConnector(
      user: user,
      child: SubValue.builder(
        create: (context) => PostFilter(context.read<Client>()),
        dispose: (_, v) => v.dispose(),
        builder: (context, filter) => LayoutBuilder(
          builder: (context, constraints) {
            Widget body;
            PreferredSizeWidget? appbar;
            final tabs = <Widget, WidgetBuilder>{
              Tab(text: l10n.navFavorites): (context) => _UserPostsTab(
                filter: filter,
                params: PostParams(tags: 'fav:${user.name}'),
              ),
              Tab(text: l10n.userUploads): (context) => _UserPostsTab(
                filter: filter,
                params: PostParams(tags: 'user:${user.name}'),
              ),
            };

            if (constraints.maxWidth < 1100) {
              body = NestedScrollView(
                controller: PrimaryScrollController.of(context),
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: UserSliverAppBar(
                      user: user,
                      tabs: tabs.keys.toList(),
                    ),
                  ),
                ],
                body: LimitedWidthLayout(
                  child: TileLayout(
                    child: Builder(
                      builder: (context) => TabBarView(
                        children: tabs.values
                            .map(
                              (e) => CustomScrollView(
                                slivers: [
                                  SliverOverlapInjector(
                                    handle:
                                        NestedScrollView.sliverOverlapAbsorberHandleFor(
                                          context,
                                        ),
                                  ),
                                  e(context),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              );
              tabs[Tab(text: l10n.navAbout)] = (context) => SliverPadding(
                padding: defaultListPadding.add(
                  LimitedWidthLayout.of(context).padding,
                ),
                sliver: SliverToBoxAdapter(
                  child: UserInfo(
                    user: user,
                    compact: constraints.maxWidth < 600,
                  ),
                ),
              );
            } else {
              body = Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: ListView(
                      primary: false,
                      padding: defaultListPadding,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: UserAvatar(
                                  id: user.avatarId,
                                  userId: user.id,
                                  hasCroppedAvatar: user.hasCroppedAvatar,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 32,
                                ),
                                child: Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        UserInfo(user: user, compact: false),
                      ],
                    ),
                  ),
                  Expanded(
                    child: LimitedWidthLayout(
                      child: TileLayout(
                        child: TabBarView(
                          children: tabs.values
                              .toList()
                              .sublist(0, tabs.length)
                              .map(
                                (e) => CustomScrollView(slivers: [e(context)]),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
              appbar = DefaultAppBar(
                ignoreTitlePointer: false,
                title: TabBar(
                  isScrollable: true,
                  labelColor: Theme.of(context).iconTheme.color,
                  indicatorColor: Theme.of(context).iconTheme.color,
                  tabs: tabs.keys.toList().sublist(0, tabs.length).toList(),
                ),
                actions: [
                  _UserProfileActions(user: user),
                  const ContextDrawerButton(),
                ],
                elevation: 0,
              );
            }

            return DefaultTabController(
              length: tabs.length,
              initialIndex: initialPage.index,
              child: Scaffold(
                appBar: appbar,
                drawer: const RouterDrawer(),
                endDrawer: ContextDrawer(
                  title: Text(l10n.postsTitle),
                  children: [
                    DrawerDenySwitch(filter: filter),
                    DrawerMultiTagCounter(filter: filter),
                  ],
                ),
                body: body,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UserPostsTab extends StatelessWidget {
  const _UserPostsTab({required this.filter, required this.params});

  final PostFilter filter;
  final PostParams params;

  @override
  Widget build(BuildContext context) {
    return FilterControllerProvider<PostFilter, Post>.value(
      value: filter,
      child: ChangeNotifierProvider(
        create: (_) => PostParamsController(initial: params, canSearch: false),
        child: SliverMainAxisGroup(
          slivers: [
            SliverPadding(
              padding: defaultActionListPadding,
              sliver: const SliverPostList(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserSliverAppBar extends StatelessWidget {
  const UserSliverAppBar({super.key, required this.user, this.tabs});

  final User user;
  final List<Widget>? tabs;

  @override
  Widget build(BuildContext context) {
    return DefaultSliverAppBar(
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
              child: Text(user.name),
            ),
            background: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: UserAvatar(
                    id: user.avatarId,
                    userId: user.id,
                    hasCroppedAvatar: user.hasCroppedAvatar,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottom: tabs != null
          ? TabBar(
              labelColor: Theme.of(context).iconTheme.color,
              indicatorColor: Theme.of(context).iconTheme.color,
              tabs: tabs!,
            )
          : null,
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
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => value(),
      itemBuilder: (context) => [
        PopupMenuTile(
          title: l10n.menuBrowse,
          icon: Icons.open_in_browser,
          value: () async => launch(context.read<Client>().withHost(user.link)),
        ),
        PopupMenuTile(
          title: l10n.menuReport,
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
            error: l10n.userLoginRequiredReport,
          ),
        ),
        PopupMenuTile(
          title: blocked ? l10n.actionUnblock : l10n.actionBlock,
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
  const UserInfo({super.key, required this.user, this.compact = true});

  final User user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        compact: compact,
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
                  header: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(l10n.navAbout),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DText(bio),
                  ),
                ),
              ),
            if (user.about?.comission case final comission?
                when comission.isNotEmpty)
              Card(
                child: ExpandablePanel(
                  controller: Expandables.of(context, 'comission'),
                  header: ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: Text(l10n.userComission),
                  ),
                  collapsed: const SizedBox.shrink(),
                  expanded: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DText(comission),
                  ),
                ),
              ),
            Card(
              child: ExpandablePanel(
                controller: Expandables.of(context, 'info'),
                header: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.info),
                ),
                collapsed: const SizedBox.shrink(),
                expanded: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      info(
                        Icons.tag,
                        l10n.userId,
                        user.id.toString(),
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: user.id.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(l10n.userCopiedId(user.id)),
                            ),
                          );
                        },
                      ),
                      if (user.stats case final stats?) ...[
                        info(
                          Icons.calendar_today,
                          l10n.userJoined,
                          stats.createdAt != null
                              ? localizedDateName(context, stats.createdAt!)
                              : null,
                        ),
                        info(
                          Icons.shield,
                          l10n.userRank,
                          stats.levelString?.toLowerCase(),
                        ),
                        info(
                          Icons.upload,
                          l10n.userPosts,
                          stats.postUploadCount,
                        ),
                        info(Icons.edit, l10n.userEdits, stats.postUpdateCount),
                        info(
                          Icons.favorite,
                          l10n.userFavorites,
                          stats.favoriteCount,
                        ),
                        info(
                          Icons.comment,
                          l10n.userComments,
                          stats.commentCount,
                        ),
                        info(Icons.forum, l10n.userForum, stats.forumPostCount),
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
    this.compact = true,
  });

  final String value;
  final String title;
  final IconData icon;
  final VoidCallback? onLongPress;
  final bool compact;

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
              child: compact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: titleStyle),
                        Text(value, style: valueStyle),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: Text(title, style: valueStyle)),
                        const SizedBox(height: 4),
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
