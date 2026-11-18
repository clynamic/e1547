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

  List<Object?> postsOf(Response<Object?> response) => response.data! as List;

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

  test('serves tags grouped by category only in extended mode', () async {
    final basic = postsOf(await posts({'limit': 1})).single! as Map;
    final extended =
        postsOf(await posts({'limit': 1, 'mode': 'extended'})).single! as Map;
    final categories = extended['tags']! as Map;

    expect(basic['tags'], categories.values.expand((e) => e as List).toList());
  });
}
