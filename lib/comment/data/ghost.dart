part of 'comment.dart';

class CommentGhost extends Comment with Ghost {
  const CommentGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  int get id => -1 - index;

  @override
  int get postId => -1;

  @override
  String get body => words(1, 3, 12);

  @override
  DateTime get createdAt => DateTime(2000 + count(2, 20));

  @override
  DateTime get updatedAt => DateTime(2000 + count(3, 20));

  @override
  int get creatorId => -1;

  @override
  String get creatorName => words(4, 1);

  @override
  int get score => count(5, 50);

  @override
  int? get vote => null;

  @override
  WarningType? get warning => null;

  @override
  bool get hidden => false;

  @override
  $CommentCopyWith<Comment> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
