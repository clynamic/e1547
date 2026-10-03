import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/flag/flag.dart';
import 'package:e1547/l10n/app_localizations.dart';
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
      title: AppLocalizations.of(context).menuShare,
      icon: Icons.share,
    ),
    if (post.file != null)
      PopupMenuTile(
        value: () => postDownloadingNotification(context, {post}),
        title: AppLocalizations.of(context).menuDownload,
        icon: Icons.file_download,
      ),
    PopupMenuTile(
      value: () async => launch(context.read<Client>().withHost(post.link)),
      title: AppLocalizations.of(context).menuBrowse,
      icon: Icons.open_in_browser,
    ),
  ];
}

List<PopupMenuItem<VoidCallback>> postMenuUserActions(
  BuildContext context,
  Post post,
) {
  final cacheSize = context.read<ImageCacheSize?>()?.size;
  return [
    PopupMenuTile(
      title: AppLocalizations.of(context).menuEdit,
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
        error: AppLocalizations.of(context).loginRequiredEdit,
      ),
    ),
    PopupMenuTile(
      title: AppLocalizations.of(context).menuComment,
      icon: Icons.comment,
      value: () => guardWithLogin(
        context: context,
        callback: () => writeComment(context: context, postId: post.id),
        error: AppLocalizations.of(context).loginRequiredComment,
      ),
    ),
    PopupMenuTile(
      title: AppLocalizations.of(context).menuReport,
      icon: Icons.report,
      value: () => guardWithLogin(
        context: context,
        callback: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostReportScreen(post: post)),
        ),
        error: AppLocalizations.of(context).loginRequiredReport,
      ),
    ),
    PopupMenuTile(
      title: AppLocalizations.of(context).menuFlag,
      icon: Icons.flag,
      value: () => guardWithLogin(
        context: context,
        callback: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PostFlagScreen(post: post)),
        ),
        error: AppLocalizations.of(context).loginRequiredFlag,
      ),
    ),
  ];
}
