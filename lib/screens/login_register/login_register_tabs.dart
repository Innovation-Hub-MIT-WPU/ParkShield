import 'package:flutter/material.dart';
import 'package:ParkShield/screens/login_register/login_tab.dart';
import 'package:ParkShield/screens/login_register/register_tab.dart';

class LoginRegisterTabs extends StatefulWidget {
  const LoginRegisterTabs({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);
  final num screenHeight, screenWidth;

  @override
  State<LoginRegisterTabs> createState() => _LoginRegisterTabsState();
}

class _LoginRegisterTabsState extends State<LoginRegisterTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // length of tabs
      initialIndex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: Theme.of(context).textTheme.subtitle2,
            unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
            tabs: const <Tab>[
              Tab(
                child: Text('Login'),
              ),
              Tab(child: Text('Register')),
            ],
          ),
          Container(
            //height of TabBarView
            height: widget.screenHeight / 2.3,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBarView(
              children: <Widget>[
                LoginTab(
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                ),
                RegisterTab(
                  screenWidth: widget.screenWidth,
                  screenHeight: widget.screenHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
