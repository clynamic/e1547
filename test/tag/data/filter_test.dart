import 'package:e1547/shared/shared.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('editing a filter keeps repeated tokens of others', () {
    QueryMap? result;
    final config = FilterConfigState(
      tags: TagMap('-type:webm -type:mp4 -type:swf'),
      onChanged: (value) => result = value,
    );

    config
        .apply(const TextFilterTag(tag: 'rating', name: 'Rating'))
        .onChanged('e');

    expect(result, isA<TagMap>());
    expect(result.toString(), '-type:webm -type:mp4 -type:swf rating:e');
  });

  test('removing a filter keeps repeated tokens of others', () {
    QueryMap? result;
    final config = FilterConfigState(
      tags: TagMap('rating:e -type:webm -type:mp4'),
      onChanged: (value) => result = value,
    );

    config
        .apply(const TextFilterTag(tag: 'rating', name: 'Rating'))
        .onChanged(null);

    expect(result, isA<TagMap>());
    expect(result.toString(), '-type:webm -type:mp4');
  });
}
