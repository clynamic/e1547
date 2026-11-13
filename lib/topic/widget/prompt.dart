import 'package:e1547/client/client.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showTopicPrompt({
  required BuildContext context,
  required Topic topic,
}) => showPrompt<void>(
  context,
  dialogWidth: 800,
  header: (context) => PromptHeader(
    title: Text(
      tagToRaw(topic.title),
      style: Theme.of(context).textTheme.titleLarge,
      softWrap: true,
    ),
    actions: ActionButton(
      icon: const Icon(Icons.share),
      onTap: () async =>
          Share.text(context, context.read<Client>().withHost(topic.link)),
      label: const Text('Share'),
    ),
  ),
  body: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TopicInfo(topic: topic),
      ),
    ],
  ),
);

class TopicInfo extends StatelessWidget {
  const TopicInfo({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    Widget textInfoRow(String label, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      );
    }

    return DefaultTextStyle(
      style: TextStyle(color: dimTextColor(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textInfoRow('replies', topic.responseCount.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('id'),
              InkWell(
                child: Text('#${topic.id}'),
                onLongPress: () async {
                  ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  Clipboard.setData(ClipboardData(text: topic.id.toString()));
                  await Navigator.of(context).maybePop();
                  messenger.showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text('Copied topic id #${topic.id}'),
                    ),
                  );
                },
              ),
            ],
          ),
          textInfoRow('locked', topic.locked ? 'yes' : 'no'),
          textInfoRow(
            'created',
            DateFormatting.dateTime(topic.createdAt.toLocal()),
          ),
          textInfoRow(
            'updated',
            DateFormatting.dateTime(topic.updatedAt.toLocal()),
          ),
        ],
      ),
    );
  }
}
