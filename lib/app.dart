import 'package:flutter/material.dart';
import 'package:sumday/screens/mainPage.dart';
import 'package:sumday/screens/loginPage.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => MainPage(),
      },
      initialRoute: '/home',
      home: MainPage(),
      onGenerateRoute: _getRoute,
    );
  }
  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}