// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetAvoidPostingsSearchOrder {
  @JsonValue('artist_name')
  artistName('artist_name'),
  @JsonValue('artist_name_asc')
  artistNameAsc('artist_name_asc'),
  @JsonValue('artist_name_desc')
  artistNameDesc('artist_name_desc'),
  @JsonValue('created_at')
  createdAt('created_at'),
  @JsonValue('updated_at')
  updatedAt('updated_at'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetAvoidPostingsSearchOrder(this.json);

  factory GetAvoidPostingsSearchOrder.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetAvoidPostingsSearchOrder> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
