import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddVehiclePopUp extends StatefulWidget {
  const AddVehiclePopUp({Key? key}) : super(key: key);

  @override
  _AddVehiclePopUpState createState() => _AddVehiclePopUpState();
}

class _AddVehiclePopUpState extends State<AddVehiclePopUp> {
  final TextEditingController vehicleIDTextController = TextEditingController();
  Future<bool> onSubmitAciton() async {
    final CollectionReference userVehicles =
        userDocumentCollection(collection: "vehicles");
    try {
      if (vehicleIDTextController.text == "") {
        return false;
      }
      await userVehicles
          .doc(vehicleIDTextController.text)
          .set({'vehicleID': vehicleIDTextController.text});

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    final Card vehicleFormField = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.two_wheeler,
          color: Colors.grey,
        ),
        title: TextField(
          obscureText: false,
          controller: vehicleIDTextController,
          decoration: InputDecoration(
            filled: false,
            hintText: 'Vehicle ID',
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      ),
    );

    final FloatingActionButton submitButton = FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.primary,
      isExtended: true,
      icon: const Icon(Icons.add),
      onPressed: () async {
        if (await onSubmitAciton()) {
          vehicleIDTextController.text = "";
        }
      },
      label: const Text("Add"),
    );
    return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.grey.shade300,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Add Vehicle",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [submitButton],
        content: Column(
          children: [
            vehicleFormField,
          ],
        ));
  }
}
