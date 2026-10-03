import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment, this.hasActions = true});

  final Comment comment;
  final bool hasActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Hero(
            tag: comment.hero,
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
                      CommentHeader(comment: comment),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Expanded(child: DText(comment.body))],
                      ),
                    ],
                  ),
                ),
              ],
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
                children: [
                  CommentVotes(comment: comment),
                  const Spacer(),
                  CommentMenu(comment: comment),
                ],
              ),
            ),
          CommentWarnings(comment: comment),
          const Divider(),
        ],
      ),
    );
  }
}

class CommentHeader extends StatelessWidget {
  const CommentHeader({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dimmed(
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserLoadingPage(comment.creatorId),
              ),
            ),
            child: TimedText(
              created: comment.createdAt,
              updated: comment.updatedAt,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: Text(comment.creatorName))],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        CommentVisibilityIndicator(comment: comment),
      ],
    );
  }
}

class CommentVotes extends StatelessWidget {
  const CommentVotes({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    return MutationBuilder(
      mutation: client.comments.useVote(id: comment.id),
      builder: (context, state, mutate) {
        final bool enabled = client.hasLogin || state.isLoading;
        return Dimmed(
          child: VoteDisplay(
            padding: EdgeInsets.zero,
            score: comment.score,
            vote: comment.vote,
            onUpvote: enabled
                ? (isLiked) async {
                    mutate((upvote: true, replace: !isLiked)).catchError((
                      error,
                    ) {
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(l10n.commentUpvoteFailed(comment.id)),
                        ),
                      );
                      return error;
                    });
                    return !isLiked;
                  }
                : null,
            onDownvote: enabled
                ? (isLiked) async {
                    mutate((upvote: false, replace: !isLiked)).catchError((
                      error,
                    ) {
                      messenger.showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(l10n.commentDownvoteFailed(comment.id)),
                        ),
                      );
                      return error;
                    });
                    return !isLiked;
                  }
                : null,
          ),
        );
      },
    );
  }
}

class CommentVisibilityIndicator extends StatelessWidget {
  const CommentVisibilityIndicator({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    if (!comment.hidden) return const SizedBox();
    return Tooltip(
      message: AppLocalizations.of(context).commentHidden,
      child: Icon(
        Icons.visibility_off,
        size: smallIconSize(context),
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class CommentMenu extends StatelessWidget {
  const CommentMenu({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<VoidCallback>(
      icon: const Dimmed(child: Icon(Icons.more_vert)),
      onSelected: (value) => value(),
      itemBuilder: (context) => [
        if (client.identity.username == comment.creatorName)
          PopupMenuTile(
            title: l10n.menuEdit,
            icon: Icons.edit,
            value: () => guardWithLogin(
              context: context,
              callback: () => editComment(context: context, comment: comment),
              error: l10n.commentLoginRequiredEdit,
            ),
          ),
        PopupMenuTile(
          title: l10n.menuReply,
          icon: Icons.reply,
          value: () => guardWithLogin(
            context: context,
            callback: () => replyComment(context: context, comment: comment),
            error: l10n.commentLoginRequiredReply,
          ),
        ),
        PopupMenuTile(
          title: l10n.menuCopyId,
          icon: Icons.tag,
          value: () async {
            Clipboard.setData(ClipboardData(text: comment.id.toString()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(l10n.commentCopiedId(comment.id)),
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
                builder: (context) => CommentReportScreen(comment: comment),
              ),
            ),
            error: l10n.commentLoginRequiredReport,
          ),
        ),
      ],
    );
  }
}

class CommentWarnings extends StatelessWidget {
  const CommentWarnings({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    WarningType? warning = comment.warning;
    if (warning == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Row(
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
      ),
    );
  }
}
