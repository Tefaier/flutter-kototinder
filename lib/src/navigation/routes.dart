import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart' as image_info;

import '/src/widget/pages/main_page.dart';
import '/src/widget/pages/details_page.dart';
import '/src/widget/pages/likes_page.dart';

abstract class RouteNames {
  const RouteNames._();

  static const main = '/';
  static const details = '/details';
  static const likes = '/likes';
}

abstract class RoutesBuilder {
  static Route<Object?>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.main:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: settings,
        );
      case RouteNames.details:
        return MaterialPageRoute(
          builder: (_) => DetailsPage(info: (settings.arguments as image_info.ImageInfo)),
          settings: settings,
        );
      case RouteNames.likes:
        return MaterialPageRoute(
          builder: (_) => const LikesPage(),
          settings: settings,
        );
    }

    return null;
  }
}
