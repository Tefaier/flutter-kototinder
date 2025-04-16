import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/image_info.dart' as image_info;
import 'package:flutter_hw_lototinder/src/model/like_interaction.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
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
        return MaterialPageRoute(
          builder: (_) => MainPage(themeSwap: getIt<ThemeSwap>().swap),
          settings: settings,
        );
      case RouteNames.details:
        return MaterialPageRoute(
          builder: (_) => DetailsPage(info: (settings.arguments as image_info.ImageInfo)),
          settings: settings,
        );
      case RouteNames.likes:
        getIt<LikesHistoryNotifier>().setHistory(settings.arguments as List<LikeInteraction>);
        // getIt<LikesHistoryNotifier>().setFilter((_) => true);
        return MaterialPageRoute(
          builder: (_) => const LikesPage(),
          settings: settings,
        );
    }

    return null;
  }
}
