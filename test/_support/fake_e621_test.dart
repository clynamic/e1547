import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_e621.dart';
import 'harness.dart';

void main() {
  late FakeE621 fake;
  late Dio dio;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start(state: FakeE621State.seeded(posts: 200));
    dio = Dio(BaseOptions(baseUrl: fake.url, validateStatus: (status) => true));
  });

  tearDown(() => fake.stop());

  Future<Response<Object?>> posts(Map<String, Object?> query) =>
      dio.get<Object?>('/posts.json', queryParameters: query);

  List<Object?> postsOf(Response<Object?> response) =>
      (response.data! as Map)['posts']! as List;

  List<int> idsOf(List<Object?> posts) =>
      posts.map((e) => (e! as Map)['id']! as int).toList();

  test('serves 75 posts when no limit is given', () async {
    expect(postsOf(await posts({})), hasLength(75));
  });

  test('serves the page after the first without a gap or an overlap', () async {
    final first = idsOf(postsOf(await posts({'page': 1, 'limit': 10})));
    final second = idsOf(postsOf(await posts({'page': 2, 'limit': 10})));

    expect(second, hasLength(10));
    expect(second.first, first.last + 1);
    expect(second.toSet().intersection(first.toSet()), isEmpty);
  });

  test('serves an empty page past the end', () async {
    expect(postsOf(await posts({'page': 40, 'limit': 10})), isEmpty);
  });

  test('serves nothing for a zero limit', () async {
    expect(postsOf(await posts({'limit': 0})), isEmpty);
  });

  test('rejects a limit above the maximum', () async {
    final response = await posts({'limit': 321});

    expect(response.statusCode, 410);
  });

  test('rejects a limit that is not a number', () async {
    expect((await posts({'limit': 'ten'})).statusCode, 410);
  });

  test('rejects a page below the first', () async {
    expect((await posts({'page': 0})).statusCode, 410);
  });

  test('rejects a page beyond the last', () async {
    expect((await posts({'page': 751})).statusCode, 410);
  });

  group('cursor pages', () {
    setUp(() {
      // The real site serves the posts a cursor continues from newest first,
      // so order the fake's posts the same way.
      fake.state.posts.sort(
        (a, b) => (b['id']! as int).compareTo(a['id']! as int),
      );
    });

    test('serves the posts before the anchor in descending id order', () async {
      final first = idsOf(postsOf(await posts({'page': 1, 'limit': 10})));
      final second = idsOf(
        postsOf(await posts({'page': 'b${first.last}', 'limit': 10})),
      );

      expect(second, hasLength(10));
      expect(second, everyElement(lessThan(first.last)));
      expect(second.first, first.last - 1);
      expect(second.toSet().intersection(first.toSet()), isEmpty);
    });

    test('serves an empty page before the oldest post', () async {
      final oldest = idsOf(
        postsOf(await posts({'page': 1, 'limit': 200})),
      ).last;
      expect(postsOf(await posts({'page': 'b$oldest'})), isEmpty);
    });

    test('serves cursors for id orders', () async {
      final plain = idsOf(postsOf(await posts({'page': 'b1200'})));
      for (final order in ['new', 'id', 'id_desc']) {
        expect(
          idsOf(
            postsOf(await posts({'page': 'b1200', 'tags': 'order:$order'})),
          ),
          plain,
          reason: 'order: $order',
        );
      }
    });

    test('ignores a cursor for other orders', () async {
      final page = idsOf(postsOf(await posts({'limit': 10})));
      final cursored = idsOf(
        postsOf(
          await posts({
            'page': 'b${page.last}',
            'limit': 10,
            'tags': 'order:score',
          }),
        ),
      );
      expect(cursored, page);
    });

    test('rejects ascending cursors', () async {
      expect((await posts({'page': 'a123'})).statusCode, 501);
    });
  });
}
