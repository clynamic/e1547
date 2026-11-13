import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PostImageWidget extends StatelessWidget {
  /// Displays the image of a post.
  ///
  /// Provides various preview options while loading.
  const PostImageWidget({
    super.key,
    required this.post,
    required this.size,
    this.showProgress = true,
    this.withLowRes = true,
    this.fit = BoxFit.contain,
    this.cacheSize,
    this.lowResCacheSize,
    this.load,
  });

  /// The post which provides the image.
  final PostSummary post;

  /// How the image should be fit.
  final BoxFit fit;

  /// The image size to be selected from that post (preview, sample, file).
  final PostImageSize size;

  /// Whether to display progress while the the image is loading.
  final bool showProgress;

  /// Whether an already loaded lower resolution image should be displayed while the image is loading.
  final bool withLowRes;

  /// The cache size for this image.
  final int? cacheSize;

  /// The cache size of a previously loaded lower resolution image.
  /// Used to bridge the gap between loading a downsized image and the full sized one.
  final int? lowResCacheSize;

  final ImageLoadController? load;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Builder(
        builder: (context) {
          double aspectRatio = post.width / post.height;

          switch (size) {
            case PostImageSize.preview:
              return RawPostImageWidget(
                post: post,
                size: PostImageSize.preview,
                showProgress: showProgress,
                fit: fit,
                cacheSize: cacheSize,
              );
            case PostImageSize.sample:
              return RawPostImageWidget(
                stacked: withLowRes,
                post: post,
                size: PostImageSize.sample,
                showProgress: showProgress,
                fit: fit,
                cacheSize: cacheSize,
                load: load,
                progressIndicatorBuilder: withLowRes
                    ? (context, url, progress) => ImageProgressWrapper(
                        aspectRatio: aspectRatio,
                        progress: load == null ? progress.progress : null,
                        child: lowResCacheSize != null
                            ? RawPostImageWidget(
                                post: post,
                                size: PostImageSize.sample,
                                fit: fit,
                                cacheSize: lowResCacheSize,
                              )
                            : RawPostImageWidget(
                                post: post,
                                size: PostImageSize.preview,
                                fit: fit,
                              ),
                      )
                    : null,
              );
            case PostImageSize.file:
              return RawPostImageWidget(
                stacked: true,
                post: post,
                size: PostImageSize.file,
                showProgress: showProgress,
                fit: fit,
                cacheSize: cacheSize,
                load: load,
                progressIndicatorBuilder: (context, url, progress) =>
                    ImageProgressWrapper(
                      progress: load == null ? progress.progress : null,
                      aspectRatio: aspectRatio,
                      child: RawPostImageWidget(
                        post: post,
                        size: PostImageSize.sample,
                        showProgress: showProgress,
                        fit: fit,
                        cacheSize: lowResCacheSize,
                      ),
                    ),
              );
          }
        },
      ),
    );
  }
}

class RawPostImageWidget extends StatefulWidget {
  const RawPostImageWidget({
    super.key,
    required this.post,
    required this.size,
    this.fit,
    this.progressIndicatorBuilder,
    this.stacked = false,
    this.showProgress = true,
    this.cacheSize,
    this.load,
  });

  final PostSummary post;
  final PostImageSize size;
  final BoxFit? fit;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final bool stacked;
  final bool showProgress;
  final int? cacheSize;
  final ImageLoadController? load;

  @override
  State<RawPostImageWidget> createState() => _RawPostImageWidgetState();
}

class _RawPostImageWidgetState extends State<RawPostImageWidget> {
  ImageProvider? _held;
  ImageStream? _stream;
  late final ImageStreamListener _listener = ImageStreamListener(
    (image, synchronousCall) => image.dispose(),
    onError: (error, stackTrace) {},
  );

  String get _url =>
      switch (widget.size) {
        PostImageSize.preview => widget.post.preview,
        PostImageSize.sample => widget.post.sample,
        PostImageSize.file => widget.post.file!,
      } ??
      widget.post.file!;

  bool get _wide => widget.post.width > widget.post.height;

  void _hold() {
    final ImageProvider image = ResizeImage.resizeIfNeeded(
      _wide ? null : widget.cacheSize,
      _wide ? widget.cacheSize : null,
      CachedNetworkImageProvider(
        _url,
        cacheManager: context.read<BaseCacheManager>(),
      ),
    );
    if (image == _held) return;
    _held = image;
    _stream?.removeListener(_listener);
    _stream = image.resolve(createLocalImageConfiguration(context))
      ..addListener(_listener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hold();
  }

  @override
  void didUpdateWidget(RawPostImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _hold();
  }

  @override
  void dispose() {
    _stream?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImageLoadController? load = widget.load;
    final String url = _url;
    final Duration fades = widget.stacked
        ? Duration.zero
        : const Duration(milliseconds: 500);

    Widget progressIndicator(
      BuildContext context,
      String url,
      DownloadProgress progress,
    ) {
      return Center(
        child: switch (progress.progress) {
          final double value => HexagonalLoadingIndicator(
            state: HexagonState.tracing,
            progress: value,
            size: 30,
          ),
          null => const HexagonalLoadingIndicator(size: 30),
        },
      );
    }

    return CachedNetworkImage(
      fit: widget.fit,
      fadeInDuration: fades,
      fadeOutDuration: fades,
      imageUrl: url,
      errorWidget: (context, url, error) {
        load?.report(url, ImageFailed(error));
        if (!widget.stacked) return const SizedBox.shrink();
        return defaultErrorBuilder(context, url, error);
      },
      progressIndicatorBuilder: widget.showProgress || widget.stacked
          ? (context, url, progress) {
              load?.report(url, ImageLoading(progress.progress));
              return (widget.progressIndicatorBuilder ?? progressIndicator)(
                context,
                url,
                progress,
              );
            }
          : null,
      imageBuilder: load != null
          ? (context, image) {
              load.report(url, const ImageLoaded());
              return Image(image: image, fit: widget.fit);
            }
          : null,
      memCacheWidth: _wide ? null : widget.cacheSize,
      memCacheHeight: _wide ? widget.cacheSize : null,
      cacheManager: context.read<BaseCacheManager>(),
    );
  }
}

class ImageProgressWrapper extends StatefulWidget {
  const ImageProgressWrapper({
    super.key,
    required this.child,
    required this.aspectRatio,
    required this.progress,
  });

  /// The widget below this one in the tree.
  final Widget child;

  /// The aspect ratio of the image.
  final double aspectRatio;

  /// The download progress.
  final double? progress;

  @override
  State<ImageProgressWrapper> createState() => _ImageProgressWrapperState();
}

class _ImageProgressWrapperState extends State<ImageProgressWrapper> {
  bool visible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: widget.child),
          if (widget.progress != null)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: defaultAnimationDuration,
                child: LinearProgressIndicator(
                  value: widget.progress,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A default error builder for cached network image.
/// Shows a centered icon.
Widget defaultErrorBuilder(BuildContext context, String url, dynamic error) =>
    const Center(child: Icon(Icons.warning_amber_outlined));

class ImageCacheSize {
  /// Configures the cache size for images.
  const ImageCacheSize(this.size);

  /// The cache size of the image.
  final int? size;
}

class ImageCacheSizeProvider extends SubProvider0<ImageCacheSize> {
  /// Provides the cache size for images to a subtree.
  ImageCacheSizeProvider({required int? size, super.child, super.builder})
    : super(
        create: (context) => ImageCacheSize(size),
        keys: (context) => [size],
      );

  /// Removes the cache size for images for a subtree.
  ImageCacheSizeProvider.none({super.child, super.builder})
    : super(create: (context) => const ImageCacheSize(null));
}
