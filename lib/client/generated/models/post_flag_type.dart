// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The type of the flag (e.g., flag or deletion)
@JsonEnum()
enum PostFlagType {
  @JsonValue('flag')
  flag('flag'),
  @JsonValue('deletion')
  deletion('deletion'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PostFlagType(this.json);

  factory PostFlagType.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<PostFlagType> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
