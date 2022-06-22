import 'package:ParkShield/globals.dart';
import 'package:ParkShield/screens/profile/add_vehicles_popup.dart';
import 'package:ParkShield/screens/profile/profile_body.dart';
import 'package:ParkShield/widgets/drawer.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBody profileBody;

  @override
  void initState() {
    profileBody = const ProfileBody();
    super.initState();
  }

  Future<void> _refresh() async {
    profileBody = const ProfileBody();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const CommonDrawer(),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh))
        ],
        title: Text(
          'PROFILE',
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 32,
              ),
        ),
        centerTitle: true,
      ),
      body: profileBody,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog(
              context: context, builder: (context) => const AddVehiclePopUp());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add),
        label: const Text("Add Vehicle"),
      ),
    );
  }
}
