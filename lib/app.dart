import 'package:flutter/material.dart';
import 'package:sumday/screens/mainPage.dart';
import 'package:sumday/screens/loginPage.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),
      },
      initialRoute: '/login',
      home: const LoginPage(),
      theme: ThemeData(
        fontFamily: 'Noto_Sans_KR',
      ),
      onGenerateRoute: _getRoute,
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}
