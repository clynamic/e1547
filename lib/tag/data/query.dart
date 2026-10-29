import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';

extension TagQuerying on TagClient {
  static const queryDomain = 'tags';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  Query<List<TagPreview>> usePreview({required List<String> names}) => Query(
    cache: queryCache,
    key: [...queryKey, 'preview', names.join(' ')],
    queryFn: () => names.isEmpty
        ? Future.value(const <TagPreview>[])
        : preview(tags: names.join(' ')),
  );

  Query<List<Tag>> useAutocomplete({required String search}) => Query(
    cache: queryCache,
    key: [...queryKey, 'autocomplete', search],
    queryFn: () => autocomplete(search: search),
  );
}
