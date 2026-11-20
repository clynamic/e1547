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

  test('a parent that is not cached pages through all its children', () async {
    final Map<String, Object?> recorded = env.fake.state.posts.first;
    env.fake.state.posts.addAll([
      for (int id = 10001; id <= 10321; id++)
        {
          ...recorded,
          'id': id,
          'relationships': {
            ...(recorded['relationships']! as Map<String, Object?>),
            'parent_id': 30,
          },
        },
    ]);
    final query = env.client.posts.useByParent(id: 30);

    await query.fetch();
    await query.getNextPage();

    expect(query.state.data?.pages.expand((e) => e), hasLength(321));
  });

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

  test('requests followed tags with a pool once', () async {
    final List<String> tags = ['tag_1', 'pool:1'];
    env.fake.requests.clear();

    await env.client.posts.useByTags(tags: tags).fetch();
    await env.client.posts.useByTags(tags: tags).fetch();

    expect(env.fake.requests.map((e) => e.path), ['/posts.json']);
  });

  test('requests followed tags without their metatags', () async {
    env.fake.requests.clear();

    await env.client.posts
        .useByTags(tags: ['tag_1', 'pool:1', 'two words'])
        .fetch();

    expect(env.fake.requests.single.query['tags'], '~tag_1');
  });
}
