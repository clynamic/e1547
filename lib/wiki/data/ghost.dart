part of 'wiki.dart';

class WikiGhost extends Wiki with Ghost {
  const WikiGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  int get id => -1 - index;

  @override
  String get title => words(1, 1, 3);

  @override
  String get body =>
      [for (int i = 0; i < 6; i++) words(10 + i, 12, 24)].join('\n\n');

  @override
  DateTime get createdAt => DateTime(2000 + count(2, 20));

  @override
  DateTime? get updatedAt => null;

  @override
  List<String>? get otherNames => null;

  @override
  bool? get isLocked => null;

  @override
  $WikiCopyWith<Wiki> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
