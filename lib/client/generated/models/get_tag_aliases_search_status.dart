// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetTagAliasesSearchStatus {
  @JsonValue('Approved')
  approved('Approved'),
  @JsonValue('Active')
  active('Active'),
  @JsonValue('Pending')
  pending('Pending'),
  @JsonValue('Deleted')
  deleted('Deleted'),
  @JsonValue('Retired')
  retired('Retired'),
  @JsonValue('Processing')
  processing('Processing'),
  @JsonValue('Queued')
  queued('Queued'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetTagAliasesSearchStatus(this.json);

  factory GetTagAliasesSearchStatus.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetTagAliasesSearchStatus> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
