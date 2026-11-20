import 'package:dio/dio.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/reply/reply.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late ReplyClient client;
  final topic = loadFixtureList('topics.json').first['id']! as int;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = ReplyClient(
      dio: createDefaultDio(
        Identity(id: 1, host: fake.url, username: 'tester', headers: null),
      ),
    );
  });

  tearDown(() => fake.stop());

  test('maps a recorded reply onto the model', () async {
    final recorded = loadFixtureList('replies.json').first;

    final replies = await client.page(query: {'search[topic_id]': '$topic'});

    final reply = replies.firstWhere((e) => e.id == recorded['id']);
    expect(reply.body, recorded['body']);
    expect(reply.topicId, recorded['topic_id']);
    expect(reply.creator, recorded['creator_name']);
    expect(reply.hidden, recorded['is_hidden']);
  });

  test('requests the replies of one topic', () async {
    await client.page(query: {'search[topic_id]': '$topic'});

    expect(fake.requests.last.path, '/forum_posts.json');
    expect(
      fake.requests.last.query,
      containsPair('search[topic_id]', '$topic'),
    );
  });

  test('creates a reply with only its body and topic', () async {
    await client.create(topicId: topic, content: 'hello');

    final request = fake.requests.last;
    expect(request.method, 'POST');
    expect(request.path, '/forum_posts.json');
    expect(request.body, {
      'forum_post[body]': 'hello',
      'forum_post[topic_id]': '$topic',
    });
  });

  test('a locked topic refuses replies', () async {
    final locked = loadFixtureList('topics.json')[1]['id']! as int;

    await expectLater(
      client.create(topicId: locked, content: 'hello'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          422,
        ),
      ),
    );
  });

  test('updates a reply body', () async {
    final id = loadFixtureList('replies.json').first['id']! as int;

    await client.update(id: id, content: 'edited');

    expect((await client.get(id: id)).body, 'edited');
  });

  test('the server rejects params it does not permit', () async {
    await expectLater(
      client.dio.post(
        '/forum_posts.json',
        data: FormData.fromMap({
          'forum_post[body]': 'hello',
          'forum_post[topic_id]': '$topic',
          'forum_post[creator_id]': '9000',
        }),
      ),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          400,
        ),
      ),
    );
  });
}
