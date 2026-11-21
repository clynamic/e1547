import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

void main() {
  final post = samplePost(
    tags: const {
      'general': ['solo'],
      'artist': ['tester'],
    },
  ).copyWith(description: 'old', sources: const ['https://a']);

  group('PostEdit.applyTo', () {
    test('keeps the category of tags it did not change', () {
      final edit = PostEdit.fromPost(post).copyWith(tags: const ['solo']);

      expect(edit.applyTo(post).tags, {
        'general': ['solo'],
        'artist': <String>[],
      });
    });

    test('files added tags under general', () {
      final edit = PostEdit.fromPost(
        post,
      ).copyWith(tags: const ['solo', 'tester', 'canine']);

      expect(edit.applyTo(post).tags['general'], ['solo', 'canine']);
    });

    test('applies the edited fields', () {
      final edit = PostEdit.fromPost(post).copyWith(
        rating: Rating.e,
        description: 'new',
        sources: const ['https://b'],
        parentId: 7,
      );

      final applied = edit.applyTo(post);
      expect(applied.rating, Rating.e);
      expect(applied.description, 'new');
      expect(applied.sources, ['https://b']);
      expect(applied.relationships.parentId, 7);
    });
  });
}
