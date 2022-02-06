import 'package:flutter/material.dart';
import 'package:ParkShield/globals.dart';
import 'package:ParkShield/screens/login_register/components/login_register_tabs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(APP_ICON), context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight / 25),
                child: Container(
                  child: Text(
                    "LOGIN",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  '''By signing in you are 
agreeing our Term and privacy policy''',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight / 30,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2.5,
                  child: Image.asset(
                    APP_ICON,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 50,
                ),
                child: LoginRegisterTabs(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
