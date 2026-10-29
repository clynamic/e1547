import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? username = context.watch<Client>().identity.username;
    if (username == null) {
      return const AdaptiveScaffold(
        appBar: DefaultAppBar(title: Text('Favorites')),
        body: IconMessage(
          icon: Icon(Icons.person_search),
          title: Text('Favorites are unavailable for anonymous users'),
        ),
      );
    }
    return PostsPage(params: PostParams(tags: 'fav:$username'));
  }
}
