import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late PostClient client;
  late CachedQuery cache;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start(state: FakeE621State.seeded(posts: 200));
    // Cursor pagination relies on the server serving the newest posts first,
    // so model that by sorting the fake's posts by descending id.
    fake.state.posts.sort(
      (a, b) => (b['id']! as int).compareTo(a['id']! as int),
    );
    cache = CachedQuery.asNewInstance();
    final identity = Identity(
      id: 1,
      host: fake.url,
      username: 'tester',
      headers: {
        'authorization': const Credentials(
          username: 'tester',
          password: 'key',
        ).basicAuth,
      },
    );
    final dio = createDefaultDio(identity, queryCache: cache);
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

  tearDown(() async {
    await fake.stop();
    await cache.dispose();
  });

  /// The post ids the fake serves, in the order it serves them.
  List<int> servedIds() =>
      fake.state.posts.map((e) => e['id']! as int).toList();

  group('order dispatch', () {
    test('id orders paginate by cursor', () {
      for (final tags in [null, 'order:new', 'order:id', 'order:id_desc']) {
        expect(
          servesNewestFirst(PostParams(tags: tags).toQuery()),
          isTrue,
          reason: 'tags: $tags',
        );
      }
    });

    test('other orders paginate by page number', () {
      for (final tags in [
        'order:score',
        'order:favcount',
        'order:rank',
        'order:random',
        'order:id_asc',
        'order:custom',
      ]) {
        expect(
          servesNewestFirst(PostParams(tags: tags).toQuery()),
          isFalse,
          reason: 'tags: $tags',
        );
      }
    });
  });

  group('page number arguments', () {
    test('start at page 1', () {
      InfiniteQueryData<List<int>, Object>? state;
      expect(state.nextPageArg(), 1);
      expect(state.nextCursorPage(), 1);
    });

    test('an empty last page ends the search', () {
      final state = InfiniteQueryData<List<int>, Object>(
        pages: const [[]],
        args: const [5],
      );
      expect(state.nextPageArg(), isNull);
      expect(state.nextCursorPage(), isNull);
    });

    test('a page cap ends the search', () {
      expect(
        InfiniteQueryData<List<int>, Object>(
          pages: const [
            [1],
          ],
          args: const [maxSitePage],
        ).nextPageArg(maxPage: maxSitePage),
        isNull,
      );
      expect(
        InfiniteQueryData<List<int>, Object>(
          pages: const [
            [1],
          ],
          args: const [maxSitePage - 1],
        ).nextPageArg(maxPage: maxSitePage),
        maxSitePage,
      );
    });

    test('a cursor argument cannot continue a page sequence', () {
      expect(
        InfiniteQueryData<List<int>, Object>(
          pages: const [
            [1],
          ],
          args: const ['b123'],
        ).nextPageArg(),
        isNull,
      );
    });
  });

  group('cursor arguments', () {
    test('continue before the lowest id of the last page', () {
      expect(
        InfiniteQueryData<List<int>, Object>(
          pages: const [
            [5, 3],
            [2, 9],
          ],
          args: const [1, 'b5'],
        ).nextCursorPage(),
        'b2',
      );
    });
  });

  test('stored page args restore with and without cursors', () {
    final restored = pagedObjectIdsFromJson({
      'pages': [
        [1, 2],
        [3],
      ],
      'args': [1, 'b123'],
    });
    expect(restored.pages, [
      [1, 2],
      [3],
    ]);
    expect(restored.args, [1, 'b123']);

    final legacy = pagedObjectIdsFromJson({
      'pages': [
        [1, 2],
        [3],
      ],
      'args': [1, 2],
    });
    expect(legacy.pages, [
      [1, 2],
      [3],
    ]);
    expect(legacy.args, [1, 2]);
  });

  test(
    'cursor searches request the first page, then the posts before it',
    () async {
      final query = client.usePage(query: const PostParams().toQuery());
      await query.fetch();

      expect(query.state.data!.pages.single, servedIds().take(75));
      expect(fake.requests.last.query['page'], '1');
      expect(query.hasNextPage(), isTrue);

      await query.getNextPage();
      expect(
        fake.requests.last.query['page'],
        'b${servedIds().take(75).reduce(min)}',
      );
      expect(query.state.data!.pages.last, servedIds().skip(75).take(75));
    },
  );

  test('an empty page ends a cursor search', () async {
    final query = client.usePage(query: const PostParams().toQuery());
    await query.fetch();
    await query.getNextPage();
    await query.getNextPage();
    expect(query.state.data!.pages.last, hasLength(50));
    await query.getNextPage();
    expect(query.state.data!.pages.last, isEmpty);
    expect(query.hasNextPage(), isFalse);
    expect(query.state.data!.pages.expand((page) => page), servedIds());
  });

  test('jumping to a page refetches only that page', () async {
    final query = client.usePage(
      query: const PostParams(tags: 'order:score').toQuery(),
    );
    final sub = query.stream.listen((_) {});
    addTearDown(sub.cancel);

    await query.fetch();
    await query.getNextPage();
    expect(query.state.data!.pages, hasLength(2));
    final requestsBefore = fake.requests.length;

    query.setData(
      InfiniteQueryData<List<int>, Object>(pages: const [], args: const [3]),
    );
    await query.invalidate();

    expect(fake.requests.length, requestsBefore + 1);
    expect(fake.requests.last.query['page'], '3');
    expect(query.state.data!.args, [3]);
    expect(query.state.data!.pages, [servedIds().skip(150)]);
    expect(query.hasNextPage(), isTrue);
  });

  test('favorites paginate by page numbers', () async {
    fake.state.favorites.addAll(servedIds().take(100));
    final query = client.useFavorites();
    await query.fetch();
    expect(fake.requests.last.path, '/favorites.json');
    expect(fake.requests.last.query['page'], '1');

    await query.getNextPage();
    expect(fake.requests.last.query['page'], '2');
    expect(query.state.data!.pages.last, servedIds().skip(75).take(25));
  });

  test('tag searches paginate by page numbers', () async {
    final query = client.useByTags(tags: ['tag_1', 'tag_2']);
    await query.fetch();
    expect(fake.requests.last.query['page'], '1');

    await query.getNextPage();
    expect(fake.requests.last.query['page'], '2');
    expect(query.state.data!.pages.last, servedIds().skip(75).take(75));
  });

  test('pool searches paginate through the pool locally', () async {
    fake.state.pools.first['post_ids'] = servedIds();
    final query = client.useByPool(id: 1252);
    await query.fetch();
    expect(query.state.data!.pages.single, servedIds().take(75));

    await query.getNextPage();
    expect(query.state.data!.pages.last, servedIds().skip(75).take(75));
    expect(query.hasNextPage(), isTrue);
  });
}
