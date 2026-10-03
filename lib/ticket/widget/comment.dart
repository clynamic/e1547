import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';

class CommentReportScreen extends StatelessWidget {
  const CommentReportScreen({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ReasonReportScreen(
      title: Text(l10n.commentTitle(comment.id)),
      onReport: (reason) => validateCall(
        () => context.read<Client>().tickets.create(
          type: TicketType.comment,
          item: comment.id,
          reason: reason,
        ),
      ),
      onSuccess: l10n.reportCommentSuccess(comment.id),
      onFailure: l10n.reportCommentFailed(comment.id),
      previewBuilder: (context, isLoading) => Card(
        clipBehavior: Clip.antiAlias,
        child: ReportLoadingOverlay(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CommentTile(comment: comment, hasActions: false),
          ),
        ),
      ),
    );
  }
}
