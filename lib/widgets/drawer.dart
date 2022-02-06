import 'package:ParkShield/services/Authentication/authenticate.dart';
import 'package:ParkShield/services/DataTransact/requesting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({Key? key}) : super(key: key);

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  late String profileImageLink;
  late Map<String, dynamic> vehiclesInformation;
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    profileImageLink = "https://i.ibb.co/Ttp2tmY/20180419-175104.jpg";
    vehiclesInformation = {
      'Vehicle 1': {
        'status': 'Connected',
        'Nominees': {},
      },
      'Vehicle 2': {
        'status': 'Not connected',
        'Nominees': {},
      },
      'Vehicle 3': {
        'status': 'Not connected',
        'Nominees': {},
      },
    };
    super.initState();
  }

  void updateInformation() {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            Ink(
              child: InkWell(
                child: SizedBox(
                  width: screenWidth / 5,
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
