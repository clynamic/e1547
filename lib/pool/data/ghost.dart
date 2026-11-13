part of 'pool.dart';

class PoolGhost extends Pool with Ghost {
  const PoolGhost([this.index = 0]) : super._();

  @override
  final int index;

  @override
  int get id => -1 - index;

  @override
  String get name => words(1, 2, 4);

  @override
  DateTime get createdAt => DateTime(2000 + count(2, 20));

  @override
  DateTime get updatedAt => DateTime(2000 + count(3, 20));

  @override
  String get description => '';

  @override
  List<int> get postIds => const [];

  @override
  int get postCount => 2 + count(4, 200);

  @override
  bool get active => true;

  @override
  $PoolCopyWith<Pool> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
