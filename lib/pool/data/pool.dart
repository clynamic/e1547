import 'package:e1547/pool/pool.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pool.freezed.dart';
part 'pool.g.dart';

@freezed
abstract class Pool with _$Pool {
  const factory Pool({
    required int id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String description,
    required List<int> postIds,
    required int postCount,
    required bool active,
    @Default(PoolCategory.series) PoolCategory category,
  }) = _Pool;

  factory Pool.fromJson(dynamic json) => _$PoolFromJson(json);
}
