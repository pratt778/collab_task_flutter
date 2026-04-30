import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Project-wide on-disk image cache. Tighter than `DefaultCacheManager`'s
/// 200-objects / 30-day defaults to keep storage footprint sane on low-end
/// devices.
///
/// Pair with `PaintingBinding.imageCache.maximumSizeBytes` (set in
/// `main_common.dart`) which caps the in-memory decoded-image cache.
class AppImageCacheManager {
  static const _key = 'flutterCleanStarterImageCache';

  static final CacheManager instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  AppImageCacheManager._();
}
