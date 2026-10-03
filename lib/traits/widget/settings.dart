import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';

class DenyListPage extends StatelessWidget {
  const DenyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildEditTextField(
      BuildContext context, {
      required String title,
      required SubmitString submit,
      String? value,
    }) => Material(
      child: ControlledTextWrapper(
        textController: TextEditingController(text: value),
        submit: submit,
        builder: (context, controller, submit) => TagInput(
          controller: controller,
          decoration: const InputDecoration(suffix: PromptTextFieldSuffix()),
          textInputAction: TextInputAction.done,
          direction: VerticalDirection.up,
          labelText: title,
          submit: submit,
          readOnly: PromptActions.of(context).isLoading,
        ),
      ),
    );

    return PromptActions(
      child: LimitedWidthLayout(
        child: Consumer<Client>(
          builder: (context, client, child) => ValueListenableBuilder(
            valueListenable: client.traits,
            builder: (context, traits, child) {
              List<String> denylist = traits.denylist.toList();
              return AdaptiveScaffold(
                appBar: DefaultAppBar(
                  title: Text(AppLocalizations.of(context).settingsBlacklist),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DenyListEditor(),
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: PromptFab(
                  builder: (context) => buildEditTextField(
                    context,
                    title: AppLocalizations.of(context).blacklistAddTag,
                    submit: (value) async {
                      // Resolved up front, the context must not cross async
                      // gaps.
                      final l10n = AppLocalizations.of(context);
                      value = value.trim();
                      if (value.isEmpty) return;
                      try {
                        await client.accounts.push(
                          traits: traits.copyWith(
                            denylist: denylist..add(value),
                          ),
                        );
                      } on ClientException {
                        throw ActionControllerException(
                          message: l10n.blacklistUpdateFailed,
                        );
                      }
                    },
                  ),
                  icon: const Icon(Icons.add),
                ),
                body: PullToRefresh(
                  onRefresh: () async {
                    await client.accounts.pull();
                  },
                  child: denylist.isEmpty
                      ? Center(
                          child: IconMessage(
                            icon: const Icon(Icons.check),
                            title: Text(
                              AppLocalizations.of(context).blacklistEmpty,
                            ),
                          ),
                        )
                      : ListView.builder(
                          primary: true,
                          padding: defaultActionListPadding.add(
                            LimitedWidthLayout.of(context).padding,
                          ),
                          itemCount: denylist.length,
                          itemBuilder: (context, index) => DenylistTile(
                            tag: denylist[index],
                            onEdit: () {
                              String tag = denylist[index];
                              PromptActions.of(context).show(
                                context,
                                buildEditTextField(
                                  context,
                                  value: tag,
                                  title: AppLocalizations.of(
                                    context,
                                  ).blacklistEditTag,
                                  submit: (value) async {
                                    // Resolved up front, the context must not
                                    // cross async gaps.
                                    final l10n = AppLocalizations.of(context);
                                    value = value.trim();
                                    try {
                                      if (value.isEmpty) {
                                        await client.accounts.push(
                                          traits: traits.copyWith(
                                            denylist: List.of(denylist)
                                              ..remove(tag),
                                          ),
                                        );
                                      } else {
                                        await client.accounts.push(
                                          traits: traits.copyWith(
                                            denylist: List.of(denylist)
                                              ..[denylist.indexOf(tag)] = value,
                                          ),
                                        );
                                      }
                                    } on ClientException {
                                      throw ActionControllerException(
                                        message: l10n.blacklistUpdateFailed,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                            onDelete: () {
                              final l10n = AppLocalizations.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              final tag = denylist[index];
                              final position = index;
                              final remaining = List.of(denylist)
                                ..removeAt(position);
                              client.accounts
                                  .push(
                                    traits: traits.copyWith(
                                      denylist: remaining,
                                    ),
                                  )
                                  .then((_) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.denylistEntryDeleted,
                                        ),
                                        action: SnackBarAction(
                                          label: l10n.actionUndo,
                                          onPressed: () {
                                            // Read the current traits:
                                            // other deletions since this
                                            // snackbar was shown must not be
                                            // rolled back.
                                            final current = client.traits.value;
                                            if (current.denylist.contains(
                                              tag,
                                            )) {
                                              return;
                                            }
                                            client.accounts.push(
                                              traits: current.copyWith(
                                                denylist:
                                                    List.of(
                                                      current.denylist,
                                                    )..insert(
                                                      position.clamp(
                                                        0,
                                                        current.denylist.length,
                                                      ),
                                                      tag,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
