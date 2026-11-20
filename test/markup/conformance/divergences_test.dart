// Inputs the staging-corpus fuzz against dmark found diverging, pinned to
// dmark's output in `fixtures/divergences.json`.

import '_support/fixtures.dart';

void main() => runFixtures('divergences');
