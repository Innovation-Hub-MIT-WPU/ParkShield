import 'package:ParkShield/screens/scan_vehicles/scan_vehicles_body.dart';
import 'package:flutter/material.dart';

class ScanVehiclesPage extends StatefulWidget {
  const ScanVehiclesPage({Key? key}) : super(key: key);

  @override
  State<ScanVehiclesPage> createState() => _ScanVehiclesPageState();
}

class _ScanVehiclesPageState extends State<ScanVehiclesPage> {
  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    return const ScanVehiclesBody();
  }
}
