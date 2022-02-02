import 'package:flutter/material.dart';
import 'package:ParkShield/globals.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.network(
                    "https://i.ibb.co/Ttp2tmY/20180419-175104.jpg"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
