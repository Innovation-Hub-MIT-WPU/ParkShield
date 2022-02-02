import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:ParkShield/globals.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatehome();
  }

  // Delay to go to landing page
  _navigatehome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacementNamed(context, '/login_register_page');
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(APP_ICON), context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: MediaQuery.of(context).size.width / 3,
              child: Image.asset(
                APP_ICON,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
