import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
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

    if (parsed.id case final id when id is String) {
      switch (type) {
        case LinkType.user:
          return tf('{id} - User', params: {'id': id});
        case LinkType.wiki:
          return tf('{id} - Wiki', params: {'id': id});
        default:
          break;
      }
    }

    if (parsed.id case final id when id is int) {
      switch (type) {
        case LinkType.post:
          return tf('Post #{id}', params: {'id': id});
        case LinkType.pool:
          return tf('Pool #{id}', params: {'id': id});
        case LinkType.user:
          return tf('User #{id}', params: {'id': id});
        case LinkType.wiki:
          return tf('Wiki #{id}', params: {'id': id});
        case LinkType.topic:
          return tf('Topic #{id}', params: {'id': id});
        case LinkType.reply:
          return tf('Reply #{id}', params: {'id': id});
      }
    }

    QueryMap? search = parsed.query;
    if (search != null && search.isNotEmpty) {
      switch (type) {
        case LinkType.post:
          String? username = context.read<Client>().identity.username;
          if (username != null &&
              favRegex(username).hasMatch(search['tags'] ?? '')) {
            return t('Favorites');
          }
          if (search['tags'] == 'order:rank') {
            return t('Hot posts');
          }
          return tf('Posts - {tags}', params: {
            'tags': tagToName(search['tags'] ?? ''),
          });
        case LinkType.pool:
          return tf('Pools - {query}', params: {
            'query': search['search[name_matches]'] ?? '',
          });
        case LinkType.user:
          return tf('Users - {query}', params: {
            'query': search['search[name_matches]'] ?? '',
          });
        case LinkType.wiki:
          return tf('Wikis - {query}', params: {
            'query': search['search[title]'] ?? '',
          });
        case LinkType.topic:
          return tf('Topics - {query}', params: {
            'query': search['search[title_matches]'] ?? '',
          });
        case LinkType.reply:
          return tf('Replies - {query}', params: {
            'query': search['search[topic_title_matches]'] ?? '',
          });
      }
    }

    switch (type) {
      case LinkType.post:
        return t('Posts');
      case LinkType.pool:
        return t('Pools');
      case LinkType.user:
        return t('Users');
      case LinkType.wiki:
        return t('Wikis');
      case LinkType.topic:
        return t('Topics');
      case LinkType.reply:
        return t('Replies');
    }
  }
}
