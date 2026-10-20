import 'package:e1547/client/client.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/reply/reply.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

Future<bool> quoteReply({required BuildContext context, required Reply reply}) {
  String body = reply.body;
  body = body
      .replaceFirstMapped(
        RegExp(
          r'\[quote\]"[\S\s]*?":/user(s|/show)/\d* said:[\S\s]*?\[/quote\]',
        ),
        (match) => '',
      )
      .trim();
  body =
      '[quote]"${reply.creator}":/users/${reply.creatorId} said:\n$body[/quote]\n';
  return writeReply(context: context, topicId: reply.topicId, text: body);
}

Future<bool> editReply({required BuildContext context, required Reply reply}) =>
    writeReply(context: context, topicId: reply.topicId, reply: reply);

Future<bool> writeReply({
  required BuildContext context,
  required int topicId,
  String? text,
  Reply? reply,
}) async {
  bool sent = false;
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DTextEditor(
        title: Text(tf('#{id} reply', params: {'id': topicId})),
        content: text ?? (reply?.body),
        onSubmitted: (text) async {
          final messenger = ScaffoldMessenger.of(context);
          final client = context.read<Client>();
          if (text.isNotEmpty) {
            try {
              if (reply == null) {
                await client.replies.useCreate(topicId: topicId).mutate(text);
              } else {
                await client.replies.useUpdate(id: reply.id).mutate(text);
              }
            } on ClientException {
              return t('Failed to send reply!');
            }
            sent = true;
            messenger.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(t('Reply sent!')),
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

extension Transitioning on Reply {
  String get hero => 'reply_$id';
}
