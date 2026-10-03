import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show sqrt;

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
    this.maxPixels,
  });

  /// The post which provides the image.
  final Post post;

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

  /// The maximum number of pixels this image may decode to.
  ///
  /// Constrains the total decoded size of images whose extreme aspect
  /// ratios would defeat a one dimensional [cacheSize] limit.
  final int? maxPixels;

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
                progressIndicatorBuilder: withLowRes
                    ? (context, url, progress) => ImageProgressWrapper(
                        aspectRatio: aspectRatio,
                        progress: progress.progress,
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
                maxPixels: maxPixels,
                progressIndicatorBuilder: (context, url, progress) =>
                    ImageProgressWrapper(
                      progress: progress.progress,
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

class RawPostImageWidget extends StatelessWidget {
  const RawPostImageWidget({
    super.key,
    required this.post,
    required this.size,
    this.fit,
    this.progressIndicatorBuilder,
    this.stacked = false,
    this.showProgress = true,
    this.cacheSize,
    this.maxPixels,
  });

  final Post post;
  final PostImageSize size;
  final BoxFit? fit;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final bool stacked;
  final bool showProgress;
  final int? cacheSize;

  /// The maximum number of pixels this image may decode to.
  final int? maxPixels;

  @override
  Widget build(BuildContext context) {
    Duration fades = stacked
        ? Duration.zero
        : const Duration(milliseconds: 500);

    Widget progressIndicator(
      BuildContext context,
      String url,
      DownloadProgress progress,
    ) {
      return Center(
        child: SizedCircularProgressIndicator(
          size: 30,
          value: progress.progress,
        ),
      );
    }

    String url =
        switch (size) {
          PostImageSize.preview => post.preview,
          PostImageSize.sample => post.sample,
          PostImageSize.file => post.file!,
        } ??
        post.file!;
    Size dimensions = Size(post.width.toDouble(), post.height.toDouble());

    double aspectRatio = dimensions.width / dimensions.height;

    int? memCacheWidth;
    int? memCacheHeight;

    int? cacheSize = this.cacheSize;
    int? maxPixels = this.maxPixels;
    if (cacheSize != null || maxPixels != null) {
      double scale = 1;
      if (cacheSize != null) {
        if (aspectRatio > 1) {
          scale = cacheSize / dimensions.height;
        } else {
          scale = cacheSize / dimensions.width;
        }
      }
      if (maxPixels != null) {
        double pixelScale = sqrt(
          maxPixels / (dimensions.width * dimensions.height),
        );
        if (pixelScale < scale) {
          scale = pixelScale;
        }
      }
      // Never upscale, mirroring ResizeImage's default.
      if (scale < 1) {
        memCacheWidth = (dimensions.width * scale).round();
        memCacheHeight = (dimensions.height * scale).round();
      }
    }

    return CachedNetworkImage(
      fit: fit,
      fadeInDuration: fades,
      fadeOutDuration: fades,
      imageUrl: url,
      errorWidget: stacked
          ? defaultErrorBuilder
          : (context, url, error) => const SizedBox.shrink(),
      progressIndicatorBuilder: showProgress || stacked
          ? progressIndicatorBuilder ?? progressIndicator
          : null,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
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

/// The cache size of images shown in fullscreen views on mobile.
///
/// Fullscreen images are e621 originals, which can exceed 4000px. Decoding
/// them at full size fills the image cache of low end devices within a
/// few posts, so their decoded size is capped. 2048px covers the physical
/// resolution of the 1080p screens such devices usually have. Other
/// platforms keep the uncapped fullscreen originals.
int? get fullscreenImageCacheSize =>
    Platform.isAndroid || Platform.isIOS ? 2048 : null;

/// The maximum number of pixels a decoded fullscreen image may occupy on
/// mobile.
///
/// The one dimensional [fullscreenImageCacheSize] limit alone lets extreme
/// aspect ratios decode to 25-30 MB, more than a 32 bit device's image
/// cache is willing to hold, so such images are never cached and get
/// redecoded whenever they scroll back into view. A pixel budget caps
/// every fullscreen image equally. Other platforms keep the uncapped
/// fullscreen originals.
int? get fullscreenImageMaxPixels =>
    Platform.isAndroid || Platform.isIOS ? 2048 * 2048 : null;

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
