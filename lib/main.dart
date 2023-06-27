import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:sumday/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sumday/providers/diaries_provider.dart';
import 'package:sumday/providers/exchange_diary_list_provider.dart';
import 'package:sumday/providers/generate_provider.dart';
import 'package:sumday/providers/location_provider.dart';
import 'package:sumday/providers/place_api.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'dart:async';
// test
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // test
  initLocationState();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => DiariesProvider()),
        ChangeNotifierProvider(create: (context) => GenerateProvider()),
        ChangeNotifierProvider(
            create: (context) => ExchangeDiaryListProvider()),
        // ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
