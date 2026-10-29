import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MetaKind {
  date('Date', Icons.event),
  counts('Counts', Icons.trending_up),
  order('Order', Icons.sort),
  rating('Rating', Icons.shield_outlined),
  file('File type', Icons.insert_drive_file_outlined),
  size('Size & shape', Icons.aspect_ratio),
  people('People', Icons.person_outline),
  pools('Pools & sets', Icons.collections_outlined),
  properties('Properties', Icons.tune),
  family('Parent & child', Icons.account_tree_outlined),
  status('Status', Icons.flag_outlined),
  text('Text & source', Icons.notes);

  const MetaKind(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum CountKind {
  score('Score', 'score'),
  favorites('Favorites', 'favcount'),
  comments('Comments', 'comment_count'),
  tags('Tags', 'tagcount');

  const CountKind(this.label, this.key);

  final String label;
  final String key;

  static CountKind? byKey(String key) =>
      values.where((e) => e.key == key).firstOrNull;
}

enum MetaOrder {
  newest('Newest', 'id'),
  score('Score', 'score'),
  favorites('Favorites', 'favcount'),
  comments('Comments', 'comment_count'),
  bumped('Last commented', 'comment_bumped'),
  resolution('Resolution', 'mpixels'),
  filesize('File size', 'filesize'),
  duration('Duration', 'duration'),
  random('Random', 'random'),
  hot('Hot', 'rank');

  const MetaOrder(this.label, this.key);

  final String label;
  final String key;

  bool get directed => this != random && this != hot;

  static MetaOrder? byKey(String key) =>
      values.where((e) => e.key == key).firstOrNull;

  static ({MetaOrder order, bool lowest})? parse(String value) {
    final MetaOrder? order = byKey(
      value.replaceAll(RegExp(r'_(asc|desc)$'), ''),
    );
    if (order == null) return null;
    return (
      order: order,
      lowest: value.endsWith('_asc') || (order == newest && value == 'id'),
    );
  }

  String? term({required bool lowest}) {
    if (this == newest && !lowest) return null;
    return 'order:$key${directed && lowest ? '_asc' : ''}';
  }
}

enum DatePreset {
  today('Today', 'day', 'past day'),
  week('Past week', 'week', 'past week'),
  month('Past month', 'month', 'past month'),
  year('Past year', 'year', 'past year'),
  lastMonth('Last month', 'yestermonth', 'last month'),
  lastYear('Last year', 'yesteryear', 'last year');

  const DatePreset(this.label, this.value, this.words);

  final String label;
  final String value;
  final String words;

  static DatePreset? byValue(String value) =>
      values.where((e) => e.value == value).firstOrNull;
}

const Map<String, String> ratingNames = {
  's': 'Safe',
  'q': 'Questionable',
  'e': 'Explicit',
};

final DateFormat metaDateFormat = DateFormat('yyyy-MM-dd');
final DateFormat metaDateWords = DateFormat.MMMd();

({String key, String value})? splitMeta(String term) {
  final String body = term.startsWith('-') || term.startsWith('~')
      ? term.substring(1)
      : term;
  final int colon = body.indexOf(':');
  if (colon <= 0) return null;
  return (key: body.substring(0, colon), value: body.substring(colon + 1));
}

List<String> groupTerms(String term) {
  if (!term.endsWith(')')) return const [];
  final int open = term.indexOf('(');
  if (open == -1 || open > 1) return const [];
  return term
      .substring(open + 1, term.length - 1)
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList();
}

MetaKind? metaKindOf(String term) {
  final List<String> group = groupTerms(term);
  if (group.isNotEmpty) {
    final Set<MetaKind?> kinds = group.map(metaKindOf).toSet();
    return kinds.length == 1 ? kinds.single : null;
  }
  final meta = splitMeta(term);
  if (meta == null) return null;
  return switch (meta.key) {
    'date' => MetaKind.date,
    'score' || 'favcount' || 'comment_count' || 'tagcount' => MetaKind.counts,
    'order' => MetaKind.order,
    'rating' => MetaKind.rating,
    'type' || 'filetype' || 'duration' => MetaKind.file,
    'mpixels' || 'ratio' || 'filesize' => MetaKind.size,
    'fav' ||
    'votedup' ||
    'voteddown' ||
    'user' ||
    'commenter' ||
    'noter' => MetaKind.people,
    'pool' || 'set' => MetaKind.pools,
    'inpool' || 'artverified' => MetaKind.properties,
    'ischild' || 'isparent' || 'parent' => MetaKind.family,
    'status' => MetaKind.status,
    'hassource' ||
    'hasdescription' ||
    'source' ||
    'description' => MetaKind.text,
    _ => null,
  };
}

String rangeWords(String value) {
  if (value.startsWith('>=')) return '≥ ${value.substring(2)}';
  if (value.startsWith('<=')) return '≤ ${value.substring(2)}';
  if (value.startsWith('>')) return '> ${value.substring(1)}';
  if (value.startsWith('<')) return '< ${value.substring(1)}';
  if (value.startsWith('..')) return '≤ ${value.substring(2)}';
  if (value.endsWith('..')) return '≥ ${value.substring(0, value.length - 2)}';
  if (value.contains('..')) {
    final List<String> parts = value.split('..');
    return '${parts[0]} to ${parts[1]}';
  }
  return value;
}

String? dateWords(String value) {
  final DatePreset? preset = DatePreset.byValue(value);
  if (preset != null) return preset.words;
  String? day(String text) {
    final DateTime? date = DateTime.tryParse(text);
    return date == null ? null : metaDateWords.format(date);
  }

  if (value.contains('..')) {
    final List<String> parts = value.split('..');
    final String? from = day(parts[0]);
    final String? to = day(parts[1]);
    if (from == null || to == null) return null;
    return '$from to $to';
  }
  return day(value);
}

String? metaWords(String term) {
  final List<String> group = groupTerms(term);
  if (group.isNotEmpty) return groupWords(group);
  final meta = splitMeta(term);
  if (meta == null) return null;
  final String value = meta.value;
  return switch (meta.key) {
    'date' => dateWords(value),
    'score' || 'favcount' || 'comment_count' || 'tagcount' =>
      '${CountKind.byKey(meta.key)!.label.toLowerCase()} '
          '${rangeWords(value)}',
    'order' => switch (MetaOrder.parse(value)) {
      (order: MetaOrder.random, lowest: _) => 'random order',
      (order: MetaOrder.newest, :final bool lowest) =>
        lowest ? 'oldest first' : 'newest first',
      (:final MetaOrder order, :final bool lowest) =>
        lowest
            ? 'by ${order.label.toLowerCase()}, lowest first'
            : 'by ${order.label.toLowerCase()}',
      null => null,
    },
    'rating' => ratingNames[value]?.toLowerCase(),
    'type' || 'filetype' => fileTypeWords([value]),
    'duration' =>
      LengthOption.byValue(value)?.words ?? '${rangeWords(value)} s',
    'mpixels' => '${rangeWords(value)} MP',
    'ratio' => ShapeOption.byValue(value)?.label.toLowerCase(),
    'filesize' => FileSizeOption.byValue(value)?.words,
    'fav' || 'votedup' || 'voteddown' || 'user' || 'commenter' || 'noter' =>
      '${PeopleRelation.byKey(meta.key)!.words} '
          '${value.replaceAll('_', ' ')}',
    'inpool' ||
    'hassource' ||
    'hasdescription' ||
    'ischild' ||
    'isparent' ||
    'artverified' => switch (value.toLowerCase()) {
      'true' => PostProperty.byKey(meta.key)!.yes,
      'false' => PostProperty.byKey(meta.key)!.no,
      _ => null,
    },
    'status' => switch (PostStatus.byValue(value)) {
      PostStatus.any => 'any status',
      final PostStatus status => status.label.toLowerCase(),
      null => null,
    },
    _ => null,
  };
}

enum FileKind {
  images('Images', ['jpg', 'png', 'webp']),
  animated('Animated', ['gif', 'apng']),
  videos('Videos', ['mp4', 'webm']),
  flash('Flash', ['swf']);

  const FileKind(this.label, this.types);

  final String label;
  final List<String> types;
}

enum LengthOption {
  short('Under 30 s', '<30', 'under 30 s'),
  medium('30 s to 2 min', '30..120', '30 s to 2 min'),
  long('Over 2 min', '>120', 'over 2 min');

  const LengthOption(this.label, this.value, this.words);

  final String label;
  final String value;
  final String words;

  static LengthOption? byValue(String value) =>
      values.where((e) => e.value == value).firstOrNull;
}

enum ResolutionOption {
  one('≥ 1 MP', '>=1'),
  four('≥ 4 MP', '>=4'),
  sixteen('≥ 16 MP', '>=16');

  const ResolutionOption(this.label, this.value);

  final String label;
  final String value;
}

enum ShapeOption {
  portrait('Portrait', '<1'),
  square('Square', '1'),
  landscape('Landscape', '>1');

  const ShapeOption(this.label, this.value);

  final String label;
  final String value;

  static ShapeOption? byValue(String value) =>
      values.where((e) => e.value == value).firstOrNull;
}

enum FileSizeOption {
  two('Under 2 MB', '<2MB', 'under 2 MB'),
  ten('Under 10 MB', '<10MB', 'under 10 MB');

  const FileSizeOption(this.label, this.value, this.words);

  final String label;
  final String value;
  final String words;

  static FileSizeOption? byValue(String value) =>
      values.where((e) => e.value == value).firstOrNull;
}

enum PeopleRelation {
  favorited('Favorited', 'fav', 'favorited by'),
  upvoted('Upvoted', 'votedup', 'upvoted by'),
  downvoted('Downvoted', 'voteddown', 'downvoted by'),
  uploaded('Uploaded', 'user', 'uploaded by'),
  commented('Commented on', 'commenter', 'commented on by'),
  noted('Noted', 'noter', 'noted by');

  const PeopleRelation(this.label, this.key, this.words);

  final String label;
  final String key;
  final String words;

  static PeopleRelation? byKey(String key) =>
      values.where((e) => e.key == key).firstOrNull;
}

enum PostProperty {
  inPool('In a pool', 'inpool', 'in a pool', 'not in a pool'),
  hasSource('Has source', 'hassource', 'has source', 'no source'),
  hasDescription(
    'Has description',
    'hasdescription',
    'has description',
    'no description',
  ),
  hasParent('Has parent', 'ischild', 'has parent', 'no parent'),
  hasChildren('Has children', 'isparent', 'has children', 'no children'),
  verified('Verified artist', 'artverified', 'verified artist', 'unverified');

  const PostProperty(this.label, this.key, this.yes, this.no);

  final String label;
  final String key;
  final String yes;
  final String no;

  static PostProperty? byKey(String key) =>
      values.where((e) => e.key == key).firstOrNull;
}

enum PostStatus {
  active('Active', null),
  pending('Pending', 'pending'),
  flagged('Flagged', 'flagged'),
  deleted('Deleted', 'deleted'),
  any('Any', 'any');

  const PostStatus(this.label, this.value);

  final String label;
  final String? value;

  static PostStatus? byValue(String value) =>
      values.where((e) => e.value == value).firstOrNull;
}

String? fileTypeWords(List<String> types) {
  for (final FileKind kind in FileKind.values) {
    if (kind.types.toSet().containsAll(types) &&
        types.toSet().containsAll(kind.types)) {
      return kind.label.toLowerCase();
    }
  }
  return types.join(' or ');
}

String? groupWords(List<String> terms) {
  final List<({String key, String value})?> metas = terms
      .map((e) => splitMeta(e))
      .toList();
  if (metas.isEmpty || metas.any((e) => e == null)) return null;
  if (metas.every((e) => e!.key == 'type' || e.key == 'filetype')) {
    return fileTypeWords(metas.map((e) => e!.value).toList());
  }
  return null;
}
