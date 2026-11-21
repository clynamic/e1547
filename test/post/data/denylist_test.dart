import 'package:e1547/post/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_support/posts.dart';

/// Mirrors the semantics of e621ng's client side blacklist, which lives in
/// `app/javascript/src/js/core/blacklist`.
void main() {
  group('lines', () {
    test('a single tag denies a post with it', () {
      final post = samplePost(
        tags: {
          'general': ['cat', 'sitting'],
        },
      );
      expect(post.isDeniedBy(['cat']), true);
      expect(post.isDeniedBy(['dog']), false);
    });

    test('tags on one line are required together', () {
      final post = samplePost(
        tags: {
          'general': ['cat', 'sitting'],
        },
      );
      expect(post.isDeniedBy(['cat sitting']), true);
      expect(post.isDeniedBy(['cat standing']), false);
    });

    test('a leading dash inverts a tag', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['cat -dog']), true);
      expect(post.isDeniedBy(['cat -sitting']), true);
      expect(post.isDeniedBy(['-cat']), false);
    });

    test('a leading tilde makes tags alternatives', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['~cat ~dog']), true);
      expect(post.isDeniedBy(['~bird ~dog']), false);
    });

    test('optional tags apply on top of required ones', () {
      final post = samplePost(
        tags: {
          'general': ['cat', 'sitting'],
        },
      );
      expect(post.isDeniedBy(['sitting ~cat ~dog']), true);
      expect(post.isDeniedBy(['sitting ~bird ~dog']), false);
      expect(post.isDeniedBy(['standing ~cat ~dog']), false);
    });

    test('blank lines are ignored', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['', '   ', 'cat']), true);
      expect(post.isDeniedBy(['', '   ']), false);
    });

    test('surrounding whitespace does not matter', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['  cat  ']), true);
    });

    test('a line starting with a hash is a comment', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['#cat']), false);
      expect(post.isDeniedBy(['# cat']), false);
    });

    test('a hash ends a line early', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['cat # a comment']), true);
      expect(post.isDeniedBy(['dog # cat']), false);
    });
  });

  group('deniers', () {
    test('reports every line that matches', () {
      final post = samplePost(
        tags: {
          'general': ['cat', 'sitting'],
        },
      );
      expect(post.getDeniers(['cat', 'dog', 'sitting']), ['cat', 'sitting']);
    });

    test('reports nothing when no line matches', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.getDeniers(['dog', 'bird']), isEmpty);
    });

    test('reports the line without its comment', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.getDeniers(['cat # a comment']), ['cat']);
    });
  });

  group('metatags', () {
    test('id matches the post id', () {
      final post = samplePost(id: 42);
      expect(post.isDeniedBy(['id:42']), true);
      expect(post.isDeniedBy(['id:43']), false);
    });

    test('rating takes a letter or a name', () {
      final post = samplePost(rating: Rating.e);
      expect(post.isDeniedBy(['rating:e']), true);
      expect(post.isDeniedBy(['rating:explicit']), true);
      expect(post.isDeniedBy(['rating:s']), false);
      expect(post.isDeniedBy(['rating:safe']), false);
    });

    test('type matches the file extension', () {
      final post = samplePost(ext: 'webm');
      expect(post.isDeniedBy(['type:webm']), true);
      expect(post.isDeniedBy(['type:png']), false);
    });

    test('fav matches a favorited post', () {
      expect(samplePost(isFavorited: true).isDeniedBy(['fav:anything']), true);
      expect(samplePost().isDeniedBy(['fav:anything']), false);
    });

    test('pool matches a pool the post belongs to', () {
      final post = samplePost(pools: [7, 9]);
      expect(post.isDeniedBy(['pool:7']), true);
      expect(post.isDeniedBy(['pool:8']), false);
    });

    test('tagcount counts tags across categories', () {
      final post = samplePost(
        tags: {
          'general': ['cat', 'sitting'],
          'artist': ['someone'],
        },
      );
      expect(post.isDeniedBy(['tagcount:3']), true);
      expect(post.isDeniedBy(['tagcount:2']), false);
    });

    test('userid matches the uploader id', () {
      final post = samplePost(uploaderId: 5);
      expect(post.isDeniedBy(['userid:5']), true);
      expect(post.isDeniedBy(['userid:>4']), true);
      expect(post.isDeniedBy(['userid:6']), false);
    });

    test('an unknown metatag falls back to a plain tag', () {
      final post = samplePost(
        tags: {
          'general': ['artist:unknown'],
        },
      );
      expect(post.isDeniedBy(['artist:unknown']), true);
      expect(post.isDeniedBy(['artist:known']), false);
    });
  });

  group('comparisons', () {
    test('a bare number requires equality', () {
      expect(samplePost(score: 10).isDeniedBy(['score:10']), true);
      expect(samplePost(score: 11).isDeniedBy(['score:10']), false);
    });

    test('greater and lesser than', () {
      expect(samplePost(score: 11).isDeniedBy(['score:>10']), true);
      expect(samplePost(score: 10).isDeniedBy(['score:>10']), false);
      expect(samplePost(score: 9).isDeniedBy(['score:<10']), true);
      expect(samplePost(score: 10).isDeniedBy(['score:<10']), false);
    });

    test('greater and lesser than or equal', () {
      expect(samplePost(score: 10).isDeniedBy(['score:>=10']), true);
      expect(samplePost(score: 9).isDeniedBy(['score:>=10']), false);
      expect(samplePost(score: 10).isDeniedBy(['score:<=10']), true);
      expect(samplePost(score: 11).isDeniedBy(['score:<=10']), false);
    });

    test('a range covers the values between its bounds', () {
      expect(samplePost(score: 15).isDeniedBy(['score:10..20']), true);
      expect(samplePost(score: 25).isDeniedBy(['score:10..20']), false);
    });

    test('comparisons apply to every numeric metatag', () {
      expect(samplePost(favCount: 5).isDeniedBy(['favcount:>3']), true);
      expect(samplePost(favCount: 3).isDeniedBy(['favcount:>3']), false);
      expect(samplePost(width: 800).isDeniedBy(['width:>=800']), true);
      expect(samplePost(width: 799).isDeniedBy(['width:>=800']), false);
      expect(samplePost(height: 600).isDeniedBy(['height:<700']), true);
      expect(samplePost(height: 700).isDeniedBy(['height:<700']), false);
      expect(samplePost(size: 2048).isDeniedBy(['filesize:>1024']), true);
      expect(samplePost(size: 1024).isDeniedBy(['filesize:>1024']), false);
    });

    test('a range includes its bounds', () {
      expect(samplePost(score: 10).isDeniedBy(['score:10..20']), true);
      expect(samplePost(score: 20).isDeniedBy(['score:10..20']), true);
    });

    test('a comparison written backwards means the same', () {
      expect(samplePost(score: 10).isDeniedBy(['score:=<10']), true);
      expect(samplePost(score: 10).isDeniedBy(['score:=>10']), true);
    });

    test('a range can be left open on either side', () {
      expect(samplePost(score: 10).isDeniedBy(['score:..20']), true);
      expect(samplePost(score: 30).isDeniedBy(['score:..20']), false);
      expect(samplePost(score: 30).isDeniedBy(['score:20..']), true);
      expect(samplePost(score: 10).isDeniedBy(['score:20..']), false);
    });

    test('a comparison accepts negative numbers', () {
      expect(samplePost(score: -5).isDeniedBy(['score:<0']), true);
      expect(samplePost(score: -5).isDeniedBy(['score:>-10']), true);
      expect(samplePost(score: -20).isDeniedBy(['score:>-10']), false);
    });

    test('filesize accepts a unit', () {
      final post = samplePost(size: 5 * 1024 * 1024);
      expect(post.isDeniedBy(['filesize:>1mb']), true);
      expect(post.isDeniedBy(['filesize:>10mb']), false);
      expect(post.isDeniedBy(['filesize:>500kb']), true);
    });
  });

  group('conformance', () {
    test('a line matches regardless of case', () {
      final post = samplePost(
        rating: Rating.e,
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['Rating:e']), true);
      expect(post.isDeniedBy(['rating:E']), true);
      expect(post.isDeniedBy(['CAT']), true);
    });

    test('an asterisk stands for any part of a tag', () {
      final post = samplePost(
        tags: {
          'general': ['cat_ears'],
        },
      );
      expect(post.isDeniedBy(['cat*']), true);
      expect(post.isDeniedBy(['*ears']), true);
      expect(post.isDeniedBy(['dog*']), false);
    });

    test('status matches the state of the post', () {
      expect(samplePost(isDeleted: true).isDeniedBy(['status:deleted']), true);
      expect(samplePost().isDeniedBy(['status:deleted']), false);
    });

    test('prefixes may be combined in any order', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['-~cat']), false);
      expect(post.isDeniedBy(['~-cat']), false);
      expect(post.isDeniedBy(['-~dog']), true);
    });

    test('user matches the uploader name, or an id behind a bang', () {
      final post = samplePost(uploaderId: 5, uploaderName: 'tester');
      expect(post.isDeniedBy(['user:tester']), true);
      expect(post.isDeniedBy(['username:tester']), true);
      expect(post.isDeniedBy(['user:!5']), true);
      expect(post.isDeniedBy(['user:someone']), false);
    });

    test('a hash only starts a comment after a space', () {
      final post = samplePost(
        tags: {
          'general': ['cat'],
        },
      );
      expect(post.isDeniedBy(['cat#dog']), false);
    });
  });
}
