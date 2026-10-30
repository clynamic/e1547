import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/bed.dart';
import '../../_support/harness.dart';
import '../../_support/posts.dart';

void main() {
  late TestBed bed;
  late PostFilter filter;

  final Post post = samplePost(
    id: 7,
    tags: const {
      'general': ['bad_tag'],
    },
  );

  setUpAll(initializeTestApp);

  setUp(() async {
    bed = await TestBed.start(denylist: ['bad_tag']);
    filter = PostFilter(bed.client);
  });

  tearDown(() async {
    filter.dispose();
    await bed.dispose();
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

  test('an allowed post stays blocked without being denied', () {
    filter.allow(post.id);

    expect(filter.blocks(post), true);
    expect(filter.denies(post), false);
  });
}
