import 'package:ParkShield/globals.dart';
import 'package:ParkShield/services/Firebase/FireDatabase/firedatabase.dart';
import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:ParkShield/widgets/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NomineePageBody extends StatefulWidget {
  const NomineePageBody({Key? key}) : super(key: key);

  @override
  State<NomineePageBody> createState() => _NomineePageBodyState();
}

class _NomineePageBodyState extends State<NomineePageBody> {
  TextEditingController uidController = TextEditingController();
  String errorTextUID = '';
  String _selectedText = 'None';
  List<String> vehicleIDs = ['None'];
  CollectionReference userVehicleDocs =
      userDocumentCollection(collection: 'vehicles');
  bool isRefreshing = false;

  @override
  void initState() {
    updateVehicleIDs();
    super.initState();
  }

  Future<void> updateVehicleIDs() async {
    vehicleIDs = ['None'];
    _selectedText = 'None';
    List<String> tempVehicles = [];

    await userVehicleDocs
        .orderBy('vehicleID')
        .get()
        .then((queryDocumentSnapshot) {
      queryDocumentSnapshot.docs.forEach((doc) {
        tempVehicles.add("${doc['vehicleID']}");
        print("${doc['vehicleID']}");
      });
    });

    vehicleIDs = vehicleIDs + tempVehicles;
    print(vehicleIDs);
    setState(() {});
  }

  Future<int> submitNomineeAddition(
      {required String vehicleID, required String nominee}) async {
    return await updateVehicleNominees(
        vehicleID: int.parse(vehicleID), nominee: nominee);
  }

  Future<void> _refresh() async {
    isRefreshing = !isRefreshing;
    setState(() {});
    await updateVehicleIDs();
    isRefreshing = !isRefreshing;
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    final Card uidAccept = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
        title: TextField(
          obscureText: false,
          controller: uidController,
          decoration: InputDecoration(
            filled: false,
            hintText: 'UID',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            errorText: errorTextUID == '' ? null : errorTextUID,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );

    final Card vehicleIDAccept = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: SizedBox(
        width: screenWidth / 2,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            iconSize: 12,
            style:
                Theme.of(context).textTheme.headline3!.copyWith(fontSize: 24),
            value: _selectedText,
            items: vehicleIDs.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(value),
                ),
              );
            }).toList(),
            onChanged: (val) {
              _selectedText = val!;
              setState(() {});
            },
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            color: MAIN_COLOR_THEME['primary'],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight / 30,
                  ),
                  child: SizedBox(
                    height: screenWidth / 2,
                    child: Image.asset(APP_ICON),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Nominee UID',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.start,
                  ),
                ),
                uidAccept,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Vehicle ID',
                    style: Theme.of(context).textTheme.headline3,
                    textAlign: TextAlign.start,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: screenWidth / 100,
                  children: [
                    vehicleIDAccept,
                    isRefreshing
                        ? const CircularProgressIndicator.adaptive()
                        : IconButton(
                            onPressed: () async {
                              await _refresh();
                              setState(() {});
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 20,
                ),
                Center(
                  child: InkWell(
                    child: Ink(
                      width: screenWidth / 2,
                      height: screenHeight / 17.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(screenWidth / 50),
                      ),
                      child: Center(
                        child: Text(
                          "SUBMIT",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (_selectedText != 'None') {
                        int responseCode = await submitNomineeAddition(
                            vehicleID: _selectedText,
                            nominee: uidController.text);
                        if (responseCode == 1) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return const MyAlertDialog(
                                title: 'Nominee Added!',
                                content: 'Okay',
                                singleButton: 'popBack',
                              );
                            },
                          );
                        } else if (responseCode == 0) {
                          await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return const MyAlertDialog(
                                title: "Vehicle doesn't exist",
                                content: 'Hit refresh to update !',
                                singleButton: 'popBack',
                              );
                            },
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return const MyAlertDialog(
                                title: 'Nominee exists',
                                content: 'Okay',
                                singleButton: 'popBack',
                              );
                            },
                          );
                        }
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return const MyAlertDialog(
                              title: 'Vehicle not selected!',
                              content: 'Okay',
                              singleButton: 'popBack',
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
