import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../test/_support/fixtures.dart' show fixtureHost;

/// Records API responses into `test/_fixtures`, with identifying values
/// replaced and structure left intact.
const String host = 'https://e926.net';

const List<Endpoint> endpoints = [
  Endpoint('posts', '/posts.json', {
    'limit': '3',
    'tags': 'order:score',
    'mode': 'extended',
  }),
  Endpoint('comments', '/comments.json', {'limit': '3'}),
  Endpoint('topics', '/forum_topics.json', {'limit': '3'}),
  Endpoint('replies', '/forum_posts.json', {'limit': '3'}, query: repliesOf),
  Endpoint('pools', '/pools.json', {'limit': '3'}),
  Endpoint('tags', '/tags.json', {'limit': '5'}, namesAreTags: true),
  Endpoint('tag_aliases', '/tag_aliases.json', {
    'limit': '3',
  }, namesAreTags: true),
  Endpoint('wiki_pages', '/wiki_pages.json', {'limit': '3'}),
  Endpoint('users', '/users.json', {'limit': '3'}),
  Endpoint('user', '/users.json', {}, path: firstUser),
  // The app only ever asks for deletion flags, and only those carry a
  // creator_id for an ordinary user.
  Endpoint('flags', '/post_flags.json', {
    'limit': '3',
    'search[type]': 'deletion',
  }),
];

/// Index and show serializers return different fields, so the single user is
/// recorded from its own route.
String? firstUser(Map<String, List<Object?>> recorded) {
  final users = recorded['users'];
  if (users == null || users.isEmpty) return null;
  final user = users.first! as Map<String, Object?>;
  return '/users/${user['id']}.json';
}

/// Ties the recorded replies to a recorded topic, so the two fixtures describe
/// the same thread.
Map<String, String> repliesOf(Map<String, List<Object?>> recorded) {
  final topics = recorded['topics'];
  if (topics == null || topics.isEmpty) return const {};
  final topic = topics.first! as Map<String, Object?>;
  return {'search[topic_id]': topic['id'].toString()};
}

class Endpoint {
  const Endpoint(
    this.name,
    this.basePath,
    this.baseQuery, {
    this.namesAreTags = false,
    this.query,
    this.path,
  });

  final String name;
  final String basePath;
  final Map<String, String> baseQuery;
  final bool namesAreTags;

  /// Builds extra params from the responses already recorded in this run.
  final Map<String, String> Function(Map<String, List<Object?>>)? query;

  /// Builds the path from the responses already recorded in this run.
  final String? Function(Map<String, List<Object?>>)? path;
}

Future<void> main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: host,
      headers: {
        HttpHeaders.userAgentHeader: 'e1547-fixtures/1.0 (binaryfloof)',
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  // One sanitizer for the whole run, so an id means the same thing in every
  // fixture and a reply still points at its topic.
  final sanitizer = Sanitizer();
  final recorded = <String, List<Object?>>{};

  for (final endpoint in endpoints) {
    final path = endpoint.path?.call(recorded) ?? endpoint.basePath;
    final response = await dio.get<Object?>(
      path,
      queryParameters: {
        ...endpoint.baseQuery,
        ...?endpoint.query?.call(recorded),
      },
    );
    if (response.statusCode != 200) {
      stdout.writeln('fail  ${endpoint.name} (${response.statusCode})');
      continue;
    }
    final body = unwrap(response.data);
    final data = body is Map ? [body] : body;
    if (data is! List || data.isEmpty) {
      stdout.writeln('empty ${endpoint.name}');
      continue;
    }
    recorded[endpoint.name] = data;
    final sanitized = sanitizer.run(data, namesAreTags: endpoint.namesAreTags);
    final file = File('test/_fixtures/${endpoint.name}.json');
    await file.parent.create(recursive: true);
    await file.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(sanitized)}\n',
    );
    stdout.writeln('write ${endpoint.name} (${data.length})');
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }
}

/// Rails wraps list responses in a single-key object, except when it does not.
Object? unwrap(Object? data) {
  if (data is Map && data.length == 1) return data.values.first;
  return data;
}

/// Replaces values that identify a person, an upload, or a host, and leaves
/// every key, type and nesting in place.
class Sanitizer {
  /// Both tags and users carry a bare `name`, so the caller decides which
  /// vocabulary a record belongs to.
  bool namesAreTags = false;

  final Map<int, int> _ids = {};
  final Map<String, String> _names = {};
  final Map<String, String> _titles = {};
  final Map<String, String> _tags = {};

  static const Set<String> _nameKeys = {
    'creator_name',
    'updater_name',
    'uploader_name',
    'approver_name',
    'name',
    'creator',
    'updater',
  };

  static const Set<String> _textKeys = {
    'description',
    'body',
    'reason',
    'message',
    'profile_about',
    'profile_artinfo',
  };

  /// Keeps the host, which drives the source icon and label, and replaces the
  /// handles and ids that identify an artist.
  String _source(String value) {
    final disabled = value.startsWith('-');
    final raw = disabled ? value.substring(1) : value;
    final uri = Uri.tryParse(raw);
    if (uri == null || uri.host.isEmpty) return value;
    final path = uri.pathSegments
        .map((e) => int.tryParse(e) != null ? '123456' : _handle(e))
        .join('/');
    final query = uri.queryParameters.map((k, v) => MapEntry(k, '123456'));
    final rebuilt = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: '/$path',
      queryParameters: query.isEmpty ? null : query,
    ).toString();
    return disabled ? '-$rebuilt' : rebuilt;
  }

  String _handle(String original) =>
      _names.putIfAbsent(original, () => 'user_${_names.length + 1}');

  Object? run(Object? value, {bool namesAreTags = false}) {
    this.namesAreTags = namesAreTags;
    return _walk(value, '');
  }

  Object? _walk(Object? value, String key) {
    if (value is List) {
      return value.map((e) => _walk(e, key)).toList();
    }
    if (value is Map) {
      if (key == 'tags') return _tagCategories(value);
      return value.map(
        (k, v) => MapEntry(k.toString(), _walk(v, k.toString())),
      );
    }
    if (value is int && _isIdKey(key)) return _id(value);
    if (value is String) return _string(value, key);
    return value;
  }

  Map<String, Object?> _tagCategories(Map<Object?, Object?> categories) =>
      categories.map((category, tags) {
        if (tags is! List) return MapEntry(category.toString(), tags);
        return MapEntry(
          category.toString(),
          tags.map((e) => _tag(e.toString())).toList(),
        );
      });

  String _tag(String original) =>
      _tags.putIfAbsent(original, () => 'tag_${_tags.length + 1}');

  static const Set<String> _idKeys = {'children', 'pools'};

  bool _isIdKey(String key) =>
      key == 'id' ||
      key.endsWith('_id') ||
      key.endsWith('_ids') ||
      _idKeys.contains(key);

  int _id(int original) =>
      _ids.putIfAbsent(original, () => 1000 + _ids.length * 7);

  String _string(String value, String key) {
    if (key == 'related_tags') {
      return value.split(' ').map((e) => e.isEmpty ? e : _tag(e)).join(' ');
    }
    if (key == 'antecedent_name' || key == 'consequent_name') {
      return _tag(value);
    }
    if (key == 'name' && namesAreTags) return _tag(value);
    if (_nameKeys.contains(key)) return _handle(value);
    if (_textKeys.contains(key)) {
      return value.isEmpty ? value : 'Recorded text with "a link":/posts/1000.';
    }
    if (key == 'sources') return _source(value);
    if (key == 'md5') return _hash(value);
    if (key == 'url' || key == 'alt') return _url(value);
    if (key == 'title') {
      return _titles.putIfAbsent(value, () => 'Title ${_titles.length + 1}');
    }
    return value;
  }

  String _hash(String original) {
    final digits = original.hashCode.abs().toString().padLeft(8, '0');
    return (digits * 4).substring(0, 32);
  }

  /// Rebuilds an asset url, deriving the shard directories from the replaced
  /// hash so no part of the original survives in the path.
  String _url(String original) {
    final uri = Uri.tryParse(original);
    if (uri == null || !uri.hasAbsolutePath) return original;
    final file = uri.pathSegments.lastWhere(
      (e) => e.contains('.'),
      orElse: () => '',
    );
    if (file.isEmpty) return '$fixtureHost/${uri.pathSegments.join('/')}';
    final dot = file.lastIndexOf('.');
    final hash = _hash(file.substring(0, dot));
    final shards = [hash.substring(0, 2), hash.substring(2, 4)];
    var shard = 0;
    final segments = uri.pathSegments.map((e) {
      if (e == file) return '$hash.${file.substring(dot + 1)}';
      if (_isShard(e) && shard < shards.length) return shards[shard++];
      return e;
    });
    return '$fixtureHost/${segments.join('/')}';
  }

  bool _isShard(String segment) =>
      segment.length == 2 && RegExp(r'^[0-9a-f]{2}$').hasMatch(segment);
}
