import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

typedef LinkCallback = FutureOr<void> Function(Uri? url);

class AppLinkHandler extends StatefulWidget {
  const AppLinkHandler({super.key, required this.child});

  final Widget child;

  @override
  State<AppLinkHandler> createState() => _AppLinkHandlerState();
}

class _AppLinkHandlerState extends State<AppLinkHandler> {
  late AppLinks appLinks;
  StreamSubscription<Uri>? linkListener;

  Future<void> onLink(Uri? url) async {
    if (url == null) return;
    final String link = url.toString();
    if (const E621LinkParser().parse(link) == null) {
      await launch(link);
      return;
    }
    final NavigatorState? navigator = await context
        .read<ShellController>()
        .reset(ShellTab.browse);
    if (navigator == null || !navigator.mounted) return;
    if (!const E621LinkParser().open(navigator.context, link)) {
      await launch(link);
    }
  }

  @override
  void initState() {
    super.initState();
    if (PlatformCapabilities.hasDeepLinks) {
      appLinks = AppLinks();
      appLinks.getInitialLink().then(onLink);
      linkListener = appLinks.uriLinkStream.listen(onLink);
    }
  }

  @override
  void dispose() {
    linkListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
