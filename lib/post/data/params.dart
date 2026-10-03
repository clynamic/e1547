import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';

enum PostOrder {
  newest('new'),
  oldest('id_asc'),
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
      const NumberRangeFilterTag(
        tag: 'score',
        name: 'Score',
        min: 0,
        max: 100,
        division: 10,
        initial: NumberRange(
          20,
          comparison: NumberComparison.greaterThanOrEqual,
        ),
        icon: Icon(Icons.arrow_upward),
      ),
      const NumberRangeFilterTag(
        tag: 'favcount',
        name: 'Favorite count',
        min: 0,
        max: 100,
        division: 10,
        initial: NumberRange(
          20,
          comparison: NumberComparison.greaterThanOrEqual,
        ),
        icon: Icon(Icons.favorite),
      ),
      EnumFilterTag<PostOrder>(
        tag: 'order',
        name: 'Sort by',
        values: PostOrder.values,
        valueMapper: (value) => value.value,
        nameMapper: (value) => switch (value) {
          PostOrder.newest => 'New',
          PostOrder.oldest => 'Oldest',
          PostOrder.score => 'Score',
          PostOrder.favcount => 'Favorites',
          PostOrder.rank => 'Rank',
          PostOrder.random => 'Random',
        },
        undefinedOption: const EnumFilterNullTagValue(name: 'Default'),
        icon: const Icon(Icons.sort),
      ),
      EnumFilterTag(
        tag: 'rating',
        name: 'Rating',
        values: Rating.values,
        valueMapper: (value) => value.name,
        nameMapper: (value) => switch (value) {
          Rating.s => 'Safe',
          Rating.q => 'Questionable',
          Rating.e => 'Explicit',
        },
        undefinedOption: const EnumFilterNullTagValue(name: 'All'),
        icon: const Icon(Icons.question_mark),
      ),
      const BooleanFilterTag(
        tag: 'inpool',
        name: 'Pool',
        description: 'Has pool',
        tristate: true,
      ),
      const BooleanFilterTag(
        tag: 'ischild',
        name: 'Child',
        description: 'Is child post',
        tristate: true,
      ),
      const BooleanFilterTag(
        tag: 'isparent',
        name: 'Parent',
        description: 'Is parent post',
        tristate: true,
      ),
      const ChoiceFilterTag(
        tag: 'date',
        name: 'Upload date',
        options: [
          ChoiceFilterTagValue(value: null, name: 'All'),
          ChoiceFilterTagValue(value: 'day', name: 'Last day'),
          ChoiceFilterTagValue(value: 'week', name: 'Last week'),
          ChoiceFilterTagValue(value: 'month', name: 'Last Month'),
          ChoiceFilterTagValue(value: 'year', name: 'Last Year'),
        ],
        icon: Icon(Icons.date_range),
      ),
      const ChoiceFilterTag(
        tag: 'status',
        name: 'Status',
        options: [
          ChoiceFilterTagValue(value: null, name: 'Default'),
          ChoiceFilterTagValue(value: 'active', name: 'Active'),
          ChoiceFilterTagValue(value: 'pending', name: 'Pending'),
          ChoiceFilterTagValue(value: 'deleted', name: 'Deleted'),
          ChoiceFilterTagValue(value: 'flagged', name: 'Flagged'),
          ChoiceFilterTagValue(value: 'any', name: 'Any'),
        ],
        icon: Icon(Icons.help),
      ),
      FileTypeFilterTag(),
      const TextFilterTag(
        tag: 'user',
        name: 'Uploader',
        icon: Icon(Icons.person),
      ),
      const NumberRangeFilterTag(
        tag: 'width',
        name: 'Width',
        min: 0,
        max: 10000,
        division: 100,
        icon: Icon(Icons.straighten),
      ),
      const NumberRangeFilterTag(
        tag: 'height',
        name: 'Height',
        min: 0,
        max: 10000,
        division: 100,
        icon: Icon(Icons.height),
      ),
      const NumberRangeFilterTag(
        tag: 'tagcount',
        name: 'Tag count',
        min: 0,
        max: 50,
        division: 10,
        icon: Icon(Icons.label),
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
