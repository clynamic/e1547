import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) => Scaffold(
        appBar: DefaultAppBar(
          title: Text(AppLocalizations.of(context).settingsTitle),
        ),
        body: LimitedWidthLayout.builder(
          builder: (context) => ListView(
            primary: true,
            padding: defaultActionListPadding.add(
              LimitedWidthLayout.of(context).padding,
            ),
            children: [
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionAccount,
              ),
              Consumer<IdentityClient>(
                builder: (context, client, child) => IdentityTile(
                  identity: client.identity,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdentitiesPage(),
                    ),
                  ),
                  trailing: const Icon(Icons.swap_horiz),
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionUser,
              ),
              Consumer<Client>(
                builder: (context, client, child) => ValueListenableBuilder(
                  valueListenable: client.traits,
                  builder: (context, traits, child) => ListTile(
                    title: Text(AppLocalizations.of(context).settingsBlacklist),
                    leading: const Icon(Icons.block),
                    subtitle: traits.denylist.isNotEmpty
                        ? Text(
                            AppLocalizations.of(context).tagsBlocked(
                              traits.denylist
                                  .join(' ')
                                  .split(' ')
                                  .trim()
                                  .where((e) => e[0] != '-')
                                  .length,
                            ),
                          )
                        : null,
                    onTap: () => Navigator.pushNamed(context, '/blacklist'),
                  ),
                ),
              ),
              Consumer<Client>(
                builder: (context, client, child) => SubStream<int>(
                  create: () => client.follows.count().streamed,
                  keys: [client],
                  builder: (context, snapshot) => ListTile(
                    title: Text(AppLocalizations.of(context).settingsFollows),
                    subtitle: snapshot.data != null && snapshot.data != 0
                        ? Text(
                            AppLocalizations.of(
                              context,
                            ).searchesFollowed(snapshot.data!),
                          )
                        : null,
                    leading: const Icon(Icons.person_add),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FollowEditor(),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<Client>(
                builder: (context, client, child) => SubStream<int>(
                  create: () => client.histories.count().streamed,
                  keys: [client],
                  builder: (context, countSnapshot) {
                    int? count = countSnapshot.data;
                    return ValueListenableBuilder(
                      valueListenable: client.traits,
                      builder: (context, traits, child) {
                        bool enabled = traits.writeHistory ?? true;
                        return DividerListTile(
                          title: Text(
                            AppLocalizations.of(context).settingsHistory,
                          ),
                          subtitle: enabled && count != null
                              ? Text(
                                  AppLocalizations.of(
                                    context,
                                  ).pagesVisited(count),
                                )
                              : null,
                          leading: const Icon(Icons.history),
                          onTap: () => Navigator.pushNamed(context, '/history'),
                          onTapSeparated: () => client.traits.value = client
                              .traits
                              .value
                              .copyWith(writeHistory: !enabled),
                          separated: Switch(
                            value: enabled,
                            onChanged: (value) => client.traits.value = client
                                .traits
                                .value
                                .copyWith(writeHistory: value),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionAppearance,
              ),
              ValueListenableBuilder<AppTheme>(
                valueListenable: settings.theme,
                builder: (context, value, child) => ListTile(
                  title: Text(AppLocalizations.of(context).settingsTheme),
                  subtitle: Text(localizedThemeName(context, value)),
                  leading: const Icon(Icons.brightness_6),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(AppLocalizations.of(context).settingsTheme),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppTheme.values
                                .map(
                                  (theme) => ListTile(
                                    title: Text(
                                      localizedThemeName(context, theme),
                                    ),
                                    trailing: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: theme.swatch.copyWith(
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color!,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      if (popDialog(context)) {
                                        settings.theme.value = theme;
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<String?>(
                valueListenable: settings.language,
                builder: (context, value, child) => ListTile(
                  title: Text(AppLocalizations.of(context).settingsLanguage),
                  subtitle: Text(
                    value == null
                        ? AppLocalizations.of(context).languageSystemDefault
                        : appLanguages
                                  .firstWhereOrNull((e) => e.value == value)
                                  ?.label ??
                              value,
                  ),
                  leading: const Icon(Icons.translate),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(
                          AppLocalizations.of(context).settingsLanguage,
                        ),
                        children: [
                          ListTile(
                            title: Text(
                              AppLocalizations.of(
                                context,
                              ).languageSystemDefault,
                            ),
                            trailing: value == null
                                ? const Icon(Icons.check)
                                : null,
                            onTap: () {
                              if (popDialog(context)) {
                                settings.language.value = null;
                              }
                            },
                          ),
                          ...appLanguages.map(
                            (language) => ListTile(
                              title: Text(language.label),
                              trailing: value == language.value
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () {
                                if (popDialog(context)) {
                                  settings.language.value = language.value;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: settings.tileSize,
                    builder: (context, value, child) => ListTile(
                      title: Text(
                        AppLocalizations.of(context).settingsTileSize,
                      ),
                      subtitle: Text(value.toString()),
                      leading: const Icon(Icons.crop),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => RangeDialog(
                          title: Text(
                            AppLocalizations.of(context).settingsTileSize,
                          ),
                          value: NumberRange(value),
                          initialMode: RangeDialogMode.exact,
                          enforceMax: false,
                          canChangeMode: false,
                          division: (300 / 50).round(),
                          min: 100,
                          max: 400,
                          onSubmit: (value) {
                            if (value == null || value.value <= 0) {
                              return;
                            }
                            settings.tileSize.value = value.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<GridQuilt>(
                    valueListenable: settings.quilt,
                    builder: (context, value, child) => GridSettingsTile(
                      state: value,
                      onChange: (value) => settings.quilt.value = value,
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.showPostInfo,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(AppLocalizations.of(context).settingsPostInfo),
                  subtitle: Text(
                    value
                        ? AppLocalizations.of(context).postInfoShown
                        : AppLocalizations.of(context).postInfoHidden,
                  ),
                  secondary: const Icon(Icons.subtitles),
                  value: value,
                  onChanged: (value) => settings.showPostInfo.value = value,
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionInteractions,
              ),
              if (!Platform.isIOS)
                ValueListenableBuilder<String?>(
                  valueListenable: settings.downloadPath,
                  builder: (context, value, child) => ListTile(
                    title: Text(
                      AppLocalizations.of(context).settingsDownloadLocation,
                    ),
                    subtitle: value != null
                        ? Text(Uri.decodeComponent(Uri.parse(value).path))
                        : null,
                    leading: const Icon(Icons.folder),
                    onTap: () async {
                      String? result = await FileDownloader.pickDirectory(
                        initial: value,
                      );
                      if (result != null) {
                        unawaited(FileDownloader.forgetDirectory(value));
                        settings.downloadPath.value = result;
                      }
                    },
                  ),
                ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.upvoteFavs,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context).settingsUpvoteFavorites,
                  ),
                  subtitle: Text(
                    value
                        ? AppLocalizations.of(context).upvoteFavoritesOn
                        : AppLocalizations.of(context).upvoteFavoritesOff,
                  ),
                  secondary: const Icon(Icons.arrow_upward),
                  value: value,
                  onChanged: (value) => settings.upvoteFavs.value = value,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.muteVideos,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(AppLocalizations.of(context).settingsVideoVolume),
                  subtitle: Text(
                    value
                        ? AppLocalizations.of(context).videoMuted
                        : AppLocalizations.of(context).videoWithSound,
                  ),
                  secondary: Icon(value ? Icons.volume_off : Icons.volume_up),
                  value: value,
                  onChanged: (value) => settings.muteVideos.value = value,
                ),
              ),
              ValueListenableBuilder<VideoResolution>(
                valueListenable: settings.videoResolution,
                builder: (context, value, child) => ListTile(
                  title: Text(
                    AppLocalizations.of(context).settingsVideoResolution,
                  ),
                  subtitle: Text(value.localizedTitle(context)),
                  leading: const Icon(Icons.video_settings),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(
                        AppLocalizations.of(context).settingsVideoResolution,
                      ),
                      children: VideoResolution.values
                          .map(
                            (resolution) => ListTile(
                              title: Text(resolution.localizedTitle(context)),
                              onTap: () {
                                if (popDialog(context)) {
                                  settings.videoResolution.value = resolution;
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionSecurity,
              ),
              if (PlatformCapabilities.hasSecureDisplay)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.secureDisplay,
                  builder: (context, value, child) => SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context).settingsSecureDisplay,
                    ),
                    subtitle: Text(
                      value
                          ? AppLocalizations.of(context).secureDisplayOn
                          : AppLocalizations.of(context).secureDisplayOff,
                    ),
                    secondary: const Icon(Icons.stop_screen_share_outlined),
                    value: value,
                    onChanged: (value) => settings.secureDisplay.value = value,
                  ),
                ),
              if (Platform.isAndroid)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.incognitoKeyboard,
                  builder: (context, value, child) => SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context).settingsIncognitoKeyboard,
                    ),
                    subtitle: Text(
                      value
                          ? AppLocalizations.of(context).enabled
                          : AppLocalizations.of(context).disabled,
                    ),
                    secondary: const Icon(Icons.keyboard),
                    value: value,
                    onChanged: (value) =>
                        settings.incognitoKeyboard.value = value,
                  ),
                ),
              ValueListenableBuilder<String?>(
                valueListenable: settings.appPin,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(AppLocalizations.of(context).settingsPinLock),
                  subtitle: Text(
                    value != null
                        ? AppLocalizations.of(context).pinEnabled
                        : AppLocalizations.of(context).pinDisabled,
                  ),
                  secondary: const Icon(Icons.pin),
                  value: value != null,
                  onChanged: (value) async {
                    if (value) {
                      String? pin = await registerPin(context);
                      if (pin != null) {
                        settings.appPin.value = pin;
                      }
                    } else {
                      settings.appPin.value = null;
                    }
                  },
                ),
              ),
              SubFuture<bool>(
                create: () => LocalAuthentication()
                    .getAvailableBiometrics()
                    .then((e) => e.isNotEmpty),
                builder: (context, snapshot) => ValueListenableBuilder<bool>(
                  valueListenable: settings.biometricAuth,
                  builder: (context, value, child) => SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context).settingsBiometricLock,
                    ),
                    subtitle: Text(
                      value
                          ? AppLocalizations.of(context).biometricsEnabled
                          : AppLocalizations.of(context).biometricsDisabled,
                    ),
                    secondary: const Icon(Icons.fingerprint),
                    value: value,
                    onChanged: (snapshot.data ?? false)
                        ? (value) => settings.biometricAuth.value = value
                        : null,
                  ),
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: AppLocalizations.of(context).sectionDevelopment,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.showDev,
                builder: (context, value, child) {
                  if (!value) return const SizedBox();
                  return SwitchListTile(
                    title: Text(
                      AppLocalizations.of(context).settingsDeveloperMode,
                    ),
                    subtitle: Text(
                      value
                          ? AppLocalizations.of(context).devOptionsShown
                          : AppLocalizations.of(context).devOptionsHidden,
                    ),
                    secondary: const Icon(Icons.bug_report),
                    value: value,
                    onChanged: (value) => settings.showDev.value = value,
                  );
                },
              ),
              if (context.watch<Logs?>() != null) ...[
                Consumer<LogErrors>(
                  builder: (context, errors, child) => ListTile(
                    leading: const Icon(Icons.format_list_numbered),
                    title: Text(AppLocalizations.of(context).logsTitle),
                    subtitle: errors.isEmpty
                        ? null
                        : Text(
                            AppLocalizations.of(
                              context,
                            ).errorsLogged(errors.length),
                          ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogsPage()),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(AppLocalizations.of(context).settingsDatabase),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DatabaseManagementPage(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
