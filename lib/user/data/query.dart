import 'package:e1547/query/query.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';

extension UserQuerying on UserClient {
  static const queryDomain = 'users';

  List<Object> get queryKey => dio.identityQueryKey(queryDomain);

  CachedQuery get queryCache => dio.queryCache!;

  QueryBridge<User, int> get userCache =>
      queryCache.bridge(queryKey, fromJson: User.fromJson);

  QueryBridge<User, int> get summaryCache =>
      queryCache.bridge([...queryKey, 'summary'], fromJson: User.fromJson);

  Query<User> useSummary({required int id}) => Query(
    cache: queryCache,
    key: [...queryKey, 'summary', id],
    queryFn: () => throw StateError('user summaries load in batches'),
    config: summaryCache.getConfig(vendored: true),
  );

  Query<User> useGet({required int id, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, id],
    queryFn: () => get(id: id),
    config: userCache.getConfig(vendored: vendored),
  );

  Query<User> useGetByName({required String name, bool? vendored}) => Query(
    cache: queryCache,
    key: [...queryKey, 'name', name],
    queryFn: () async {
      final user = await getByName(name: name);
      userCache.set(user);
      return user;
    },
    config: userCache.getConfig(vendored: vendored),
  );
}
