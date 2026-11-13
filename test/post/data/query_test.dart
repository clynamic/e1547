import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  List<int> recordedIds() =>
      loadFixtureList('posts.json').map((e) => e['id']! as int).toList();

  test('posts asked for by id at once come in one request', () async {
    final List<int> ids = recordedIds().take(3).toList();
    env.fake.requests.clear();

    final List<Post> posts = await Future.wait([
      for (final int id in ids)
        env.client.posts.useGet(id: id).fetch().then((e) => e.data!),
    ]);

    expect(posts.map((e) => e.id), ids);
    expect(env.fake.requests.map((e) => e.path), ['/posts.json']);
  });

  test('a post already in the cache is not asked for', () async {
    final int id = recordedIds().first;
    env.client.posts.postCache.set(samplePost(id: id, preview: 'kept'));
    env.fake.requests.clear();

    final Post? post = (await env.client.posts.useGet(id: id).fetch()).data;

    expect(post?.preview, 'kept');
    expect(env.fake.requests, isEmpty);
  });
}
