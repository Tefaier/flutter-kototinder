import 'package:flutter/material.dart';
import './routes.dart';

class NavigationManager {
  NavigationManager._();

  static final instance = NavigationManager._();

  final key = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => key.currentState!;

  void openDetails(ImageInfo info) async {
    await _navigator.pushNamed(
      RouteNames.details,
      arguments: info,
    );
  }

  void openLikeHistory() async {
    await _navigator.pushNamed(
      RouteNames.likes,
      arguments: [
      ],
    );
  }

  void pop([Object? result]) {
    _navigator.pop(result);
  }
}
