import 'package:e1547/app/app.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';

extension PostTagging on PostSummary {
  bool hasTag(String tag) {
    if (tag.trim().isEmpty) return false;

    if (tag.contains(':')) {
      String identifier = tag.split(':')[0];
      String value = tag.split(':')[1];
      switch (identifier) {
        case 'id':
          return id == int.tryParse(value);
        case 'rating':
          return rating == Rating.values.asNameMap()[value] ||
              value == rating.title.toLowerCase();
        case 'type':
          return ext.toLowerCase() == value.toLowerCase();
        case 'width':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(width);
        case 'height':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(height);
        case 'filesize':
          NumberRange? range = NumberRange.tryParse(_sizeToBytes(value));
          if (range == null) return false;
          return range.has(size);
        case 'score':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(score);
        case 'favcount':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(favCount);
        case 'fav':
          return isFavorited;
        case 'status':
          return switch (value) {
            'deleted' => isDeleted,
            _ => false,
          };
        case 'uploader':
        case 'user':
          if (value.startsWith('!')) {
            return uploaderId == int.tryParse(value.substring(1));
          }
          return uploaderName?.toLowerCase() == value;
        case 'userid':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(uploaderId);
        case 'username':
          return uploaderName?.toLowerCase() == value;
        case 'pool':
          return pools?.contains(int.tryParse(value)) ?? false;
        case 'tagcount':
          NumberRange? range = NumberRange.tryParse(value);
          if (range == null) return false;
          return range.has(allTags.length);
      }
    }

    if (tag.contains('*')) {
      final RegExp pattern = RegExp(
        '^${RegExp.escape(tag.toLowerCase()).replaceAll(r'\*', '.*')}\$',
      );
      return allTags.any(pattern.hasMatch);
    }

    return allTags.contains(tag.toLowerCase());
  }
}

final RegExp _sizeUnit = RegExp(
  r'(\d+(?:\.\d+)?)\s*(kb|mb|b)',
  caseSensitive: false,
);

/// Rewrites the units in a filesize expression into plain byte counts.
String _sizeToBytes(String value) => value.replaceAllMapped(_sizeUnit, (match) {
  final double number = double.parse(match.group(1)!);
  final int factor = switch (match.group(2)!.toLowerCase()) {
    'kb' => 1024,
    'mb' => 1048576,
    _ => 1,
  };
  return (number * factor).truncate().toString();
});

final RegExp _tagPrefix = RegExp(r'^[~-]+');

extension PostDenying on PostSummary {
  bool isDeniedBy(List<String> denylist) =>
      getDeniers(denylist).iterator.moveNext();

  Iterable<String> getDeniers(List<String> denylist) sync* {
    for (String line in denylist) {
      line = line.trim().toLowerCase();
      if (line.isEmpty || line.startsWith('#')) continue;

      line = line.replaceFirst(RegExp(r' #.*$'), '').trim();
      if (line.isEmpty) continue;

      bool pass = true;
      bool isOptional = false;
      bool hasOptional = false;

      for (String tag in line.split(' ')) {
        if (tag.isEmpty) continue;

        bool optional = false;
        bool inverted = false;

        final String? prefix = _tagPrefix.stringMatch(tag);
        if (prefix != null) {
          optional = prefix.contains('~');
          inverted = prefix.contains('-');
          tag = tag.substring(prefix.length);
        }

        if (tag.isEmpty) continue;

        bool matches = hasTag(tag);

        if (inverted) {
          matches = !matches;
        }

        if (optional) {
          isOptional = true;
          if (matches) {
            hasOptional = true;
          }
        } else {
          if (!matches) {
            pass = false;
            break;
          }
        }
      }

      if (pass && isOptional) {
        pass = hasOptional;
      }

      if (!pass) continue;

      yield line;
    }
  }
}

enum PostType { image, video, unsupported }

extension PostTyping on PostSummary {
  PostType get type {
    switch (ext) {
      case 'mp4':
      case 'webm':
        if (PlatformCapabilities.hasVideos) {
          return PostType.video;
        }
        return PostType.unsupported;
      case 'swf':
        return PostType.unsupported;
      default:
        return PostType.image;
    }
  }
}

extension PostVideoPlaying on Post {
  VideoPlayer? getVideo(BuildContext context) {
    if (type == PostType.video && file != null) {
      // An inactive subtree holds no player, so that a stack of post routes
      // cannot pin one video each.
      if (!TickerMode.valuesOf(context).enabled) return null;

      VideoService service = context.watch<VideoService>();
      Settings settings = context.watch<Settings>();

      VideoResolution target = settings.videoResolution.value;
      String closestUrl = file!;
      int? closestDifference;

      // maybe move this logic into the VideoService
      if (variants != null && variants!.isNotEmpty) {
        for (final MapEntry(:key, :value) in variants!.entries) {
          if (value == null) continue;
          if (!value.endsWith('mp4') && !value.endsWith('webm')) continue;
          final dimensions = key.split('x').map(int.parse).toList();
          final pixelSize = dimensions[0] * dimensions[1];
          final difference = (target.pixels - pixelSize).abs();

          if (closestDifference == null || difference < closestDifference) {
            closestDifference = difference;
            closestUrl = value;
          }
        }
      }

      return service.getVideo(closestUrl);
    }
    return null;
  }
}

extension PostLinking on Post {
  static String getPostLink(int id) => '/posts/$id';

  String get link => getPostLink(id);
}

extension PostVoting on Post {
  Post withVote({required bool upvote, required bool replace}) {
    final result = applyVote(
      score: score,
      vote: vote,
      upvote: upvote,
      replace: replace,
    );
    return copyWith(score: result.score, vote: result.vote);
  }
}
