import 'package:e1547/topic/topic.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late TopicClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = TopicClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded topic onto the model', () async {
    final recorded = loadFixtureList('topics.json').first;

    final topic = (await client.page()).first;

    expect(topic.id, recorded['id']);
    expect(topic.title, recorded['title']);
    expect(topic.creatorId, recorded['creator_id']);
    expect(topic.responseCount, recorded['response_count']);
    expect(topic.sticky, recorded['is_sticky']);
    expect(topic.hidden, recorded['is_hidden']);
    expect(topic.categoryId, recorded['category_id']);
  });

  test('reads a topic by id', () async {
    final recorded = loadFixtureList('topics.json').last;

    final topic = await client.get(id: recorded['id']! as int);

    expect(topic.title, recorded['title']);
  });
}
