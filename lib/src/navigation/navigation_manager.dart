import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import './routes.dart';
import "package:flutter_hw_lototinder/src/model/image_info.dart" as image_info;

class NavigationManager {
  final key = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => key.currentState!;

  void openDetails(image_info.ImageInfo info) async {
    await _navigator.pushNamed(
      RouteNames.details,
      arguments: info,
    );
  }

  void showAlert(String alertTitle, String alertMessage) {
    // decided to ignore that multiple alerts can be stacked
    // otherwise it can be tracked using static variable here
    showDialog(
        context: key.currentContext!,
        builder: (BuildContext context) => AlertDialog(
              title: Text(alertTitle),
              content: Text(alertMessage),
              actions: [
                TextButton(
                    onPressed: () => _navigator.pop(),
                    child: const Text("Close"))
              ],
            ));
  }

  Future<List<LikeInteraction>> openLikeHistory(
      List<LikeInteraction> history) async {
    var changedHistory = await _navigator.pushNamed(
      RouteNames.likes,
      arguments: history,
    ) as List<LikeInteraction>?;
    return changedHistory ?? history;
  }

  void pop([Object? result]) {
    _navigator.pop(result);
  }
}
