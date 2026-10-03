import 'dart:io';

import 'package:e1547/account/account.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

class HostUnavailablePage extends StatelessWidget {
  const HostUnavailablePage({super.key, this.offerResolve = false});

  final bool offerResolve;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(child: AppBar(leading: const CloseButton())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 60),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).hostUnavailableTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).hostUnavailableBody(
                  linkToDisplay(context.watch<Client>().host),
                ),
              ),
              const SizedBox(height: 16),
              if (offerResolve && (Platform.isAndroid || Platform.isIOS)) ...[
                Text(AppLocalizations.of(context).hostUnavailableResolveHint),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const CookieCapturePage(),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context).hostUnavailableResolve,
                  ),
                ),
              ] else
                Dimmed(
                  child: Text(
                    AppLocalizations.of(context).hostUnavailableWaitBody(
                      linkToDisplay(context.watch<Client>().host),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
