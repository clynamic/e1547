// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'get_pool_element_recent_json_response.g.dart';

@JsonSerializable()
class GetPoolElementRecentJsonResponse {
  const GetPoolElementRecentJsonResponse({
    this.id,
    this.name,
  });
  
  factory GetPoolElementRecentJsonResponse.fromJson(Map<String, Object?> json) => _$GetPoolElementRecentJsonResponseFromJson(json);
  
  /// The pool ID
  final int? id;

  /// The pool name
  final String? name;

  Map<String, Object?> toJson() => _$GetPoolElementRecentJsonResponseToJson(this);
}
