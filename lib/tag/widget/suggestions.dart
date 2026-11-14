import 'package:e1547/client/client.dart';
// ignore: feature_layering
import 'package:e1547/pool/pool.dart';
import 'package:e1547/tag/tag.dart';
// ignore: feature_layering
import 'package:e1547/user/user.dart';

Future<List<TagSuggestion>> suggestTerm(
  Client client,
  String term, {
  int? category,
}) async {
  final MetatagTerm typed = splitMetatagTerm(term);
  final String prefix = typed.prefix;
  if (category != null) {
    return [
      for (final Tag tag in await client.tags.autocomplete(
        search: tagToRaw(term),
        category: category,
        limit: 3,
      ))
        TagSuggestion(
          name: '$prefix${tag.name}',
          category: tag.category,
          count: tag.count,
        ),
    ];
  }
  final String value = typed.value;
  final bool searchable =
      value.replaceAll('*', '').trim().length >= suggestionMinLength;
  TagSuggestion named(String name, {bool complete = true}) => TagSuggestion(
    name: '$prefix$name',
    category: TagCategory.meta.id,
    complete: complete,
  );
  Future<List<TagSuggestion>> found() async => [
    for (final Tag tag in await client.tags.autocomplete(search: value))
      TagSuggestion(
        name: '$prefix${tag.name}',
        category: tag.category,
        count: tag.count,
      ),
  ];
  switch (typed.metatag) {
    case null:
      if (value.length < suggestionMinLength) return const [];
      return [
        for (final String match in staticMetatagMatches('type', value))
          named(match),
        ...await found(),
        for (final String match in metatagNameMatches(value).take(3))
          named(match, complete: false),
      ];
    case final String metatag when staticMetatagValues.containsKey(metatag):
      return staticMetatagMatches(metatag, value).map(named).toList();
    case final String metatag when userMetatagNames.contains(metatag):
      if (!searchable) return const [];
      final List<PartialUser> users = await client.users.search(
        name: value.trim(),
        limit: metatagSuggestionLimit,
      );
      return [
        for (final PartialUser user in users) named('$metatag:${user.name}'),
      ];
    case 'pool':
      if (!searchable) return const [];
      final List<Pool> pools = await client.pools.page(
        limit: metatagSuggestionLimit,
        query: {
          'search[name_matches]': value.trim(),
          'search[order]': 'post_count',
        },
      );
      return [for (final Pool pool in pools) named('pool:${pool.name}')];
    case final String metatag when tagCategoryNames.contains(metatag):
      if (!searchable) return const [];
      return found();
    default:
      return const [];
  }
}
