// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_alias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagAlias _$TagAliasFromJson(Map<String, dynamic> json) => TagAlias(
  id: (json['id'] as num).toInt(),
  antecedentName: json['antecedent_name'] as String,
  consequentName: json['consequent_name'] as String,
  status: TagAliasStatus.fromJson(json['status'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  creatorId: (json['creator_id'] as num).toInt(),
  reason: json['reason'] as String?,
  approverId: (json['approver_id'] as num?)?.toInt(),
  forumPostId: (json['forum_post_id'] as num?)?.toInt(),
  forumTopicId: (json['forum_topic_id'] as num?)?.toInt(),
  postCount: (json['post_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$TagAliasToJson(TagAlias instance) => <String, dynamic>{
  'id': instance.id,
  'antecedent_name': instance.antecedentName,
  'consequent_name': instance.consequentName,
  'status': _$TagAliasStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'reason': instance.reason,
  'creator_id': instance.creatorId,
  'approver_id': instance.approverId,
  'forum_post_id': instance.forumPostId,
  'forum_topic_id': instance.forumTopicId,
  'post_count': instance.postCount,
};

const _$TagAliasStatusEnumMap = {
  TagAliasStatus.active: 'active',
  TagAliasStatus.pending: 'pending',
  TagAliasStatus.deleted: 'deleted',
  TagAliasStatus.retired: 'retired',
  TagAliasStatus.processing: 'processing',
  TagAliasStatus.queued: 'queued',
  TagAliasStatus.$unknown: r'$unknown',
};
