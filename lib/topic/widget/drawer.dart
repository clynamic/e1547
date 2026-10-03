import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';

class TopicListDrawer extends StatelessWidget {
  const TopicListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TopicFilter>();
    return ContextDrawer(
      title: Text(AppLocalizations.of(context).topicsTitle),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.sell),
          title: Text(AppLocalizations.of(context).topicHideTagEdits),
          subtitle: Text(
            controller.value.hideTagEditing
                ? AppLocalizations.of(context).topicTagEditsHidden
                : AppLocalizations.of(context).topicTagEditsVisible,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          value: controller.value.hideTagEditing,
          onChanged: (value) {
            controller.value = (hideTagEditing: value);
            Scaffold.of(context).closeEndDrawer();
          },
        ),
      ],
    );
  }
}
