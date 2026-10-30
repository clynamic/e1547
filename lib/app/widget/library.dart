import 'package:e1547/follow/follow.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget entry(String title, IconData icon, WidgetBuilder builder) =>
        ListTile(
          title: Text(title),
          leading: Icon(icon),
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: builder)),
        );

    return Scaffold(
      appBar: const DefaultAppBar(title: Text('Library')),
      body: LimitedWidthLayout.builder(
        builder: (context) => ListView(
          primary: true,
          padding: defaultActionListPadding.add(
            LimitedWidthLayout.of(context).padding,
          ),
          children: [
            entry(
              'Favorites',
              Icons.favorite,
              (context) => const FavoritesPage(),
            ),
            entry(
              'Subscriptions',
              Icons.person_add,
              (context) => const FollowsSubscriptionsPage(),
            ),
            entry(
              'Bookmarks',
              Icons.bookmark,
              (context) => const FollowsBookmarkPage(),
            ),
            entry('Pools', Icons.collections, (context) => const PoolsPage()),
            entry('Forum', Icons.forum, (context) => const TopicsPage()),
            entry('History', Icons.history, (context) => const HistoriesPage()),
          ],
        ),
      ),
    );
  }
}
