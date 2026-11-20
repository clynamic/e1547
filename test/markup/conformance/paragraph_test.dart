// Paragraph and block-boundary conformance: newline handling, paragraph
// splits, block boundaries when adjacent to headers, quotes, lists, code,
// and anchors. Inputs and frozen expected JSON live in
// `fixtures/paragraph.json`.

import '_support/fixtures.dart';

void main() => runFixtures('paragraph');
