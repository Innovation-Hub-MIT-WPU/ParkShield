import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ParkShield/globals.dart';

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
              child: Container(
                child: const Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 64),
                ),
              ),
            ),
            Center(
              child: Container(
                child: const Text(
                  '''By signing in you are 
agreeing our Term and privacy policy''',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight / 15,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
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
                horizontal: screenWidth / 25,
              ),
              child: DefaultTabController(
                length: 2, // length of tabs
                initialIndex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: TabBar(
                        labelColor: Colors.blueGrey[500],
                        unselectedLabelColor: Colors.grey[500],
                        tabs: [
                          Tab(text: 'Login'),
                          Tab(text: 'Register'),
                        ],
                      ),
                    ),
                    Container(
                      //height of TabBarView
                      height: screenHeight / 5,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5))),
                      child: TabBarView(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Text('Login',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text('Register',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
