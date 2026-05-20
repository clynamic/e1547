// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetUsersSearchOrder {
  @JsonValue('date')
  date('date'),
  @JsonValue('name')
  name('name'),
  @JsonValue('post_upload_count')
  postUploadCount('post_upload_count'),
  @JsonValue('note_count')
  noteCount('note_count'),
  @JsonValue('post_update_count')
  postUpdateCount('post_update_count'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetUsersSearchOrder(this.json);

  factory GetUsersSearchOrder.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetUsersSearchOrder> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
