import 'package:e1547/wiki/wiki.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late WikiClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = WikiClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded wiki page onto the model', () async {
    final recorded = loadFixtureList('wiki_pages.json').first;

    final wiki = (await client.page()).first;

    expect(wiki.id, recorded['id']);
    expect(wiki.title, recorded['title']);
    expect(wiki.body, recorded['body']);
  });

  test('reads a wiki page by title', () async {
    final recorded = loadFixtureList('wiki_pages.json').last;

    final wiki = await client.getByTitle(title: recorded['title']! as String);

    expect(wiki.id, recorded['id']);
  });
}
