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

  test('file, size, people and property terms read in words', () {
    expect(metaWords('( ~type:mp4 ~type:webm )'), 'videos');
    expect(metaWords('type:png'), 'png');
    expect(metaWords('duration:<30'), 'under 30 s');
    expect(metaWords('mpixels:>=4'), '≥ 4 MP');
    expect(metaWords('ratio:>1'), 'landscape');
    expect(metaWords('filesize:<10MB'), 'under 10 MB');
    expect(metaWords('fav:tester'), 'favorited by tester');
    expect(metaWords('hassource:false'), 'no source');
    expect(metaWords('ischild:true'), 'has parent');
    expect(metaWords('status:pending'), 'pending');
  });

  test('a group of file types belongs to the file builder', () {
    expect(metaKindOf('( ~type:gif ~type:apng )'), MetaKind.file);
    expect(metaKindOf('( ~type:gif ~fav:tester )'), isNull);
  });
}
