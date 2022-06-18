import 'dart:collection';

import 'package:ParkShield/services/Firebase/FireAuth/fireauth.dart';
import 'package:firebase_database/firebase_database.dart';

// Update Vehicle Database
Future<int> updateVehicleNominees({
  required int vehicleID,
  required String nominee,
  bool removeNominee = false,
}) async {
  // Database reference
  final DatabaseReference database =
      FirebaseDatabase.instance.ref("vehicles/$vehicleID");

  // Vehicle doesn't exist check
  if (!(await database.get()).exists) {
    print("Vehicle doesn't exist");
    return 0;
  }

  // Get list of previous nominees
  List nominees = ((await database.once()).snapshot.value!
      as LinkedHashMap)["nominees"] as List;

  // Nominee already exists
  if (nominees.contains(nominee)) {
    print("Nominee already exists");
    return -1;
  }
  nominees = nominees + [nominee];
  database.update({"nominees": nominees});
  return 1;
}

// Read Vehicle Coordinates
Future<List<double>> readVehicleCoordinates({
  required int vehicleID,
  bool removeNominee = false,
}) async {
  // Database reference
  final DatabaseReference database =
      FirebaseDatabase.instance.ref("vehicles/$vehicleID");

  // Vehicle doesn't exist check
  if (!(await database.get()).exists) {
    print("Vehicle doesn't exist");
    return [-1, -1];
  }

  // Get list of previous nominees
  LinkedHashMap gps = ((await database.once()).snapshot.value!
      as LinkedHashMap)["GPS"] as LinkedHashMap;
  print(gps);
  return [
    double.parse(gps["lat"].toString()),
    double.parse(gps["lon"].toString()),
  ];
}

// Read Vehicle Coordinates
Future<Map> readVehicleDatabase({
  required int vehicleID,
  bool removeNominee = false,
}) async {
  // Database reference
  final DatabaseReference database =
      FirebaseDatabase.instance.ref("vehicles/$vehicleID");

  // Vehicle doesn't exist check
  if (!(await database.get()).exists) {
    print("Vehicle doesn't exist");
    return LinkedHashMap.from({"exists": -1});
  }

  // Get list of previous nominees
  LinkedHashMap completeDatabase =
      ((await database.once()).snapshot.value! as LinkedHashMap);

  Map toBeSent = {
    "isOn": completeDatabase["isOn"],
    "isTampered": completeDatabase["isTampered"],
    "isParked": completeDatabase["isParked"],
    "ultrasonic": completeDatabase["ultrasonic"],
    "nominees": completeDatabase["nominees"],
  };
  return toBeSent;
}

// Set Vehicle Database
Future<int> setVehicleDatabase({required int vehicleID}) async {
  int isError = 0;
  // Database reference
  print("MEOW");
  final DatabaseReference newVehicle =
      FirebaseDatabase.instance.ref("vehicles").child(vehicleID.toString());
  if ((await newVehicle.get()).exists) {
    print("Vehicle already exists");

    return -1;
  }
  final String owner = getCurrentUserId();

  // Add the new vehicle
  await newVehicle.set({
    "GPS": {
      "lat": 0,
      "lon": 0,
    },
    "MPU": {
      "x": 0,
      "y": 0,
      "z": 0,
    },
    "isOn": false,
    "isTampered": false,
    "isParked": false,
    "ultrasonic": 0,
    "nominees": [
      owner,
    ],
    "owner": owner,
  }).catchError((onError) {
    print(onError);
    isError = 1;
  });
  return isError == 1 ? 0 : 1;
}
