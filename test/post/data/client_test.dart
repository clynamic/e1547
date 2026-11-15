import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late PostClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    final identity = Identity(
      id: 1,
      host: fake.url,
      username: 'tester',
      headers: null,
    );
    final dio = createDefaultDio(identity);
    client = PostClient(
      dio: dio,
      pools: PoolClient(dio: dio),
      traits: ValueNotifier(
        const Traits(
          id: 1,
          userId: null,
          denylist: [],
          homeTags: '',
          avatar: null,
          perPage: null,
        ),
      ),
      identity: identity,
    );
  });

  tearDown(() => fake.stop());

  String served(String url) => url.replaceAll(fixtureHost, fake.url);

  test('maps a recorded post onto the model', () async {
    final recorded = loadFixtureList('posts.json').first;
    final files = recorded['files']! as Map<String, Object?>;
    final meta = files['meta']! as Map<String, Object?>;
    final original = files['original']! as Map<String, Object?>;
    final stats = recorded['stats']! as Map<String, Object?>;

    final post = (await client.page()).first;

    expect(post.id, recorded['id']);
    expect(post.ext, meta['ext']);
    expect(post.width, original['width']);
    expect(post.height, original['height']);
    expect(post.size, meta['size']);
    expect(post.file, served(original['url']! as String));
    expect(post.sample, served((files['sample']! as Map)['jpg'] as String));
    expect(post.preview, served((files['preview']! as Map)['jpg'] as String));
    expect(post.uploaderId, recorded['uploader_id']);
    expect(post.favCount, stats['fav_count']);
    expect(post.commentCount, stats['comment_count']);
    expect(post.isFavorited, stats['is_favorited']);
    expect(post.rating.name, recorded['rating']);
    expect(post.score, (stats['score']! as Map)['total']);
    expect(post.isDeleted, (recorded['flags']! as Map)['deleted']);
    expect(post.tags.keys, (recorded['tags']! as Map).keys);
  });

  test('leaves the sample empty when the post has none', () async {
    final recorded = fake.state.posts.first;
    final files = recorded['files']! as Map<String, Object?>;
    final original = files['original']! as Map<String, Object?>;
    fake.state.posts
      ..clear()
      ..add({
        ...recorded,
        'files': {
          ...files,
          'meta': {
            ...(files['meta']! as Map<String, Object?>),
            'has_sample': false,
          },
          'sample': {
            ...(files['sample']! as Map<String, Object?>),
            'jpg': original['url'],
            'webp': original['url'],
          },
        },
      });

    final post = (await client.page()).single;

    expect(post.sample, isNull);
    expect(post.file, isNotNull);
  });

  test('folds video samples into variants', () async {
    final posts = await client.page();
    final video = posts.firstWhere((e) => e.ext == 'webm');

    expect(video.variants, isNotNull);
    expect(video.variants!.keys, isNotEmpty);
    expect(video.variants!.keys, everyElement(matches(RegExp(r'^\d+x\d+$'))));
  });

  test('parses child relationships', () async {
    final recorded = loadFixtureList('posts.json').firstWhere(
      (e) => ((e['relationships']! as Map)['children']! as List).isNotEmpty,
    );
    final children = (recorded['relationships']! as Map)['children']! as List;

    final posts = await client.page();
    final parent = posts.firstWhere((e) => e.id == recorded['id']);

    expect(parent.relationships.children, children);
    expect(parent.relationships.hasChildren, isTrue);
  });

  test('asks for ids as a tag filter', () async {
    final ids = loadFixtureList(
      'posts.json',
    ).map((e) => e['id']! as int).toList().reversed.toList();

    await client.byIds(ids: ids);

    expect(fake.requests.last.query['tags'], 'id:${ids.join(',')}');
  });

  test('asks for more than 320 ids in one request limited to 320', () async {
    final ids = List.generate(321, (index) => index + 1);

    await client.byIds(ids: ids);

    final posts = fake.requests.where((e) => e.path == '/posts.json').toList();
    expect(posts.single.query['tags'], 'id:${ids.join(',')}');
    expect(posts.single.query['limit'], '320');
  });

  test('restores the requested id order', () async {
    final ids = loadFixtureList(
      'posts.json',
    ).map((e) => e['id']! as int).toList().reversed.toList();

    final posts = await client.byIds(ids: ids);

    expect(posts.map((e) => e.id), ids);
  });

  test(
    'finds posts by id that a search would hide, when asked for them',
    () async {
      final Map<String, Object?> recorded = fake.state.posts.first;
      final Map<String, Object?> files =
          recorded['files']! as Map<String, Object?>;
      final Map<String, Object?> unavailable = {
        ...files,
        'original': {
          ...(files['original']! as Map<String, Object?>),
          'url': null,
        },
      };
      fake.state.posts.addAll([
        {
          ...recorded,
          'id': 998,
          'flags': {
            ...(recorded['flags']! as Map<String, Object?>),
            'deleted': true,
          },
          'files': unavailable,
        },
        {...recorded, 'id': 999, 'files': unavailable},
      ]);

      final found = await client.byIds(ids: [998, 999], hidden: true);
      final shown = await client.byIds(ids: [998, 999]);

      expect(found.map((e) => (e.id, e.isDeleted, e.file)), [
        (998, true, null),
        (999, false, null),
      ]);
      expect(shown, isEmpty);
    },
  );

  test('drops posts that cannot be displayed', () async {
    fake.state.posts.add({
      ...fake.state.posts.first,
      'id': 999,
      'files': {
        ...(fake.state.posts.first['files']! as Map<String, Object?>),
        'original': {
          ...((fake.state.posts.first['files']! as Map)['original']!
              as Map<String, Object?>),
          'url': null,
        },
      },
    });

    final posts = await client.page();

    expect(posts.map((e) => e.id), isNot(contains(999)));
  });

  test('serves recorded asset urls from itself', () async {
    final post = (await client.page()).first;

    expect(post.file, startsWith(fake.url));

    final response = await client.dio.get<List<int>>(
      post.file!,
      options: Options(responseType: ResponseType.bytes),
    );

    expect(response.headers.value(HttpHeaders.contentTypeHeader), 'image/png');
    expect(response.data!.take(4), [0x89, 0x50, 0x4e, 0x47]);
  });

  test('favorites are unavailable without credentials', () async {
    await expectLater(
      client.favorites(),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });

  test('favorites are served to a signed in user', () async {
    final id = loadFixtureList('posts.json').first['id']! as int;
    fake.state.favorites.add(id);
    final signedIn = PostClient(
      dio: createDefaultDio(
        Identity(
          id: 1,
          host: fake.url,
          username: 'tester',
          headers: {
            HttpHeaders.authorizationHeader: const Credentials(
              username: 'tester',
              password: 'key',
            ).basicAuth,
          },
        ),
      ),
      pools: client.pools,
      traits: client.traits,
      identity: client.identity,
    );

    final posts = await signedIn.favorites();

    expect(posts.map((e) => e.id), [id]);
  });

  test('sends a vote the way the server expects', () async {
    final id = loadFixtureList('posts.json').first['id']! as int;

    await client.vote(id: id, upvote: true, replace: true);

    expect(fake.requests.last.path, '/posts/$id/votes.json');
    expect(fake.requests.last.query, {'score': '1', 'no_unvote': 'true'});
  });
}
