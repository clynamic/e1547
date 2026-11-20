import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/environment.dart';
import '../../_support/harness.dart';

void main() {
  setUpAll(initializeTestApp);

  late TestEnvironment env;

  setUp(() async => env = await TestEnvironment.start());

  tearDown(() => env.dispose());

  Future<List<String>> names(String term) async =>
      (await suggestTerm(env.client, term)).map((e) => e.name).toList();

  test(
    'a metatag with fixed values suggests those that start as typed',
    () async {
      expect(await names('rating:'), [
        'rating:explicit',
        'rating:questionable',
        'rating:safe',
      ]);
      expect(await names('order:sc'), ['order:score', 'order:score_asc']);
      expect(await names('status:de'), ['status:deleted']);
    },
  );

  test('a negated metatag keeps its sign on every suggestion', () async {
    expect(await names('-rating:s'), ['-rating:safe']);
  });

  test('a file type typed as flash suggests swf', () async {
    expect(await names('type:flash'), ['type:swf']);
  });

  test(
    'a file type typed bare is offered as a type metatag before tags',
    () async {
      env.fake.state.tags.add({
        ...env.fake.state.tags.first,
        'name': 'webm_tag',
      });

      expect(await names('webm'), ['type:webm', 'webm_tag']);
    },
  );

  test(
    'the start of a metatag name suggests the name, left open for a value',
    () async {
      final List<TagSuggestion> found = await suggestTerm(env.client, 'ord');

      expect(found.map((e) => (e.name, e.complete)), [('order:', false)]);
    },
  );

  test('a user metatag suggests users whose names start as typed', () async {
    expect(await names('fav:user_3'), [
      'fav:user_34',
      'fav:user_35',
      'fav:user_36',
    ]);
    expect(await names('fav:us'), isEmpty);
  });

  test('the pool metatag suggests pools by name', () async {
    final String pool = env.fake.state.pools[1]['name']! as String;

    expect(await names('pool:$pool'), ['pool:$pool']);
  });
}
