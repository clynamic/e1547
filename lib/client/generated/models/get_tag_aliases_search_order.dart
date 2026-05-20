// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum GetTagAliasesSearchOrder {
  @JsonValue('id_desc')
  idDesc('id_desc'),
  @JsonValue('id_asc')
  idAsc('id_asc'),
  @JsonValue('status')
  status('status'),
  @JsonValue('created_at')
  createdAt('created_at'),
  @JsonValue('updated_at')
  updatedAt('updated_at'),
  @JsonValue('name')
  name('name'),
  @JsonValue('tag_count')
  tagCount('tag_count'),
  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const GetTagAliasesSearchOrder(this.json);

  factory GetTagAliasesSearchOrder.fromJson(String json) => values.firstWhere(
        (e) => e.json == json,
        orElse: () => $unknown,
      );

  final String? json;

  @override
  String toString() => json?.toString() ?? super.toString();
  /// Returns all defined enum values excluding the $unknown value.
  static List<GetTagAliasesSearchOrder> get $valuesDefined => values.where((value) => value != $unknown).toList();
}
