// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The rating of the post (e.g., safe, questionable, explicit)
@JsonEnum()
enum PostRating {
  @JsonValue('s')
  s('s'),
  @JsonValue('q')
  q('q'),
  @JsonValue('e')
  e('e'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const PostRating(this.json);

  factory PostRating.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<PostRating> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
