import 'package:ParkShield/services/Firebase/FireDatabase/firedatabase.dart';
import 'package:ParkShield/services/Firebase/FireStore/firestore.dart';
import 'package:ParkShield/widgets/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddVehiclePopUp extends StatefulWidget {
  const AddVehiclePopUp({Key? key}) : super(key: key);

  @override
  _AddVehiclePopUpState createState() => _AddVehiclePopUpState();
}

class _AddVehiclePopUpState extends State<AddVehiclePopUp> {
  final TextEditingController vehicleIDTextController = TextEditingController();

  // Method to submit the
  Future<bool> onSubmitAciton({required BuildContext context}) async {
    final CollectionReference userVehicles =
        userDocumentCollection(collection: "vehicles");
    try {
      if (vehicleIDTextController.text == "") {
        return false;
      }

      print("yo");
      int responseCode = await setVehicleDatabase(
          vehicleID: int.parse(vehicleIDTextController.text));
      // Set up vehicle in database
      if (responseCode == 0) {
        // Error in setting up vehicle
        await showDialog(
            context: context,
            builder: (context) => const MyAlertDialog(
                singleButton: 'popBack',
                title: "Error occured !",
                content: "Okay"));
        return false;
      } else if (responseCode == -1) {
        await showDialog(
            context: context,
            builder: (context) => const MyAlertDialog(
                singleButton: 'popBack',
                title: "Vehicle already registered !",
                content: "Okay"));
      } else {
        await userVehicles
            .doc(vehicleIDTextController.text)
            .set({'vehicleID': vehicleIDTextController.text});

        Navigator.pop(context);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Card vehicleFormField = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: const Icon(
          Icons.two_wheeler,
          color: Colors.grey,
        ),
        title: TextFormField(
          validator: (value) {},
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
          ],
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
        if (await onSubmitAciton(context: context)) {
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
