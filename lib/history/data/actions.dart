import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/l10n/app_localizations.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/widgets.dart';

extension Identification on History {
  bool isItem(LinkType type) {
    Link? parsed = const E621LinkParser().parse(link);
    return type == parsed?.type && parsed?.id != null;
  }

  bool isSearch(LinkType type) {
    Link? parsed = const E621LinkParser().parse(link);
    return type == parsed?.type && (parsed?.query?.isNotEmpty ?? false);
  }

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Link? parsed = const E621LinkParser().parse(link);
    LinkType? type = parsed?.type;
    if (parsed == null || type == null) {
      if (title != null) {
        return title!;
      }
      return link;
    }

    if (title != null) {
      switch (type) {
        case LinkType.pool:
        case LinkType.wiki:
          return tagToName(title!);
        default:
          break;
      }
      return title!;
    }

    if (parsed.id case final String id) {
      switch (type) {
        case LinkType.user:
          return l10n.historyLinkUserByName(id);
        case LinkType.wiki:
          return l10n.historyLinkWikiByName(id);
        default:
          break;
      }
    }

    if (parsed.id case final int id) {
      switch (type) {
        case LinkType.post:
          return l10n.historyLinkPost(id);
        case LinkType.pool:
          return l10n.poolLink(id);
        case LinkType.user:
          return l10n.historyLinkUser(id);
        case LinkType.wiki:
          return l10n.historyLinkWiki(id);
        case LinkType.topic:
          return l10n.topicLink(id);
        case LinkType.reply:
          return l10n.replyTitle(id);
      }
    }

    QueryMap? search = parsed.query;
    if (search != null && search.isNotEmpty) {
      switch (type) {
        case LinkType.post:
          String? username = context.read<Client>().identity.username;
          if (username != null &&
              favRegex(username).hasMatch(search['tags'] ?? '')) {
            return l10n.navFavorites;
          }
          if (search['tags'] == 'order:rank') {
            return l10n.historyHotPosts;
          }
          return l10n.historySearchQuery(
            l10n.postsTitle,
            tagToName(search['tags'] ?? ''),
          );
        case LinkType.pool:
          return l10n.historySearchQuery(
            l10n.navPools,
            search['search[name_matches]'] ?? '',
          );
        case LinkType.user:
          return l10n.historySearchQuery(
            l10n.historyUsers,
            search['search[name_matches]'] ?? '',
          );
        case LinkType.wiki:
          return l10n.historySearchQuery(
            l10n.historyWikis,
            search['search[title]'] ?? '',
          );
        case LinkType.topic:
          return l10n.historySearchQuery(
            l10n.topicsTitle,
            search['search[title_matches]'] ?? '',
          );
        case LinkType.reply:
          return l10n.historySearchQuery(
            l10n.repliesTitle,
            search['search[topic_title_matches]'] ?? '',
          );
      }
    }

    switch (type) {
      case LinkType.post:
        return l10n.postsTitle;
      case LinkType.pool:
        return l10n.navPools;
      case LinkType.user:
        return l10n.historyUsers;
      case LinkType.wiki:
        return l10n.historyWikis;
      case LinkType.topic:
        return l10n.topicsTitle;
      case LinkType.reply:
        return l10n.repliesTitle;
    }
  }
}
