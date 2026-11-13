import 'dart:math';

mixin Ghost {
  int get index;

  Random _random(int salt) => Random(index * 7919 + salt);

  int count(int salt, int max) => _random(salt).nextInt(max + 1);

  String words(int salt, int min, [int? max]) {
    final Random random = _random(salt);
    final int length = min + random.nextInt((max ?? min) - min + 1);
    return [
      for (int i = 0; i < length; i++)
        'Moockmoock'.substring(0, 3 + random.nextInt(6)),
    ].join(' ');
  }
}

class GhostsAreIntangibleError extends Error {
  GhostsAreIntangibleError(this.ghost, this.message);

  final Ghost ghost;
  final String message;

  @override
  String toString() =>
      '${ghost.runtimeType} #${ghost.index} is intangible: $message';
}
