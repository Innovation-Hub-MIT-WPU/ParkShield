import 'package:ParkShield/globals.dart';
import 'package:ParkShield/src/homepage.dart';
import 'package:ParkShield/src/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:ParkShield/splash.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
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
        textTheme: GoogleFonts.notoSansMayanNumeralsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.notoSansMayanNumeralsTextTheme(
          Theme.of(context).textTheme,
        ),
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
