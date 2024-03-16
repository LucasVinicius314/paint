import 'package:flutter/material.dart';
import 'package:paint/pages/main_page.dart';
import 'package:paint/utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        MainPage.route: (context) => const MainPage(),
      },
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(
          waitDuration: Duration(seconds: 1),
        ),
      ),
      title: Constants.appName,
    );
  }
}

// TODO: app icon