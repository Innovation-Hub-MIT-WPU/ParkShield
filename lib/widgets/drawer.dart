import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Requests/firestore_requesting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    ['Scan Vehicles', '/test'],
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

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: userDocumentReference().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  userInfo = snapshot.data!.data() as Map<String, dynamic>;
                  return UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      radius: screenWidth / 4,
                      backgroundImage: const NetworkImage(
                        DEFAULT_PROFILE_PICTURE,
                      ),
                    ),
                    accountName: const Text(''),
                    accountEmail: Text(userInfo['email']),
                  );
                } else if (snapshot.hasError) {
                  return const Text('There was an error...');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            Column(
              children: routesInfo.map(
                (List l) {
                  return Ink(
                    child: InkWell(
                      child: SizedBox(
                        width: screenWidth / 1,
                        height: screenHeight / 10,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth / 100),
                          ),
                          child: ListTile(
                            title: Text(
                              l[0],
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        Navigator.pushReplacementNamed(
                          context,
                          l[1],
                        );
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
