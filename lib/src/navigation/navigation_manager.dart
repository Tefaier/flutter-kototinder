import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import './routes.dart';
import "package:flutter_hw_lototinder/src/model/image_info.dart" as image_info;

class NavigationManager {
  NavigationManager._();

  static final instance = NavigationManager._();

  final key = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => key.currentState!;

  void openDetails(image_info.ImageInfo info) async {
    await _navigator.pushNamed(
      RouteNames.details,
      arguments: info,
    );
  }

  Future<List<LikeInteraction>> openLikeHistory(List<LikeInteraction> history) async {
    var changedHistory = await _navigator.pushNamed(
      RouteNames.likes,
      arguments: history,
    ) as List<LikeInteraction>;
    return changedHistory;
  }

  void pop([Object? result]) {
    _navigator.pop(result);
  }
}
