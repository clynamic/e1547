import 'package:e1547/client/client.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

const double postToolbarClearance = 100;
const double postToolbarFadeHeight = 64;

class PostToolbar extends StatelessWidget {
  const PostToolbar({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool left = Handedness.of(context) == Handedness.left;
    final BoxDecoration raised = BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x8C000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
    Widget action(IconData icon, String tooltip, VoidCallback? onPressed) =>
        SizedBox.square(
          dimension: 48,
          child: IconButton(
            tooltip: tooltip,
            icon: Icon(icon),
            onPressed: onPressed,
          ),
        );
    final List<Widget> actions = [
      action(Icons.comment, 'Comments', () => openPostComments(context, post)),
      action(
        Icons.share,
        'Share',
        () => Share.text(context, context.read<Client>().withHost(post.link)),
      ),
      if (post.file != null)
        action(
          Icons.file_download,
          'Download',
          () => postDownloadingNotification(context, {post}),
        ),
      PopupMenuButton<VoidCallback>(
        tooltip: 'More',
        position: PopupMenuPosition.over,
        useRootNavigator: true,
        icon: const Icon(Icons.more_horiz),
        onSelected: (value) => value(),
        itemBuilder: (context) => [
          ...postMenuUserActions(context, post),
          postBrowseAction(context, post),
        ],
      ),
    ];
    final List<Widget> row = [
      DecoratedBox(
        decoration: raised,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: left ? actions : actions.reversed.toList(),
            ),
          ),
        ),
      ),
      if (context.read<Client>().hasLogin)
        Padding(
          padding: EdgeInsets.only(left: left ? 0 : 12, right: left ? 12 : 0),
          child: DecoratedBox(
            decoration: raised,
            child: SizedBox.square(
              dimension: 56,
              child: Center(
                child: IconTheme.merge(
                  data: const IconThemeData(color: Colors.pinkAccent),
                  child: FavoriteButton(post: post, size: 24),
                ),
              ),
            ),
          ),
        ),
    ];
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Row(
        mainAxisAlignment: left
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: left ? row.reversed.toList() : row,
      ),
    );
  }
}
