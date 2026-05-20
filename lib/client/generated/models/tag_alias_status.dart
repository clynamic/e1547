// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The current status of the tag alias
@JsonEnum()
enum TagAliasStatus {
  @JsonValue('active')
  active('active'),
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('deleted')
  deleted('deleted'),
  @JsonValue('retired')
  retired('retired'),
  @JsonValue('processing')
  processing('processing'),
  @JsonValue('queued')
  queued('queued'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TagAliasStatus(this.json);

  factory TagAliasStatus.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<TagAliasStatus> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
