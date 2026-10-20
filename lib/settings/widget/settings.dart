import 'dart:async';
import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
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
        appBar: DefaultAppBar(title: Text(t('Settings'))),
        body: LimitedWidthLayout.builder(
          builder: (context) => ListView(
            primary: true,
            padding: defaultActionListPadding.add(
              LimitedWidthLayout.of(context).padding,
            ),
            children: [
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: t('Account'),
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
                title: t('User'),
              ),
              Consumer<Client>(
                builder: (context, client, child) => ValueListenableBuilder(
                  valueListenable: client.traits,
                  builder: (context, traits, child) => ListTile(
                    title: Text(t('Blacklist')),
                    leading: const Icon(Icons.block),
                    subtitle: traits.denylist.isNotEmpty
                        ? Text(
                            tf(
                              '{n} tags blocked',
                              params: {
                                'n': traits.denylist.join(' ').split(' ').trim().where((e) => e[0] != '-').length,
                              },
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
                    title: Text(t('Follows')),
                    subtitle: snapshot.data != null && snapshot.data != 0
                        ? Text(
                            tf(
                              '{n} searches followed',
                              params: {'n': snapshot.data},
                            ),
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
                          title: Text(t('History')),
                          subtitle: enabled && count != null
                              ? Text(
                                  tf(
                                    '{n} pages visited',
                                    params: {'n': count},
                                  ),
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
                title: t('Appearance'),
              ),
              ValueListenableBuilder<AppTheme>(
                valueListenable: settings.theme,
                builder: (context, value, child) => ListTile(
                  title: Text(t('Theme')),
                  subtitle: Text(value.name),
                  leading: const Icon(Icons.brightness_6),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(t('Theme')),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppTheme.values
                                .map(
                                  (theme) => ListTile(
                                    title: Text(theme.name),
                                    trailing: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.data.cardColor,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color!,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      settings.theme.value = theme;
                                      Navigator.of(context).maybePop();
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
              ValueListenableBuilder<AppLanguage>(
                valueListenable: settings.language,
                builder: (context, value, child) => ListTile(
                  title: Text(t('Language')),
                  subtitle: Text(value.title),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text(t('Language')),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppLanguage.values
                                .map(
                                  (language) => ListTile(
                                    title: Text(language.title),
                                    onTap: () {
                                      settings.language.value = language;
                                      Navigator.of(context).maybePop();
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
              Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: settings.tileSize,
                    builder: (context, value, child) => ListTile(
                      title: Text(t('Tile size')),
                      subtitle: Text(value.toString()),
                      leading: const Icon(Icons.crop),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => RangeDialog(
                          title: Text(t('Tile size')),
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
                  title: Text(t('Post info')),
                  subtitle: Text(t(value ? 'info on post tiles' : 'image tiles only')),
                  secondary: const Icon(Icons.subtitles),
                  value: value,
                  onChanged: (value) => settings.showPostInfo.value = value,
                ),
              ),
              const Divider(),
              SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: t('Interactions'),
              ),
              if (!Platform.isIOS)
                ValueListenableBuilder<String?>(
                  valueListenable: settings.downloadPath,
                  builder: (context, value, child) => ListTile(
                    title: Text(t('Download location')),
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
                  title: Text(t('Upvote favorites')),
                  subtitle: Text(t(value ? 'upvote and favorite' : 'favorite only')),
                  secondary: const Icon(Icons.arrow_upward),
                  value: value,
                  onChanged: (value) => settings.upvoteFavs.value = value,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.muteVideos,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(t('Video volume')),
                  subtitle: Text(t(value ? 'muted' : 'with sound')),
                  secondary: Icon(value ? Icons.volume_off : Icons.volume_up),
                  value: value,
                  onChanged: (value) => settings.muteVideos.value = value,
                ),
              ),
              ValueListenableBuilder<VideoResolution>(
                valueListenable: settings.videoResolution,
                builder: (context, value, child) => ListTile(
                  title: Text(t('Video resolution')),
                  subtitle: Text(t(value.title)),
                  leading: const Icon(Icons.video_settings),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(t('Video resolution')),
                      children: VideoResolution.values
                          .map(
                            (resolution) => ListTile(
                              title: Text(t(resolution.title)),
                              onTap: () {
                                settings.videoResolution.value = resolution;
                                Navigator.of(context).maybePop();
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
                title: t('Security'),
              ),
              if (PlatformCapabilities.hasSecureDisplay)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.secureDisplay,
                  builder: (context, value, child) => SwitchListTile(
                    title: Text(t('Secure display')),
                    subtitle: Text(t(value ? 'screen protected' : 'screen visible')),
                    secondary: const Icon(Icons.stop_screen_share_outlined),
                    value: value,
                    onChanged: (value) => settings.secureDisplay.value = value,
                  ),
                ),
              if (Platform.isAndroid)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.incognitoKeyboard,
                  builder: (context, value, child) => SwitchListTile(
                    title: Text(t('Incognito keyboard')),
                    subtitle: Text(t(value ? 'enabled' : 'disabled')),
                    secondary: const Icon(Icons.keyboard),
                    value: value,
                    onChanged: (value) =>
                        settings.incognitoKeyboard.value = value,
                  ),
                ),
              ValueListenableBuilder<String?>(
                valueListenable: settings.appPin,
                builder: (context, value, child) => SwitchListTile(
                  title: Text(t('PIN lock')),
                  subtitle: Text(t(value != null ? 'PIN enabled' : 'PIN disabled')),
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
                    title: Text(t('Biometric lock')),
                    subtitle: Text(
                      t(value ? 'biometrics enabled' : 'biometrics disabled'),
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
                title: t('Development'),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.showDev,
                builder: (context, value, child) {
                  if (!value) return const SizedBox();
                  return SwitchListTile(
                    title: Text(t('Developer mode')),
                    subtitle: Text(t(value ? 'options shown' : 'options hidden')),
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
                    title: Text(t('Logs')),
                    subtitle: errors.isEmpty
                        ? null
                        : Text(
                            tf(
                              '{n} errors logged',
                              params: {'n': errors.length},
                            ),
                          ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogsPage()),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(t('Database')),
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
