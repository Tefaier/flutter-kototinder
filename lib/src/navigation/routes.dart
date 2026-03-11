import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/domain/model/image_info.dart'
    as image_info;
import 'package:flutter_hw_lototinder/src/widget/app_holder.dart';
import 'package:get_it/get_it.dart';

import '/src/widget/pages/main_page.dart';
import '/src/widget/pages/details_page.dart';
import '/src/widget/pages/likes_page.dart';

GetIt getIt = GetIt.instance;

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
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              MainPage(themeSwap: getIt<ThemeSwap>().swap),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          settings: settings,
        );
      case RouteNames.details:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              DetailsPage(info: (settings.arguments as image_info.ImageInfo)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = 0.0;
            const end = 1.0;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
            final scaleAnimation = animation.drive(tween);
            return ScaleTransition(scale: scaleAnimation, child: child);
          },
          settings: settings,
        );
      case RouteNames.likes:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LikesPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          settings: settings,
        );
    }

    return null;
  }
}
