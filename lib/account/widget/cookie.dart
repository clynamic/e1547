import 'dart:io';

import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager_plus/webview_cookie_manager_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CookieCapturePage extends StatefulWidget {
  const CookieCapturePage({super.key, this.title});

  final Widget? title;

  @override
  State<CookieCapturePage> createState() => _CookieCapturePageState();
}

class _CookieCapturePageState extends State<CookieCapturePage> {
  late final Logger logger = Logger('CookieCapture', {
    'host': context.read<Client>().host,
  });

  /// The only origin this page is allowed to navigate.
  late final String host = normalizeHostUrl(context.read<Client>().host);

  late final WebViewController controller = WebViewController()
    ..setUserAgent(AppInfo.instance.userAgent)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Theme.of(context).colorScheme.surface)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          if (allowsCookieCaptureNavigation(host, request)) {
            return NavigationDecision.navigate;
          }
          logger.debug('Blocked navigation', {'url': request.url});
          return NavigationDecision.prevent;
        },
      ),
    )
    ..loadRequest(Uri.parse(host));

  Future<void> setCookies(BuildContext context) async {
    IdentityClient client = context.read<IdentityClient>();
    WebviewCookieManager cookieManager = WebviewCookieManager();
    List<Cookie> cookies = await cookieManager.getCookies(client.identity.host);

    Map<String, String> headers = Map.of(client.identity.headers ?? {});
    // Drop cookies the old logic wrongly stored as top-level headers.
    Set<String> captured = cookies.map((cookie) => cookie.name).toSet();
    headers.removeWhere(
      (key, value) => isCloudflareCookie(key) || captured.contains(key),
    );

    Map<String, String> jar = {};
    String? existing = headers[HttpHeaders.cookieHeader];
    if (existing != null) {
      for (final pair in existing.split('; ')) {
        int split = pair.indexOf('=');
        if (split <= 0) continue;
        String name = pair.substring(0, split);
        if (isCloudflareCookie(name)) jar[name] = pair.substring(split + 1);
      }
    }

    for (final cookie in cookies) {
      if (isCloudflareCookie(cookie.name)) jar[cookie.name] = cookie.value;
    }

    if (jar.isEmpty) return;

    headers[HttpHeaders.cookieHeader] = jar.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('; ');
    client.replace(client.identity.copyWith(headers: headers));
  }

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton(), title: widget.title),
      body: WebViewWidget(controller: controller),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          // A double tap would capture and replace the identity twice.
          if (submitted) return;
          submitted = true;
          NavigatorState navigator = Navigator.of(context);
          try {
            await setCookies(context);
          } on Exception catch (e, stacktrace) {
            logger.error('Failed to capture cookies', null, e, stacktrace);
          }
          await navigator.maybePop();
        },
      ),
    );
  }
}

/// Discards stored Cloudflare cookies once the host has rejected them.
Future<void> dropCloudflareCookies(IdentityClient client) async {
  Map<String, String>? headers = withoutCloudflareCookies(
    client.identity.headers,
  );
  if (headers == null) return;
  await client.replace(client.identity.copyWith(headers: headers));
}

/// Strips Cloudflare cookies from [headers], or null when nothing changes.
Map<String, String>? withoutCloudflareCookies(Map<String, String>? headers) {
  String? existing = headers?[HttpHeaders.cookieHeader];
  if (existing == null) return null;

  List<String> pairs = existing.split('; ');
  List<String> kept = pairs
      .where((pair) => !isCloudflareCookie(pair.split('=').first))
      .toList();
  if (kept.length == pairs.length) return null;

  Map<String, String> result = Map.of(headers!);
  if (kept.isEmpty) {
    result.remove(HttpHeaders.cookieHeader);
  } else {
    result[HttpHeaders.cookieHeader] = kept.join('; ');
  }
  return result;
}

bool isCloudflareCookie(String name) {
  // Challenge state cookies are transient and pointless to persist.
  if (name.startsWith('cf_chl')) return false;
  return name.startsWith('cf_') || name.startsWith('__cf');
}

/// Decides whether the cookie capture page may navigate to [request].
///
/// The page exists only to pass a Cloudflare challenge on [host], so
/// main-frame navigation is restricted to http(s) requests for that exact
/// host. Everything else—off-site links, redirects, and non-http schemes
/// like intent://, tel: or market://—is phishing or scheme-escape surface
/// and is blocked. Subframes are always allowed, because Cloudflare
/// challenge widgets are embedded in iframes on challenges.cloudflare.com.
bool allowsCookieCaptureNavigation(String host, NavigationRequest request) {
  if (!request.isMainFrame) return true;
  Uri? allowed = Uri.tryParse(normalizeHostUrl(host));
  Uri? target = Uri.tryParse(request.url);
  if (allowed == null || allowed.host.isEmpty || target == null) return false;
  if (!target.isScheme('http') && !target.isScheme('https')) return false;
  return target.host == allowed.host;
}
