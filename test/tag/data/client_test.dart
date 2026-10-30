import 'package:dio/dio.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/client.dart';
import '../../_support/fake_e621.dart';
import '../../_support/fixtures.dart';
import '../../_support/harness.dart';

void main() {
  late FakeE621 fake;
  late TagClient client;

  setUpAll(initializeTestApp);

  setUp(() async {
    fake = await FakeE621.start();
    client = TagClient(dio: dioFor(fake));
  });

  tearDown(() => fake.stop());

  test('maps a recorded tag onto the model', () async {
    final recorded = loadFixtureList('tags.json').first;

    final tag = (await client.page()).first;

    expect(tag.id, recorded['id']);
    expect(tag.name, recorded['name']);
    expect(tag.count, recorded['post_count']);
    expect(tag.category, recorded['category']);
  });

  test('resolves an alias to its consequent', () async {
    final recorded = loadFixtureList(
      'tag_aliases.json',
    ).firstWhere((e) => e['status'] != 'deleted');

    final alias = await client.aliases(
      query: {
        'search[antecedent_name]': recorded['antecedent_name']! as String,
      },
    );

    expect(alias, recorded['consequent_name']);
  });

  group('previews', () {
    late TagClient tags;

    setUp(() {
      final Dio dio = dioFor(fake)..queryCache = CachedQuery.asNewInstance();
      tags = TagClient(dio: dio);
    });

    List<String> asked() => [
      for (final FakeRequest request in fake.requests)
        if (request.path == '/tags/preview.json') request.body['tags']!,
    ];

    test('lists asked for together share one request', () async {
      final List<String> names = [
        for (final Map<String, Object?> tag in loadFixtureList('tags.json'))
          tag['name']! as String,
      ].take(3).toList();

      final results = await Future.wait([
        tags.usePreview(names: names.take(2).toList()).fetch(),
        tags.usePreview(names: names.skip(1).toList()).fetch(),
      ]);

      expect(asked(), hasLength(1));
      expect(asked().single.split(' ').toSet(), names.toSet());
      expect(results.map((e) => e.data!.map((e) => e.name)), [
        names.take(2),
        names.skip(1),
      ]);
    });

    test('a later list asks only for the names not seen yet', () async {
      final List<String> names = [
        for (final Map<String, Object?> tag in loadFixtureList('tags.json'))
          tag['name']! as String,
      ].take(3).toList();
      await tags.usePreview(names: names.take(2).toList()).fetch();

      final result = await tags.usePreview(names: names).fetch();

      expect(asked(), [names.take(2).join(' '), names.last]);
      expect(result.data!.map((e) => e.name), names);
    });
  });
}
