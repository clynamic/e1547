import 'package:e1547/app/app.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

Future<void> showHistoryPrompt({
  required BuildContext context,
  required History entry,
}) => showPrompt<void>(
  context,
  header: (context) {
    final VoidCallback? onTap = const E621LinkParser().parseOnTap(
      context,
      entry.link,
    );
    return Padding(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap != null
            ? () {
                if (popDialog(context)) {
                  onTap();
                }
              }
            : null,
        child: Text(
          entry.getName(context),
          style: Theme.of(context).textTheme.titleLarge,
          softWrap: true,
        ),
      ),
    );
  },
  body: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: entry.subtitle != null
        ? DText(entry.subtitle!)
        : Center(
            child: Text(
              AppLocalizations.of(context).historyNoDescription,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: dimTextColor(context),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
  ),
);
