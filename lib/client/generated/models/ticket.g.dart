// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  id: (json['id'] as num).toInt(),
  creatorId: (json['creator_id'] as num).toInt(),
  reason: json['reason'] as String,
  dispId: (json['disp_id'] as num).toInt(),
  qtype: TicketQtype.fromJson(json['qtype'] as String),
  status: AppealStatus.fromJson(json['status'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  response: json['response'] as String,
  handlerId: (json['handler_id'] as num).toInt(),
  claimantId: (json['claimant_id'] as num?)?.toInt(),
  reportReason: json['report_reason'] as String?,
  accusedId: (json['accused_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'creator_id': instance.creatorId,
  'reason': instance.reason,
  'disp_id': instance.dispId,
  'qtype': _$TicketQtypeEnumMap[instance.qtype]!,
  'status': _$AppealStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'response': instance.response,
  'handler_id': instance.handlerId,
  'claimant_id': instance.claimantId,
  'report_reason': instance.reportReason,
  'accused_id': instance.accusedId,
};

const _$TicketQtypeEnumMap = {
  TicketQtype.user: 'user',
  TicketQtype.comment: 'comment',
  TicketQtype.forum: 'forum',
  TicketQtype.blip: 'blip',
  TicketQtype.wiki: 'wiki',
  TicketQtype.pool: 'pool',
  TicketQtype.valueSet: 'set',
  TicketQtype.post: 'post',
  TicketQtype.dmail: 'dmail',
  TicketQtype.replacement: 'replacement',
  TicketQtype.$unknown: r'$unknown',
};

const _$AppealStatusEnumMap = {
  AppealStatus.pending: 'pending',
  AppealStatus.partial: 'partial',
  AppealStatus.approved: 'approved',
  AppealStatus.$unknown: r'$unknown',
};
