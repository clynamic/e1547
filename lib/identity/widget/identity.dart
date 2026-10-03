import 'package:e1547/client/client.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class IdentityPage extends StatelessWidget {
  const IdentityPage({super.key, this.identity});

  final Identity? identity;

  @override
  Widget build(BuildContext context) {
    String defaultHost = context
        .read<ClientFactory>()
        .createDefaultIdentity()
        .host;
    return KeyboardDismisser(
      child: Scaffold(
        appBar: const DefaultAppBar(leading: CloseButton(), elevation: 0),
        body: LimitedWidthLayout.builder(
          maxWidth: 520,
          builder: (context) => Center(
            child: ListView(
              padding: LimitedWidthLayout.of(
                context,
              ).padding.add(defaultActionListPadding),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Text(
                    identity == null
                        ? AppLocalizations.of(context).identityAdd
                        : AppLocalizations.of(context).identityEdit,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AccountForm(
                    identity: identity,
                    initialHost: identity == null ? defaultHost : null,
                    onSubmitted: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
