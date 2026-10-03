import 'dart:io';

import 'package:e1547/account/account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  group('withoutCloudflareCookies', () {
    test('strips Cloudflare cookies and keeps the rest', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader:
              'cf_clearance=dead; _danbooru_session=keep; __cfruid=dead',
        }),
        {HttpHeaders.cookieHeader: '_danbooru_session=keep'},
      );
    });

    test('removes the header when only Cloudflare cookies remain', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.authorizationHeader: 'Basic secret',
          HttpHeaders.cookieHeader: 'cf_clearance=dead',
        }),
        {HttpHeaders.authorizationHeader: 'Basic secret'},
      );
    });

    test('returns null when there is nothing to strip', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader: '_danbooru_session=keep',
        }),
        null,
      );
      expect(withoutCloudflareCookies({}), null);
      expect(withoutCloudflareCookies(null), null);
    });

    test('keeps values containing separators intact', () {
      expect(
        withoutCloudflareCookies({
          HttpHeaders.cookieHeader: 'cf_clearance=dead; session=a=b=c',
        }),
        {HttpHeaders.cookieHeader: 'session=a=b=c'},
      );
    });
  });

  group('allowsCookieCaptureNavigation', () {
    NavigationRequest request(String url, {bool isMainFrame = true}) =>
        NavigationRequest(url: url, isMainFrame: isMainFrame);

    test('allows same-host http and https', () {
      const host = 'https://e621.net';
      expect(
        allowsCookieCaptureNavigation(host, request('https://e621.net/posts')),
        isTrue,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('http://e621.net/posts')),
        isTrue,
      );
    });

    test('accepts a bare host and normalizes it', () {
      expect(
        allowsCookieCaptureNavigation('e621.net', request('https://e621.net')),
        isTrue,
      );
    });

    test('allows any subframe', () {
      const host = 'https://e621.net';
      expect(
        allowsCookieCaptureNavigation(
          host,
          request(
            'https://challenges.cloudflare.com/widget',
            isMainFrame: false,
          ),
        ),
        isTrue,
      );
      expect(
        allowsCookieCaptureNavigation(
          host,
          request('https://evil.example', isMainFrame: false),
        ),
        isTrue,
      );
    });

    test('blocks off-site hosts', () {
      const host = 'https://e621.net';
      expect(
        allowsCookieCaptureNavigation(host, request('https://evil.example')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('https://www.e621.net')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(
          host,
          request('https://static1.e621.net'),
        ),
        isFalse,
      );
    });

    test('blocks non-http schemes and malformed urls', () {
      const host = 'https://e621.net';
      expect(
        allowsCookieCaptureNavigation(
          host,
          request('intent://e621.net/#Intent;end'),
        ),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('tel:+15551234')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('mailto:a@b.c')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('market://details?id=x')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('javascript:alert(1)')),
        isFalse,
      );
      expect(
        allowsCookieCaptureNavigation(host, request('http://[invalid')),
        isFalse,
      );
    });
  });
}
