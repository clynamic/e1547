// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_blip_body_blip.g.dart';

@JsonSerializable()
class UpdateBlipBodyBlip {
  const UpdateBlipBodyBlip({
    this.body,
  });
  
  factory UpdateBlipBodyBlip.fromJson(Map<String, Object?> json) => _$UpdateBlipBodyBlipFromJson(json);
  
  /// The blip body text
  final String? body;

  Map<String, Object?> toJson() => _$UpdateBlipBodyBlipToJson(this);
}
