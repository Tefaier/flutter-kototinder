import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
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
  bool isDark = false;

  void themeSwap() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  void initState() {
    super.initState();
    getIt.registerSingletonIfAbsent<ThemeSwap>(() => ThemeSwap(themeSwap));
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
