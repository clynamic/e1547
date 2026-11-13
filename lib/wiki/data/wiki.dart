import 'package:e1547/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost.dart';
part 'wiki.freezed.dart';
part 'wiki.g.dart';

@freezed
abstract class Wiki with _$Wiki {
  const factory Wiki({
    required int id,
    required String title,
    required String body,
    required DateTime createdAt,
    DateTime? updatedAt,
    List<String>? otherNames,
    bool? isLocked,
  }) = _Wiki;

  const Wiki._();

  factory Wiki.fromJson(dynamic json) => _$WikiFromJson(json);
}
