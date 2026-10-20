import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum PostOrder {
  newest('new'),
  score('score'),
  favcount('favcount'),
  rank('rank'),
  random('random');

  const PostOrder(this.value);

  final String value;
}

@freezed
abstract class PostParams with _$PostParams {
  const factory PostParams({String? tags}) = _PostParams;

  const PostParams._();

  QueryMap toQuery() => <String, Object?>{'tags': tags}.toQuery();

  /// The id of the pool this search lists, when its tags are a pool tag with
  /// at most an order.
  int? get poolId {
    final map = TagMap(tags);
    final id = int.tryParse(map['pool'] ?? '');
    if (id == null) return null;
    if (map.length == 1) return id;
    if (map.length == 2 && map['order'] != null) return id;
    return null;
  }

  bool get poolOldestFirst {
    final order = TagMap(tags)['order'];
    return order == null || order == 'pool';
  }

  static final tagsFilter = NestedFilterTag(
    tag: 'tags',
    decode: TagMap.new,
    encode: (value) => TagMap.from(value).toString(),
    filters: [
      NumberRangeFilterTag(
        tag: 'score',
        name: t('Score'),
        min: 0,
        max: 100,
        division: 10,
        initial: const NumberRange(
          20,
          comparison: NumberComparison.greaterThanOrEqual,
        ),
        icon: const Icon(Icons.arrow_upward),
      ),
      NumberRangeFilterTag(
        tag: 'favcount',
        name: t('Favorite count'),
        min: 0,
        max: 100,
        division: 10,
        initial: const NumberRange(
          20,
          comparison: NumberComparison.greaterThanOrEqual,
        ),
        icon: const Icon(Icons.favorite),
      ),
      EnumFilterTag<PostOrder>(
        tag: 'order',
        name: t('Sort by'),
        values: PostOrder.values,
        valueMapper: (value) => value.value,
        nameMapper: (value) => switch (value) {
          PostOrder.newest => t('New'),
          PostOrder.score => t('Score'),
          PostOrder.favcount => t('Favorites'),
          PostOrder.rank => t('Rank'),
          PostOrder.random => t('Random'),
        },
        undefinedOption: EnumFilterNullTagValue(name: t('Default')),
        icon: const Icon(Icons.sort),
      ),
      EnumFilterTag(
        tag: 'rating',
        name: t('Rating'),
        values: Rating.values,
        valueMapper: (value) => value.name,
        nameMapper: (value) => switch (value) {
          Rating.s => t('Safe'),
          Rating.q => t('Questionable'),
          Rating.e => t('Explicit'),
        },
        undefinedOption: EnumFilterNullTagValue(name: t('All')),
        icon: const Icon(Icons.question_mark),
      ),
      BooleanFilterTag(
        tag: 'inpool',
        name: t('Pool'),
        description: t('Has pool'),
        tristate: true,
      ),
      BooleanFilterTag(
        tag: 'ischild',
        name: t('Child'),
        description: t('Is child post'),
        tristate: true,
      ),
      BooleanFilterTag(
        tag: 'isparent',
        name: t('Parent'),
        description: t('Is parent post'),
        tristate: true,
      ),
      ChoiceFilterTag(
        tag: 'date',
        name: t('Upload date'),
        options: [
          ChoiceFilterTagValue(value: null, name: t('All')),
          ChoiceFilterTagValue(value: 'day', name: t('Last day')),
          ChoiceFilterTagValue(value: 'week', name: t('Last week')),
          ChoiceFilterTagValue(value: 'month', name: t('Last Month')),
          ChoiceFilterTagValue(value: 'year', name: t('Last Year')),
        ],
        icon: const Icon(Icons.date_range),
      ),
      ChoiceFilterTag(
        tag: 'status',
        name: t('Status'),
        options: [
          ChoiceFilterTagValue(value: null, name: t('Default')),
          ChoiceFilterTagValue(value: 'active', name: t('Active')),
          ChoiceFilterTagValue(value: 'pending', name: t('Pending')),
          ChoiceFilterTagValue(value: 'deleted', name: t('Deleted')),
          ChoiceFilterTagValue(value: 'flagged', name: t('Flagged')),
          ChoiceFilterTagValue(value: 'any', name: t('Any')),
        ],
        icon: const Icon(Icons.help),
      ),
    ],
  );
}

enum PostDisplayType { grid, comic, timeline }

class PostDisplayController extends ValueNotifier<PostDisplayType> {
  PostDisplayController([PostDisplayType? initial])
    : super(initial ?? PostDisplayType.grid);
}

class PostParamsController extends ValueNotifier<PostParams> {
  PostParamsController({PostParams? initial, this.canSearch = true})
    : super(initial ?? const PostParams());

  /// Whether the owning page offers search affordances, meaning the tag
  /// actions and the search button. The mutating methods below are not gated.
  final bool canSearch;

  void update(PostParams Function(PostParams) updater) =>
      value = updater(value);

  TagMap get _tagMap => TagMap(value.tags);

  void _writeTags(TagMap map) =>
      update((p) => p.copyWith(tags: map.toString()));

  void addTag(String tag) => _writeTags(_tagMap..add(tag));

  void removeTag(String tag) => _writeTags(_tagMap..remove(tag));

  void subtractTag(String tag) => addTag('-$tag');

  bool hasTag(String tag) => _tagMap.containsKey(tag);
}
