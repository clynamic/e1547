import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

export 'package:skeletonizer/skeletonizer.dart'
    show Bone, Skeleton, Skeletonizer, SkeletonizerConfig;

class ThemedSkeletons extends StatelessWidget {
  const ThemedSkeletons({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effectResolver: (brightness) => PulseEffect(
          from: AppStyle.of(context).skeleton,
          to: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }
}

bool isSkeleton(BuildContext context) =>
    Skeletonizer.maybeOf(context)?.enabled ?? false;

class SliverSkeletonPaging<T extends Object> extends StatelessWidget {
  const SliverSkeletonPaging({
    super.key,
    required this.state,
    required this.fetchNextPage,
    required this.ghost,
    required this.builder,
  });

  final PagingState<int, T> state;
  final VoidCallback fetchNextPage;
  final T Function(int index) ghost;
  final Widget Function(
    BuildContext context,
    PagingState<int, T> state,
    VoidCallback fetchNextPage,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final bool loading = state.status == PagingStatus.loadingFirstPage;
    return Skeletonizer.sliver(
      enabled: loading,
      child: builder(
        context,
        loading
            ? PagingState<int, T>(
                pages: [
                  [for (int index = 0; index < 12; index++) ghost(index)],
                ],
                keys: const [1],
              )
            : state,
        loading ? () {} : fetchNextPage,
      ),
    );
  }
}

class SkeletonIgnore extends StatelessWidget {
  const SkeletonIgnore({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(ignoring: isSkeleton(context), child: child);
}

class SliverSkeletonIgnore extends StatelessWidget {
  const SliverSkeletonIgnore({super.key, required this.sliver});

  final Widget sliver;

  @override
  Widget build(BuildContext context) =>
      SliverIgnorePointer(ignoring: isSkeleton(context), sliver: sliver);
}

class SkeletonPage extends StatelessWidget {
  const SkeletonPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey('skeleton'),
    child: Skeletonizer(ignorePointers: false, child: child),
  );
}
