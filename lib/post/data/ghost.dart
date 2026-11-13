part of 'post.dart';

class PostGhost extends Post with Ghost {
  const PostGhost([this.index = 0]) : super._();

  @override
  final int index;

  static const List<double> ratios = [0.8, 1.1, 0.75, 1, 0.9, 1.3];

  @override
  int get id => -1 - index;

  @override
  String? get file => null;

  @override
  String? get sample => null;

  @override
  String? get preview => null;

  @override
  int get width => 100;

  @override
  int get height => (100 / ratios[count(1, ratios.length - 1)]).round();

  @override
  String get ext => 'jpg';

  @override
  int get size => count(2, 5000000);

  @override
  Map<String, String?>? get variants => null;

  @override
  Map<String, List<String>> get tags => {
    'artist': [words(3, 1)],
    'general': [for (int i = 0; i < 7; i++) words(4 + i, 1, 2)],
  };

  @override
  int get uploaderId => -1;

  @override
  String? get uploaderName => null;

  @override
  DateTime get createdAt => DateTime(2000 + count(11, 20));

  @override
  DateTime? get updatedAt => null;

  @override
  int get score => count(12, 500);

  @override
  int? get vote => null;

  @override
  bool get isDeleted => false;

  @override
  Rating get rating => Rating.s;

  @override
  int get favCount => count(13, 1000);

  @override
  bool get isFavorited => false;

  @override
  int get commentCount => count(14, 50);

  @override
  String get description => count(15, 1) == 0 ? words(16, 10, 30) : '';

  @override
  List<String> get sources => const [];

  @override
  List<int>? get pools => null;

  @override
  Relationships get relationships => const Relationships(
    parentId: null,
    hasChildren: false,
    hasActiveChildren: null,
    children: [],
  );

  @override
  $PostCopyWith<Post> get copyWith =>
      throw GhostsAreIntangibleError(this, 'Cannot copy a ghost.');

  @override
  Map<String, dynamic> toJson() =>
      throw GhostsAreIntangibleError(this, 'Cannot convert a ghost to json.');
}
