import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';

/// Enqueues download tasks for [items]. The floating task bubble surfaces
/// progress; this call returns as soon as the tasks are persisted.
Future<void> postDownloadingNotification(
  BuildContext context,
  Set<Post> items,
) async {
  if (items.isEmpty) return;
  final TasksController controller = context.read<TasksController>();
  await controller.enqueueAll(
    items.map(
      (post) => TaskRequest(
        action: TaskAction.download,
        postId: post.id,
        metadata: TaskMetadata(
          previewUrl: post.preview,
          fileUrl: post.file,
          fileName: post.downloadFileName,
        ),
      ),
    ),
  );
}

/// Enqueues favorite or unfavorite tasks for [items], skipping ones already in
/// the target state.
Future<void> postFavoritingNotification(
  BuildContext context,
  Set<Post> items,
  bool isLiked,
) async {
  if (items.isEmpty) return;
  final TasksController controller = context.read<TasksController>();
  final TaskAction action = isLiked
      ? TaskAction.unfavorite
      : TaskAction.favorite;
  final Iterable<Post> targets = items.where(
    (post) => isLiked ? post.isFavorited : !post.isFavorited,
  );
  if (targets.isEmpty) return;
  await controller.enqueueAll(
    targets.map(
      (post) => TaskRequest(
        action: action,
        postId: post.id,
        metadata: TaskMetadata(previewUrl: post.preview),
      ),
    ),
  );
}
