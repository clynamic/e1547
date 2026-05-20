// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetBulkUpdateRequestsSearchOrder {
  @JsonValue('status_desc')
  statusDesc('status_desc'),
  @JsonValue('updated_at_desc')
  updatedAtDesc('updated_at_desc'),
  @JsonValue('id_desc')
  idDesc('id_desc'),
  @JsonValue('id_asc')
  idAsc('id_asc'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetBulkUpdateRequestsSearchOrder(this.json);

  factory GetBulkUpdateRequestsSearchOrder.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetBulkUpdateRequestsSearchOrder> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
