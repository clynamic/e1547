// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetEditHistoriesSearchOrder {
  @JsonValue('updated_at')
  updatedAt('updated_at'),
  @JsonValue('updated_at_desc')
  updatedAtDesc('updated_at_desc'),
  @JsonValue('id')
  id('id'),
  @JsonValue('id_desc')
  idDesc('id_desc'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetEditHistoriesSearchOrder(this.json);

  factory GetEditHistoriesSearchOrder.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetEditHistoriesSearchOrder> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
