import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart' as image_info;


class LikesNotifier extends ValueNotifier<List<LikeInteraction>> {
  LikesNotifier(super.value);

  void add(image_info.ImageInfo info) {
    value.add(LikeInteraction(imageInfo: info, likeTime: DateTime.now()));
  }

  void remove(String url) {
    value.removeWhere((item) => item.imageInfo.url == url);
  }
}

class LikesInheritedNotifier extends InheritedNotifier<LikesNotifier> {
  const LikesInheritedNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static LikesNotifier of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<LikesInheritedNotifier>();

    final notifier = result?.notifier;
    if (notifier == null) {
      throw StateError('No LikesInheritedNotifier found in context');
    }

    return notifier;
  }
}
