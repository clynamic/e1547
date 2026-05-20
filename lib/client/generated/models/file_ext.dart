// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The file extension (e.g., jpg, png, webm)
@JsonEnum()
enum FileExt {
  @JsonValue('jpg')
  jpg('jpg'),
  @JsonValue('png')
  png('png'),
  @JsonValue('gif')
  gif('gif'),
  @JsonValue('webm')
  webm('webm'),
  @JsonValue('mp4')
  mp4('mp4'),
  @JsonValue('swf')
  swf('swf'),
  @JsonValue('apng')
  apng('apng'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const FileExt(this.json);

  factory FileExt.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<FileExt> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
