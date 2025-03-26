import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/model/app_state.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/state/images_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/state/images_loader.dart';
import 'package:flutter_hw_lototinder/src/state/likes_history_notifier.dart';
import 'package:get_it/get_it.dart';

import '/src/widget/app_holder.dart';
import '/src/utils/error_handler.dart';
import '/src/utils/logger.dart';

GetIt getIt = GetIt.instance;

void initGetIt() {
  getIt.registerSingleton<LikesHistoryNotifier>(LikesHistoryNotifier(history: []));
  getIt.registerSingleton<ImagesNotifier>(ImagesNotifier(value: AppState()));
  getIt.registerSingleton<ImagesLoader>(ImagesLoader());
  getIt.registerSingleton<NavigationManager>(NavigationManager());
}

void main() {
  initLogger();
  logger.info('Start main');
  ErrorHandler.init();

  initGetIt();
    
  runApp(const App());
}
