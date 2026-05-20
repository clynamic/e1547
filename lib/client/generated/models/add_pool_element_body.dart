// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'add_pool_element_body.g.dart';

@JsonSerializable()
class AddPoolElementBody {
  const AddPoolElementBody({
    required this.postId,
    this.poolId,
    this.poolName,
  });
  
  factory AddPoolElementBody.fromJson(Map<String, Object?> json) => _$AddPoolElementBodyFromJson(json);
  
  /// The ID of the pool
  @JsonKey(name: 'pool_id')
  final int? poolId;

  /// The name of the pool (alternative to pool_id)
  @JsonKey(name: 'pool_name')
  final String? poolName;

  /// The ID of the post to add
  @JsonKey(name: 'post_id')
  final int postId;

  Map<String, Object?> toJson() => _$AddPoolElementBodyToJson(this);
}
