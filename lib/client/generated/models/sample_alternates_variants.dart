// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'sample_alternates_variants.g.dart';

@JsonSerializable()
class SampleAlternatesVariants {
  const SampleAlternatesVariants({
    this.codec,
    this.url,
    this.width,
    this.height,
  });
  
  factory SampleAlternatesVariants.fromJson(Map<String, Object?> json) => _$SampleAlternatesVariantsFromJson(json);
  
  final String? codec;
  final String? url;
  final int? width;
  final int? height;

  Map<String, Object?> toJson() => _$SampleAlternatesVariantsToJson(this);
}
