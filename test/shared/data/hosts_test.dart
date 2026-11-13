import 'package:e1547/shared/shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a link finds the favicon of its site by host, alias or parent', () {
    expect(
      getFaviconHost('https://www.furaffinity.net/view/1'),
      'furaffinity.net',
    );
    expect(getFaviconHost('https://x.com/artist/status/1'), 'twitter.com');
    expect(getFaviconHost('https://pbs.twimg.com/media/a.png'), 'twitter.com');
    expect(
      getFaviconHost('https://d.furaffinity.net/art/a.png'),
      'furaffinity.net',
    );
    expect(getFaviconHost('https://pawb.fun/@artist'), 'mastodon.social');
    expect(getFaviconHost('https://www.bilibili.com/opus/1'), 'bilibili.com');
    expect(getFaviconHost('https://example.org/a'), isNull);
  });
}
