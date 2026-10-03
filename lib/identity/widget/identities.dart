import 'package:e1547/app/app.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class IdentitiesPage extends StatelessWidget {
  const IdentitiesPage({super.key});

  Widget tile(BuildContext context, Identity identity) {
    bool selected = context.watch<IdentityClient>().identity == identity;
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.primary : null,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: ListTile(
            leading: IdentityAvatar(identity.id),
            title: Text(identity.username ?? l10n.identityAnonymous),
            onTap: () {
              if (popDialog(context)) {
                context.read<IdentityClient>().activate(identity.id);
              }
            },
            trailing: PopupMenuButton<VoidCallback>(
              icon: const Dimmed(child: Icon(Icons.more_vert)),
              onSelected: (value) => value(),
              itemBuilder: (context) => [
                PopupMenuTile(
                  title: l10n.menuEdit,
                  icon: Icons.edit,
                  value: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => IdentityPage(identity: identity),
                    ),
                  ),
                ),
                PopupMenuTile(
                  title: l10n.actionRemove,
                  icon: Icons.delete,
                  value: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.identityRemoveTitle),
                      content: Text(l10n.identityRemoveBody),
                      actions: [
                        TextButton(
                          onPressed: () => popDialog(context),
                          child: Text(l10n.actionCancel),
                        ),
                        ElevatedButton(
                          child: Text(l10n.actionRemove),
                          onPressed: () {
                            if (popDialog(context)) {
                              final storage = context.read<AppStorage>();
                              context.read<IdentityClient>().remove(identity);
                              removeIdentityQueries(
                                cache: storage.queryCache,
                                database: storage.sqlite,
                                identity: identity.id,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget form(BuildContext context, List<Identity> identities) {
    Map<String, List<Identity>> groups = {};
    for (final identity in identities) {
      groups.putIfAbsent(identity.host, () => []).add(identity);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            AppLocalizations.of(context).identityAccounts,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        for (final MapEntry(key: host, value: group) in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: Text(
              linkToDisplay(host),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          for (final identity in group) tile(context, identity),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubStream(
      create: () => context.watch<IdentityClient>().all().stream,
      builder: (context, snapshot) => LimitedWidthLayout.builder(
        builder: (context) {
          List<Identity>? identities = snapshot.data;
          return Scaffold(
            appBar: const TransparentAppBar(
              child: DefaultAppBar(leading: CloseButton()),
            ),
            floatingActionButton: identities != null
                ? FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const IdentityPage(),
                      ),
                    ),
                  )
                : null,
            body: LimitedWidthLayout.builder(
              maxWidth: 520,
              builder: (context) => Center(
                child: ListView(
                  padding: LimitedWidthLayout.of(
                    context,
                  ).padding.add(defaultActionListPadding),
                  shrinkWrap: true,
                  children: [
                    if (identities == null)
                      const Center(child: CircularProgressIndicator())
                    else if (snapshot.hasError)
                      IconMessage(
                        icon: const Icon(Icons.warning_amber),
                        title: Text(
                          AppLocalizations.of(context).failedToLoadIdentities,
                        ),
                      )
                    else
                      form(context, identities),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
