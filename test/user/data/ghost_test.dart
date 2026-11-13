import 'package:e1547/shared/shared.dart';
import 'package:e1547/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a user ghost reads the same every time for its index', () {
    expect(const UserGhost(3).about, const UserGhost(3).about);
    expect(const UserGhost(3).name, const UserGhost(3).name);
  });

  test('user ghosts of different indexes differ', () {
    expect({
      for (int i = 0; i < 6; i++) UserGhost(i).about?.bio,
    }, hasLength(greaterThan(1)));
  });

  test('a user ghost refuses to be copied or stored', () {
    expect(
      () => const UserGhost().copyWith,
      throwsA(isA<GhostsAreIntangibleError>()),
    );
    expect(
      () => const UserGhost().toJson(),
      throwsA(isA<GhostsAreIntangibleError>()),
    );
  });
}
