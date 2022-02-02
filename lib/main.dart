import 'package:ParkShield/globals.dart';
import 'package:ParkShield/screens/homepage.dart';
import 'package:ParkShield/screens/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:ParkShield/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: DEFAULT_TEXT_THEME,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: DEFAULT_TEXT_THEME,
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const Splash(
              title: APP_TITLE,
            ),
        '/homepage': (context) => const HomePage(
              title: APP_TITLE,
            ),
        '/login_register_page': (context) => const LoginPage(
              title: APP_TITLE,
            ),
      },
    );
  }
}
