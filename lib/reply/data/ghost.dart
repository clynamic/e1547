part of 'reply.dart';

class ReplyGhost extends Reply with Ghost {
  const ReplyGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  int get id => -1 - index;

  @override
  int get creatorId => -1;

  @override
  String get creator => words(1, 1);

  @override
  DateTime get createdAt => DateTime(2000 + count(2, 20));

  @override
  int? get updaterId => null;

  @override
  String? get updater => null;

  @override
  DateTime get updatedAt => DateTime(2000 + count(3, 20));

  @override
  String get body => words(4, 8, 24);

  @override
  int get topicId => -1;

  @override
  WarningType? get warning => null;

  @override
  bool get hidden => false;

  @override
  $ReplyCopyWith<Reply> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
