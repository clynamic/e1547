import 'package:e1547/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost.dart';
part 'user.freezed.dart';
part 'user.g.dart';

abstract class UserSummary {
  int get id;
  String get name;
  int? get avatarId;
  bool get hasCroppedAvatar;
}

@freezed
abstract class User with _$User implements UserSummary {
  const factory User({
    required int id,
    required String name,
    required int? avatarId,
    @Default(false) bool hasCroppedAvatar,
    required UserAbout? about,
    required UserStats? stats,
  }) = _User;

  const User._();

  factory User.fromJson(dynamic json) => _$UserFromJson(json);
}

@freezed
abstract class PartialUser with _$PartialUser implements UserSummary {
  const factory PartialUser({
    required int id,
    required String name,
    required int? avatarId,
    @Default(false) bool hasCroppedAvatar,
  }) = _PartialUser;

  factory PartialUser.fromJson(dynamic json) => _$PartialUserFromJson(json);
}

@freezed
abstract class UserAbout with _$UserAbout {
  const factory UserAbout({required String? bio, required String? comission}) =
      _UserAbout;

  factory UserAbout.fromJson(dynamic json) => _$UserAboutFromJson(json);
}

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({
    required DateTime? createdAt,
    required String? levelString,
    required int? favoriteCount,
    required int? postUpdateCount,
    required int? postUploadCount,
    required int? forumPostCount,
    required int? commentCount,
  }) = _UserStats;

  factory UserStats.fromJson(dynamic json) => _$UserStatsFromJson(json);
}
