import 'package:e1547/flag/flag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late FlagClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = FlagClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded flag onto the model', () async {
    final recorded = loadFixtureList('flags.json').first;

    final flag = (await client.page()).first;

    expect(flag.id, recorded['id']);
    expect(flag.postId, recorded['post_id']);
    expect(flag.reason, recorded['reason']);
    expect(flag.isResolved, recorded['is_resolved']);
    expect(flag.creatorId, recorded['creator_id']);
    expect(flag.isDeletion, recorded['is_deletion']);
  });

  test('lists flags by the query it is given', () async {
    await client.page(query: {'search[type]': 'deletion'});

    expect(fake.requests.last.query, containsPair('search[type]', 'deletion'));
  });

  test('creates a flag with only the permitted params', () async {
    final postId = loadFixtureList('posts.json').first['id']! as int;

    await client.create(postId, 'inferior', parent: 42);

    expect(fake.requests.last.body, {
      'post_flag[post_id]': '$postId',
      'post_flag[reason_name]': 'inferior',
      'post_flag[parent_id]': '42',
    });
  });
}
