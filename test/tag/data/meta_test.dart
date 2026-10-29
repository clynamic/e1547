import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('metatags read in words', () {
    expect(metaWords('date:month'), 'past month');
    expect(metaWords('date:yesteryear'), 'last year');
    expect(metaWords('date:2026-09-29..2026-10-29'), 'Sep 29 to Oct 29');
    expect(metaWords('score:>=100'), 'score ≥ 100');
    expect(metaWords('favcount:10..50'), 'favorites 10 to 50');
    expect(metaWords('order:score'), 'by score');
    expect(metaWords('order:favcount_asc'), 'by favorites, lowest first');
    expect(metaWords('order:random'), 'random order');
    expect(metaWords('order:id'), 'oldest first');
    expect(metaWords('order:id_desc'), 'newest first');
    expect(metaWords('rating:s'), 'safe');
  });

  test('plain tags and unknown metatags have no words', () {
    expect(metaWords('riolu'), isNull);
    expect(metaWords('md5:abc'), isNull);
  });

  test('metatags belong to their builder', () {
    expect(metaKindOf('-date:week'), MetaKind.date);
    expect(metaKindOf('tagcount:>=5'), MetaKind.counts);
    expect(metaKindOf('order:rank'), MetaKind.order);
    expect(metaKindOf('riolu'), isNull);
  });
}
