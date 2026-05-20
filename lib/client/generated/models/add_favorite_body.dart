// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'add_favorite_body.g.dart';

@JsonSerializable()
class AddFavoriteBody {
  const AddFavoriteBody({
    required this.postId,
  });
  
  factory AddFavoriteBody.fromJson(Map<String, Object?> json) => _$AddFavoriteBodyFromJson(json);
  
  /// The ID of the post to favorite
  @JsonKey(name: 'post_id')
  final int postId;

  Map<String, Object?> toJson() => _$AddFavoriteBodyToJson(this);
}
