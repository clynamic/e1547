// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_ticket_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTicketBody _$UpdateTicketBodyFromJson(Map<String, dynamic> json) =>
    UpdateTicketBody(
      object122: json['ticket[response]'] as String?,
      object123: json['ticket[status]'] == null
          ? null
          : AppealStatus.fromJson(json['ticket[status]'] as String),
      object124: json['ticket[record_type]'] as String?,
      object125: json['ticket[send_update_dmail]'] as bool?,
      forceClaim: json['force_claim'] as bool?,
    );

Map<String, dynamic> _$UpdateTicketBodyToJson(UpdateTicketBody instance) =>
    <String, dynamic>{
      'ticket[response]': instance.object122,
      'ticket[status]': _$AppealStatusEnumMap[instance.object123],
      'ticket[record_type]': instance.object124,
      'ticket[send_update_dmail]': instance.object125,
      'force_claim': instance.forceClaim,
    };

const _$AppealStatusEnumMap = {
  AppealStatus.pending: 'pending',
  AppealStatus.partial: 'partial',
  AppealStatus.approved: 'approved',
  AppealStatus.$unknown: r'$unknown',
};
