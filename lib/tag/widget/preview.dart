import 'package:e1547/client/client.dart';
import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter/widgets.dart';

String tagPreviewKey(String term) => tagWithoutPrefix(term).toLowerCase();

List<String> tagPreviewNames(Iterable<String> terms) => {
  for (final String term in terms)
    if (tagPreviewKey(term) case final String name
        when name.isNotEmpty &&
            !name.contains(':') &&
            !name.contains(' ') &&
            !name.startsWith('('))
      name,
}.toList();

class TagPreviews {
  TagPreviews(Iterable<TagPreview> previews)
    : _byName = {
        for (final TagPreview preview in previews) preview.name: preview,
      };

  final Map<String, TagPreview> _byName;

  TagPreview? of(String term) => _byName[tagPreviewKey(term)];
}

class TagPreviewBuilder extends StatelessWidget {
  const TagPreviewBuilder({
    super.key,
    required this.terms,
    required this.builder,
  });

  final Iterable<String> terms;
  final Widget Function(BuildContext context, TagPreviews previews) builder;

  @override
  Widget build(BuildContext context) {
    final Client? client = context.watch<Client?>();
    if (client == null) return builder(context, TagPreviews(const []));
    return QueryBuilder(
      query: client.tags.usePreview(names: tagPreviewNames(terms)),
      builder: (context, state) =>
          builder(context, TagPreviews(state.data ?? const [])),
    );
  }
}
