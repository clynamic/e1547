import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';

extension TagQuerying on TagClient {
  static const queryDomain = 'tags';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<TagPreview, String> get previewCache => queryCache.bridge([
    ...queryKey,
    'preview',
  ], getId: (preview) => preview.name);

  Query<List<TagPreview>> usePreview({required List<String> names}) => Query(
    cache: queryCache,
    key: [...queryKey, 'previews', names.join(' ')],
    queryFn: () async {
      final List<String> wanted = {
        for (final String name in names) name.toLowerCase(),
      }.toList();
      await previews.request(wanted);
      return [
        for (final String name in wanted)
          if (previewCache.get(name) case final TagPreview preview) preview,
      ];
    },
  );

  Query<List<Tag>> useAutocomplete({required String search}) => Query(
    cache: queryCache,
    key: [...queryKey, 'autocomplete', search],
    queryFn: () => autocomplete(search: search),
  );
}
