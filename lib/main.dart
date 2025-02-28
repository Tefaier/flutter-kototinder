import 'package:flutter/material.dart';

import 'main_app.dart';
import 'tools/error_handler.dart';
import 'tools/logger.dart';

void main() {
  initLogger();
  logger.info('Start main');
  ErrorHandler.init();

  runApp(const MainApp());
}
