import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hw_lototinder/src/domain/model/app_state.dart';
import 'package:flutter_hw_lototinder/src/domain/model/awailable_apis.dart';
import 'package:flutter_hw_lototinder/src/domain/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart' as image_info;

class ImagesNotifier extends ChangeNotifier {
  AppState value;

  ImagesNotifier({required this.value});

  void addLike(image_info.ImageInfo info) {
    addInteractionEntry(info, true);
  }

  void addDislike(image_info.ImageInfo info) {
    addInteractionEntry(info, false);
  }

  void addInteractionEntry(image_info.ImageInfo info, bool isLike) async {
    await value.dao.saveItem(LikeInteraction(imageInfo: info, actionTime: DateTime.now(), isLike: isLike));
    notifyListeners();
  }

  void removeInteractionEntry(String url) async {
    await value.dao.deleteItemByUrl(url);
    notifyListeners();
  }

  void addLoadedInfo(image_info.ImageInfo info) {
    value.loadedImages.putIfAbsent(info.apiSource, () => <image_info.ImageInfo>[]);
    value.loadedImages[info.apiSource]!.add(info);
    DefaultCacheManager().downloadFile(info.url);
    notifyListeners();
  }

  void removeLoadedInfo(image_info.ImageInfo info) {
    value.loadedImages.putIfAbsent(info.apiSource, () => <image_info.ImageInfo>[]);
    value.loadedImages[info.apiSource]!.removeWhere((item) => item.url == info.url);
    notifyListeners();
  }

  Future<int> countOfLiked() {
    return value.dao.getLikeCount(true);
  }

  Future<int> countOfDisliked() {
    return value.dao.getLikeCount(false);
  }

  image_info.ImageInfo? getTopLoaded(AwailableAPIs api) {
    return value.loadedImages[api]?.firstOrNull;
  }
}

class ImagesInheritedNotifier extends InheritedNotifier<ImagesNotifier> {
  const ImagesInheritedNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ImagesNotifier of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<ImagesInheritedNotifier>();

    final notifier = result?.notifier;
    if (notifier == null) {
      throw StateError('No ImagesInheritedNotifier found in context');
    }

    return notifier;
  }
}
