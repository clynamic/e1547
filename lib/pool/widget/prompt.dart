import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/pool/pool.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/material.dart';

Future<void> showPoolPrompt({
  required BuildContext context,
  required Pool pool,
}) => showPrompt<void>(
  context,
  dialogWidth: 800,
  pinnedHeader: true,
  header: (context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: OverflowBar(
      alignment: MainAxisAlignment.spaceBetween,
      overflowSpacing: 8,
      children: [
        Text(
          tagToName(pool.name),
          style: Theme.of(context).textTheme.titleLarge,
          softWrap: true,
        ),
        PoolActions(pool: pool),
      ],
    ),
  ),
  body: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Divider(indent: 4, endIndent: 4),
      Padding(
        padding: const EdgeInsets.all(16),
        child: pool.description.isNotEmpty
            ? DText(pool.description)
            : Text(
                AppLocalizations.of(context).historyNoDescription,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
      ),
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: PoolInfo(pool: pool),
      ),
    ],
  ),
);

class PoolActions extends StatelessWidget {
  const PoolActions({super.key, required this.pool});

  final Pool pool;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActionButton(
            icon: const Icon(Icons.share),
            label: Text(AppLocalizations.of(context).menuShare),
            onTap: () async =>
                Share.text(context, context.read<Client>().withHost(pool.link)),
          ),
          TagListActions(tag: 'pool:${pool.id}'),
        ],
      ),
    );
  }
}
