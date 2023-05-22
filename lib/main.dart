import 'package:flutter/material.dart';
import 'package:sumday/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:sumday/providers/loginProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        // ChangeNotifierProvider(create: (context) => ReviewProvider()),
      ],
      child: MyApp(),
    ),
  );
}
