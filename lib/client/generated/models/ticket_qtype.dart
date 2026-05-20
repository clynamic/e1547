// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The type of ticket (e.g., comment, user, post)
@JsonEnum()
enum TicketQtype {
  @JsonValue('user')
  user('user'),
  @JsonValue('comment')
  comment('comment'),
  @JsonValue('forum')
  forum('forum'),
  @JsonValue('blip')
  blip('blip'),
  @JsonValue('wiki')
  wiki('wiki'),
  @JsonValue('pool')
  pool('pool'),
  /// The name has been replaced because it contains a keyword. Original name: `set`.
  @JsonValue('set')
  valueSet('set'),
  @JsonValue('post')
  post('post'),
  @JsonValue('dmail')
  dmail('dmail'),
  @JsonValue('replacement')
  replacement('replacement'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const TicketQtype(this.json);

  factory TicketQtype.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<TicketQtype> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
