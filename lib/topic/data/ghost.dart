part of 'topic.dart';

class TopicGhost extends Topic with Ghost {
  const TopicGhost([this.index = 0]) : super._();

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
  int get updaterId => -1;

  @override
  String get updater => words(3, 1);

  @override
  DateTime get updatedAt => DateTime(2000 + count(4, 20));

  @override
  String get title => words(5, 3, 6);

  @override
  int get responseCount => 1 + count(6, 100);

  @override
  bool get sticky => false;

  @override
  bool get locked => false;

  @override
  bool get hidden => false;

  @override
  int get categoryId => TopicCategory.general.id;

  @override
  $TopicCopyWith<Topic> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
