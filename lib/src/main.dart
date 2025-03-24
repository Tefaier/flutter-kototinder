import 'package:flutter/material.dart';

import '/src/widget/app_holder.dart';
import '/src/utils/error_handler.dart';
import '/src/utils/logger.dart';

void main() {
  initLogger();
  logger.info('Start main');
  ErrorHandler.init();

  runApp(const App());
}
