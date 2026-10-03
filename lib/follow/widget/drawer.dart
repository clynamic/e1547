import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:intl/intl.dart';

class FollowMarkReadTile extends StatelessWidget {
  const FollowMarkReadTile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    final controller = context.watch<FollowParamsController>();
    return QueryBuilder(
      query: client.follows.useAll(query: controller.value.toQuery()),
      builder: (context, state) {
        int unseenCount =
            state.data?.fold<int>(0, (a, b) => a + (b.unseen ?? 0)) ?? 0;
        return ListTile(
          enabled: unseenCount > 0,
          leading: Icon(unseenCount > 0 ? Icons.mark_email_read : Icons.drafts),
          title: Text(AppLocalizations.of(context).followUnseenPosts),
          subtitle: unseenCount > 0
              ? TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: unseenCount),
                  duration: defaultAnimationDuration,
                  builder: (context, value, child) {
                    return Text(
                      AppLocalizations.of(context).followMarkPostsSeen(value),
                    );
                  },
                )
              : Text(AppLocalizations.of(context).followNoUnseenPosts),
          onTap: () {
            Scaffold.of(context).closeEndDrawer();
            client.follows.markAllSeen(null);
            onTap?.call();
          },
        );
      },
    );
  }
}

class FollowFilterReadTile extends StatelessWidget {
  const FollowFilterReadTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.watch<Settings>().filterUnseenFollows,
      builder: (context, filterUnseenFollows, child) => SwitchListTile(
        value: filterUnseenFollows,
        onChanged: (value) {
          Scaffold.of(context).closeEndDrawer();
          context.read<Settings>().filterUnseenFollows.value = value;
        },
        secondary: Icon(
          filterUnseenFollows ? Icons.mark_email_unread : Icons.email,
        ),
        title: Text(AppLocalizations.of(context).followShowUnseenFirst),
        subtitle: filterUnseenFollows
            ? Text(AppLocalizations.of(context).followFilteringUnseen)
            : Text(AppLocalizations.of(context).followAllPostsShown),
      ),
    );
  }
}

class FollowEditingTile extends StatelessWidget {
  const FollowEditingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(AppLocalizations.of(context).menuEdit),
      leading: const Icon(Icons.edit),
      onTap: () {
        Scaffold.of(context).closeEndDrawer();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const FollowEditor()));
      },
    );
  }
}

class FollowForceSyncTile extends StatelessWidget {
  const FollowForceSyncTile({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<Client>();
    return SubStream<FollowSync?>(
      create: () => client.followServer.syncStream,
      keys: [client],
      builder: (context, syncSnapshot) {
        bool enabled = false;
        FollowSync? sync = syncSnapshot.data;
        if (syncSnapshot.connectionState == ConnectionState.active) {
          enabled = sync == null;
        }
        return StreamBuilder<double>(
          stream: sync?.progress,
          builder: (context, progressSnapshot) => Column(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context).followForceSync),
                leading: const Icon(Icons.sync),
                subtitle: (sync?.completed ?? true)
                    ? Text(AppLocalizations.of(context).followSyncAllFollows)
                    : Text(
                        AppLocalizations.of(context).followSyncingFollows(
                          NumberFormat(
                            '0.#%',
                          ).format(progressSnapshot.data ?? 0),
                        ),
                      ),
                enabled: enabled,
                onTap: () {
                  // Scaffold.of(context).closeEndDrawer();
                  client.followServer.sync(force: true);
                },
              ),
              if (sync != null)
                TweenAnimationBuilder(
                  duration: defaultAnimationDuration,
                  tween: Tween<double>(
                    begin: 0,
                    end: progressSnapshot.data ?? 0,
                  ),
                  builder: (context, value, child) =>
                      LinearProgressIndicator(value: value == 0 ? null : value),
                ),
            ],
          ),
        );
      },
    );
  }
}
