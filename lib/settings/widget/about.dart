import 'dart:async';
import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/topic/topic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AppInfoClient?>();
    final versions = client?.useNewVersions();
    final bundledDonors = client?.useBundledDonors();
    final donors = client?.useDonors();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const TransparentAppBar(
        child: DefaultAppBar(leading: CloseButton()),
      ),
      body: LimitedWidthLayout.builder(
        builder: (context) => PullToRefresh(
          onRefresh: () async {
            await Future.wait([
              ?versions?.invalidate(),
              ?bundledDonors?.invalidate(),
              ?donors?.invalidate(),
            ]);
          },
          child: ListView(
            padding: LimitedWidthLayout.of(context).padding,
            children: [
              const SizedBox(height: 100),
              const DevOptionEnabler(child: AboutLogo()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  child: Column(
                    children: [
                      if (PlatformCapabilities.isExperimental)
                        const AboutExperimental(),
                      AboutVersion(newVersions: versions),
                      const AboutLinks(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Card(
                  child: AboutDonations(
                    bundledDonors: bundledDonors,
                    donors: donors,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class DevOptionEnabler extends StatefulWidget {
  const DevOptionEnabler({super.key, required this.child});

  final Widget child;

  @override
  State<DevOptionEnabler> createState() => _DevOptionEnablerState();
}

class _DevOptionEnablerState extends State<DevOptionEnabler> {
  int taps = 0;
  Timer? reset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final messenger = ScaffoldMessenger.of(context);
        reset?.cancel();
        setState(() => taps++);
        if (taps == 7) {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(t('You are now a developer!')),
            ),
          );
          context.read<Settings>().showDev.value = true;
          taps = 0;
        }
        reset = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() => taps = 0);
        });
      },
      child: widget.child,
    );
  }
}

class AboutLogo extends StatelessWidget {
  const AboutLogo({super.key});

  @override
  Widget build(BuildContext context) {
    AppInfo appInfo = AppInfo.instance;
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(radius: 64),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 12),
              child: Text(
                appInfo.appName,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            Text(appInfo.version, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class AboutExperimental extends StatelessWidget {
  const AboutExperimental({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(t('Experimental platform')),
          subtitle: Text(
            t('This platform is not supported. Expect bugs and missing features.'),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class AboutVersion extends StatelessWidget {
  // ignore: unused_element
  const AboutVersion({super.key, required this.newVersions});

  final Query<List<AppVersion>>? newVersions;

  @override
  Widget build(BuildContext context) {
    void openGithub() {
      AppInfoClient? updater = context.read<AppInfoClient?>();
      if (updater == null) return;
      launch(updater.latestReleaseUrl());
    }

    Widget changesDialog(List<AppVersion> versions) {
      return AlertDialog(
        title: Text(AppInfo.instance.appName),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('A newer version is available: '),
                  style: TextStyle(color: dimTextColor(context, 0.5)),
                ),
                ...versions
                    .map(
                      (release) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${release.name} (${release.version})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Text(release.description!),
                      ],
                    )
                    .reduce((a, b) => [...a, ...b]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).maybePop,
            child: Text(t('CANCEL')),
          ),
          TextButton(onPressed: openGithub, child: Text(t('DOWNLOAD'))),
        ],
      );
    }

    Widget tile(QueryState<List<AppVersion>>? state) {
      final List<AppVersion>? data = state?.data;
      String message;
      Widget icon;
      VoidCallback? onTap;
      if (data == null && (state?.isLoading ?? true)) {
        message = t('Fetching updates...');
        icon = const FaIcon(FontAwesomeIcons.clockRotateLeft);
      } else if (data == null) {
        message = t('Failed to check for updates');
        onTap = openGithub;
        icon = const FaIcon(FontAwesomeIcons.circleExclamation);
      } else if (data.isEmpty) {
        message = t('You have the newest version');
        icon = const FaIcon(FontAwesomeIcons.clockRotateLeft);
      } else {
        message = tf(
          'A newer version is available: {version}',
          params: {'version': data.first.version},
        );
        onTap = () => showDialog(
          context: context,
          builder: (context) => changesDialog(data),
        );
        icon = const FaIcon(FontAwesomeIcons.download);
      }

      return Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              ListTile(
                leading: icon,
                title: Text(t('Version')),
                subtitle: Text(message),
                onTap: onTap,
              ),
              if (data?.isNotEmpty ?? false)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(),
        ],
      );
    }

    final query = newVersions;
    if (query == null) return tile(null);
    return QueryBuilder(query: query, builder: (context, state) => tile(state));
  }
}

class AboutLinks extends StatelessWidget {
  const AboutLinks({super.key});

  @override
  Widget build(BuildContext context) {
    AppInfo appInfo = AppInfo.instance;

    Widget linkListTile({
      Widget? leading,
      required Widget title,
      required String link,
      String? extra,
    }) {
      return ListTile(
        leading: leading,
        title: title,
        subtitle: Text(extra ?? link),
        onTap: () => launch(link + (extra ?? '')),
      );
    }

    return Column(
      children: [
        linkListTile(
          leading: const FaIcon(FontAwesomeIcons.github),
          title: Text(t('GitHub')),
          link: 'https://github.com/',
          extra: appInfo.github,
        ),
        linkListTile(
          leading: const FaIcon(FontAwesomeIcons.discord),
          title: Text(t('Discord')),
          link: 'https://discord.gg/',
          extra: appInfo.discord,
        ),
        if (appInfo.forumTopicId != null)
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.comments),
            title: Text(t('Forum')),
            subtitle: Text(
              tf('e621 thread #{n}', params: {'n': appInfo.forumTopicId}),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TopicLoadingPage(appInfo.forumTopicId!),
              ),
            ),
          ),
        if (appInfo.website != null)
          linkListTile(
            leading: const FaIcon(FontAwesomeIcons.house),
            title: Text(t('Website')),
            link: 'https://',
            extra: appInfo.website,
          ),
        if (appInfo.kofi != null &&
            ![
              Source.IS_INSTALLED_FROM_PLAY_STORE,
              Source.IS_INSTALLED_FROM_APP_STORE,
            ].contains(appInfo.source))
          linkListTile(
            leading: const FaIcon(FontAwesomeIcons.mugSaucer),
            title: Text(t('Ko-fi')),
            link: 'https://ko-fi.com/',
            extra: appInfo.kofi,
          ),
        if (appInfo.email != null)
          linkListTile(
            leading: const FaIcon(FontAwesomeIcons.solidEnvelope),
            title: Text(t('Email')),
            link: 'mailto:',
            extra: appInfo.email,
          ),
        const Divider(),
        linkListTile(
          leading: const FaIcon(FontAwesomeIcons.googlePlay),
          title: Text(t('Playstore')),
          link: Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id='
              : 'https://play.google.com/store/search?q=',
          extra: AppInfo.instance.packageName,
        ),
      ],
    );
  }
}

class AboutDonations extends StatelessWidget {
  const AboutDonations({super.key, this.bundledDonors, this.donors});

  final Query<List<Donor>>? bundledDonors;
  final Query<List<Donor>>? donors;

  @override
  Widget build(BuildContext context) {
    Widget section(
      QueryState<List<Donor>>? assetDonations,
      QueryState<List<Donor>>? githubDonations,
    ) {
      List<Donor>? donors = githubDonations?.data ?? assetDonations?.data;

      if ((githubDonations?.isError ?? false) &&
          (assetDonations?.isError ?? false)) {
        return IconMessage(
          icon: const Icon(Icons.warning_amber),
          title: Text(t('Failed to fetch donors')),
        );
      }

      if (donors?.isEmpty ?? false) {
        return const SizedBox();
      }

      return Column(
        children: [
          ListTile(
            title: Text(t('Donors')),
            leading: const FaIcon(FontAwesomeIcons.handHoldingHeart),
            subtitle: Text(t('Thanks for helping me keep up development!')),
          ),
          const Divider(),
          const SizedBox(height: 8),
          if (donors == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            )
          else if (donors.isEmpty)
            // I dont like whining about no donors
            ListTile(
              title: Text(t('No donors yet')),
              leading: const FaIcon(FontAwesomeIcons.heartCrack),
            )
          else
            Donors(donors: donors),
        ],
      );
    }

    final bundled = bundledDonors;
    final remote = donors;
    if (bundled == null || remote == null) return section(null, null);
    return QueryBuilder(
      query: bundled,
      builder: (context, assetDonations) => QueryBuilder(
        query: remote,
        builder: (context, githubDonations) =>
            section(assetDonations, githubDonations),
      ),
    );
  }
}

class DrawerUpdateIcon extends StatelessWidget {
  const DrawerUpdateIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final query = context.watch<AppInfoClient?>()?.useNewVersions();
    if (query == null) return const Icon(Icons.info);
    return QueryBuilder(
      query: query,
      builder: (context, state) {
        if (state.data?.isNotEmpty ?? false) {
          return Stack(
            children: [
              const Icon(Icons.update),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Icon(Icons.info);
        }
      },
    );
  }
}
