import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

class DenyListEditor extends StatelessWidget {
  const DenyListEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.read<Client>();
    return TextEditor(
      title: Text(AppLocalizations.of(context).settingsBlacklist),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () =>
              showTagSearchPrompt(context: context, tag: 'e621:blacklist'),
        ),
      ],
      content: client.traits.value.denylist.join('\n'),
      onSubmitted: (value) async {
        // Resolved up front, the context must not cross async gaps.
        final l10n = AppLocalizations.of(context);
        List<String> tags = value.split('\n');
        tags = tags.trim();
        tags.removeWhere((tag) => tag.isEmpty);
        try {
          await client.accounts.push(
            traits: client.traits.value.copyWith(denylist: tags),
          );
        } on ClientException {
          return l10n.blacklistUpdateFailed;
        }
        return null;
      },
      onClosed: Navigator.of(context).maybePop,
    );
  }
}
