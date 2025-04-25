import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageInfoInheritedNotifier extends InheritedNotifier<ValueNotifier<int>> {
  const ImageInfoInheritedNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<int> of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ImageInfoInheritedNotifier>();

    final notifier = result?.notifier;
    if (notifier == null) {
      throw StateError('No ImageInfoInheritedNotifier found in context');
    }

    return notifier;
  }
}
