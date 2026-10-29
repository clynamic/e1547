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

MetaKind? metaKindOf(String term) {
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
    _ => null,
  };
}
