import 'package:flutter/material.dart';
import 'package:flutter_hw_lototinder/src/domain/model/app_state.dart';
import 'package:flutter_hw_lototinder/src/navigation/navigation_manager.dart';
import 'package:flutter_hw_lototinder/src/domain/state/images_history_notifier.dart';
import 'package:flutter_hw_lototinder/src/domain/state/images_loader.dart';
import 'package:flutter_hw_lototinder/src/domain/state/likes_history_notifier.dart';
import 'package:get_it/get_it.dart';

import '/src/widget/app_holder.dart';
import '/src/utils/error_handler.dart';
import '/src/utils/logger.dart';

GetIt getIt = GetIt.instance;

Future<void> initGetIt() async {
  AppState state = await AppState.withObjectBox();
  getIt.registerSingleton<LikesHistoryNotifier>(LikesHistoryNotifier(dao: state.dao));
  getIt.registerSingleton<ImagesNotifier>(ImagesNotifier(value: state));
  getIt.registerSingleton<ImagesLoader>(ImagesLoader());
  getIt.registerSingleton<NavigationManager>(NavigationManager());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogger();
  logger.info('Start main');
  ErrorHandler.init();

  await initGetIt();

  logger.info('App run');
  runApp(const App());
}
