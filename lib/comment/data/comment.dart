import 'package:e1547/shared/shared.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ghost.dart';
part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required int id,
    required int postId,
    required String body,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int creatorId,
    required String creatorName,
    required int score,
    required int? vote,
    required WarningType? warning,
    required bool hidden,
  }) = _Comment;

  const Comment._();

  factory Comment.fromJson(dynamic json) => _$CommentFromJson(json);
}

extension CommentVoting on Comment {
  Comment withVote({required bool upvote, required bool replace}) {
    final result = applyVote(
      score: score,
      vote: vote,
      upvote: upvote,
      replace: replace,
    );
    return copyWith(score: result.score, vote: result.vote);
  }
}

@JsonEnum()
enum WarningType {
  warning,
  record,
  ban;

  String get message {
    switch (this) {
      case warning:
        return 'User received a warning for this message';
      case record:
        return 'User received a record for this message';
      case ban:
        return 'User was banned for this message';
    }
  }
}
