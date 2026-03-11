import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/navigation/routes.dart';
import '/src/navigation/navigation_manager.dart';
import '/src/utils/app_theme.dart';
import '/src/utils/localization.dart';

GetIt getIt = GetIt.instance;

class ThemeSwap {
  VoidCallback swap;

  ThemeSwap(this.swap);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SharedPreferences prefs;
  late final StreamSubscription<List<ConnectivityResult>> subscription;
  bool noConnection = false;
  bool isDark = false;

  void themeSwap() {
    setState(() {
      isDark = !isDark;
    });
    prefs.setBool("isDark", isDark);
  }

  @override
  void initState() {
    super.initState();
    getIt.registerSingletonIfAbsent<ThemeSwap>(() => ThemeSwap(themeSwap));
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      var newNoConnection = result.contains(ConnectivityResult.none);
      if (newNoConnection != noConnection) {
        noConnection = newNoConnection;
        getIt<NavigationManager>().showSnackBar(newNoConnection ? "No internet connection" : "Internet connection detected");
      }
    });
    SharedPreferences.getInstance().then((inst) {
      prefs = inst;
      setState(() {
        isDark = prefs.getBool("isDark") ?? false;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(isDark),
      initialRoute: RouteNames.main,
      onGenerateRoute: RoutesBuilder.onGenerateRoute,
      navigatorKey: getIt<NavigationManager>().key,
    );
  }
}
