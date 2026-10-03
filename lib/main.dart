import 'dart:ffi';

import 'package:e1547/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _limitImageCache();
  runApp(const App());
}

// This app shows e621 originals, whose decoded size can reach tens of
// megabytes each. On Android 7 devices, especially those running 32 bit
// builds, the default cache of 1000 images and 100 MB grows past what the
// OS low memory killer tolerates, which silently discards the process
// without any Dart-level error to show for it. iOS kills equally greedy
// apps through Jetsam, so its 64 bit devices get the same cap as Android's.
// Desktop platforms have swap space and no such killer, they keep
// Flutter's defaults.
void _limitImageCache() {
  ImageCache cache = PaintingBinding.instance.imageCache;
  switch (Abi.current()) {
    case Abi.androidArm:
    case Abi.androidIA32:
      // 32 bit processes have a small address space, keep the decoded
      // image cache small. 48 MB still fits two pixel capped fullscreen
      // images (~17 MB each) alongside the grid thumbnails.
      cache.maximumSize = 300;
      cache.maximumSizeBytes = 48 << 20;
    case Abi.androidArm64:
    case Abi.androidX64:
    case Abi.androidRiscv64:
    case Abi.iosArm64:
      cache.maximumSize = 500;
      cache.maximumSizeBytes = 64 << 20;
    default:
      break;
  }
}
