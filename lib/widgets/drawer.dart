import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';
import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  late String profileImageLink;
  List<List<String>> routesInfo = [
    ['Profile', '/profile_page'],
    ['Scan Vehicles', '/scan_vehicles_page'],
    ['Nominees', '/nominee_page'],
    ['Logout', '/login_register_page'],
  ];
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    profileImageLink = "https://i.ibb.co/Ttp2tmY/20180419-175104.jpg";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const NetworkImage(DEFAULT_PROFILE_PICTURE), context);

    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    final User user = getCurrentUser();
    return Drawer(
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.horizontal(right: Radius.elliptical(150, 500))),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              currentAccountPicture: CircleAvatar(
                radius: screenWidth / 4,
                backgroundImage: NetworkImage(
                  user.photoURL == null
                      ? DEFAULT_PROFILE_PICTURE
                      : user.photoURL!,
                ),
              ),
              accountName: Text(
                user.displayName as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
              accountEmail: Text(
                user.email as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Column(
              children: routesInfo.map(
                (List l) {
                  return Ink(
                    child: InkWell(
                      child: SizedBox(
                        width: screenWidth / 1,
                        height: screenHeight / 12,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            elevation: 5,
                            color: MAIN_COLOR_THEME['primary'],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.elliptical(400, 900),
                                  left: Radius.elliptical(200, 200)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  l[0],
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (l[1] != '/login_register_page') {
                          Navigator.pushReplacementNamed(
                            context,
                            l[1],
                          );
                        } else {
                          await signOut();
                          await signOutGoogle();
                          Navigator.pushReplacementNamed(
                            context,
                            l[1],
                          );
                        }
                      },
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
