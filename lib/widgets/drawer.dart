import 'package:ParkShield/services/CheckingAndRequests/authenticate.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Center(
                child: Image.network(
                    "https://i.ibb.co/Ttp2tmY/20180419-175104.jpg"),
              ),
            ),
            Ink(
              child: InkWell(
                child: SizedBox(
                  width: screenWidth / 3,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth / 100),
                    ),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Logout',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  if (await signOut()) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/login_register_page',
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
