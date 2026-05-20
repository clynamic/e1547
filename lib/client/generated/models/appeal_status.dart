// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

/// The current status of the appeal
@JsonEnum()
enum AppealStatus {
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('partial')
  partial('partial'),
  @JsonValue('approved')
  approved('approved'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const AppealStatus(this.json);

  factory AppealStatus.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<AppealStatus> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
