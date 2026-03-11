import 'package:flutter/material.dart';
import "package:flutter_hw_lototinder/src/domain/model/image_info.dart"
    as image_info;
import 'package:flutter_hw_lototinder/src/navigation/routes.dart';

class NavigationManager {
  final key = GlobalKey<NavigatorState>();
  bool dialogOpened = false;

  NavigatorState get _navigator => key.currentState!;

  void openDetails(image_info.ImageInfo info) async {
    await _navigator.pushNamed(
      RouteNames.details,
      arguments: info,
    );
  }

  void showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(label: 'Close', onPressed: () {}),
    );

    ScaffoldMessenger.of(key.currentContext!).showSnackBar(snackBar);
  }

  void showAlert(String alertTitle, String alertMessage) {
    // decided to ignore repeated dialogs
    if (dialogOpened) {
      return;
    }
    dialogOpened = true;
    showDialog(
        context: key.currentContext!,
        builder: (BuildContext context) => AlertDialog(
              title: Text(alertTitle),
              content: Text(alertMessage),
              actions: [
                TextButton(
                    onPressed: () {
                      dialogOpened = false;
                      _navigator.pop();
                    },
                    child: const Text("Close"))
              ],
            ));
  }

  Future<void> openLikeHistory() async {
    _navigator.pushNamed(
      RouteNames.likes,
    );
  }

  void pop([Object? result]) {
    _navigator.pop(result);
  }
}
