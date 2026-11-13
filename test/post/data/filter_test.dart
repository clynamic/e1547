import 'package:drift/native.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notified_preferences/notified_preferences.dart';

import '../../_support/fake_e621.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  late FakeE621 fake;
  late Client client;
  late ValueNotifier<Traits> traits;
  late AppDatabase sqlite;
  late PostFilter filter;

  final Post post = samplePost(
    id: 7,
    tags: const {
      'general': ['bad_tag'],
    },
  );

  setUpAll(() async {
    await initializeTestApp();
    sqlite = AppDatabase(NativeDatabase.memory());
  });

  tearDownAll(() => sqlite.close());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fake = await FakeE621.start();
    traits = ValueNotifier(
      const Traits(
        id: 1,
        userId: null,
        denylist: ['bad_tag'],
        homeTags: '',
        avatar: null,
        perPage: null,
      ),
    );
    client = Client(
      identity: Identity(id: 1, host: fake.url, username: null, headers: null),
      traits: traits,
      storage: AppStorage(
        preferences: await SharedPreferences.getInstance(),
        temporaryFiles: '.',
        queryCache: CachedQuery.asNewInstance(),
        sqlite: sqlite,
      ),
    );
    filter = PostFilter(client);
  });

  tearDown(() async {
    filter.dispose();
    traits.dispose();
    await fake.stop();
  });

  test('a post with a denied entry is blocked and denied', () {
    expect(filter.blocks(post), true);
    expect(filter.denies(post), true);
  });

  test('nothing is blocked while denying is off', () {
    filter.denying = false;

    expect(filter.blocks(post), false);
    expect(filter.denies(post), false);
  });

  test('an allowed entry lifts the block', () {
    filter.enable('bad_tag');

    expect(filter.blocks(post), false);
    expect(filter.denies(post), false);
  });

  test('a post whose tags change is judged by its new tags', () {
    final Post clean = samplePost(
      id: 8,
      tags: const {
        'general': ['fine_tag'],
      },
    );
    expect(filter.blocks(clean), false);

    final Post tagged = clean.copyWith(
      tags: const {
        'general': ['fine_tag', 'bad_tag'],
      },
    );

    expect(filter.blocks(tagged), true);
  });

  test('an allowed post stays blocked without being denied', () {
    filter.allow(post.id);

    expect(filter.blocks(post), true);
    expect(filter.denies(post), false);
  });
}
