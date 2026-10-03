import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'fixtures.dart';

class FakeE621 {
  FakeE621._(this.state);

  late final HttpServer _server;
  final FakeE621State state;

  final List<FakeRequest> requests = [];

  String get url => 'http://${_server.address.host}:${_server.port}';

  static Future<FakeE621> start({FakeE621State? state}) async {
    final fake = FakeE621._(state ?? FakeE621State.seeded());
    fake._server = await shelf_io.serve(
      fake._route,
      InternetAddress.loopbackIPv4,
      0,
    );
    return fake;
  }

  Future<void> stop() => _server.close(force: true);

  late final Router _router = Router()
    ..get('/status.json', (Request request) => _json({'online': true}))
    ..get('/data/<path|.*>', _serveImage)
    ..get('/posts.json', _listPosts)
    ..get('/favorites.json', _listFavorites)
    ..get('/posts/<id|[0-9]+>.json', _showPost)
    ..post('/posts/<id|[0-9]+>/votes.json', _votePost)
    ..get('/forum_posts.json', _listReplies)
    ..post('/forum_posts.json', _createReply)
    ..get('/forum_posts/<id|[0-9]+>.json', _showReply)
    ..patch('/forum_posts/<id|[0-9]+>.json', _updateReply)
    ..get('/comments.json', (Request request) => _list(state.comments, request))
    ..post('/comments.json', _createComment)
    ..get(
      '/comments/<id|[0-9]+>.json',
      (Request request, String id) => _json(_find(state.comments, id)),
    )
    ..patch('/comments/<id|[0-9]+>.json', _updateComment)
    ..get(
      '/forum_topics.json',
      (Request request) => _list(state.topics, request),
    )
    ..get(
      '/forum_topics/<id|[0-9]+>.json',
      (Request request, String id) => _json(_find(state.topics, id)),
    )
    ..get('/pools.json', (Request request) => _list(state.pools, request))
    ..get(
      '/pools/<id|[0-9]+>.json',
      (Request request, String id) => _json(_find(state.pools, id)),
    )
    ..get('/tags.json', (Request request) => _list(state.tags, request))
    ..get(
      '/tag_aliases.json',
      (Request request) => _list(state.tagAliases, request),
    )
    ..get('/users.json', (Request request) => _list(state.users, request))
    ..get('/users/<lookup>.json', _showUser)
    ..get('/wiki_pages.json', (Request request) => _list(state.wikis, request))
    ..get('/wiki_pages/<lookup>.json', _showWiki)
    ..get('/post_flags.json', _listFlags)
    ..post('/post_flags.json', _createFlag)
    ..post('/tickets', _createTicket);

  Response _list(List<Map<String, Object?>> items, Request request) =>
      _json(_paginate(items, request.url.queryParameters));

  Map<String, Object?> _find(List<Map<String, Object?>> items, String id) =>
      items.firstWhere(
        (e) => e['id'] == int.parse(id),
        orElse: () => throw FakeE621Error(404, 'Not found'),
      );

  Response _showUser(Request request, String lookup) =>
      _json(_lookup([state.user], lookup, 'name'));

  Response _showWiki(Request request, String lookup) =>
      _json(_lookup(state.wikis, lookup, 'title'));

  Map<String, Object?> _lookup(
    List<Map<String, Object?>> items,
    String lookup,
    String field,
  ) {
    final name = Uri.decodeComponent(lookup);
    final id = int.tryParse(name);
    return items.firstWhere(
      (e) => id != null ? e['id'] == id : e[field] == name,
      orElse: () => throw FakeE621Error(404, 'Not found'),
    );
  }

  Response _createComment(Request request) {
    final fields = _permit(_params(request), 'comment', [
      'body',
      'post_id',
      'do_not_bump_post',
    ]);
    _requirePresent(fields, 'body');
    final postId = _requireInt(fields, 'post_id');
    if (!state.posts.any((e) => e['id'] == postId)) {
      throw FakeE621Error(404, 'Not found');
    }
    return _json(
      state.addComment(postId: postId, body: fields['body']!),
      status: 201,
    );
  }

  Response _updateComment(Request request, String id) {
    final fields = _permit(_params(request), 'comment', ['body']);
    _requirePresent(fields, 'body');
    final comment = _find(state.comments, id);
    comment['body'] = fields['body'];
    return _json(comment);
  }

  Response _listFlags(Request request) {
    final type = request.url.queryParameters['search[type]'];
    final flags = switch (type) {
      'deletion' => state.flags.where((e) => e['is_deletion'] == true),
      'flag' => state.flags.where((e) => e['is_deletion'] == false),
      _ => state.flags,
    };
    return _list(flags.toList(), request);
  }

  Response _createFlag(Request request) {
    final fields = _permit(_params(request), 'post_flag', [
      'post_id',
      'reason_name',
      'parent_id',
      'note',
    ]);
    _requireInt(fields, 'post_id');
    _requirePresent(fields, 'reason_name');
    return _json({'id': 1, ...fields}, status: 201);
  }

  Future<Response> _route(Request request) async {
    final params = {
      ...request.url.queryParameters,
      ...await _readBody(request),
    };
    requests.add(
      FakeRequest(
        method: request.method,
        path: '/${request.url.path}',
        query: request.url.queryParameters,
        body: params,
      ),
    );
    try {
      return await _router.call(request.change(context: {'params': params}));
    } on FakeE621Error catch (e) {
      return _json({'message': e.message}, status: e.status);
    }
  }

  static final Uint8List _pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGM4ceIEAAS0Al'
    'kWLoFAAAAAAElFTkSuQmCC',
  );

  Response _serveImage(Request request, String path) => Response.ok(
    _pixel,
    headers: {HttpHeaders.contentTypeHeader: 'image/png'},
  );

  Map<String, String> _params(Request request) =>
      request.context['params']! as Map<String, String>;

  Response _listPosts(Request request) {
    final query = request.url.queryParameters;
    var posts = state.posts;
    final tags = query['tags'] ?? '';
    final ids = RegExp(r'^id:([\d,]+)$').firstMatch(tags);
    if (ids != null) {
      final wanted = ids.group(1)!.split(',').map(int.parse).toSet();
      posts = posts.where((e) => wanted.contains(e['id'])).toList();
    }
    return _json({'posts': _paginate(posts, query)});
  }

  Response _listFavorites(Request request) {
    final query = request.url.queryParameters;
    if (query['user_id'] == null && _username(request) == null) {
      throw FakeE621Error(404, 'Not found');
    }
    final favorites = state.posts
        .where((e) => state.favorites.contains(e['id']))
        .toList();
    return _json({'posts': _paginate(favorites, query)});
  }

  String? _username(Request request) {
    final header = request.headers[HttpHeaders.authorizationHeader];
    if (header == null) return null;
    final match = RegExp(r'Basic (\S+)').firstMatch(header);
    if (match == null) return null;
    final decoded = utf8.decode(base64Decode(match.group(1)!));
    final separator = decoded.indexOf(':');
    if (separator == -1) return null;
    return decoded.substring(0, separator);
  }

  Response _showPost(Request request, String id) {
    final post = state.posts.firstWhere(
      (e) => e['id'] == int.parse(id),
      orElse: () => throw FakeE621Error(404, 'Not found'),
    );
    return _json({'post': post});
  }

  Response _votePost(Request request, String id) {
    final query = request.url.queryParameters;
    final score = int.tryParse(query['score'] ?? '');
    if (score != 1 && score != -1) {
      throw FakeE621Error(
        422,
        'score must be 1 or -1, got "${query['score']}"',
      );
    }
    if (!{'true', 'false'}.contains(query['no_unvote'])) {
      throw FakeE621Error(
        422,
        'no_unvote must be a boolean, got "${query['no_unvote']}"',
      );
    }
    final post = state.posts.firstWhere(
      (e) => e['id'] == int.parse(id),
      orElse: () => throw FakeE621Error(404, 'Not found'),
    );
    final total = (post['score']! as Map)['total']! as int;
    return _json({'score': total + score!, 'our_score': score});
  }

  Response _listReplies(Request request) {
    final query = request.url.queryParameters;
    final topicId = query['search[topic_id]'];
    var replies = state.replies.where(
      (e) => topicId == null || e['topic_id'].toString() == topicId,
    );
    if (query['search[order]'] == 'id_desc') {
      replies = replies.toList().reversed;
    }
    return _json(_paginate(replies.toList(), query));
  }

  Response _createReply(Request request) {
    final fields = _permit(_params(request), 'forum_post', [
      'body',
      'topic_id',
    ]);
    final topicId = _requireInt(fields, 'topic_id');
    _requirePresent(fields, 'body');
    if (!state.topics.any((e) => e['id'] == topicId)) {
      throw FakeE621Error(404, 'Topic ID is invalid');
    }
    if (state.lockedTopics.contains(topicId)) {
      throw FakeE621Error(422, 'Topic does not allow replies');
    }
    return _json(
      state.addReply(topicId: topicId, body: fields['body']!),
      status: 201,
    );
  }

  Response _showReply(Request request, String id) =>
      _json(_reply(int.parse(id)));

  Response _updateReply(Request request, String id) {
    final fields = _permit(_params(request), 'forum_post', ['body']);
    _requirePresent(fields, 'body');
    final reply = _reply(int.parse(id));
    reply['body'] = fields['body'];
    reply['updated_at'] = DateTime.now().toIso8601String();
    return _json(reply);
  }

  Response _createTicket(Request request) {
    final fields = _permit(_params(request), 'ticket', [
      'qtype',
      'disp_id',
      'reason',
      'report_reason',
    ]);
    if (!_validQtypes.contains(fields['qtype'])) {
      throw FakeE621Error(422, 'qtype is not valid');
    }
    _requireInt(fields, 'disp_id');
    _requirePresent(fields, 'reason');
    final reportReason = fields['report_reason'];
    if (reportReason != null) {
      final id = int.tryParse(reportReason);
      if (id == null || !state.reportReasons.contains(id)) {
        throw FakeE621Error(
          422,
          'report_reason must reference a post report reason, '
          'got "$reportReason"',
        );
      }
    }
    return Response(302, headers: {HttpHeaders.locationHeader: '/tickets/1'});
  }

  Map<String, Object?> _reply(int id) => state.replies.firstWhere(
    (e) => e['id'] == id,
    orElse: () => throw FakeE621Error(404, 'Not found'),
  );

  static const _validQtypes = {
    'user',
    'dmail',
    'comment',
    'forum',
    'blip',
    'wiki',
    'pool',
    'set',
    'post',
  };

  /// Reads `name[field]` params, throwing when a field is not in [allowed].
  ///
  /// We throw to enforce validity in clients, unlike Rails which ignores extra parameters.
  Map<String, String> _permit(
    Map<String, String> params,
    String name,
    List<String> allowed,
  ) {
    final fields = <String, String>{};
    for (final entry in params.entries) {
      final match = RegExp('^$name\\[([a-z_]+)\\]\$').firstMatch(entry.key);
      if (match == null) continue;
      final field = match.group(1)!;
      if (!allowed.contains(field)) {
        throw FakeE621Error(
          400,
          'unpermitted parameter $name[$field], allowed: $allowed',
        );
      }
      fields[field] = entry.value;
    }
    return fields;
  }

  void _requirePresent(Map<String, String> fields, String key) {
    if ((fields[key] ?? '').isEmpty) {
      throw FakeE621Error(422, '$key cannot be blank');
    }
  }

  int _requireInt(Map<String, String> fields, String key) {
    final value = int.tryParse(fields[key] ?? '');
    if (value == null) {
      throw FakeE621Error(422, '$key must be an integer, got "${fields[key]}"');
    }
    return value;
  }

  static const int recordsPerPage = 75;
  static const int maxPerPage = 320;
  static const int maxNumberedPages = 750;

  List<Object?> _paginate(
    List<Map<String, Object?>> items,
    Map<String, String> query,
  ) {
    final limit = _parseLimit(query['limit']);
    final (page, anchor) = _parsePageParams(query);
    if (anchor != null) {
      // e621 serves the posts before a cursor anchor in descending id order,
      // while our fixtures are stored ascending, so sort them.
      final remaining = items.where((e) => (e['id']! as int) < anchor).toList()
        ..sort((a, b) => (b['id']! as int).compareTo(a['id']! as int));
      if (limit == 0 || remaining.isEmpty) return const [];
      return remaining.sublist(0, limit.clamp(0, remaining.length));
    }
    final start = (page - 1) * limit;
    if (limit == 0 || start >= items.length) return const [];
    return items.sublist(start, (start + limit).clamp(0, items.length));
  }

  /// Parses the `page` parameter into a 1-based page number and, for a `b<id>`
  /// cursor request, the anchor id the server may honor.
  ///
  /// A cursor combined with an `order` tag that does not sort by descending id
  /// is parsed as page 1: the real e621 api silently ignores cursors for those
  /// orders and serves the first page instead, and since this fake does not
  /// implement order sorting, page 1 is exactly what it serves too.
  (int, int?) _parsePageParams(Map<String, String> query) {
    final page = query['page'];
    final cursor = page == null ? null : RegExp(r'^b(\d+)$').firstMatch(page);
    if (cursor != null) {
      if (_cursorOrder(query['tags'])) {
        return (1, int.parse(cursor.group(1)!));
      }
      return (1, null);
    }
    return (_parsePage(page), null);
  }

  /// Whether the `order` tags sort results by descending id, the only orders
  /// the real e621 api honors cursors for.
  bool _cursorOrder(String? tags) {
    for (final tag in (tags ?? '').split(' ')) {
      final order = RegExp(r'^order:(.+)$').firstMatch(tag);
      if (order != null && !{'new', 'id', 'id_desc'}.contains(order.group(1))) {
        return false;
      }
    }
    return true;
  }

  /// An invalid page or limit is [410].
  int _parseLimit(String? limit) {
    if (limit == null || limit.isEmpty) return recordsPerPage;
    final value = int.tryParse(limit);
    if (value == null || !RegExp(r'^\d+$').hasMatch(limit)) {
      throw FakeE621Error(410, 'Invalid limit.');
    }
    if (value < 0 || value > maxPerPage) {
      throw FakeE621Error(410, 'Limit must be between 0 and $maxPerPage.');
    }
    return value;
  }

  int _parsePage(String? page) {
    if (page == null || page.isEmpty) return 1;
    if (RegExp(r'^[ab]\d+$').hasMatch(page)) {
      throw FakeE621Error(501, 'sequential pagination is not implemented');
    }
    final value = int.tryParse(page);
    if (value == null || !RegExp(r'^\d+$').hasMatch(page)) {
      throw FakeE621Error(410, 'Invalid page number.');
    }
    if (value < 1) throw FakeE621Error(410, 'Invalid page number.');
    if (value > maxNumberedPages) {
      throw FakeE621Error(410, 'You cannot go beyond page $maxNumberedPages.');
    }
    return value;
  }

  Future<Map<String, String>> _readBody(Request request) async {
    final header = request.headers[HttpHeaders.contentTypeHeader];
    if (header == null) return {};
    final type = ContentType.parse(header);
    if (type.mimeType == 'multipart/form-data') {
      final boundary = type.parameters['boundary'];
      if (boundary == null) return {};
      final fields = <String, String>{};
      final parts = MimeMultipartTransformer(boundary).bind(request.read());
      await for (final part in parts) {
        final disposition = part.headers['content-disposition'] ?? '';
        final name = RegExp('name="([^"]*)"').firstMatch(disposition);
        final value = await utf8.decodeStream(part);
        if (name != null) fields[name.group(1)!] = value;
      }
      return fields;
    }
    if (type.mimeType == 'application/x-www-form-urlencoded') {
      return Uri.splitQueryString(await request.readAsString());
    }
    if (type.mimeType == 'application/json') {
      final decoded = jsonDecode(await request.readAsString());
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    }
    return {};
  }

  Response _json(Object? body, {int status = 200}) => Response(
    status,
    body: jsonEncode(body).replaceAll(fixtureHost, url),
    headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()},
  );
}

class FakeE621Error implements Exception {
  FakeE621Error(this.status, this.message);

  final int status;
  final String message;

  @override
  String toString() => 'FakeE621Error($status): $message';
}

class FakeRequest {
  FakeRequest({
    required this.method,
    required this.path,
    required this.query,
    required this.body,
  });

  final String method;
  final String path;
  final Map<String, String> query;
  final Map<String, String> body;

  @override
  String toString() => '$method $path $query $body';
}

class FakeE621State {
  FakeE621State({
    required this.posts,
    required this.favorites,
    required this.topics,
    required this.replies,
    required this.comments,
    required this.pools,
    required this.tags,
    required this.tagAliases,
    required this.users,
    required this.user,
    required this.wikis,
    required this.flags,
    required this.lockedTopics,
    required this.reportReasons,
  });

  factory FakeE621State.seeded({
    int? posts,
    int? topics,
    int? replies,
    int? comments,
  }) {
    final recordedTopics = _repeat(loadFixtureList('topics.json'), topics);
    final locked = recordedTopics[1];
    locked['is_locked'] = true;
    return FakeE621State(
      posts: _repeat(loadFixtureList('posts.json'), posts),
      favorites: {},
      topics: recordedTopics,
      replies: _repeat(loadFixtureList('replies.json'), replies),
      comments: _repeat(loadFixtureList('comments.json'), comments),
      pools: loadFixtureList('pools.json'),
      tags: loadFixtureList('tags.json'),
      tagAliases: loadFixtureList('tag_aliases.json'),
      users: loadFixtureList('users.json'),
      user: loadFixtureList('user.json').first,
      wikis: loadFixtureList('wiki_pages.json'),
      flags: loadFixtureList('flags.json'),
      lockedTopics: {locked['id']! as int},
      reportReasons: _postReportReasonIds,
    );
  }

  static const Set<int> _postReportReasonIds = {1, 2, 3, 4, 5, 6};

  static List<Map<String, Object?>> _repeat(
    List<Map<String, Object?>> templates,
    int? count,
  ) {
    if (count == null) return templates;
    final next =
        templates.map((e) => e['id']! as int).reduce((a, b) => a > b ? a : b) +
        1;
    return List.generate(count, (index) {
      final template = templates[index % templates.length];
      return {
        ...jsonDecode(jsonEncode(template)) as Map<String, Object?>,
        'id': next + index,
      };
    });
  }

  final List<Map<String, Object?>> posts;
  final Set<int> favorites;
  final List<Map<String, Object?>> topics;
  final List<Map<String, Object?>> replies;
  final List<Map<String, Object?>> comments;
  final List<Map<String, Object?>> pools;
  final List<Map<String, Object?>> tags;
  final List<Map<String, Object?>> tagAliases;
  final List<Map<String, Object?>> users;

  /// `/users/<id>` returns more fields than `/users`.
  final Map<String, Object?> user;
  final List<Map<String, Object?>> wikis;
  final List<Map<String, Object?>> flags;
  final Set<int> lockedTopics;
  final Set<int> reportReasons;

  int _nextId = 100;

  Map<String, Object?> addComment({required int postId, required String body}) {
    final now = DateTime.now().toIso8601String();
    final comment = <String, Object?>{
      ...jsonDecode(jsonEncode(comments.first)) as Map<String, Object?>,
      'id': _nextId++,
      'post_id': postId,
      'body': body,
      'created_at': now,
      'updated_at': now,
    };
    comments.add(comment);
    return comment;
  }

  Map<String, Object?> addReply({required int topicId, required String body}) {
    final now = DateTime.now().toIso8601String();
    final reply = <String, Object?>{
      'id': _nextId++,
      'creator_id': 2,
      'creator_name': 'tester',
      'created_at': now,
      'updated_at': now,
      'updater_id': null,
      'updater_name': null,
      'body': body,
      'topic_id': topicId,
      'warning_type': null,
      'is_hidden': false,
    };
    replies.add(reply);
    return reply;
  }
}
