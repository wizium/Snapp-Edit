import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' show DefaultCacheManager;

class CacheManager {
  CacheManager._privateConstructor();
  static final CacheManager _instance = CacheManager._privateConstructor();
  factory CacheManager() {
    return _instance;
  }

  Future<void> clearCacheAndShowSize() async {
    try {
      await DefaultCacheManager().emptyCache();
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
        Fluttertoast.showToast(
          msg: "Cache cleared successfully",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to clear cache");
    }
  }

  Future<int> _calculateCacheSize() async {
    try {
      final directory = await getTemporaryDirectory();
      int totalSize = 0;
      await for (var file in directory.list(recursive: true)) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}