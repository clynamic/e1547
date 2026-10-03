/// This file contains global, app-wide default providers.
///
/// They are not meant for usage further down the tree.
/// Using them in such a manner could cause conflicts,
/// because no two controllers should be attached to global singletons.
library;

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/files/files.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/traits/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_sub/flutter_sub.dart';

class IdentityClientProvider
    extends
        SubChangeNotifierProvider3<
          AppStorage,
          Settings,
          ClientFactory,
          IdentityClient
        > {
  IdentityClientProvider({super.child, TransitionBuilder? builder})
    : super(
        create: (context, storage, settings, factory) => IdentityClient(
          database: storage.sqlite,
          onCreate: factory.createDefaultIdentity,
        ),
        builder: (context, child) => Consumer2<IdentityClient, Settings>(
          builder: (context, client, settings, child) => SubListener(
            listenable: client,
            listener: () => settings.identity.value = client.identity.id,
            builder: (context) => SubValue<Future<void>>(
              create: () => client.activate(settings.identity.value),
              keys: [client],
              builder: (context, future) {
                // This layer lives below the app's Localizations scope, so
                // the error text can be resolved up front, before the future
                // completes in a post frame callback.
                final l10n = AppLocalizations.of(context);
                return LoadingLayer(
                  future: future,
                  builder: (context, _) =>
                      builder?.call(context, child) ?? child!,
                  errorToString: (error) => l10n.identityActivateFailed(error),
                );
              },
            ),
          ),
          child: child,
        ),
      );
}

class TraitsClientProvider
    extends
        SubChangeNotifierProvider3<
          AppStorage,
          IdentityClient,
          ClientFactory,
          TraitsClient
        > {
  TraitsClientProvider({super.child, TransitionBuilder? builder})
    : super(
        create: (context, storage, identities, factory) => TraitsClient(
          database: storage.sqlite,
          onCreate: (id) async {
            Identity? identity = await identities.getOrNull(id);
            if (identity == null) return null;
            return factory.createDefaultTraits(identity);
          },
        ),
        builder: (context, child) => Consumer2<TraitsClient, IdentityClient>(
          builder: (context, traits, identities, child) =>
              SubValue<Future<void>>(
                create: () => traits.activate(identities.identity.id),
                keys: [traits, identities, identities.identity],
                builder: (context, future) {
                  // See the identity provider above for why this is safe.
                  final l10n = AppLocalizations.of(context);
                  return LoadingLayer(
                    future: future,
                    builder: (context, _) =>
                        builder?.call(context, child) ?? child!,
                    errorToString: (error) => l10n.traitsActivateFailed(error),
                  );
                },
              ),
          child: child,
        ),
      );
}

class SettingsProvider extends SubProvider<AppStorage, Settings> {
  SettingsProvider({super.child, TransitionBuilder? builder})
    : super(
        create: (context, databases) => Settings(databases.preferences),
        builder: (context, child) =>
            PrivateTextFields(child: builder?.call(context, child) ?? child!),
      );
}

class ClientFactoryProvider extends SubProvider0<ClientFactory> {
  ClientFactoryProvider({super.child, super.builder})
    : super(create: (context) => ClientFactory());
}

class ClientProvider
    extends
        SubProvider4<
          AppStorage,
          IdentityClient,
          TraitsClient,
          ClientFactory,
          Client
        > {
  ClientProvider({super.child, super.builder})
    : super(
        create: (context, storage, identities, traits, factory) =>
            factory.create(
              ClientConfig(
                identity: identities.identity,
                traits: traits.notifier,
                storage: storage,
              ),
            ),
        keys: (context) => [
          context.watch<IdentityClient>().identity,
          context.watch<TraitsClient>(), // notifier is created per identity
          context.watch<AppStorage>().queryCache,
        ],
        dispose: (context, client) => client.dispose(),
      );
}

class FileCacheProvider
    extends SubProvider2<Client, AppStorage, BaseCacheManager> {
  FileCacheProvider({super.child, super.builder})
    : super(
        create: (context, client, storage) =>
            createFileCache(dio: client.dio, database: storage.sqlite),
        dispose: (context, manager) => manager.dispose(),
      );
}

class AppInfoClientProvider extends SubProvider0<AppInfoClient?> {
  AppInfoClientProvider({super.child, super.builder})
    : super(
        create: (context) =>
            AppInfoClient(queryCache: context.read<AppStorage>().queryCache),
      );
}
