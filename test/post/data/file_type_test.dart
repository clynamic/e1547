import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('type tokens round trip through the tag map', () {
    for (final type in PostFileType.values) {
      final token = type.token;
      if (token == null) continue;
      expect(TagMap(token).toString(), token);
    }
  });

  test('type group tokens are recognized', () {
    expect(
      fileTypeFromTags(TagMap(PostFileType.image.token!)),
      PostFileType.image,
    );
    expect(
      fileTypeFromTags(TagMap(PostFileType.video.token!)),
      PostFileType.video,
    );
  });

  test('plain type tags map to their category', () {
    for (final extension in ['jpg', 'png', 'gif', 'webp']) {
      expect(
        fileTypeFromTags(TagMap('type:$extension')),
        PostFileType.image,
        reason: 'type:$extension',
      );
    }
    for (final extension in ['webm', 'mp4']) {
      expect(
        fileTypeFromTags(TagMap('type:$extension')),
        PostFileType.video,
        reason: 'type:$extension',
      );
    }
  });

  test('unknown and negated type tags report no selection', () {
    expect(fileTypeFromTags(TagMap('type:swf')), PostFileType.none);
    expect(fileTypeFromTags(TagMap('type:flv')), PostFileType.none);
    expect(fileTypeFromTags(TagMap('-type:webm')), PostFileType.none);
    expect(fileTypeFromTags(TagMap('~type:webm')), PostFileType.none);
    expect(fileTypeFromTags(TagMap('wolf')), PostFileType.none);
    expect(fileTypeFromTags(TagMap('')), PostFileType.none);
  });

  test('switching types keeps other tags and clears the family', () {
    expect(
      withFileType(TagMap('wolf'), PostFileType.image).toString(),
      'wolf ${PostFileType.image.token}',
    );
    expect(
      withFileType(
        TagMap('wolf ${PostFileType.image.token}'),
        PostFileType.video,
      ).toString(),
      'wolf ${PostFileType.video.token}',
    );
    expect(
      withFileType(
        TagMap('wolf ${PostFileType.video.token}'),
        PostFileType.none,
      ).toString(),
      'wolf',
    );
  });

  test('picking a type replaces the plain tags of older queries', () {
    expect(
      withFileType(TagMap('type:jpg wolf'), PostFileType.video).toString(),
      'wolf ${PostFileType.video.token}',
    );
    expect(
      withFileType(
        TagMap('-type:webm -type:mp4 wolf'),
        PostFileType.none,
      ).toString(),
      'wolf',
    );
  });

  test('unrelated repeated tokens survive a type switch', () {
    expect(
      withFileType(TagMap('~a ~b wolf'), PostFileType.image).toString(),
      '~a ~b wolf ${PostFileType.image.token}',
    );
  });

  test('type tokens are detected for the filter button', () {
    expect(hasFileTypeTokens(TagMap('wolf')), isFalse);
    expect(hasFileTypeTokens(TagMap('type:jpg')), isTrue);
    expect(hasFileTypeTokens(TagMap('-type:webm')), isTrue);
    expect(hasFileTypeTokens(TagMap(PostFileType.video.token!)), isTrue);
  });
}
