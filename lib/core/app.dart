import 'package:flutter/material.dart';
import 'package:paint/pages/main_page.dart';
import 'package:paint/utils/constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.only(left: 8, right: 16),
        ),
      ),
      routes: {
        MainPage.route: (context) => const MainPage(),
      },
      title: Constants.appName,
    );
  }
}
