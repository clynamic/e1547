import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class SiteFavicon extends StatelessWidget {
  const SiteFavicon({super.key, required this.url, this.size = 20});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String? host = getFaviconHost(url);
    if (host == null) {
      return Icon(Icons.public, size: size, color: dimTextColor(context));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppStyle.of(context).smallRadius),
      child: Image.asset(
        'assets/icon/favicons/$host.png',
        width: size,
        height: size,
      ),
    );
  }
}
