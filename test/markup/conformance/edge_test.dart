// Edge cases: empty input, whitespace-only, unmatched tags, deeply
// nested formatting, unicode, emoji, and other oddities found in the
// Ragel grammar but not covered by the per-category suites above.
// Inputs and frozen expected JSON live in `fixtures/edge.json`.

import '_support/fixtures.dart';

void main() => runFixtures('edge');
