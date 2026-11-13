part of 'user.dart';

class UserGhost extends User with Ghost {
  const UserGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  int get id => -1 - index;

  @override
  String get name => words(1, 1);

  @override
  int? get avatarId => null;

  @override
  bool get hasCroppedAvatar => false;

  @override
  UserAbout? get about => UserAbout(bio: words(2, 20, 60), comission: null);

  @override
  UserStats? get stats => UserStats(
    createdAt: DateTime(2000 + count(3, 20)),
    levelString: words(4, 1),
    favoriteCount: count(5, 5000),
    postUpdateCount: count(6, 5000),
    postUploadCount: count(7, 500),
    forumPostCount: count(8, 500),
    commentCount: count(9, 500),
  );

  @override
  $UserCopyWith<User> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
