import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReplyTile extends StatelessWidget {
  const ReplyTile({super.key, required this.reply, this.hasActions = true});

  final Reply reply;
  final bool hasActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Hero(
            tag: reply.hero,
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8, top: 4),
                    child: Icon(Icons.person),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReplyHeader(reply: reply),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Expanded(child: DText(reply.body))],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            flightShuttleBuilder:
                (
                  flightContext,
                  animation,
                  flightDirection,
                  fromHeroContext,
                  toHeroContext,
                ) => Material(
                  type: MaterialType.transparency,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: switch (flightDirection) {
                      HeroFlightDirection.push => fromHeroContext.widget,
                      HeroFlightDirection.pop => toHeroContext.widget,
                    },
                  ),
                ),
          ),
          if (hasActions)
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [ReplyMenu(reply: reply)],
              ),
            ),
          ReplyWarning(reply: reply),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}

class ReplyHeader extends StatelessWidget {
  const ReplyHeader({super.key, required this.reply});

  final Reply reply;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dimmed(
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            child: TimedText(
              created: reply.createdAt,
              updated: reply.updatedAt,
              child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        reply.creator,
                        style: TextStyle(color: dimTextColor(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserLoadingPage(reply.creatorId),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        ReplyVisibilityIndicator(reply: reply),
      ],
    );
  }
}

class ReplyVisibilityIndicator extends StatelessWidget {
  const ReplyVisibilityIndicator({super.key, required this.reply});

  final Reply reply;

  @override
  Widget build(BuildContext context) {
    if (!reply.hidden) return const SizedBox();
    return Tooltip(
      message: AppLocalizations.of(context).replyHidden,
      child: Icon(
        Icons.visibility_off,
        size: smallIconSize(context),
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class ReplyMenu extends StatelessWidget {
  const ReplyMenu({super.key, required this.reply});

  final Reply reply;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<VoidCallback>(
      icon: const Dimmed(child: Icon(Icons.more_vert)),
      onSelected: (value) => value(),
      itemBuilder: (context) => [
        if (client.identity.username == reply.creator)
          PopupMenuTile(
            title: l10n.menuEdit,
            icon: Icons.edit,
            value: () => guardWithLogin(
              context: context,
              callback: () => editReply(context: context, reply: reply),
              error: l10n.replyLoginRequiredEdit,
            ),
          ),
        PopupMenuTile(
          title: l10n.menuReply,
          icon: Icons.reply,
          value: () => guardWithLogin(
            context: context,
            callback: () => quoteReply(context: context, reply: reply),
            error: l10n.replyLoginRequiredReply,
          ),
        ),
        PopupMenuTile(
          title: l10n.menuCopyId,
          icon: Icons.tag,
          value: () async {
            Clipboard.setData(ClipboardData(text: reply.id.toString()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(l10n.replyCopiedId(reply.id)),
              ),
            );
          },
        ),
        PopupMenuTile(
          title: l10n.menuReport,
          icon: Icons.report,
          value: () => guardWithLogin(
            context: context,
            callback: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReplyReportScreen(reply: reply),
              ),
            ),
            error: l10n.replyLoginRequiredReport,
          ),
        ),
      ],
    );
  }
}

class ReplyWarning extends StatelessWidget {
  const ReplyWarning({super.key, required this.reply});

  final Reply reply;

  @override
  Widget build(BuildContext context) {
    WarningType? warning = reply.warning;
    if (warning == null) return const SizedBox();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.warning_amber,
            size: smallIconSize(context),
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        Text(
          switch (warning) {
            WarningType.warning => AppLocalizations.of(
              context,
            ).warningUserWarned,
            WarningType.record => AppLocalizations.of(
              context,
            ).warningUserRecorded,
            WarningType.ban => AppLocalizations.of(context).warningUserBanned,
          },
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
