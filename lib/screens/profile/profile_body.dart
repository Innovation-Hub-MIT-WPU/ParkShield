import 'dart:collection';

import 'package:ParkShield/globals.dart';
import 'package:ParkShield/screens/map_screen/map_page.dart';
import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';
import 'package:ParkShield/services/Firebase/FireDatabase/firedatabase.dart';
import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    precacheImage(const NetworkImage(DEFAULT_PROFILE_PICTURE), context);

    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    final User user = getCurrentUser();
    final String userID = getCurrentUserId();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: MAIN_COLOR_THEME['primary'],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight / 30,
                  ),
                  child: CircleAvatar(
                    radius: screenWidth / 4,
                    backgroundImage: NetworkImage(
                      FirebaseAuth.instance.currentUser!.photoURL != null
                          ? FirebaseAuth.instance.currentUser!.photoURL
                              as String
                          : DEFAULT_PROFILE_PICTURE,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight / 75,
                  ),
                  child: Center(
                    child: SizedBox(
                      child: Text("ID : " + userID,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 22)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 10, horizontal: screenWidth / 4),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'My Vehicles :',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight / 75,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: userDocumentCollection(collection: 'vehicles')
                  .orderBy('vehicleID')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: snapshot.data!.docs.isNotEmpty
                          ? snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;

                              return FutureBuilder<Map>(
                                  future: readVehicleDatabase(
                                      vehicleID: int.parse(data['vehicleID'])),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Map> internalSnapshot) {
                                    if (internalSnapshot.hasData) {
                                      List<ListTile> vehicleData = [];
                                      for (dynamic key
                                          in internalSnapshot.data!.keys) {
                                        dynamic internalData =
                                            internalSnapshot.data![key];
                                        if (internalData.runtimeType == bool) {
                                          vehicleData.add(ListTile(
                                            leading: Icon(
                                              internalSnapshot.data![key]
                                                  ? Icons.check
                                                  : Icons.close,
                                              color: internalSnapshot.data![key]
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            onTap: () {},
                                            title: Text(
                                              key.toString(),
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                            subtitle:
                                                Text(internalData.toString()),
                                          ));
                                        } else if (internalData.runtimeType ==
                                            List<Object?>) {
                                          vehicleData.addAll([
                                            ListTile(
                                              leading: const Icon(
                                                Icons.list_alt_rounded,
                                              ),
                                              onTap: () {},
                                              title: Text(
                                                key.toString(),
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                ),
                                              ),
                                              subtitle: Wrap(
                                                runSpacing: 10,
                                                children: (internalData as List)
                                                    .map(
                                                      (e) => Text(
                                                        "⬤ " + e.toString(),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ]);
                                        }
                                      }
                                      return Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            screenWidth / 50,
                                          ),
                                        ),
                                        child: ExpansionTile(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          leading:
                                              const Icon(Icons.two_wheeler),
                                          title: Text(
                                            "VehicleID: ${data['vehicleID']}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                          ),
                                          childrenPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2),
                                          children: [
                                                ListTile(
                                                  tileColor: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  leading: const Icon(
                                                      Icons.location_on),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CurrentLocationScreen(
                                                                vehicleID: data[
                                                                    'vehicleID']),
                                                      ),
                                                    );
                                                  },
                                                  title: const Text(
                                                      "Show location"),
                                                ),
                                              ] +
                                              vehicleData,
                                        ),
                                      );
                                    } else {
                                      return const Align(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator());
                                    }
                                  });
                            }).toList()
                          : [
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "No vehicles were found",
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('There was an error...');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
