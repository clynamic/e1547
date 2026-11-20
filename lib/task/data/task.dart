import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    required int id,
    required TaskAction action,
    required int postId,
    required TaskStatus status,
    required String? error,
    required DateTime createdAt,
    required DateTime? completedAt,
    required TaskMetadata? metadata,
  }) = _Task;
}

@freezed
abstract class TaskRequest with _$TaskRequest {
  const factory TaskRequest({
    required TaskAction action,
    required int postId,
    TaskMetadata? metadata,
  }) = _TaskRequest;
}

@freezed
abstract class TaskMetadata with _$TaskMetadata {
  const factory TaskMetadata({
    String? previewUrl,
    String? fileUrl,
    String? fileName,
  }) = _TaskMetadata;

  factory TaskMetadata.fromJson(Map<String, dynamic> json) =>
      _$TaskMetadataFromJson(json);
}

enum TaskAction { download, favorite, unfavorite }

typedef TaskLane = ({int postId, bool download});

extension TaskActionX on TaskAction {
  TaskLane laneOf(int postId) =>
      (postId: postId, download: this == TaskAction.download);
}

enum TaskStatus { pending, running, completed, failed, canceled }

extension TaskStatusX on TaskStatus {
  /// Still queued or in progress.
  bool get isActive => this == TaskStatus.pending || this == TaskStatus.running;

  /// Finished, regardless of outcome.
  bool get isTerminal =>
      this == TaskStatus.completed ||
      this == TaskStatus.failed ||
      this == TaskStatus.canceled;
}
