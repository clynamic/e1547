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
    final file = recorded['file']! as Map<String, Object?>;

    final post = (await client.page()).first;

    expect(post.id, recorded['id']);
    expect(post.ext, file['ext']);
    expect(post.width, file['width']);
    expect(post.height, file['height']);
    expect(post.size, file['size']);
    expect(post.file, served(file['url']! as String));
    expect(
      post.preview,
      served((recorded['preview']! as Map)['url'] as String),
    );
    expect(post.uploaderId, recorded['uploader_id']);
    expect(post.favCount, recorded['fav_count']);
    expect(post.commentCount, recorded['comment_count']);
    expect(post.rating.name, recorded['rating']);
    expect(post.score, (recorded['score']! as Map)['total']);
    expect(post.isDeleted, (recorded['flags']! as Map)['deleted']);
    expect(post.tags.keys, (recorded['tags']! as Map).keys);
  });

  test('folds sample alternates into variants', () async {
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

  test('splits ids into chunks of 320', () async {
    final ids = List.generate(321, (index) => index + 1);

    await client.byIds(ids: ids);

    final posts = fake.requests.where((e) => e.path == '/posts.json').toList();
    expect(posts.length, 2);
    expect(posts.first.query['tags'], 'id:${ids.take(320).join(',')}');
    expect(posts.first.query['limit'], '320');
    expect(posts.last.query['tags'], 'id:${ids.last}');
    expect(posts.last.query['limit'], '1');
  });

  test('restores the requested id order', () async {
    final ids = loadFixtureList(
      'posts.json',
    ).map((e) => e['id']! as int).toList().reversed.toList();

    final posts = await client.byIds(ids: ids);

    expect(posts.map((e) => e.id), ids);
  });

  test('drops posts that cannot be displayed', () async {
    fake.state.posts.add({
      ...fake.state.posts.first,
      'id': 999,
      'file': {
        ...(fake.state.posts.first['file']! as Map<String, Object?>),
        'url': null,
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

  test('a replacing upvote posts a score of 1 that does not unvote', () async {
    final id = loadFixtureList('posts.json').first['id']! as int;

    await client.vote(id: id, upvote: true, replace: true);

    expect(fake.requests.last.path, '/posts/$id/votes.json');
    expect(fake.requests.last.query, {'score': '1', 'no_unvote': 'true'});
  });
}
