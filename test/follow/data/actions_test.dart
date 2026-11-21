import 'package:e1547/follow/follow.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

void main() {
  const bookmark = Follow(
    id: 1,
    tags: 'canine',
    title: null,
    alias: null,
    type: FollowType.bookmark,
    latest: null,
    unseen: null,
    thumbnail: null,
    updated: null,
  );

  group('Follow.withUnseen', () {
    test('takes the thumbnail of an older post when the newest has none', () {
      final updated = bookmark.withUnseen([
        samplePost(id: 2, preview: '/preview/2'),
        samplePost(id: 3),
      ]);

      expect(updated.latest, 3);
      expect(updated.thumbnail, '/preview/2');
    });

    test('uses the newest post that has a thumbnail', () {
      final updated = bookmark.withUnseen([
        samplePost(id: 2, preview: '/preview/2'),
        samplePost(id: 3, preview: '/preview/3'),
      ]);

      expect(updated.thumbnail, '/preview/3');
    });

    test('keeps the previous thumbnail when no post has one', () {
      final updated = bookmark
          .copyWith(thumbnail: '/preview/1', latest: 1, unseen: 0)
          .withUnseen([samplePost(id: 3)]);

      expect(updated.latest, 3);
      expect(updated.thumbnail, '/preview/1');
    });
  });
}
