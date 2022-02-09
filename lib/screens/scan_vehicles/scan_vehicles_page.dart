import 'package:ParkShield/screens/scan_vehicles/scan_vehicles_body.dart';
import 'package:flutter/material.dart';

class ScanVehiclesPage extends StatefulWidget {
  const ScanVehiclesPage({Key? key}) : super(key: key);

  @override
  State<ScanVehiclesPage> createState() => _ScanVehiclesPageState();
}

class _ScanVehiclesPageState extends State<ScanVehiclesPage> {
  late ScanVehiclesBody scanVehiclesBody;
  Future<void> _refresh() async {
    scanVehiclesBody = const ScanVehiclesBody();
    setState(() {});
  }

  @override
  void initState() {
    scanVehiclesBody = const ScanVehiclesBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    return scanVehiclesBody;
  }
}
