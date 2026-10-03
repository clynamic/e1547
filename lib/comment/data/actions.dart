import 'package:e1547/client/client.dart';
import 'package:e1547/comment/comment.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

Future<bool> replyComment({
  required BuildContext context,
  required Comment comment,
}) {
  String body = comment.body;
  body = body
      .replaceFirstMapped(
        RegExp(
          r'\[quote\]"[\S\s]*?":/user(s|/show)/\d* said:[\S\s]*?\[/quote\]',
        ),
        (match) => '',
      )
      .trim();
  body =
      '[quote]"${comment.creatorName}":/users/${comment.creatorId} said:\n$body[/quote]\n';
  return writeComment(context: context, postId: comment.postId, text: body);
}

Future<bool> editComment({
  required BuildContext context,
  required Comment comment,
}) => writeComment(postId: comment.postId, context: context, comment: comment);

Future<bool> writeComment({
  required BuildContext context,
  required int postId,
  String? text,
  Comment? comment,
}) async {
  final l10n = AppLocalizations.of(context);
  bool sent = false;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DTextEditor(
        title: Text(l10n.commentEditorTitle(postId)),
        content: text ?? (comment?.body),
        onSubmitted: (text) async {
          final messenger = ScaffoldMessenger.of(context);
          final client = context.read<Client>();
          if (text.isNotEmpty) {
            try {
              if (comment == null) {
                await client.comments.useCreate(postId: postId).mutate(text);
              } else {
                await client.comments
                    .useUpdate(id: comment.id, postId: postId)
                    .mutate(text);
              }
            } on ClientException {
              return l10n.commentSendFailed;
            }
            sent = true;
            messenger.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(l10n.commentSent),
              ),
            );
          }
          return null;
        },
        onClosed: Navigator.of(context).maybePop,
      ),
    ),
  );
  return sent;
}

extension Transitioning on Comment {
  String get hero => getCommentHero(id);
}

String getCommentHero(int id) => 'comment_$id';
