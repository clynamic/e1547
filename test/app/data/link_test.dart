import 'package:e1547/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mirrors the url shapes e621ng serves, which are declared in
/// `config/routes.rb`.
void main() {
  Link? parse(String url) => const E621LinkParser().parse(url);

  group('posts', () {
    test('reads an id from the current and the legacy path', () {
      for (final url in ['/posts/123', '/post/show/123']) {
        final link = parse(url);
        expect(link?.type, LinkType.post, reason: url);
        expect(link?.id, 123, reason: url);
      }
    });

    test('reads an id from an absolute url', () {
      expect(parse('https://e621.net/posts/123')?.id, 123);
      expect(parse('https://e926.net/posts/123')?.id, 123);
    });

    test('reads a search without an id', () {
      final link = parse('/posts?tags=cat');
      expect(link?.type, LinkType.post);
      expect(link?.id, null);
      expect(link?.query, {'tags': 'cat'});
    });

    test('leaves the query empty when there is none', () {
      final link = parse('/posts');
      expect(link?.type, LinkType.post);
      expect(link?.query, null);
    });
  });

  group('pools', () {
    test('reads an id from the current and the legacy path', () {
      for (final url in ['/pools/12', '/pool/show/12']) {
        final link = parse(url);
        expect(link?.type, LinkType.pool, reason: url);
        expect(link?.id, 12, reason: url);
      }
    });

    test('reads a search without an id', () {
      final link = parse('/pools?search[name_matches]=cat');
      expect(link?.type, LinkType.pool);
      expect(link?.id, null);
      expect(link?.query, {'search[name_matches]': 'cat'});
    });
  });

  group('users', () {
    test('reads a name', () {
      final link = parse('/users/tester');
      expect(link?.type, LinkType.user);
      expect(link?.id, 'tester');
    });

    test('reads an id as a number', () {
      expect(parse('/users/123')?.id, 123);
      expect(parse('/user/show/9')?.id, 9);
    });
  });

  group('wiki pages', () {
    test('reads a title', () {
      final link = parse('/wiki_pages/cat');
      expect(link?.type, LinkType.wiki);
      expect(link?.id, 'cat');
    });

    test('reads an id as a number', () {
      expect(parse('/wiki_pages/123')?.id, 123);
    });

    test('reads a search without a title', () {
      expect(parse('/wiki_pages')?.type, LinkType.wiki);
      expect(parse('/wiki_pages')?.id, null);
    });
  });

  group('forum', () {
    test('reads a topic id with its query', () {
      final link = parse('/forum_topics/5?page=2');
      expect(link?.type, LinkType.topic);
      expect(link?.id, 5);
      expect(link?.query, {'page': '2'});
    });

    test('reads a topic search', () {
      expect(parse('/forum_topics')?.type, LinkType.topic);
      expect(parse('/forum_topics')?.id, null);
    });

    test('reads a reply id', () {
      final link = parse('/forum_posts/7');
      expect(link?.type, LinkType.reply);
      expect(link?.id, 7);
    });
  });

  group('rejection', () {
    test('ignores paths that belong to no known type', () {
      expect(parse('/artists/1'), null);
      expect(parse('/tags'), null);
    });

    test('ignores text that is not a url', () {
      expect(parse('nonsense'), null);
      expect(parse(''), null);
    });

    test('ignores a path with a trailing segment', () {
      expect(parse('/posts/123/extra'), null);
    });
  });

  group('conformance', () {
    test('reads an id from the paths that e621 redirects', () {
      for (final url in [
        '/post/show/123/artist_name',
        '/post/view/123',
        '/post/view/123/artist_name',
        '/post/flag/123',
      ]) {
        final link = parse(url);
        expect(link?.type, LinkType.post, reason: url);
        expect(link?.id, 123, reason: url);
      }
    });

    test('reads a search from the legacy singular paths', () {
      final link = parse('/post?tags=cat');
      expect(link?.type, LinkType.post);
      expect(link?.id, null);
      expect(link?.query, {'tags': 'cat'});
      expect(parse('/pool')?.type, LinkType.pool);
      expect(parse('/user')?.type, LinkType.user);
    });

    test('reads a wiki title from the show or new path', () {
      final link = parse('/wiki_pages/show_or_new?title=cat');
      expect(link?.type, LinkType.wiki);
      expect(link?.id, 'cat');
    });

    test('parses the wiki search path as a search', () {
      final link = parse('/wiki_pages/search?title=cat');
      expect(link?.type, LinkType.wiki);
      expect(link?.id, null);
      expect(link?.query, {'title': 'cat'});
    });

    test('ignores a trailing slash', () {
      expect(parse('/posts/123/')?.id, 123);
    });
  });
}
