// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  file: File.fromJson(json['file'] as Map<String, dynamic>),
  preview: Preview.fromJson(json['preview'] as Map<String, dynamic>),
  sample: Sample.fromJson(json['sample'] as Map<String, dynamic>),
  score: Score.fromJson(json['score'] as Map<String, dynamic>),
  tags: Tags.fromJson(json['tags'] as Map<String, dynamic>),
  lockedTags: (json['locked_tags'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  changeSeq: (json['change_seq'] as num).toInt(),
  flags: Flags.fromJson(json['flags'] as Map<String, dynamic>),
  rating: PostRating.fromJson(json['rating'] as String),
  favCount: (json['fav_count'] as num).toInt(),
  sources: (json['sources'] as List<dynamic>).map((e) => e as String).toList(),
  pools: (json['pools'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  relationships: Relationships.fromJson(
    json['relationships'] as Map<String, dynamic>,
  ),
  uploaderId: (json['uploader_id'] as num).toInt(),
  description: json['description'] as String,
  commentCount: (json['comment_count'] as num).toInt(),
  hasNotes: json['has_notes'] as bool,
  approverId: (json['approver_id'] as num?)?.toInt(),
  uploaderName: json['uploader_name'] as String?,
  isFavorited: json['is_favorited'] as bool?,
  duration: json['duration'] as num?,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'file': instance.file,
  'preview': instance.preview,
  'sample': instance.sample,
  'score': instance.score,
  'tags': instance.tags,
  'locked_tags': instance.lockedTags,
  'change_seq': instance.changeSeq,
  'flags': instance.flags,
  'rating': _$PostRatingEnumMap[instance.rating]!,
  'fav_count': instance.favCount,
  'sources': instance.sources,
  'pools': instance.pools,
  'relationships': instance.relationships,
  'approver_id': instance.approverId,
  'uploader_id': instance.uploaderId,
  'uploader_name': instance.uploaderName,
  'description': instance.description,
  'comment_count': instance.commentCount,
  'is_favorited': instance.isFavorited,
  'has_notes': instance.hasNotes,
  'duration': instance.duration,
};

const _$PostRatingEnumMap = {
  PostRating.s: 's',
  PostRating.q: 'q',
  PostRating.e: 'e',
  PostRating.$unknown: r'$unknown',
};
