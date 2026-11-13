import 'package:e1547/post/post.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;
  late List<int> posts;

  setUp(() async {
    env = await TestEnvironment.start();
    env.fake.state.users.add({'id': 1014, 'name': 'uploader'});
    posts = env.fake.state.posts.map((e) => e['id']! as int).toList();
    env.fake.state.posts.first['uploader_id'] = 1014;
    env.fake.state.favoritesOf['uploader'] = {posts[1], posts[2]};
  });

  tearDown(() => env.dispose());

  User uploader() => E621User.fromJson({
    ...loadFixtureList('user.json').first,
    'id': 1014,
    'name': 'uploader',
    'post_upload_count': 1,
    'favorite_count': 2,
  });

  Future<void> show(WidgetTester tester) async {
    await tester.runAsync(
      () => tester.pumpWidget(env.app(UserPage(user: uploader()))),
    );
    await env.settle(tester);
  }

  List<int> row(WidgetTester tester, String title) => tester
      .widgetList<PostRowTile>(
        find.descendant(
          of: find.ancestor(
            of: find.text(title),
            matching: find.byType(PostRowSection),
          ),
          matching: find.byType(PostRowTile, skipOffstage: false),
        ),
      )
      .map((e) => e.post.id)
      .toList();

  displayTest('a profile lists the uploads and the favorites of its user', (
    tester,
  ) async {
    await show(tester);

    expect(row(tester, 'Uploads'), [posts[0]]);
    expect(row(tester, 'Favorites'), unorderedEquals([posts[1], posts[2]]));
  });

  displayTest('a profile row follows changes to its posts', (tester) async {
    await show(tester);
    final Post upload = env.client.posts.postCache.get(posts[0])!;

    env.client.posts.postCache.set(upload.copyWith(isDeleted: true));
    await env.settle(tester);

    final PostRowTile tile = tester.widget(
      find.byWidgetPredicate((e) => e is PostRowTile && e.post.id == posts[0]),
    );
    expect(tile.post.isDeleted, isTrue);
  });

  displayTest('a profile says so when its user keeps favorites private', (
    tester,
  ) async {
    env.fake.state.privateFavorites.add('uploader');

    await show(tester);

    expect(row(tester, 'Uploads'), [posts[0]]);
    expect(find.text('uploader keeps their favorites private'), findsOneWidget);
  });
}
