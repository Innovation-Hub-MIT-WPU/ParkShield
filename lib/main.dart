import 'package:flutter/material.dart';

import 'package:ParkShield/globals.dart';
import 'package:ParkShield/screens/login_register/login_register_page.dart';
import 'package:ParkShield/screens/splash/splash.dart';
import 'package:ParkShield/screens/nominee/nominee_page.dart';
import 'package:ParkShield/screens/profile/profile_page.dart';
import 'package:ParkShield/screens/scan_vehicles/scan_vehicles_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:ParkShield/services/Authentication/firebase_options.dart';

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
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0x9400688B),
              secondary: const Color(0xFFF0FFFF),
            ),
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              buttonColor: const Color(0xFFC1F0F6),
            ),
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
        '/login_register_page': (context) => const LoginPage(
              title: APP_TITLE,
            ),
        '/profile_page': (context) => const ProfilePage(),
        '/nominee_page': (context) => const NomineePage(),
        '/scan_vehicles_page': (context) => const ScanVehiclesPage(),
      },
    );
  }
}
