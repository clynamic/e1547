import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/flag/flag.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

List<PopupMenuItem<VoidCallback>> postMenuPostActions(
  BuildContext context,
  Post post,
) {
  return [
    PopupMenuTile(
      value: () async =>
          Share.text(context, context.read<Client>().withHost(post.link)),
      title: 'Share',
      icon: Icons.share,
    ),
    if (post.file != null)
      PopupMenuTile(
        value: () => postDownloadingNotification(context, {post}),
        title: 'Download',
        icon: Icons.file_download,
      ),
    postBrowseAction(context, post),
  ];
}

PopupMenuItem<VoidCallback> postBrowseAction(BuildContext context, Post post) =>
    PopupMenuTile(
      value: () async => launch(context.read<Client>().withHost(post.link)),
      title: 'Browse',
      icon: Icons.open_in_browser,
    );

List<PopupMenuItem<VoidCallback>> postMenuUserActions(
  BuildContext context,
  Post post,
) {
  final cacheSize = context.read<ImageCacheSize?>()?.size;
  return [
    PopupMenuTile(
      title: 'Edit',
      icon: Icons.edit,
      value: () => guardWithLogin(
        context: context,
        callback: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageCacheSizeProvider(
              size: cacheSize,
              child: PostEditPage(post: post),
            ),
          ),
        ),
        error: 'You must be logged in to edit posts!',
      ),
    ),
    PopupMenuTile(
      title: 'Report',
      icon: Icons.report,
      value: () => guardWithLogin(
        context: context,
        callback: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostReportScreen(post: post)),
        ),
        error: 'You must be logged in to report posts!',
      ),
    ),
    PopupMenuTile(
      title: 'Flag',
      icon: Icons.flag,
      value: () => guardWithLogin(
        context: context,
        callback: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostFlagScreen(post: post)),
        ),
        error: 'You must be logged in to flag posts!',
      ),
    ),
  ];
}
